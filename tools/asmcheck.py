#!/usr/bin/env python3
"""asmcheck.py - a strict stand-in for  ca65 + ld65  on the sources of this project.

It reads the same files with the same rules, so a project can be checked where cc65 is not installed:
  python3 tools/asmcheck.py -I src --bin-include-dir orig -C menu64k.cfg -o build/out.bin src/main.s

What it follows (cc65 2.19 behaviour, 6502 CPU):
  ca65  .setcpu "6502", .include / .incbin "f"[,start[,size]] (searched in the current directory, then -I / --bin-include-dir)
        .segment "NAME" (code before any .segment goes to CODE), .byte, .word, .res n[,v]
        labels "name:", equates "name = expr" / "name := expr"; symbols are case sensitive, a symbol may be defined once
        address size: an expression of constants and equates takes its size from its value (<= $FF = zero page);
        anything with a segment label, and any forward reference, is absolute; "a:" forces absolute, "z:" zero page;
        zero page is used only where the instruction has that mode (lda $12,y -> absolute,y)
        legal 6502 opcodes only; immediates and .byte values must be -128..255; branches within -128..+127
  ld65  MEMORY start/size/file=%O/fill/fillval, SEGMENTS load=/type=/optional=; segments placed in SEGMENTS order;
        a memory area that overflows, or a non-empty segment missing from the config, is an error
Anything else in a source (another directive, a macro, an expression operator it does not know) stops it with an
error, so it never quietly accepts a line ca65 might read differently."""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from op6502 import ENC, MODES_LEN

BRANCH = {'bpl', 'bmi', 'bvc', 'bvs', 'bcc', 'bcs', 'bne', 'beq'}
MNEMONICS = {m for m, _ in ENC}
RESERVED = {'a', 'x', 'y', 's'}
IDENT = r'[A-Za-z_][A-Za-z0-9_]*'


class AsmError(Exception):
    pass


def strip_comment(line):
    out, q = [], False
    line = re.sub(r"'[ -~]'", lambda m: m.group(0) if m.group(0) != "';'" else "59", line)   # ';' as a character constant
    for ch in line:
        if ch == '"': q = not q
        if ch == ';' and not q: break
        out.append(ch)
    return ''.join(out).rstrip()


# ------------------------------------------------------------------------------------------------ expressions
TOK = re.compile(r"\s*('[ -~]'|\$[0-9A-Fa-f]+|%[01]+|\d+|" + IDENT + r'|<<|>>|[-+*/&|^~<>()])')


def tokenize(s, where):
    pos, out = 0, []
    while pos < len(s):
        if s[pos:].strip() == '': break
        m = TOK.match(s, pos)
        if not m: raise AsmError('%s: cannot read expression %r' % (where, s))
        out.append(m.group(1)); pos = m.end()
    return out


