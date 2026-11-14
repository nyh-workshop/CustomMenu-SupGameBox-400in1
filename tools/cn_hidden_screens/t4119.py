import sys, hashlib; import os; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from force import run, B
from run_cn import boot_cn
SCRIPTS={1:[('wait',200),('press','DOWN'),('press','RIGHT'),('wait',60),('press','DOWN')],
         0:[('wait',200),('press','DOWN'),('press','RIGHT'),('wait',60)],
         2:[('wait',200),('press','DOWN'),('press','START'),('wait',120),('press','DOWN')]}
def go(step,val):
    m=boot_cn(reg4119=val); m.patches[0xFA42]=step
    h=hashlib.md5(); reads0d=[]; r4119=[]
    orig_read=m.read
    def rd(a):
        if a==0x000D: reads0d.append(m.pc)
        if a==0x4119: r4119.append(m.pc)
        return orig_read(a)
    m.read=rd
    os=m.step
    def st(): h.update(m.pc.to_bytes(2,'little')); os()
    m.step=st
    for it in SCRIPTS[step]:
        if it[0]=='wait':
            for _ in range(it[1]): m.run_frame()
        else:
            m.pad=B[it[1]]
            for _ in range(4): m.run_frame()
            m.pad=0
            for _ in range(8): m.run_frame()
    ram=bytearray(m.ram); flag=ram[0x0D]; ram[0x0D]=0
    img=hashlib.md5(m.render().tobytes()).hexdigest()[:8]
    return flag, h.hexdigest()[:8], hashlib.md5(ram).hexdigest()[:8], img, sorted(set(reads0d)), sorted(set(r4119))
for step in (1,0,2):
    for val in (0x41,0x00,0xFF,0x18,0x08,0x10):
        print('step',step,'$4119=%02X'%val, go(step,val))
