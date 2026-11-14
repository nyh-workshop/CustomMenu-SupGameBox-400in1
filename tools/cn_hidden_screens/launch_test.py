import sys; import os; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from force import run, B
from decode_ascii import decode
from run_cn import ROM
fl=open(ROM,'rb').read()
def ename(k): return fl[0x78000+16*k:0x78000+16*k+16].split(b'\xff')[0].decode('ascii','replace')
def launch(step, pre, tag, reg4119=0x41):
    m,_=run(step,[('wait',200)]+pre,tag,reg4119=reg4119)
    shown = decode(m) if step==0 else None
    info={'cn_page':m.ram[0x375],'cn_row':m.ram[0x3C3]}
    log=[]; ow=m.write
    def w(a,v):
        if 0x4100<=a<=0x411F or 0x2010<=a<=0x201F: log.append((hex(m.pc),hex(a),'%02X'%v))
        ow(a,v)
    m.write=w
    hit={}
    os=m.step
    def st():
        if m.pc in (0xAADB,0xAAE8) and m.r41[0x0B]==4 and 'idx' not in hit:
            hit['idx']=m.ram[0x18]|m.ram[0x19]<<8; hit['rec0400']=bytes(m.ram[0x400:0x408]).hex()
        os()
    m.step=st
    m.pad=B['START']
    for i in range(6): m.run_frame()
    m.pad=0
    try:
        for i in range(40): m.run_frame()
    except Exception as e: hit['stop']=str(e)
    hit['final_pc']=hex(m.pc)
    return m,shown,info,hit,log
if __name__=='__main__':
    for step,pre in ((1,[('press','DOWN'),('press','DOWN')]),(0,[('press','DOWN'),('press','DOWN')])):
        m,shown,info,hit,log=launch(step,pre,'L%d'%step)
        print('=== step',step,info,hit)
        if shown: print(shown)
        if 'idx' in hit: print('English entry',hit['idx'],ename(hit['idx']))
        for l in log[-30:]: print(l)
