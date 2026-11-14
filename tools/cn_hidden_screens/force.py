import sys
import os; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from run_cn import boot_cn
B=dict(A=0x80,B=0x40,SEL=0x20,START=0x10,UP=8,DOWN=4,LEFT=2,RIGHT=1)
def run(step, script, tag, reg4119=0x41, log=None):
    m=boot_cn(reg4119=reg4119)
    m.patches[0xFA42]=step
    reads=[]
    m.watch_read[0x000D]=lambda pc: reads.append(pc)
    f=0
    for item in script:
        if item[0]=='wait':
            for _ in range(item[1]): m.run_frame(); f+=1
        elif item[0]=='press':
            m.pad=B[item[1]]
            for _ in range(item[2] if len(item)>2 else 4): m.run_frame(); f+=1
            m.pad=0
            for _ in range(8): m.run_frame(); f+=1
        elif item[0]=='shot':
            m.render().resize((512,480)).save('shots/%s_%s.png'%(tag,item[1]))
            if log is not None: log.append((tag,item[1],f,hex(m.pc),m.ram[0x30],m.ram[0x31],m.ram[0x32],dict(r4107=hex(m.r41[7]),r410b=hex(m.r41[0xb]),r4100=hex(m.r41[0]))))
    return m, reads
