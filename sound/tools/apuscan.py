"""usage: python apuscan.py TRACE.log LABEL  -> apu_LABEL.pkl
One pass over an FCEUX trace: every APU write ($4000-$4017, incl. FCEUX names) and every PRG data
read, keyed by the file offset of the instruction (OneBus PRG rule, as prgread2.py)."""
import re, sys, collections, pickle
fn, label = sys.argv[1], sys.argv[2]
PS = {0: 0x3F, 1: 0x1F, 2: 0x0F, 3: 0x07, 4: 0x03, 5: 0x01, 6: 0x00, 7: 0xFF}
st = collections.defaultdict(int); mmc3_sel = 0
line_re = re.compile(r'^A:([0-9A-F]{2}) X:([0-9A-F]{2}) Y:([0-9A-F]{2}) S:[0-9A-F]{2}\s+\$(?:([0-9A-F]{2}):)?([0-9A-F]{4}): ((?:[0-9A-F]{2} ){1,3})\s*(\S+)\s*(.*)$')
ea_re = re.compile(r'@ \$([0-9A-F]{4})|^\(?\$([0-9A-F]{4})')
NAMES = {'SQ1_VOL':0x4000,'SQ1_SWEEP':0x4001,'SQ1_LO':0x4002,'SQ1_HI':0x4003,'SQ2_VOL':0x4004,'SQ2_SWEEP':0x4005,'SQ2_LO':0x4006,'SQ2_HI':0x4007,
 'TRI_LINEAR':0x4008,'TRI_LO':0x400A,'TRI_HI':0x400B,'NOISE_VOL':0x400C,'NOISE_LO':0x400E,'NOISE_HI':0x400F,'DMC_FREQ':0x4010,'DMC_RAW':0x4011,
 'DMC_START':0x4012,'DMC_LEN':0x4013,'APU_STATUS':0x4015,'APU_FRAME':0x4017}
READS = {'LDA','LDX','LDY','ADC','SBC','AND','ORA','EOR','CMP','CPX','CPY','BIT'}
def foff(addr):
    slot=(addr-0x8000)>>13; im=PS[st[0x410B]&7]
    if st[0x4105]&0x40 and slot in (0,2): slot^=2
    inner={0:st[0x4107],1:st[0x4108],2:st[0x4109] if st[0x410B]&0x40 else 0xFE,3:0xFF}[slot]
    return ((inner&im)|(st[0x410A]&~im&0xFF)|((st[0x4100]>>4)<<8))*0x2000+(addr&0x1FFF)
apu=collections.Counter(); apuvals=collections.defaultdict(set); reads=collections.defaultdict(collections.Counter)
first=collections.OrderedDict(); n=0
with open(fn,errors='replace') as f:
    for line in f:
        n+=1
        m=line_re.match(line)
        if not m: continue
        a,x,y,bk,pc,byts,mn,rest=m.groups(); pc=int(pc,16)
        src=foff(pc) if pc>=0x8000 else -pc
        tok=rest.split(' ')[0].rstrip(',')
        if mn in ('STA','STX','STY'):
            v=int({'STA':a,'STX':x,'STY':y}[mn],16)
            ea=None
            base=tok.split(',')[0]
            if base in NAMES: ea=NAMES[base]
            else:
                e=ea_re.search(rest)
                if e: ea=int(e.group(1) or e.group(2),16)
            if ea is None: continue
            if 0x4000<=ea<=0x4017:
                apu[(src,ea)]+=1; apuvals[(src,ea)].add(v)
                if src not in first: first[src]=n
            elif 0x4100<=ea<=0x410B: st[ea]=v
            elif ea==0x8000: mmc3_sel=v; st[0x4105]=(st[0x4105]&0x3F)|(v&0xC0)
            elif ea==0x8001:
                if mmc3_sel&7==6: st[0x4107]=v
                elif mmc3_sel&7==7: st[0x4108]=v
        elif mn in READS:
            e=ea_re.search(rest)
            if e:
                ea=int(e.group(1) or e.group(2),16)
                if ea>=0x8000: reads[src][foff(ea)]+=1
pickle.dump(dict(apu=apu,apuvals=apuvals,reads=dict(reads),first=first,lines=n),open('apu_%s.pkl'%label,'wb'))
print(label,'done',n)