class Expr:
    """parsed expression; evaluate(symbols) -> int or None if a symbol is unknown"""
    def __init__(self, text, where):
        self.text, self.where = text, where
        self.toks = tokenize(text, where)
        self.i = 0
        self.tree = self.p_or()
        if self.i != len(self.toks): raise AsmError('%s: bad expression %r' % (where, text))

    def peek(self): return self.toks[self.i] if self.i < len(self.toks) else None
    def take(self): t = self.peek(); self.i += 1; return t

    def bin(self, sub, ops):
        n = sub()
        while self.peek() in ops:
            op = self.take(); n = (op, n, sub())
        return n
    def p_or(self): return self.bin(self.p_xor, ('|',))
    def p_xor(self): return self.bin(self.p_and, ('^',))
    def p_and(self): return self.bin(self.p_shift, ('&',))
    def p_shift(self): return self.bin(self.p_add, ('<<', '>>'))
    def p_add(self): return self.bin(self.p_mul, ('+', '-'))
    def p_mul(self): return self.bin(self.p_unary, ('*', '/'))
    def p_unary(self):
        t = self.peek()
        if t in ('<', '>', '-', '~', '^'):
            self.take(); return ('u' + t, self.p_unary())
        if t == '(':
            self.take(); n = self.p_or()
            if self.take() != ')': raise AsmError('%s: missing ) in %r' % (self.where, self.text))
            return n
        t = self.take()
        if t is None: raise AsmError('%s: expression ends early: %r' % (self.where, self.text))
        if len(t) == 3 and t[0] == t[2] == "'": return ('num', ord(t[1]))     # character constant (ASCII)
        if t.startswith('$'): return ('num', int(t[1:], 16))
        if t.startswith('%'): return ('num', int(t[1:], 2))
        if t.isdigit(): return ('num', int(t))
        if re.fullmatch(IDENT, t):
            if t.lower() in RESERVED: raise AsmError('%s: %r is a register name' % (self.where, t))
            return ('sym', t)
        raise AsmError('%s: unexpected %r in %r' % (self.where, t, self.text))

    def symbols(self, n=None):
        n = self.tree if n is None else n
        if n[0] == 'sym': return [n[1]]
        if n[0] == 'num': return []
        return [s for c in n[1:] for s in self.symbols(c)]

    def value(self, syms, n=None):
        n = self.tree if n is None else n
        k = n[0]
        if k == 'num': return n[1]
        if k == 'sym':
            v = syms.get(n[1])
            if v is None: raise AsmError('%s: undefined symbol %s' % (self.where, n[1]))
            return v
        if k.startswith('u'):
            v = self.value(syms, n[1]); op = k[1:]
            return {'<': v & 0xFF, '>': (v >> 8) & 0xFF, '-': -v, '~': ~v, '^': (v >> 16) & 0xFF}[op]
        a, b = self.value(syms, n[1]), self.value(syms, n[2])
        return {'+': a + b, '-': a - b, '*': a * b, '/': a // b if b else 0, '&': a & b, '|': a | b, '^': a ^ b,
                '<<': a << b, '>>': a >> b}[k]


