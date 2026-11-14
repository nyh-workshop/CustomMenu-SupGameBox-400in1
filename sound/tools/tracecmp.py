"""Compare the NSF player's APU writes with an FCEUX trace.
usage: python tracecmp.py ROM_512KiB.bin TRACE_DIR"""
import re, sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'music'))   # sndlib.py
from sndlib import Block, NSFPlayer
NAMES = {'SQ1_VOL':0x4000,'SQ1_SWEEP':0x4001,'SQ1_LO':0x4002,'SQ1_HI':0x4003,'SQ2_VOL':0x4004,'SQ2_SWEEP':0x4005,'SQ2_LO':0x4006,'SQ2_HI':0x4007,
 'TRI_LINEAR':0x4008,'TRI_LO':0x400A,'TRI_HI':0x400B,'NOISE_VOL':0x400C,'NOISE_LO':0x400E,'NOISE_HI':0x400F,'APU_STATUS':0x4015}
rx = re.compile(r'^A:([0-9A-F]{2}) X:([0-9A-F]{2}) Y:([0-9A-F]{2}).*?\$(?:[0-9A-F]{2}:)?([0-9A-F]{4}): (?:[0-9A-F]{2} ){1,3}\s*(ST[AXY]) (\S+)(?: @ (\S+))?')
def trace_apu(fn, start_line, lo, hi):
    out = []
    with open(fn, errors='replace') as f:
        for i, l in enumerate(f):
            if i < start_line: continue
            m = rx.match(l)
            if not m: continue
            a, x, y, pc, mn, op, eff = m.groups()
            if not lo <= int(pc, 16) < hi: continue
            nm = (eff or op).split(',')[0]
            if nm in NAMES: out.append((NAMES[nm], int({'STA': a, 'STX': x, 'STY': y}[mn], 16)))
    return out
rom = open(sys.argv[1], 'rb').read(); T = os.path.join(sys.argv[2], '400in1_romdump_10042024_512KiB_')
for nm, trace, start, lo, hi in (('chinese', 'chinese', 2096300, 0xE379, 0xEB30), ('langsel', 'english', 450700, 0xEF26, 0xF700),
                                 ('langsel', 'chinese', 450700, 0xEF26, 0xF700)):
    tr = trace_apu(T + trace + '.log', start, lo, hi)
    fr = NSFPlayer(Block(rom, nm).nsf()).run(0, 3000)
    em = [w for f in fr for w in f if w[0] not in (0x4009, 0x400D)]   # FCEUX has no names for these unused registers
    bad = next((i for i in range(len(tr)) if tr[i] != em[i]), None)
    print('%-8s vs %-8s trace: %d APU writes, %s' % (nm, trace, len(tr), 'all identical' if bad is None else 'first difference at %d' % bad))
