"""Code/data map for the English menu half (file 0x78000-0x7FFFF, CPU $8000-$FFFF).
Seeds: every instruction seen in the 4 FCEUX traces, the vectors, and the ROM
sources of RAM-copied stubs. Static recursive descent adds untraced paths, but a
path is rejected if it hits an illegal opcode or overlaps already-known bytes
misaligned."""
import pickle, sys, os, importlib
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from op6502 import OPS, MODES_LEN
MENU = os.environ.get('MENU', 'en')
C = importlib.import_module('cfg_' + MENU)
rom = C.ROM
LO, HI = getattr(C, 'LO', 0x8000), getattr(C, 'HI', 0x10000)

ex = {o: (n, None) for o, n in C.COV.items()}
traced = {o for o in ex if LO <= o < HI}

# RAM stubs: ROM source -> (run address, max length)
STUBS = C.STUBS

def ins_at(a):
    op = rom[a]
    if op not in OPS:
        return None
    m, md = OPS[op]
    n = MODES_LEN[md]
    if a + n > HI:
        return None
    opd = rom[a + 1] if n == 2 else (rom[a + 1] | rom[a + 2] << 8 if n == 3 else None)
    return m, md, n, opd

code = {}      # start -> length   (instruction starts)
owner = {}     # byte -> instruction start

def try_path(start, accept_new, follow_abs=True):
    """Recursive descent from start; returns set of new instr starts or None on conflict."""
    new = {}
    stack = [start]
    while stack:
        a = stack.pop()
        while True:
            if not (LO <= a < HI):
                break
            if a in code or a in new:
                break
            if a in owner:                 # lands inside an existing instruction
                return None
            r = ins_at(a)
            if r is None:
                return None
            m, md, n, opd = r
            for b in range(a, a + n):
                if b in owner or any(b in range(s, s + l) for s, l in ()):
                    return None
            # overlap with other new instructions
            for b in range(a + 1, a + n):
                if b in new:
                    return None
            new[a] = n
            if md == 'rel':
                t = a + 2 + (opd - 256 if opd > 127 else opd)
                stack.append(t)
            if m == 'jsr' and LO <= opd < HI and follow_abs:
                stack.append(opd)
            if m == 'jmp' and md == 'abs':
                if LO <= opd < HI and follow_abs:
                    stack.append(opd)
                break
            if m in ('rts', 'rti', 'brk') or (m == 'jmp'):
                break
            a += n
    # check new instructions do not overlap each other
    occ = {}
    for s, l in new.items():
        for b in range(s, s + l):
            if b in occ or b in owner:
                return None
            occ[b] = s
    return new

def commit(new):
    for s, l in new.items():
        code[s] = l
        for b in range(s, s + l):
            owner[b] = s

# 1) traced instructions are ground truth
for o in sorted(traced):
    n = ex[o][0]
    code[o] = n
    for b in range(o, o + n):
        owner[b] = o

# 2) descent from traced instructions' successors and from extra seeds
seeds = set()
for o in sorted(traced):
    r = ins_at(o)
    m, md, n, opd = r
    if md == 'rel':
        seeds.add(o + 2 + (opd - 256 if opd > 127 else opd))
    if m not in ('rts', 'rti', 'jmp', 'brk'):
        seeds.add(o + n)
    if m in ('jsr', 'jmp') and md == 'abs' and LO <= opd < HI:
        seeds.add(opd)
for v in getattr(C, 'VECTORS', (0xFFFA, 0xFFFC, 0xFFFE)):
    seeds.add(rom[v] | rom[v + 1] << 8)
seeds |= set(STUBS)
# targets of indirect jumps found in pointer tables / immediate pointer setups
EXTRA = C.EXTRA
seeds |= set(EXTRA)
rejected = []
changed = True
while changed:
    changed = False
    for s in sorted(seeds):
        if s in code or not (LO <= s < HI):
            continue
        new = try_path(s, True, follow_abs=(s not in STUBS))
        if new is None:
            rejected.append(s)
            continue
        commit(new)
        changed = True
    seeds = {s for s in seeds if s not in code and s not in rejected}

static_only = sorted(set(code) - traced)
print('traced instrs', len(traced), ' total instrs', len(code), ' static-only', len(static_only))
print('rejected seeds', ['%04X' % s for s in sorted(set(rejected))])
pickle.dump(dict(code=code, traced=traced, stubs=STUBS), open(os.path.join(HERE, 'codemap_%s.pkl' % MENU), 'wb'))
