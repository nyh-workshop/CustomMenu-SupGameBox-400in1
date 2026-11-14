"""Mini two-pass assembler for the generated subset of ca65 syntax.
Mirrors ca65 address-size rules: a numeric operand < $100 without "a:" is zero page;
labels in ROM and register names (>= $2000) are absolute.  Used to prove the
generated sources rebuild the original bytes when ca65 isn't available here.
Usage: verify.py <dir with regs.inc + bank3c..3f.s> <reference 64K bin>"""
import re, sys, os, importlib
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from op6502 import ENC, MODES_LEN
C = importlib.import_module('cfg_' + os.environ.get('MENU', 'en'))
D = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, '..', 'src')
BRANCH = {'bpl', 'bmi', 'bvc', 'bvs', 'bcc', 'bcs', 'bne', 'beq'}
syms = {}
equ = set()
for line in open(D + '/regs.inc').readlines() + open(os.path.join(D, getattr(C, 'RAM_INC', 'ram.inc'))).readlines():
    m = re.match(r'\s*(\w+)\s*=\s*\$([0-9A-Fa-f]+)', line)
    if m:
        syms[m.group(1)] = int(m.group(2), 16); equ.add(m.group(1))
files = [(s.lower() + '.s', b) for b, s, n in C.BANKS]
for extra in sys.argv[3:]:
    pass

def strip(l):
    # remove comment (no ';' inside our operands)
    return l.split(';', 1)[0].rstrip()

def ev(e, pass2):
    e = e.strip()
    m = re.fullmatch(r'\$([0-9A-Fa-f]+)', e)
    if m:
        return int(m.group(1), 16)
    m = re.fullmatch(r'(\w+)\s*([+-])\s*(\d+)', e)
    if m:
        b = ev(m.group(1), pass2)
        return b + int(m.group(3)) if m.group(2) == '+' else b - int(m.group(3))
    if e in syms:
        return syms[e]
    if pass2:
        raise KeyError(e)
    return 0x8000

def parse(mn, op, pc, pass2):
    if op == '':
        return ('imp', None) if (mn, 'imp') in ENC else ('acc', None)
    if op == 'a':
        return 'acc', None
    if op.startswith('#'):
        return 'imm', ev(op[1:], pass2) & 0xff
    if mn in BRANCH:
        t = ev(op, pass2)
        d = t - (pc + 2)
        if pass2 and not -128 <= d <= 127:
            raise ValueError('branch range at %04X' % pc)
        return 'rel', d & 0xff
    m = re.fullmatch(r'\((.+),x\)', op)
    if m:
        return 'izx', ev(m.group(1), pass2)
    m = re.fullmatch(r'\((.+)\),y', op)
    if m:
        return 'izy', ev(m.group(1), pass2)
    m = re.fullmatch(r'\((.+)\)', op)
    if m:
        return 'ind', ev(m.group(1), pass2)
    idx = None
    m = re.fullmatch(r'(.+),([xy])', op)
    if m:
        op, idx = m.group(1), m.group(2)
    force_abs = op.startswith('a:')
    if force_abs:
        op = op[2:]
    v = ev(op, pass2)
    numeric = op.startswith('$') or op.split('+')[0] in equ
    zp = numeric and not force_abs and v < 0x100
    if zp:
        md = {None: 'zp', 'x': 'zpx', 'y': 'zpy'}[idx]
        if (mn, md) not in ENC:            # e.g. lda $xx,y has no zp form -> abs
            md = {None: 'abs', 'x': 'abx', 'y': 'aby'}[idx]
    else:
        md = {None: 'abs', 'x': 'abx', 'y': 'aby'}[idx]
    return md, v

def assemble(pass2):
    out = {}
    for fn, base in files:
        pc = base
        for raw in open(D + '/' + fn):
            l = strip(raw)
            if not l.strip() or l.strip().startswith('.segment'):
                continue
            m = re.match(r'^(\w+):\s*$', l)
            if m:
                if not pass2:
                    if m.group(1) in syms and syms[m.group(1)] != pc:
                        raise ValueError('dup label ' + m.group(1))
                    syms[m.group(1)] = pc
                continue
            s = l.strip()
            if s.startswith('.byte'):
                for tok in re.findall(r'"[^"]*"|[^,]+', s[5:]):
                    tok = tok.strip()
                    if tok.startswith('"'):
                        for ch in tok[1:-1]:
                            out[pc] = ord(ch); pc += 1
                    else:
                        out[pc] = ev(tok, pass2) & 0xff; pc += 1
                continue
            if s.startswith('.word'):
                for tok in s[5:].split(','):
                    x = ev(tok, pass2)
                    out[pc] = x & 0xff; out[pc + 1] = (x >> 8) & 0xff; pc += 2
                continue
            parts = s.split(None, 1)
            mn = parts[0]; op = parts[1].strip() if len(parts) > 1 else ''
            md, v = parse(mn, op, pc, pass2)
            opc = ENC[(mn, md)]
            n = MODES_LEN[md]
            out[pc] = opc
            if n >= 2: out[pc + 1] = v & 0xff
            if n == 3: out[pc + 2] = (v >> 8) & 0xff
            pc += n
        if pc != base + 0x2000:
            raise ValueError('%s size %X' % (fn, pc - base))
    return out

assemble(False)
img = assemble(True)
ref = C.ROM
rng = [a for b, s, n in C.BANKS for a in range(b, b + 0x2000)]
bad = [a for a in rng if img.get(a) != ref[a]]
print('%s: bytes compared: %d   mismatches: %d' % (C.TITLE, len(rng), len(bad)))
for a in bad[:20]:
    print('  %04X want %02X got %s' % (a, ref[a], img.get(a)))
sys.exit(1 if bad else 0)
