#!/usr/bin/env python3
"""Make small homebrew test cartridges (.nes) for the ROM builder:  python3 make_test_carts.py [OUTDIR, default examples/carts]

Each cart prints its name, then checks that the console maps its memory the way the cartridge expects:
  - every 8 KiB PRG bank starts with a signature [bank number, cart id, $A5]; the cart reads them all
    (NROM: $8000/$A000/$C000/$E000; MMC3: every bank through R6, plus the fixed $C000/$E000 banks);
  - every 1 KiB CHR bank starts with [bank number, cart id]; the cart reads them through $2007
    (NROM: the 8 KiB at PPU $0000-$1FFF; MMC3: every bank through R2) - or, with CHR-RAM, writes and reads back;
  - with WRAM ($6000-$7FFF), writes and reads back.
and shows OK / BAD for each.  So when one of these runs from the multicart, the screen says whether the menu's
OneBus settings for it are right.  The carts are written from scratch for this project (no third-party code).
Needs cc65 (ca65 + ld65): set CC65=/path/to/cc65/bin or have them on PATH."""
import os, sys, subprocess, shutil, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from font5x7 import ascii_tiles

# id, file name, title, mapper, PRG KiB, CHR KiB (0 = CHR-RAM), mirroring, battery/WRAM
CARTS = [
    (1, 'nrom16_test.nes',  'NROM 16K TEST',      0, 16,  8,   'V', False),
    (2, 'nrom32_test.nes',  'NROM 32K TEST',      0, 32,  8,   'H', False),
    (3, 'mmc3_128k.nes',    'MMC3 128K/128K',     4, 128, 128, 'V', False),
    (4, 'mmc3_256k_wram.nes', 'MMC3 256K WRAM',   4, 256, 128, 'H', True),
    (5, 'mmc3_chrram.nes',  'MMC3 CHR-RAM',       4, 128, 0,   'V', False),
    (6, 'mmc3_512k.nes',    'MMC3 512K/256K',     4, 512, 256, 'V', False),
    (7, 'mmc3_64k.nes',     'MMC3 64K/32K',       4, 64,  32,  'H', False),
    (8, 'mmc3_384k.nes',    'MMC3 384K (ODD)',    4, 384, 64,  'V', False),
]


def cc65_bin():
    for d in (os.environ.get('CC65'), os.path.dirname(shutil.which('ca65') or '') or None):
        if d and (os.path.exists(os.path.join(d, 'ca65')) or os.path.exists(os.path.join(d, 'ca65.exe'))): return d
    raise SystemExit('ca65 / ld65 not found: set CC65=/path/to/cc65/bin')