# ------------------------------------------------------------------------------------------------ assembler
class Asm:
    def __init__(self, inc_dirs, bin_dirs):
        self.inc_dirs, self.bin_dirs = inc_dirs, bin_dirs
        self.equ = {}            # name -> value (constants known at definition time)
        self.equ_zp = {}         # name -> True if zero page size
        self.labels = {}         # name -> (segment, offset)
        self.defined_at = {}
        self.segs = {}           # name -> list of items
        self.size = {}           # name -> current size
        self.seg = 'CODE'
        self.order = []

    def find(self, name, dirs, base):
        for d in [os.path.dirname(base), '.'] + dirs:
            p = os.path.join(d, name)
            if os.path.isfile(p): return p
        raise AsmError('cannot find %r (looked in %s)' % (name, ', '.join([os.path.dirname(base) or '.', '.'] + dirs)))

    def define(self, name, where):
        if name.lower() in RESERVED: raise AsmError('%s: %r is a register name' % (where, name))
        if name in self.defined_at:
            raise AsmError('%s: symbol %s is already defined at %s' % (where, name, self.defined_at[name]))
        self.defined_at[name] = where

    def emit(self, item, n):
        if self.seg not in self.segs: self.segs[self.seg] = []; self.size[self.seg] = 0; self.order.append(self.seg)
        self.segs[self.seg].append((self.size[self.seg], item)); self.size[self.seg] += n

    def addr_zp(self, e):
        """ca65's address size for an operand: zero page only if every symbol is an already-known equate and the
        value is <= $FF"""
        for s in e.symbols():
            if s not in self.equ: return False          # label (segment relative) or forward reference
        return 0 <= e.value(self.equ) <= 0xFF

    def file(self, path):
        for no, raw in enumerate(open(path, encoding='utf-8', errors='strict'), 1):
            where = '%s:%d' % (os.path.relpath(path), no)
            line = strip_comment(raw.rstrip('\n'))
            if not line.strip(): continue
            m = re.match(r'^\s*(' + IDENT + r'):(.*)$', line)
            if m and not m.group(2).startswith('='):
                name = m.group(1)
                self.define(name, where)
                if name.lower() in MNEMONICS: raise AsmError('%s: label %s is an instruction name' % (where, name))
                self.labels[name] = (self.seg, self.size.get(self.seg, 0))
                if self.seg not in self.segs: self.segs[self.seg] = []; self.size[self.seg] = 0; self.order.append(self.seg)
                line = m.group(2)
                if not line.strip(): continue
            m = re.match(r'^\s*(' + IDENT + r')\s*:?=\s*(.+)$', line)
            if m:
                name = m.group(1); self.define(name, where)
                e = Expr(m.group(2), where)
                if any(s not in self.equ for s in e.symbols()):
                    raise AsmError('%s: equate %s uses a label or an undefined symbol (not checked here)' % (where, name))
                v = e.value(self.equ); self.equ[name] = v; self.equ_zp[name] = 0 <= v <= 0xFF
                continue
            s = line.strip()
            if s.startswith('.'):
                d, _, arg = s.partition(' '); d = d.lower(); arg = arg.strip()
                if d == '.include':
                    self.file(self.find(self.string(arg, where), self.inc_dirs, path))
                elif d == '.setcpu':
                    if self.string(arg, where) != '6502': raise AsmError('%s: only .setcpu "6502" is handled by this check' % where)
                elif d == '.segment':
                    self.seg = self.string(arg.split(',')[0].strip(), where)
                elif d == '.incbin':
                    parts = [p.strip() for p in self.split_args(arg)]
                    p = self.find(self.string(parts[0], where), self.bin_dirs, path)
                    data = open(p, 'rb').read()
                    start = Expr(parts[1], where).value({}) if len(parts) > 1 else 0
                    size = Expr(parts[2], where).value({}) if len(parts) > 2 else len(data) - start
                    if start + size > len(data): raise AsmError('%s: .incbin reads past the end of %s' % (where, p))
                    self.emit(('bin', data[start:start + size]), size)
                elif d in ('.byte', '.byt', '.db'):
                    for tok in self.split_args(arg):
                        tok = tok.strip()
                        if tok.startswith('"'):
                            t = self.string(tok, where); self.emit(('bin', t.encode('ascii')), len(t))
                        else:
                            self.emit(('byte', Expr(tok, where), where), 1)
                elif d in ('.word', '.addr', '.dw'):
                    for tok in self.split_args(arg): self.emit(('word', Expr(tok.strip(), where), where), 2)
                elif d == '.res':
                    parts = self.split_args(arg)
                    n = Expr(parts[0], where).value(self.equ)
                    v = Expr(parts[1], where).value(self.equ) if len(parts) > 1 else 0
                    self.emit(('bin', bytes([v & 0xFF]) * n), n)
                else:
                    raise AsmError('%s: directive %s is not handled by this check' % (where, d))
                continue
            self.instr(s, where)

    @staticmethod
    def split_args(a):
        out, cur, q = [], '', False
        for ch in a:
            if ch == '"': q = not q
            if ch == ',' and not q: out.append(cur); cur = ''
            else: cur += ch
        out.append(cur)
        return out

    @staticmethod
    def string(tok, where):
        tok = tok.strip()
        if len(tok) < 2 or tok[0] != '"' or tok[-1] != '"': raise AsmError('%s: expected a "string", got %s' % (where, tok))
        return tok[1:-1]

    def instr(self, s, where):
        parts = s.split(None, 1)
        mn = parts[0].lower(); op = parts[1].strip() if len(parts) > 1 else ''
        if mn not in MNEMONICS: raise AsmError('%s: unknown instruction %r' % (where, parts[0]))
        if op == '':
            md = 'imp' if (mn, 'imp') in ENC else 'acc'
            if (mn, md) not in ENC: raise AsmError('%s: %s needs an operand' % (where, mn))
            self.emit(('ins', mn, md, None, where), 1); return
        if op.lower() == 'a':
            if (mn, 'acc') not in ENC: raise AsmError('%s: %s has no accumulator mode' % (where, mn))
            self.emit(('ins', mn, 'acc', None, where), 1); return
        if op.startswith('#'):
            if (mn, 'imm') not in ENC: raise AsmError('%s: %s has no immediate mode' % (where, mn))
            self.emit(('ins', mn, 'imm', Expr(op[1:], where), where), 2); return
        if mn in BRANCH:
            self.emit(('ins', mn, 'rel', Expr(op, where), where), 2); return
        m = re.fullmatch(r'\((.+),\s*[xX]\s*\)', op)
        if m: return self.pick(mn, ('izx',), Expr(m.group(1), where), where, zp_only=True)
        m = re.fullmatch(r'\((.+)\)\s*,\s*[yY]', op)
        if m: return self.pick(mn, ('izy',), Expr(m.group(1), where), where, zp_only=True)
        if mn == 'jmp' and op.startswith('('):
            m = re.fullmatch(r'\((.+)\)', op)
            self.emit(('ins', mn, 'ind', Expr(m.group(1), where), where), 3); return
        idx = None
        m = re.fullmatch(r'(.+?)\s*,\s*([xXyY])', op)
        if m: op, idx = m.group(1).strip(), m.group(2).lower()
        force = None
        if op[:2].lower() in ('a:', 'z:'): force, op = op[0].lower(), op[2:]
        e = Expr(op, where)
        zpm = {None: 'zp', 'x': 'zpx', 'y': 'zpy'}[idx]; abm = {None: 'abs', 'x': 'abx', 'y': 'aby'}[idx]
        if force == 'z':
            if (mn, zpm) not in ENC: raise AsmError('%s: %s has no zero page mode here' % (where, mn))
            self.emit(('ins', mn, zpm, e, where), 2); return
        zp = force is None and self.addr_zp(e) and (mn, zpm) in ENC
        md = zpm if zp else abm
        if (mn, md) not in ENC: raise AsmError('%s: %s does not have mode %s' % (where, mn, md))
        self.emit(('ins', mn, md, e, where), MODES_LEN[md])

    def pick(self, mn, modes, e, where, zp_only):
        md = modes[0]
        if (mn, md) not in ENC: raise AsmError('%s: %s does not have mode %s' % (where, mn, md))
        self.emit(('ins', mn, md, e, where), 2)


