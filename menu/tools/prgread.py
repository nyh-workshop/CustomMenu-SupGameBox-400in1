"""Replay a trace and map every PRG access ($8000-$FFFF) to a file offset with the
OneBus rule (VT02+ PRG-ROM Bankswitching):
  bank8k = (inner & IM) | ($410A & ~IM) | (($4100 >> 4) << 8)     IM from $410B bits 0-2
  $8000=$4107  $A000=$4108  $C000=$4109 if $410B bit6 else $FE  $E000=$FF
  $4105 bit6 swaps $8000<->$C000 (MMC3 $8000 bit 6)
Checks the rule against FCEUX's 16 KiB bank prefix on every executed ROM instruction.
Usage: prgread.py trace start end label"""
import re, sys, collections, json
fn, lo, hi, label = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
PS = {0: 0x3F, 1: 0x1F, 2: 0x0F, 3: 0x07, 4: 0x03, 5: 0x01, 6: 0x00, 7: 0xFF}
st = collections.defaultdict(int)
mmc3_sel = 0
line_re = re.compile(r'^A:([0-9A-F]{2}) X:([0-9A-F]{2}) Y:([0-9A-F]{2}) S:[0-9A-F]{2}\s+\$(?:([0-9A-F]{2}):)?([0-9A-F]{4}): ((?:[0-9A-F]{2} ){1,3})\s*(\S+)\s*(.*)$')
ea_re = re.compile(r'@ \$([0-9A-F]{4})|^\(?\$([0-9A-F]{4})')
READS = {'LDA', 'LDX', 'LDY', 'ADC', 'SBC', 'AND', 'ORA', 'EOR', 'CMP', 'CPX', 'CPY', 'BIT'}

def slot_bank(slot):
    im = PS[st[0x410B] & 7]
    if st[0x4105] & 0x40 and slot in (0, 2):
        slot ^= 2
    inner = {0: st[0x4107], 1: st[0x4108], 2: st[0x4109] if st[0x410B] & 0x40 else 0xFE, 3: 0xFF}[slot]
    return (inner & im) | (st[0x410A] & ~im & 0xFF) | ((st[0x4100] >> 4) << 8)

def foff(addr):
    return slot_bank((addr - 0x8000) >> 13) * 0x2000 + (addr & 0x1FFF)

reads = collections.Counter(); execs = collections.Counter(); mism = collections.Counter(); bankw = collections.Counter()
n = 0
with open(fn, errors='replace') as f:
    for line in f:
        n += 1
        if n > hi: break
        m = line_re.match(line)
        if not m: continue
        a, x, y, bk, pc, byts, mn, rest = m.groups()
        pc = int(pc, 16)
        inwin = n >= lo
        if inwin and pc >= 0x8000:
            o = foff(pc)
            execs[o] += 1
            if bk is not None and int(bk, 16) * 0x4000 + (pc & 0x3FFF) != o:
                mism[(bk, '%04X' % pc, '%05X' % o)] += 1
        e = ea_re.search(rest)
        if not e: continue
        ea = int(e.group(1) or e.group(2), 16)
        if mn in ('STA', 'STX', 'STY'):
            v = int({'STA': a, 'STX': x, 'STY': y}[mn], 16)
            if 0x4100 <= ea <= 0x410B or ea == 0x4105:
                st[ea] = v
                if inwin: bankw[('%04X' % ea, '%02X' % v)] += 1
            elif ea == 0x8000:
                mmc3_sel = v; st[0x4105] = (st[0x4105] & ~0xC0 & 0xFF) | (v & 0xC0)
            elif ea == 0x8001:
                if mmc3_sel & 7 == 6: st[0x4107] = v
                elif mmc3_sel & 7 == 7: st[0x4108] = v
        elif mn in READS and ea >= 0x8000 and inwin and 'JMP' not in mn:
            reads[foff(ea)] += 1
json.dump(dict(reads=sorted(reads.items()), execs=sorted(execs.items()), mism=[[*k, c] for k, c in mism.items()],
               bankw=sorted([[*k, c] for k, c in bankw.items()])), open('prg_%s.json' % label, 'w'))
print(label, 'reads', sum(reads.values()), 'distinct', len(reads), 'execs', len(execs), 'formula mismatches', sum(mism.values()))
