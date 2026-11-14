import re, sys, collections, pickle
pat = re.compile(r'\$([0-9A-F]{2}):([0-9A-F]{4}): ((?:[0-9A-F]{2} ){1,3})\s*(\S.*)$')
res = {}
for fn in sys.argv[1:]:
    execd = {}            # fileoff -> (len, first line idx)
    order = []            # first-hit order of 'blocks' (16K bank, cpu addr)
    regw = collections.OrderedDict()
    n = 0
    with open(fn, 'r', errors='replace') as f:
        for line in f:
            m = pat.search(line)
            if not m: continue
            n += 1
            bank = int(m.group(1),16); pc = int(m.group(2),16)
            nb = len(m.group(3).split())
            if pc < 0x8000:
                off = ('RAM', pc)
            else:
                off = bank*0x4000 + (pc & 0x3fff)
            if off not in execd:
                execd[off] = (nb, n, pc)
            ins = m.group(4)
            mm = re.match(r'ST[AXY] \$(4[01][0-9A-F]{2}|20[01][0-9A-F]|8000|8001|A000|A001|C000|C001|E000|E001)', ins)
            if mm:
                key = (mm.group(1), line.split('A:')[1][:2] if 'A:' in line else '')
                regw.setdefault(mm.group(1), collections.Counter())
                # value stored: from register field
                r = ins[2]
                regs = dict(re.findall(r'([AXY]):([0-9A-F]{2})', line))
                regw[mm.group(1)][(regs.get(r,'??'), '%02X:%04X'%(bank,pc))] += 1
    res[fn] = dict(execd=execd, regw=regw, n=n)
    print(fn, 'lines', n, 'unique PCs', len(execd), file=sys.stderr)
import os; pickle.dump(res, open('cov_'+os.path.basename(sys.argv[1])[31:-4]+'.pkl','wb'))