# ------------------------------------------------------------------------------------------------ linker
def read_cfg(path):
    txt = re.sub(r'#.*', '', open(path).read())
    blocks = dict(re.findall(r'(MEMORY|SEGMENTS|FEATURES|SYMBOLS|FILES|FORMATS)\s*\{(.*?)\}', txt, re.S))
    for k in blocks:
        if k not in ('MEMORY', 'SEGMENTS'): raise AsmError('%s: section %s is not handled by this check' % (path, k))
    def entries(body):
        out = []
        for name, attrs in re.findall(r'(\w+)\s*:\s*([^;]*);', body):
            d = {}
            for a in attrs.split(','):
                if not a.strip(): continue
                k, v = [x.strip() for x in a.split('=', 1)]; d[k.lower()] = v
            out.append((name, d))
        return out
    num = lambda v: int(v[1:], 16) if v.startswith('$') else int(v, 0)
    mem = []
    for name, d in entries(blocks.get('MEMORY', '')):
        mem.append(dict(name=name, start=num(d['start']), size=num(d['size']), file=d.get('file', '%O'),
                        fill=d.get('fill', 'no') == 'yes', fillval=num(d.get('fillval', '0'))))
    segs = [(name, d) for name, d in entries(blocks.get('SEGMENTS', ''))]
    return mem, segs


