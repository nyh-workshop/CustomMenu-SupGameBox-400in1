# 6502 opcode table (legal opcodes only) shared by disassembler and verifier.
# mode names: imp acc imm zp zpx zpy abs abx aby ind izx izy rel
MODES_LEN = dict(imp=1, acc=1, imm=2, zp=2, zpx=2, zpy=2, abs=3, abx=3, aby=3,
                 ind=3, izx=2, izy=2, rel=2)

_T = """
00 brk imp|01 ora izx|05 ora zp|06 asl zp|08 php imp|09 ora imm|0A asl acc|0D ora abs|0E asl abs
10 bpl rel|11 ora izy|15 ora zpx|16 asl zpx|18 clc imp|19 ora aby|1D ora abx|1E asl abx
20 jsr abs|21 and izx|24 bit zp|25 and zp|26 rol zp|28 plp imp|29 and imm|2A rol acc|2C bit abs|2D and abs|2E rol abs
30 bmi rel|31 and izy|35 and zpx|36 rol zpx|38 sec imp|39 and aby|3D and abx|3E rol abx
40 rti imp|41 eor izx|45 eor zp|46 lsr zp|48 pha imp|49 eor imm|4A lsr acc|4C jmp abs|4D eor abs|4E lsr abs
50 bvc rel|51 eor izy|55 eor zpx|56 lsr zpx|58 cli imp|59 eor aby|5D eor abx|5E lsr abx
60 rts imp|61 adc izx|65 adc zp|66 ror zp|68 pla imp|69 adc imm|6A ror acc|6C jmp ind|6D adc abs|6E ror abs
70 bvs rel|71 adc izy|75 adc zpx|76 ror zpx|78 sei imp|79 adc aby|7D adc abx|7E ror abx
81 sta izx|84 sty zp|85 sta zp|86 stx zp|88 dey imp|8A txa imp|8C sty abs|8D sta abs|8E stx abs
90 bcc rel|91 sta izy|94 sty zpx|95 sta zpx|96 stx zpy|98 tya imp|99 sta aby|9A txs imp|9D sta abx
A0 ldy imm|A1 lda izx|A2 ldx imm|A4 ldy zp|A5 lda zp|A6 ldx zp|A8 tay imp|A9 lda imm|AA tax imp|AC ldy abs|AD lda abs|AE ldx abs
B0 bcs rel|B1 lda izy|B4 ldy zpx|B5 lda zpx|B6 ldx zpy|B8 clv imp|B9 lda aby|BA tsx imp|BC ldy abx|BD lda abx|BE ldx aby
C0 cpy imm|C1 cmp izx|C4 cpy zp|C5 cmp zp|C6 dec zp|C8 iny imp|C9 cmp imm|CA dex imp|CC cpy abs|CD cmp abs|CE dec abs
D0 bne rel|D1 cmp izy|D5 cmp zpx|D6 dec zpx|D8 cld imp|D9 cmp aby|DD cmp abx|DE dec abx
E0 cpx imm|E1 sbc izx|E4 cpx zp|E5 sbc zp|E6 inc zp|E8 inx imp|E9 sbc imm|EA nop imp|EC cpx abs|ED sbc abs|EE inc abs
F0 beq rel|F1 sbc izy|F5 sbc zpx|F6 inc zpx|F8 sed imp|F9 sbc aby|FD sbc abx|FE inc abx
"""
OPS = {}
for chunk in _T.replace('\n', '|').split('|'):
    chunk = chunk.strip()
    if not chunk:
        continue
    h, m, md = chunk.split()
    OPS[int(h, 16)] = (m, md)
ENC = {(m, md): op for op, (m, md) in OPS.items()}
assert len(OPS) == 151, len(OPS)
