"""usage: fullscan.py TRACE LABEL  -> scan_LABEL.json
PRG: executed bytes, data reads, JMP (ind) pointer reads (OneBus PRG rule).
CHR: 1 KiB banks of the pattern tables in use while rendering (BG half if BG on, sprite half(s) if sprites on), + $2007.
Stops at the first write of a non-zero value to $4100 (a game outside the 512 KiB menu image starts)."""
import re, sys, collections, json
fn, label = sys.argv[1], sys.argv[2]
PS = {0: 0x3F, 1: 0x1F, 2: 0x0F, 3: 0x07, 4: 0x03, 5: 0x01, 6: 0x00, 7: 0xFF}
CM = {0: (0xFF, 0), 1: (0x7F, 0x80), 2: (0x3F, 0xC0), 4: (0x1F, 0xE0), 5: (0x0F, 0xF0), 6: (0x07, 0xF8), 3: (0xFF, 0), 7: (0xFF, 0)}
MMC3 = {0: 0x2016, 1: 0x2017, 2: 0x2012, 3: 0x2013, 4: 0x2014, 5: 0x2015}
NAMED = dict(PPU_CTRL=0x2000, PPU_MASK=0x2001, PPU_STATUS=0x2002, OAM_ADDR=0x2003, OAM_DATA=0x2004, PPU_SCROLL=0x2005,
             PPU_ADDRESS=0x2006, PPU_ADDR=0x2006, PPU_DATA=0x2007)
st = collections.defaultdict(int); sel = 0; paddr = 0; latch = 0
line_re = re.compile(r'^A:([0-9A-F]{2}) X:([0-9A-F]{2}) Y:([0-9A-F]{2}) S:[0-9A-F]{2}\s+\$(?:([0-9A-F]{2}):)?([0-9A-F]{4}): ((?:[0-9A-F]{2} ){1,3})\s*(\S+)\s*(.*)$')
ea_re = re.compile(r'@ \$([0-9A-F]{4})|^\(?\$([0-9A-F]{4})|^(PPU_[A-Z]+|OAM_[A-Z]+)\b')
READS = {'LDA', 'LDX', 'LDY', 'ADC', 'SBC', 'AND', 'ORA', 'EOR', 'CMP', 'CPX', 'CPY', 'BIT'}
def prg(a):
    slot = (a - 0x8000) >> 13; im = PS[st[0x410B] & 7]
    if st[0x4105] & 0x40 and slot in (0, 2): slot ^= 2
    inner = (st[0x4107], st[0x4108], st[0x4109] if st[0x410B] & 0x40 else 0xFE, 0xFF)[slot]
    return ((inner & im) | (st[0x410A] & ~im & 0xFF) | ((st[0x4100] >> 4) << 8)) * 0x2000 + (a & 0x1FFF)
def chrb():
    im, mm = CM[st[0x201A] & 7]
    base = ((st[0x4100] & 15) << 11) | (((st[0x2018] >> 4) & 7) << 8); mid = st[0x201A] & mm
    inner = [st[0x2016] & 0xFE, st[0x2016] | 1, st[0x2017] & 0xFE, st[0x2017] | 1, st[0x2012], st[0x2013], st[0x2014], st[0x2015]]
    b = [base | (v & im) | mid for v in inner]
    return b[4:] + b[:4] if st[0x4105] & 0x80 else b
ex = set(); rd = set(); ch = collections.Counter(); n = 0; stop = None; dirty = True; cur = ()
with open(fn, errors='replace') as f:
    for line in f:
        n += 1
        m = line_re.match(line)
        if not m: continue
        a, x, y, bk, pc, byts, mn, rest = m.groups(); pc = int(pc, 16)
        if pc >= 0x8000:
            o = prg(pc)
            for i in range(len(byts.split())): ex.add(o + i)
        if dirty:
            mask, ctrl = st[0x2001], st[0x2000]; b = chrb(); s = set()
            if mask & 0x08: s.update(b[4:] if ctrl & 0x10 else b[:4])
            if mask & 0x10:
                if ctrl & 0x20: s.update(b)
                else: s.update(b[4:] if ctrl & 0x08 else b[:4])
            cur = tuple(sorted(s)); dirty = False
        for k in cur: ch[k] += 1
        e = ea_re.search(rest)
        if not e: continue
        ea = int(e.group(1) or e.group(2), 16) if (e.group(1) or e.group(2)) else NAMED.get(e.group(3))
        if ea is None: continue
        if mn == 'JMP' and rest.startswith('($'):
            p = int(rest[2:6], 16)
            if p >= 0x8000: rd.update((prg(p), prg(p + 1)))
            continue
        if mn in READS:
            if ea >= 0x8000: rd.add(prg(ea))
            elif ea == 0x2007:
                if paddr < 0x2000: ch[chrb()[paddr >> 10]] += 1
                paddr = (paddr + (32 if st[0x2000] & 4 else 1)) & 0x3FFF
            elif ea == 0x2002: latch = 0
            continue
        if mn not in ('STA', 'STX', 'STY'): continue
        v = int({'STA': a, 'STX': x, 'STY': y}[mn], 16)
        if ea == 0x4100 and v:
            stop = n; break
        if ea in (0x2000, 0x2001) or 0x2010 <= ea <= 0x201F or 0x4100 <= ea <= 0x410B:
            st[ea] = v; dirty = True
        elif ea == 0x8000:
            sel = v; st[0x4105] = (st[0x4105] & 0x3F) | (v & 0xC0); dirty = True
        elif ea == 0x8001:
            r = sel & 7
            if r == 6: st[0x4107] = v
            elif r == 7: st[0x4108] = v
            elif r in MMC3: st[MMC3[r]] = v
            dirty = True
        elif ea == 0x2006:
            paddr = ((paddr & 0xFF) | (v & 0x3F) << 8) if latch == 0 else ((paddr & 0xFF00) | v); latch ^= 1
        elif ea == 0x2007:
            if paddr < 0x2000: ch[chrb()[paddr >> 10]] += 1
            paddr = (paddr + (32 if st[0x2000] & 4 else 1)) & 0x3FFF
json.dump(dict(lines=n, stop=stop, ex=sorted(ex), rd=sorted(rd), chr=sorted(ch)), open('scan_%s.json' % label, 'w'))
print(label, 'lines', n, 'stopped at', stop, 'exec', len(ex), 'read', len(rd), 'chr banks', len(ch))
