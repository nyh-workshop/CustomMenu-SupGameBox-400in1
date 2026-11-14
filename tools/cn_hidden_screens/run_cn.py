import sys, time
import os; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'rombuilder'))
from emu import OneBus
import os
ROM=os.environ.get('ROM') or os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin')
def boot_cn(step=1, reg4119=0x41):
    fl=open(ROM,'rb').read()
    m=OneBus(fl, reg4119)
    m.r41[0x0B]=1
    for i,v in enumerate((0x1C,0x1D,0x1E,0x1F)): m.r41[7+i]=v
    m.pc = m.read(0xFFFC)|m.read(0xFFFD)<<8
    m.p=0x24
    return m
if __name__=='__main__':
    m=boot_cn(); print(hex(m.pc))
    t=time.time()
    for f in range(60): m.run_frame()
    print('60 frames',time.time()-t, hex(m.pc))
    m.render().save('cn60.png')