def asm_source(cid, title, mapper, prg_kb, chr_kb, mirror, wram):
    nb = prg_kb // 8
    nchr = chr_kb                     # 1 KiB banks
    lines = [(4, 4, title), (4, 6, 'MAPPER %d  PRG %dK' % (mapper, prg_kb)),
             (4, 7, 'CHR %s' % ('RAM' if not chr_kb else '%dK' % chr_kb) + ('  WRAM' if wram else '')),
             (4, 10, 'PRG BANKS'), (4, 12, 'CHR ' + ('RAM' if not chr_kb else 'BANKS'))]
    if wram: lines.append((4, 14, 'WRAM'))
    lines.append((4, 22, 'ONEBUS BUILDER TEST CART'))
    text = []
    for x, y, s in lines:
        a = 0x2000 + y * 32 + x
        text.append('        .byte $%02X,$%02X,%d,"%s"' % (a >> 8, a & 0xFF, len(s), s))
    def status(row, label):          # write OK at column 16 of `row`, or BAD
        a = 0x2000 + row * 32 + 16
        return '''%s_ok:  lda #$%02X
        sta $2006
        lda #$%02X
        sta $2006
        lda #'O'
        sta $2007
        lda #'K'
        sta $2007
        jmp %s_done
%s_bad: lda #$%02X
        sta $2006
        lda #$%02X
        sta $2006
        lda #'B'
        sta $2007
        lda #'A'
        sta $2007
        lda #'D'
        sta $2007
%s_done:''' % (label, a >> 8, a & 0xFF, label, label, a >> 8, a & 0xFF, label)

    if mapper == 0:
        pairs = [(0x8000, 0), (0xA000, 1), (0xC000, 0 if nb == 2 else 2), (0xE000, 1 if nb == 2 else 3)]
        prg = '\n'.join('''        lda $%04X
        cmp #%d
        bne prg_bad
        lda $%04X
        cmp #%d
        bne prg_bad''' % (a, b, a + 1, cid) for a, b in pairs) + '\n        jmp prg_ok'
    else:
        prg = '''        ldx #0
prg_loop:
        lda #6
        sta $8000
        stx $8001
        cpx $8000
        bne prg_bad
        lda $8001
        cmp #%d
        bne prg_bad
        inx
        cpx #%d
        bne prg_loop
        lda #6
        sta $8000
        lda #0
        sta $8001
        lda $C000
        cmp #%d
        bne prg_bad
        lda $E000
        cmp #%d
        bne prg_bad
        jmp prg_ok''' % (cid, nb, nb - 2, nb - 1)

    if not chr_kb:
        chrc = '''        lda #$10
        sta $2006
        lda #$00
        sta $2006
        lda #$A5
        sta $2007
        lda #$5A
        sta $2007
        lda #$10
        sta $2006
        lda #$00
        sta $2006
        lda $2007
        lda $2007
        cmp #$A5
        bne chr_bad
        lda $2007
        cmp #$5A
        bne chr_bad
        jmp chr_ok'''
    elif mapper == 0:
        chrc = '''        ldx #0
chr_loop:
        txa
        asl a
        asl a
        sta $2006
        lda #0
        sta $2006
        lda $2007
        cpx $2007
        bne chr_bad
        lda $2007
        cmp #%d
        bne chr_bad
        inx
        cpx #8
        bne chr_loop
        jmp chr_ok''' % cid
    else:
        chrc = '''        ldx #0
chr_loop:
        lda #2
        sta $8000
        stx $8001
        lda #$10
        sta $2006
        lda #0
        sta $2006
        lda $2007
        cpx $2007
        bne chr_bad
        lda $2007
        cmp #%d
        bne chr_bad
        inx
        cpx #%d
        bne chr_loop
        lda #2
        sta $8000
        lda #4
        sta $8001
        jmp chr_ok''' % (cid, nchr & 0xFF)

    wr = '''        lda #$A5
        sta $6000
        lda #$5A
        sta $7FFF
        lda $6000
        cmp #$A5
        bne wram_bad
        lda $7FFF
        cmp #$5A
        bne wram_bad
        jmp wram_ok
''' + status(14, 'wram') if wram else ''

    mmc3_init = '''        ldx #0
init_loop:
        stx $8000
        lda init_regs,x
        sta $8001
        inx
        cpx #8
        bne init_loop
        lda #%d
        sta $A000''' % (1 if mirror == 'H' else 0) if mapper == 4 else ''
    upload = '''        lda #$00
        sta $2006
        sta $2006
        lda #<font
        sta $00
        lda #>font
        sta $01
        ldx #16
        ldy #0
up_loop:
        lda ($00),y
        sta $2007
        iny
        bne up_loop
        inc $01
        dex
        bne up_loop''' if not chr_kb else ''
    return '''        .setcpu "6502"
        .segment "CODE"
reset:  sei
        cld
        ldx #$FF
        txs
        lda #0
        sta $2000
        sta $2001
%s
        bit $2002
vb1:    bit $2002
        bpl vb1
vb2:    bit $2002
        bpl vb2
%s
        lda #$3F
        sta $2006
        lda #$00
        sta $2006
        ldx #0
pal_loop:
        lda palette,x
        sta $2007
        inx
        cpx #32
        bne pal_loop
        lda #$20
        sta $2006
        lda #$00
        sta $2006
        ldy #4
        ldx #0
        lda #$20
clr_loop:
        sta $2007
        inx
        bne clr_loop
        dey
        bne clr_loop
        lda #$23
        sta $2006
        lda #$C0
        sta $2006
        lda #0
        ldx #64
attr_loop:
        sta $2007
        dex
        bne attr_loop
        ldx #0
txt_loop:
        lda text,x
        beq txt_done
        sta $2006
        inx
        lda text,x
        sta $2006
        inx
        ldy text,x
        inx
txt_chr:
        lda text,x
        sta $2007
        inx
        dey
        bne txt_chr
        jmp txt_loop
txt_done:
%s
%s
%s
%s
%s
        lda #0
        sta $2005
        sta $2005
        sta $2000
        lda #$0A
        sta $2001
forever:
        jmp forever
nmi:
irq:    rti
palette: .byte $0F,$30,$10,$00, $0F,$30,$10,$00, $0F,$30,$10,$00, $0F,$30,$10,$00
         .byte $0F,$30,$10,$00, $0F,$30,$10,$00, $0F,$30,$10,$00, $0F,$30,$10,$00
init_regs: .byte 0, 2, 4, 5, 6, 7, 0, 1
text:
%s
        .byte 0
%s
        .segment "VECTORS"
        .word nmi, reset, irq
''' % (mmc3_init, upload, prg, status(10, 'prg'), chrc, status(12, 'chr'), wr, '\n'.join(text),
       'font:   .incbin "font.bin"' if not chr_kb else '')


