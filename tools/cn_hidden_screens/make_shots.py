import sys; import os; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from force import B
from run_cn import boot_cn
from decode_ascii import decode
from PIL import Image, ImageDraw, ImageFont
OUT='shots/'
def new(step):
    m=boot_cn(); m.patches[0xFA42]=step; return m
def frames(m,n):
    for _ in range(n): m.run_frame()
def press(m,b,hold=4,after=10):
    m.pad=B[b]; frames(m,hold); m.pad=0; frames(m,after)
def save(m,name): m.render().resize((512,480),Image.NEAREST).save(OUT+name+'.png'); return OUT+name+'.png'
shots=[]
# normal path
m=new(1); frames(m,200); shots.append((save(m,'01_step1_normal'),'Step 1 (normal boot path): Chinese glyph list, page 1'))
# step 0
m=new(0); frames(m,200); shots.append((save(m,'02_step0_initial'),'Step 0 forced: ASCII list, raw output (CHR base $02)'))
txt0=decode(m)
press(m,'DOWN'); press(m,'DOWN'); press(m,'DOWN'); shots.append((save(m,'03_step0_cursor_row4'),'Step 0: Down x3, cursor on row 4'))
press(m,'RIGHT'); frames(m,60); shots.append((save(m,'04_step0_page2'),'Step 0: Right, page 2 (entries 9-16)'))
txt1=decode(m)
# reconstruction of step 0 page 1
m=new(0); frames(m,200)
for r in range(6,22):
    for c in range(8,30): m.vram[r*32+c]=0
m.lines=[(b[:4]+(0,1,2,3),)+l[1:] for l in m.lines for b in [l[0]]]
img=m.render()
img=img.resize((512,480),Image.NEAREST); d=ImageDraw.Draw(img)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf',22)
except Exception: f=ImageFont.load_default()
for i,s in enumerate(txt0): d.text((10*16,(6+2*i)*16+2),s.strip(),font=f,fill=(255,255,255))
d.rectangle((0,0,511,479),outline=(255,200,0),width=3); d.text((8,456),'RECONSTRUCTION: wallpaper from CHR $00, text decoded from RAM',fill=(255,200,0))
img.save(OUT+'05_step0_reconstructed.png'); shots.append((OUT+'05_step0_reconstructed.png','Step 0 RECONSTRUCTED (not emulator output)'))
# step 2
m=new(2); frames(m,200); shots.append((save(m,'06_step2_initial'),'Step 2 forced: chooser, option 0 (CHR base $82)'))
press(m,'DOWN'); shots.append((save(m,'07_step2_option1'),'Step 2: Down, cursor on option 1'))
press(m,'START'); frames(m,120); shots.append((save(m,'08_step2_start_opt1_to_step0'),'Step 2, Start on option 1: goes to step 0 (ASCII list)'))
m=new(2); frames(m,200); press(m,'START'); frames(m,120); shots.append((save(m,'09_step2_start_opt0_to_step1'),'Step 2, Start on option 0: goes to step 1 (Chinese list)'))
# contact sheet
W,H=512,480; cols=3; rows=(len(shots)+cols-1)//cols
sheet=Image.new('RGB',(cols*W+ (cols+1)*12, rows*(H+40)+12),(32,32,32)); d=ImageDraw.Draw(sheet)
try: cf=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',17)
except Exception: cf=ImageFont.load_default()
for i,(p,cap) in enumerate(shots):
    x=12+(i%cols)*(W+12); y=12+(i//cols)*(H+40)
    sheet.paste(Image.open(p),(x,y+28)); d.text((x,y+4),cap,font=cf,fill=(235,235,235))
sheet.save(OUT+'00_contact_sheet.png')
print(txt0); print(txt1)
