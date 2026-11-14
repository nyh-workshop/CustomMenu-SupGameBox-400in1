"""Replay an FCEUX trace and work out which CHR (pattern) memory is mapped while
the screen is rendering, using the OneBus rules (VT02+ CHR-ROM Bankswitching,
2bpp, Address Extension off):
  1 KiB bank = ($4100&$0F)<<11 | (($2018>>4)&7)<<8 | (inner & IMASK | $201A & MMASK)
  inner: $2016 (&FE/|1) -> $0000/$0400, $2017 -> $0800/$0C00, $2012-$2015 -> $1000-$1C00
  MMC3 R0-R5 ($8000/$8001) feed $2016,$2017,$2012-$2015; $8000 bit7 swaps the 4 KiB halves.
A snapshot is taken at every RTI (end of NMI = mapping used for the next frame).
Usage: chrtrack.py trace.log start_line end_line label"""
import re, sys, collections, json
fn, lo, hi, label = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
MASKS = {0: (0xFF, 0x00), 1: (0x7F, 0x80), 2: (0x3F, 0xC0), 4: (0x1F, 0xE0), 5: (0x0F, 0xF0), 6: (0x07, 0xF8),
         3: (0xFF, 0x00), 7: (0xFF, 0x00)}   # 3/7 invalid; treated as no mask
st = collections.defaultdict(int)          # register file
st[0x4105] = 0
mmc3_sel = 0
MMC3_TO_REG = {0: 0x2016, 1: 0x2017, 2: 0x2012, 3: 0x2013, 4: 0x2014, 5: 0x2015}
ppu_addr = 0; latch = 0
snaps = collections.Counter()
dur = collections.Counter()
cpu_chr = collections.Counter()           # (kind, bank1k) for $2007 access below $2000
writes = collections.Counter()            # (reg, val) for CHR-related registers
line_re = re.compile(r'^A:([0-9A-F]{2}) X:([0-9A-F]{2}) Y:([0-9A-F]{2}) S:[0-9A-F]{2}\s+\$(?:[0-9A-F]{2}:)?[0-9A-F]{4}: ((?:[0-9A-F]{2} ){1,3})\s*(\S+)\s*(.*)$')
ea_re = re.compile(r'@ \$([0-9A-F]{4})|^\$([0-9A-F]{4})|^(PPU_CTRL|PPU_MASK|PPU_STATUS|OAM_ADDR|OAM_DATA|PPU_SCROLL|PPU_ADDRESS|PPU_ADDR|PPU_DATA|PPU_OAM_ADDR)\b')
NAMED = dict(PPU_CTRL=0x2000, PPU_MASK=0x2001, PPU_STATUS=0x2002, OAM_ADDR=0x2003, OAM_DATA=0x2004,
             PPU_SCROLL=0x2005, PPU_ADDR=0x2006, PPU_ADDRESS=0x2006, PPU_DATA=0x2007, PPU_OAM_ADDR=0x2003)

def slot_banks():
    im, mm = MASKS[st[0x201A] & 7]
    base = ((st[0x4100] & 0x0F) << 11) | (((st[0x2018] >> 4) & 7) << 8)
    mid = st[0x201A] & mm
    inner = [st[0x2016] & 0xFE, st[0x2016] | 1, st[0x2017] & 0xFE, st[0x2017] | 1,
             st[0x2012], st[0x2013], st[0x2014], st[0x2015]]
    banks = [base | ((v & im) | mid) for v in inner]
    if st[0x4105] & 0x80:
        banks = banks[4:] + banks[:4]
    return tuple(banks)

n = 0
with open(fn, errors='replace') as f:
    for line in f:
        n += 1
        if n > hi: break
        m = line_re.match(line)
        if not m: continue
        inwin = n >= lo
        if inwin and (st[0x2001] & 0x18):
            dur[(slot_banks(), st[0x2000] & 0x38)] += 1
        a, x, y, byts, mn, rest = m.groups()
        op = byts.split()[0]
        if mn == 'RTI':
            ctrl, mask = st[0x2000], st[0x2001]
            if mask & 0x18 and inwin:
                snaps[(slot_banks(), ctrl & 0x38, mask & 0x18)] += 1
            continue
        if mn in ('STA', 'STX', 'STY', 'LDA', 'LDX', 'LDY', 'BIT'):
            e = ea_re.search(rest)
            if not e: continue
            ea = int(e.group(1) or e.group(2), 16) if (e.group(1) or e.group(2)) else NAMED[e.group(3)]
            if mn.startswith('ST'):
                v = int({'STA': a, 'STX': x, 'STY': y}[mn], 16)
                if ea in (0x2000, 0x2001):
                    st[ea] = v
                elif 0x2010 <= ea <= 0x201F or ea in (0x4100, 0x4105):
                    st[ea] = v
                    if inwin: writes[('%04X' % ea, '%02X' % v)] += 1
                elif ea == 0x8000:
                    mmc3_sel = v; st[0x4105] = (st[0x4105] & 0x7F) | (v & 0x80)
                    if inwin: writes[('8000', '%02X' % v)] += 1
                elif ea == 0x8001 and (mmc3_sel & 7) in MMC3_TO_REG:
                    st[MMC3_TO_REG[mmc3_sel & 7]] = v
                elif ea == 0x2006:
                    if latch == 0: ppu_addr = (ppu_addr & 0x00FF) | ((v & 0x3F) << 8)
                    else: ppu_addr = (ppu_addr & 0xFF00) | v
                    latch ^= 1
                elif ea == 0x2007:
                    if ppu_addr < 0x2000 and inwin:
                        cpu_chr[('write', slot_banks()[ppu_addr >> 10])] += 1
                    ppu_addr = (ppu_addr + (32 if st[0x2000] & 4 else 1)) & 0x3FFF
            else:
                if ea == 0x2002: latch = 0
                elif ea == 0x2007:
                    if ppu_addr < 0x2000 and inwin:
                        cpu_chr[('read', slot_banks()[ppu_addr >> 10])] += 1
                    ppu_addr = (ppu_addr + (32 if st[0x2000] & 4 else 1)) & 0x3FFF

out = dict(label=label, dur=[[list(k[0]), k[1], c] for k, c in dur.most_common()], snaps=[[list(k[0]), k[1], k[2], c] for k, c in snaps.items()],
           cpu_chr=[[k[0], k[1], c] for k, c in cpu_chr.items()],
           writes=sorted([[k[0], k[1], c] for k, c in writes.items()]))
json.dump(out, open('chr_%s.json' % label, 'w'))
print(label, 'frames rendered', sum(snaps.values()), 'distinct mappings', len(snaps), 'cpu chr access', sum(cpu_chr.values()))
