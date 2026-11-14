"""Generate CA65 source for the Sup 400-in-1 English menu (CPU $8000-$FFFF of the
0x70000 64 KiB block).  Output must reassemble byte-identically."""
import pickle, sys, os, importlib
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from op6502 import OPS, MODES_LEN
MENU = os.environ.get('MENU', 'en')
C = importlib.import_module('cfg_' + MENU)
globals().update({k: v for k, v in vars(C).items() if k.isupper()})
STRS = getattr(C, 'STRS', {})
rom = ROM
cm = pickle.load(open(os.path.join(HERE, 'codemap_%s.pkl' % MENU), 'rb'))
code, traced = cm['code'], cm['traced']
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, '..', 'src')
LO, HI = getattr(C, 'LO', 0x8000), getattr(C, 'HI', 0x10000)

owner = {}
for s, l in code.items():
    for b in range(s, s + l):
        owner[b] = s

labels = dict(NAMES)
refs_data = set()

def fmt_name(b):
    parts, cur = [], ''
    for c in b:
        if 32 <= c < 127 and c != 34:
            cur += chr(c)
        else:
            if cur: parts.append('"%s"' % cur); cur = ''
            parts.append('$%02X' % c)
    if cur: parts.append('"%s"' % cur)
    return ','.join(parts)

def rel_target(a, opd):
    return a + 2 + (opd - 256 if opd > 127 else opd)

# discover labels
for a in sorted(code):
    op = rom[a]; m, md = OPS[op]; n = MODES_LEN[md]
    opd = rom[a + 1] if n == 2 else (rom[a + 1] | rom[a + 2] << 8 if n == 3 else None)
    if md == 'rel':
        t = rel_target(a, opd)
        labels.setdefault(t, 'loc_%04X' % t)
    elif md in ('abs', 'abx', 'aby', 'ind') and LO <= opd < HI and a not in FOREIGN:
        if m in STORES and opd in REGS:
            continue
        if m == 'jsr':
            labels.setdefault(opd, 'sub_%04X' % opd)
        elif m == 'jmp' and md == 'abs':
            labels.setdefault(opd, 'loc_%04X' % opd)
        else:
            refs_data.add(opd)
for t in refs_data:
    if t in owner and owner[t] != t:
        continue                     # will be expressed as owner+off
    labels.setdefault(t, ('dat_%04X' if t not in code else 'loc_%04X') % t)
if HI == 0x10000:
    labels[0xFFFA] = 'vec_nmi'; labels[0xFFFC] = 'vec_reset'; labels[0xFFFE] = 'vec_irq'
for s in STUBS:
    labels.setdefault(s, 'ram_stub_%04X' % s)
# a label inside an instruction is not allowed: move to owner+off
for t in list(labels):
    if t in owner and owner[t] != t:
        o = owner[t]
        labels.setdefault(o, 'loc_%04X' % o)
        del labels[t]

# addresses inside multi-byte data items (words, names, records) -> base+off
inner = {}
for w0, cnt in WORDS.items():
    for k in range(cnt):
        inner[w0 + 2 * k + 1] = w0 + 2 * k
for k in range(NAME_COUNT if NAME_HI > NAME_LO else 0):
    for o in range(1, 16):
        inner[NAME_LO + 16 * k + o] = NAME_LO + 16 * k
for k in range(REC_N):
    for o in range(1, 9):
        inner[REC_LO + 9 * k + o] = REC_LO + 9 * k
for r0, (rl, k, nm) in ROWSTART.items():
    for o in range(1, rl):
        inner[r0 + o] = r0
for s0, sl in STRS.items():
    for o in range(1, sl):
        inner[s0 + o] = s0
for t in list(labels):
    if t in inner:
        b = inner[t]
        labels.setdefault(b, 'dat_%04X' % b)
        del labels[t]

def sym(t):
    if t in inner and t not in labels:
        b = inner[t]
        if b in labels:
            return '%s+%d' % (labels[b], t - b)
    if t in labels:
        return labels[t]
    if t in owner and owner[t] in labels:
        return '%s+%d' % (labels[owner[t]], t - owner[t])
    return None

def operand(a, m, md, opd):
    if md in ('imp',):
        return ''
    if md == 'acc':
        return 'a'
    if md == 'imm':
        return '#$%02X' % opd
    if md == 'rel':
        return labels[rel_target(a, opd)]
    if md in ('zp', 'zpx', 'zpy', 'izx', 'izy'):
        v = RAMV.get(opd, '$%02X' % opd)
        return {'zp': v, 'zpx': v + ',x', 'zpy': v + ',y', 'izx': '(%s,x)' % v, 'izy': '(%s),y' % v}[md]
    # absolute family
    s = None
    if a in FOREIGN:
        s = None
    elif m in STORES and opd in REGS:
        s = REGS[opd]
    elif opd in REGS and opd < 0x8000:
        s = REGS[opd]
    elif LO <= opd < HI:
        s = sym(opd)
    elif opd in RAMV:
        s = RAMV[opd]
    if s is None:
        s = ('a:$%04X' if opd < 0x100 and md != 'ind' else '$%04X') % opd
    elif opd < 0x100 and md != 'ind':
        s = 'a:' + s
    return {'abs': s, 'abx': s + ',x', 'aby': s + ',y', 'ind': '(%s)' % s}[md]