CFG = '''MEMORY { CODE: start=$E010, size=$1FEA, fill=yes, fillval=$FF; VEC: start=$FFFA, size=6; }
SEGMENTS { CODE: load=CODE, type=ro; VECTORS: load=VEC, type=ro; }
'''


def build_cart(cid, title, mapper, prg_kb, chr_kb, mirror, wram, B, tmp):
    font = ascii_tiles()
    open(os.path.join(tmp, 'font.bin'), 'wb').write(font)
    open(os.path.join(tmp, 'cart.s'), 'w').write(asm_source(cid, title, mapper, prg_kb, chr_kb, mirror, wram))
    open(os.path.join(tmp, 'cart.cfg'), 'w').write(CFG)
    for cmd in ([B + '/ca65', '-o', 'cart.o', 'cart.s'], [B + '/ld65', '-C', 'cart.cfg', '-o', 'code.bin', 'cart.o']):
        r = subprocess.run(cmd, cwd=tmp, capture_output=True, text=True)
        if r.returncode: raise SystemExit(r.stdout + r.stderr)
    code = open(os.path.join(tmp, 'code.bin'), 'rb').read()          # $E010-$FFFF
    nb = prg_kb // 8
    prg = bytearray(b'\xFF' * (prg_kb * 1024))
    for b in range(nb):
        prg[b * 0x2000:b * 0x2000 + 3] = bytes([b, cid, 0xA5])
    prg[(nb - 1) * 0x2000 + 0x10:nb * 0x2000] = code
    chrd = bytearray()
    for k in range(chr_kb):
        blk = bytearray([(k * 7 + j) & 0xFF for j in range(0x400)])    # some non-blank filler
        if k == 0: blk[0x200:0x400] = font[0x200:0x400]                 # tiles $20-$3F
        if k == 1: blk[0:0x200] = font[0x400:0x600]                     # tiles $40-$5F
        blk[0:2] = bytes([k, cid])                                      # signature (tile 0 / tile $40 '@': unused)
        chrd += blk
    hdr = bytearray(b'NES\x1a') + bytes([prg_kb // 16, chr_kb // 8,
                                         ((mapper & 0x0F) << 4) | (1 if mirror == 'V' else 0) | (2 if wram else 0),
                                         mapper & 0xF0]) + bytes(8)
    return bytes(hdr) + bytes(prg) + bytes(chrd)


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'carts')
    os.makedirs(out, exist_ok=True)
    B = cc65_bin()
    tmp = tempfile.mkdtemp(prefix='carts_')
    for c in CARTS:
        data = build_cart(c[0], c[2], c[3], c[4], c[5], c[6], c[7], B, tmp)
        open(os.path.join(out, c[1]), 'wb').write(data)
        print('%-22s %-18s mapper %d  PRG %3dK  CHR %s' % (c[1], c[2], c[3], c[4], 'RAM' if not c[5] else '%dK' % c[5]))
    shutil.rmtree(tmp)


if __name__ == '__main__':
    main()