def link(asm, cfg):
    mem, segs = read_cfg(cfg)
    memd = {m['name']: m for m in mem}
    known = {n for n, _ in segs}
    for s in asm.order:
        if asm.size[s] and s not in known: raise AsmError('ld65: segment %s is not in %s' % (s, cfg))
    base, used = {}, {m['name']: 0 for m in mem}
    for n, d in segs:
        m = memd.get(d.get('load'))
        if m is None: raise AsmError('ld65: segment %s loads into unknown memory %s' % (n, d.get('load')))
        if n not in asm.size:
            if d.get('optional', 'no') != 'yes': print('  ld65 would warn: segment %s does not exist' % n)
            continue
        base[n] = m['start'] + used[m['name']]; used[m['name']] += asm.size[n]
        if used[m['name']] > m['size']:
            raise AsmError('ld65: memory area %s overflows by %d bytes' % (m['name'], used[m['name']] - m['size']))
    syms = dict(asm.equ)
    for name, (seg, off) in asm.labels.items():
        if seg not in base: raise AsmError('label %s is in segment %s, which is not linked' % (name, seg))
        syms[name] = base[seg] + off
    out = bytearray()
    for m in mem:
        if m['file'] != '%O': continue
        area = bytearray()
        for n, d in segs:
            if d.get('load') != m['name'] or n not in base: continue
            pc0 = base[n]
            for off, it in asm.segs[n]:
                pc = pc0 + off
                if it[0] == 'ins' and it[2] == 'rel':
                    # ca65 only resolves a branch to a label of the same segment; to a label of another segment it
                    # stops with "Range error (Address size 2 does not match fragment size 1)"
                    other = [x for x in it[3].symbols() if x in asm.labels and asm.labels[x][0] != n]
                    if other:
                        raise AsmError('%s: range error: branch from segment %s to %s in segment %s (ca65: "Address size 2 '
                                       'does not match fragment size 1"); write it as .byte' % (it[4], n, other[0], asm.labels[other[0]][0]))
                area += encode(it, pc, syms)
        if m['fill']: area += bytes([m['fillval']]) * (m['size'] - len(area))
        out += area
    return bytes(out), syms


def encode(it, pc, syms):
    k = it[0]
    if k == 'bin': return it[1]
    if k == 'byte':
        v = it[1].value(syms)
        if not -128 <= v <= 255: raise AsmError('%s: range error: .byte %s = %d' % (it[2], it[1].text, v))
        return bytes([v & 0xFF])
    if k == 'word':
        v = it[1].value(syms)
        if not -32768 <= v <= 0xFFFF: raise AsmError('%s: range error: .word %d' % (it[2], v))
        return bytes([v & 0xFF, (v >> 8) & 0xFF])
    _, mn, md, e, where = it
    opc = ENC[(mn, md)]
    if md in ('imp', 'acc'): return bytes([opc])
    v = e.value(syms)
    if md == 'rel':
        d = v - (pc + 2)
        if not -128 <= d <= 127: raise AsmError('%s: branch out of range (%d)' % (where, d))
        return bytes([opc, d & 0xFF])
    if MODES_LEN[md] == 2:
        if not -128 <= v <= 255: raise AsmError('%s: range error: %s %s = $%X does not fit 8 bits' % (where, mn, e.text, v))
        return bytes([opc, v & 0xFF])
    if not 0 <= v <= 0xFFFF: raise AsmError('%s: range error: %s %s = $%X' % (where, mn, e.text, v))
    return bytes([opc, v & 0xFF, v >> 8])


def main(argv):
    inc, bins, cfg, out, src, lbl = [], [], None, None, None, None
    i = 0
    while i < len(argv):
        a = argv[i]
        if a == '-I': inc.append(argv[i + 1]); i += 2
        elif a == '--bin-include-dir': bins.append(argv[i + 1]); i += 2
        elif a == '-C': cfg = argv[i + 1]; i += 2
        elif a == '-o': out = argv[i + 1]; i += 2
        elif a == '-Ln': lbl = argv[i + 1]; i += 2
        else: src = a; i += 1
    if not (cfg and out and src): raise SystemExit(__doc__)
    try:
        asm = Asm(inc, bins); asm.file(src)
        img, syms = link(asm, cfg)
    except (AsmError, UnicodeDecodeError) as e:
        print('ERROR: %s' % e); return 1
    os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
    open(out, 'wb').write(img)
    if lbl:
        with open(lbl, 'w') as f:
            for n in sorted(syms, key=lambda k: syms[k]): f.write('al %06X .%s\n' % (syms[n], n))
    print('asmcheck: %s -> %s (%d bytes, %d symbols, %d labels)' % (src, out, len(img), len(syms), len(asm.labels)))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