# ---------------------------------------------------------------- emit
banks = [(b, s) for b, s, n in BANKS]
BANKNO = {s: n for b, s, n in BANKS}
os.makedirs(OUT, exist_ok=True)
used_regs = set()
for base, seg in banks:
    L = []
    L.append('; %s, 8 KiB PRG bank $%02X (file 0x%05X), mapped at CPU $%04X' % (TITLE, BANKNO[seg], FILE_BASE + base, base))
    L.append('; Generated from the ROM + FCEUX traces. Untraced code is marked "static".')
    L.append('.segment "%s"' % seg)
    L.append('')
    a = base
    end = base + 0x2000
    prev_kind = None
    while a < end:
        if a in labels or a in STUBS:
            if a in STUB_NOTE:
                L.append('; ---- RAM stub: %s' % STUB_NOTE[a])
            if a in labels:
                L.append('%s:' % labels[a])
        if a in code:
            l = code[a]
            if a + l > end:
                raise SystemExit('instruction crosses bank at %04X' % a)
            m, md = OPS[rom[a]]
            opd = rom[a + 1] if l == 2 else (rom[a + 1] | rom[a + 2] << 8 if l == 3 else None)
            kind = 'T' if a in traced else 'S'
            if kind == 'S' and prev_kind != 'S':
                L.append('        ; static (not seen in traces)')
            prev_kind = kind
            txt = '        %-4s %s' % (m, operand(a, m, md, opd))
            cmt = ''
            if a in FOREIGN and FOREIGN[a]:
                cmt = ' ; -> ' + FOREIGN[a]
            if md in ('abs', 'abx', 'aby') and opd in REGS:
                used_regs.add(opd)
            L.append('%-40s; %04X%s' % (txt.rstrip(), a, cmt))
            a += l
        elif a in WORDS:
            prev_kind = None
            for k in range(WORDS[a]):
                v = rom[a] | rom[a + 1] << 8
                L.append('        .word %s ; %04X' % (sym(v) or '$%04X' % v, a))
                a += 2
                if a in labels: break
        elif NAME_LO <= a < NAME_HI and (a - NAME_LO) % 16 == 0:
            prev_kind = None
            L.append('        .byte %s ; %04X  #%d' % (fmt_name(rom[a:a + 16]), a, (a - NAME_LO) // 16))
            a += 16
        elif a in STRS:
            prev_kind = None
            L.append('        .byte %s ; %04X' % (fmt_name(rom[a:a + STRS[a]]), a))
            a += STRS[a]
        elif a in ROWSTART:
            prev_kind = None
            rl, k, nm = ROWSTART[a]
            L.append('        .byte %s ; %04X  %s %d' % (','.join('$%02X' % b for b in rom[a:a + rl]), a, nm, k))
            a += rl
        elif REC_LO <= a < REC_LO + 9 * REC_N and (a - REC_LO) % 9 == 0:
            prev_kind = None
            i = (a - REC_LO) // 9
            L.append('        .byte %s ; %04X  %s' % (','.join('$%02X' % b for b in rom[a:a + 9]), a,
                     rom[NAME_LO + 16 * i:NAME_LO + 16 * i + 16].replace(b'\xff', b'').decode('latin1').strip()))
            a += 9
        else:
            prev_kind = None
            j = a + 1
            while j < end and j not in code and j not in labels and j not in WORDS and j - a < 16 and not (NAME_LO <= j < NAME_HI) and not (REC_LO <= j < REC_LO + 9 * REC_N) and j not in ROWSTART and j not in STRS:
                j += 1
            L.append('        .byte %s ; %04X' % (','.join('$%02X' % b for b in rom[a:j]), a))
            a = j
    open(os.path.join(OUT, seg.lower() + '.s'), 'w').write('\n'.join(L) + '\n')

# register equates
E = ['; Hardware register names.  Only the NES PPU/APU, the OneBus PRG/CHR bank',
     '; registers and the MMC3-compatible $8000/$8001/$A000 are treated as known.',
     '; REG_41xx = observed write, meaning NOT assumed for this ROM.']
for r in sorted(REGS):
    E.append('%-20s = $%04X' % (REGS[r], r))
open(os.path.join(OUT, 'regs.inc'), 'w').write('\n'.join(E) + '\n')
R = ['; RAM variables, named from how the menu code uses them.', '; Unnamed RAM is still written as plain addresses.']
for k in sorted(RAMV):
    R.append('%-22s = $%04X' % (RAMV[k], k) if k >= 0x100 else '%-22s = $%02X' % (RAMV[k], k))
open(os.path.join(OUT, getattr(C, 'RAM_INC', 'ram.inc')), 'w').write('\n'.join(R) + '\n')
print('labels', len(labels), 'regs', len(used_regs))
