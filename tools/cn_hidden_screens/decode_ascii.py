def decode(m, rows=range(6,22,2), c0=8, c1=30):
    cm=m.ram[0x3FA:0x47A]; pair={}
    for c in range(0x20,0x60):
        t,b=cm[c-0x20],cm[c-0x20+0x40]
        if (t or b) and (t,b) not in pair: pair[(t,b)]=chr(c)
    out=[]
    for r in rows:
        s=''
        for c in range(c0,c1):
            t,b=m.vram[r*32+c],m.vram[(r+1)*32+c]
            s+=' ' if (t,b)==(0,0) else pair.get((t,b),'?')
        out.append(s.rstrip())
    return out
