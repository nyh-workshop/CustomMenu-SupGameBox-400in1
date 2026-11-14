"""Minimal OneBus (VT02-style) NES emulator for poking at the 400-in-1 menus.

Scope: 6502 (legal opcodes), 2 KiB RAM, OneBus PRG banking ($4100, $4107-$410B,
MMC3-style $8000/$8001), OneBus CHR banking ($2012-$201A, $4100 low bits),
PPU registers, OAM DMA, pad 1, and a scanline IRQ on $4101-$4104 modelled like
MMC3 (latch / reload / disable+ack / enable) -- an emulator ASSUMPTION.
Rendering: per-scanline register snapshots, background + sprites drawn on demand.
Not emulated: APU (writes ignored), VT extended video modes, open-bus details.
"""
import array

NESPAL = [int(x, 16) for x in '''7C7C7C 0000FC 0000BC 4428BC 940084 A80020 A81000 881400 503000 007800 006800 005800 004058 000000 000000 000000
BCBCBC 0078F8 0058F8 6844FC D800CC E40058 F83800 E45C10 AC7C00 00B800 00A800 00A844 008888 000000 000000 000000
F8F8F8 3CBCFC 6888FC 9878F8 F878F8 F85898 F87858 FCA044 F8B800 B8F818 58D854 58F898 00E8D8 787878 000000 000000
FCFCFC A4E4FC B8B8F8 D8B8F8 F8B8F8 F8A4C0 F0D0B0 FCE0A8 F8D878 D8F878 B8F8B8 B8F8D8 00FCFC F8D8F8 000000 000000'''.split()]
PS = {0: 0x3F, 1: 0x1F, 2: 0x0F, 3: 0x07, 4: 0x03, 5: 0x01, 6: 0x00, 7: 0xFF}
CMASK = {0: 0xFF, 1: 0x7F, 2: 0x3F, 3: 0xFF, 4: 0x1F, 5: 0x0F, 6: 0x07, 7: 0xFF}

# base cycle counts (page-cross penalties ignored)
CYC = [7,6,2,8,3,3,5,5,3,2,2,2,4,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7,
       6,6,2,8,3,3,5,5,4,2,2,2,4,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7,
       6,6,2,8,3,3,5,5,3,2,2,2,3,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7,
       6,6,2,8,3,3,5,5,4,2,2,2,5,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7,
       2,6,2,6,3,3,3,3,2,2,2,2,4,4,4,4, 2,6,2,6,4,4,4,4,2,5,2,5,5,5,5,5,
       2,6,2,6,3,3,3,3,2,2,2,2,4,4,4,4, 2,5,2,5,4,4,4,4,2,4,2,4,4,4,4,4,
       2,6,2,8,3,3,5,5,2,2,2,2,4,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7,
       2,6,2,8,3,3,5,5,2,2,2,2,4,4,6,6, 2,5,2,8,4,4,6,6,2,4,2,7,4,4,7,7]


class Halt(Exception):
    pass


SWAP45 = bytes((v & 0xCF) | ((v >> 1) & 0x10) | ((v << 1) & 0x20) for v in range(256))   # opcode bits 4 <-> 5


class OneBus:
    def __init__(self, flash, reg4119=0x41, scrambled=False):
        self.flash = flash
        # the handheld starts with its opcode decoder scrambled (bits 4 <-> 5 of every opcode fetched, operands as they
        # are) until the reset code writes $411C; emulators, and this model by default, start plain
        self.scrambled = scrambled
        self.ram = bytearray(0x800)
        self.r41 = bytearray(0x100)        # $4100-$41FF write latches
        self.r20 = bytearray(0x10)         # $2010-$201F
        self.mmc3_sel = 0
        self.mirror_h = 0
        self.reg4119 = reg4119
        # PPU
        self.vram = bytearray(0x800); self.pal = bytearray(32); self.oam = bytearray(256)
        self.chrram = bytearray(0x2000); self.wram = bytearray(0x2000)     # CHR-RAM ($4118 bit 7), PRG-RAM $6000
        self.ctrl = self.mask = 0; self.status = 0; self.oamaddr = 0
        self.latch = 0; self.v = 0; self.t = 0; self.fx = 0; self.rbuf = 0
        self.scroll_x = 0; self.scroll_y = 0
        # IRQ (MMC3-like model on $4101-$4104)
        self.irq_latch = 0; self.irq_counter = 0; self.irq_reload = False; self.irq_en = False; self.irq_line = False
        # pad
        self.pad = 0; self.pad_shift = 0; self.pad_strobe = 0
        # CPU
        self.a = self.x = self.y = 0; self.s = 0xFD; self.p = 0x24; self.pc = 0
        self.cycles = 0; self.nmi_pending = False
        self.watch_read = {}               # addr -> callback(pc)
        self.lines = []                    # per-scanline snapshot of the last frame
        self.frame = 0
        self.patches = {}                  # CPU address -> byte override (code patches)

    # ------------------------------------------------------------ banking
    def prg_off(self, a):
        r = self.r41
        im = PS[r[0x0B] & 7]
        slot = (a - 0x8000) >> 13
        if r[0x05] & 0x40 and slot in (0, 2):
            slot ^= 2
        inner = (r[0x07], r[0x08], r[0x09] if r[0x0B] & 0x40 else 0xFE, 0xFF)[slot]
        bank = (inner & im) | (r[0x0A] & ~im & 0xFF) | ((r[0x00] >> 4) << 8)
        return (bank * 0x2000 + (a & 0x1FFF)) % len(self.flash)

    def chr_banks(self):
        r = self.r20
        m = CMASK[r[0x0A] & 7]
        base = ((self.r41[0] & 0x0F) << 11) | (((r[0x08] >> 4) & 7) << 8)
        mid = r[0x0A] & ~m & 0xFF
        inner = [r[0x06] & 0xFE, r[0x06] | 1, r[0x07] & 0xFE, r[0x07] | 1, r[0x02], r[0x03], r[0x04], r[0x05]]
        b = [base | (v & m) | mid for v in inner]
        if self.r41[0x05] & 0x80:
            b = b[4:] + b[:4]
        return tuple(b)

    # ------------------------------------------------------------ bus
    def read(self, a):
        if a < 0x2000:
            if a == 0x000D and 0x000D in self.watch_read: self.watch_read[0x000D](self.pc)
            return self.ram[a & 0x7FF]
        if a >= 0x8000:
            if a in self.patches: return self.patches[a]
            return self.flash[self.prg_off(a)]
        if a < 0x4000:
            if 0x2010 <= a < 0x2020: return self.r20[a - 0x2010]
            return self.ppu_read(a & 7)
        if a == 0x4016:
            v = (self.pad_shift >> 7) & 1
            if not self.pad_strobe: self.pad_shift = (self.pad_shift << 1) & 0xFF | 1
            return v | 0x40
        if a == 0x4119:
            return self.reg4119
        if 0x4100 <= a < 0x4200:
            return self.r41[a - 0x4100]
        if 0x6000 <= a < 0x8000:
            return self.wram[a - 0x6000]
        return 0

    def write(self, a, v):
        if a < 0x2000:
            self.ram[a & 0x7FF] = v; return
        if 0x6000 <= a < 0x8000:
            self.wram[a - 0x6000] = v; return
        if a < 0x4000:
            if 0x2010 <= a < 0x2020: self.r20[a - 0x2010] = v; return
            self.ppu_write(a & 7, v); return
        if a == 0x4014:
            base = v << 8
            for i in range(256): self.oam[(self.oamaddr + i) & 0xFF] = self.read(base + i)
            self.cycles += 513; return
        if a == 0x4016:
            self.pad_strobe = v & 1
            if self.pad_strobe: self.pad_shift = self.pad
            return
        if 0x4100 <= a < 0x4200:
            self.r41[a - 0x4100] = v
            if a == 0x4101: self.irq_latch = v & 0xFE
            elif a == 0x4102: self.irq_reload = True; self.irq_counter = 0
            elif a == 0x4103: self.irq_en = False; self.irq_line = False
            elif a == 0x4104: self.irq_en = True
            elif a == 0x411C: self.scrambled = False
            return
        if a >= 0x8000:
            if a & 0xE001 == 0x8000:
                self.mmc3_sel = v; self.r41[0x05] = (self.r41[0x05] & 0x3F) | (v & 0xC0)
            elif a & 0xE001 == 0x8001:
                r = self.mmc3_sel & 7
                if r == 6: self.r41[0x07] = v
                elif r == 7: self.r41[0x08] = v
                else: self.r20[(0x06, 0x07, 0x02, 0x03, 0x04, 0x05)[r]] = v
            elif a & 0xE001 == 0xA000:
                self.mirror_h = v & 1
            elif a & 0xE001 == 0xC000: self.irq_latch = v
            elif a & 0xE001 == 0xC001: self.irq_reload = True
            elif a & 0xE001 == 0xE000: self.irq_en = False; self.irq_line = False
            elif a & 0xE001 == 0xE001: self.irq_en = True
            return

    # ------------------------------------------------------------ PPU
    def nt_index(self, a):
        a &= 0xFFF
        if self.mirror_h: return ((a >> 1) & 0x400) | (a & 0x3FF)
        return a & 0x7FF

    def ppu_read(self, r):
        if r == 2:
            v = self.status; self.status &= 0x7F; self.latch = 0; return v
        if r == 4: return self.oam[self.oamaddr]
        if r == 7:
            a = self.v & 0x3FFF
            if a >= 0x3F00:
                v = self.pal[a & 0x1F]
            else:
                v = self.rbuf; self.rbuf = self.vread(a)
            self.v = (self.v + (32 if self.ctrl & 4 else 1)) & 0x7FFF
            return v
        return 0

    def vread(self, a):
        if a < 0x2000 and self.r41[0x18] & 0x80:
            return self.chrram[a]
        if a < 0x2000:
            b = self.chr_banks()[a >> 10]
            return self.flash[(b * 0x400 + (a & 0x3FF)) % len(self.flash)]
        return self.vram[self.nt_index(a)]

    def ppu_write(self, r, v):
        if r == 0:
            self.ctrl = v; self.t = (self.t & 0x73FF) | ((v & 3) << 10)
        elif r == 1: self.mask = v
        elif r == 3: self.oamaddr = v
        elif r == 4: self.oam[self.oamaddr] = v; self.oamaddr = (self.oamaddr + 1) & 0xFF
        elif r == 5:
            if self.latch == 0: self.scroll_x = v
            else: self.scroll_y = v
            self.latch ^= 1
        elif r == 6:
            if self.latch == 0: self.t = (self.t & 0xFF) | ((v & 0x3F) << 8)
            else: self.t = (self.t & 0x7F00) | v; self.v = self.t
            self.latch ^= 1
        elif r == 7:
            a = self.v & 0x3FFF
            if a >= 0x3F00:
                i = a & 0x1F
                if i & 3 == 0: i &= 0x0F
                self.pal[i] = v & 0x3F
                if i in (0, 4, 8, 12): self.pal[i | 0x10] = v & 0x3F
            elif a < 0x2000:
                if self.r41[0x18] & 0x80: self.chrram[a] = v
            elif a >= 0x2000:
                self.vram[self.nt_index(a)] = v
            self.v = (self.v + (32 if self.ctrl & 4 else 1)) & 0x7FFF

    # ------------------------------------------------------------ CPU helpers
    def push(self, v): self.write(0x100 | self.s, v); self.s = (self.s - 1) & 0xFF
    def pop(self): self.s = (self.s + 1) & 0xFF; return self.read(0x100 | self.s)

    def interrupt(self, vec, brk=False):
        self.push(self.pc >> 8); self.push(self.pc & 0xFF)
        self.push((self.p | 0x20 | (0x10 if brk else 0)) & (0xFF if brk else 0xEF))
        self.p |= 0x04
        self.pc = self.read(vec) | self.read(vec + 1) << 8
        self.cycles += 7

    def setnz(self, v):
        self.p = (self.p & 0x7D) | (v & 0x80) | (0 if v else 0x02)

    def step(self):
        pc = self.pc; op = self.read(pc)
        if self.scrambled: op = SWAP45[op]
        rd = self.read
        b1 = rd((pc + 1) & 0xFFFF)
        self.cycles += CYC[op]
        x, y = self.x, self.y
        # ---- addressing by opcode group
        lo = op & 0x1F
        mode = None
        if op in (0x20,):
            pass
        # decode via table built once
        f = OPS[op]
        if f is None:
            raise Halt('illegal opcode %02X at %04X' % (op, pc))
        f(self, pc, b1)

    def run_frame(self, on_line=None):
        """One frame: 262 scanlines of ~113.67 CPU cycles; vblank at 241."""
        self.lines = []
        self.status &= 0x1F                         # clear vblank / sprite 0 at pre-render
        ys = self.scroll_y
        for sl in range(262):
            target = self.cycles + (114 if sl % 3 else 113)
            if sl == 241:
                self.status |= 0x80
                if self.ctrl & 0x80:
                    self.interrupt(0xFFFA)
            while self.cycles < target:
                if self.irq_line and not (self.p & 0x04):
                    self.interrupt(0xFFFE)
                self.step()
            if sl < 240:
                rendering = self.mask & 0x18
                self.lines.append((self.chr_banks(), self.ctrl, self.mask, self.scroll_x, ys, bytes(self.pal)))
                # sprite 0 hit (approximate: on the sprite's first line)
                if rendering and sl == self.oam[0] + 1:
                    self.status |= 0x40
                if rendering:                         # MMC3-style counter clocked once per visible line
                    if self.irq_counter == 0 or self.irq_reload:
                        self.irq_counter = self.irq_latch; self.irq_reload = False
                    else:
                        self.irq_counter -= 1
                    if self.irq_counter == 0 and self.irq_en:
                        self.irq_line = True
            if sl == 261:
                ys = self.scroll_y
        self.frame += 1

    # ------------------------------------------------------------ render
    def render(self):
        from PIL import Image
        img = Image.new('RGB', (256, 240)); px = img.load()
        rgb = [((c >> 16) & 255, (c >> 8) & 255, c & 255) for c in NESPAL]
        fl = self.flash; L = len(fl)
        if self.r41[0x18] & 0x80:
            fl = self.chrram; L = 0x2000
        for sl, (banks, ctrl, mask, sx, sy, pal) in enumerate(self.lines):
            if self.r41[0x18] & 0x80: banks = (0, 1, 2, 3, 4, 5, 6, 7)
            bgc = rgb[pal[0] & 0x3F]
            row = [bgc] * 256
            prio = [0] * 256
            if mask & 0x08:
                ptab = 4 if ctrl & 0x10 else 0
                ntsel = ctrl & 3
                yy = sl + sy
                for X in range(256):
                    xx = X + sx + ((ntsel & 1) << 8)
                    ty_full = yy + ((ntsel >> 1) * 240)
                    ntx = (xx >> 8) & 1; nty = (ty_full // 240) & 1
                    cx = (xx & 0xFF) >> 3; cy = (ty_full % 240) >> 3
                    base = 0x2000 + (nty * 2 + ntx) * 0x400
                    t = self.vram[self.nt_index(base + cy * 32 + cx)]
                    at = self.vram[self.nt_index(base + 0x3C0 + (cy >> 2) * 8 + (cx >> 2))]
                    p = (at >> (((cy & 2) << 1) | (cx & 2))) & 3
                    fy = (ty_full % 240) & 7; fxp = xx & 7
                    a = t * 16 + fy
                    b = banks[ptab + (a >> 10)] * 0x400 + (a & 0x3FF)
                    c = ((fl[b % L] >> (7 - fxp)) & 1) | (((fl[(b + 8) % L] >> (7 - fxp)) & 1) << 1)
                    if c:
                        row[X] = rgb[pal[p * 4 + c] & 0x3F]; prio[X] = 1
            if mask & 0x10:
                h = 16 if ctrl & 0x20 else 8
                for i in range(63, -1, -1):
                    sy0 = self.oam[i * 4] + 1
                    if not (sy0 <= sl < sy0 + h): continue
                    t = self.oam[i * 4 + 1]; at = self.oam[i * 4 + 2]; sx0 = self.oam[i * 4 + 3]
                    r = sl - sy0
                    if at & 0x80: r = h - 1 - r
                    if h == 16:
                        tb = (t & 1) * 4; t &= 0xFE
                        if r >= 8: t += 1; r -= 8
                    else:
                        tb = 4 if ctrl & 0x08 else 0
                    a = t * 16 + r
                    b = banks[tb + (a >> 10)] * 0x400 + (a & 0x3FF)
                    for k in range(8):
                        X = sx0 + k
                        if X > 255: break
                        bit = k if at & 0x40 else 7 - k
                        c = ((fl[b % L] >> bit) & 1) | (((fl[(b + 8) % L] >> bit) & 1) << 1)
                        if c and not (at & 0x20 and prio[X]):
                            row[X] = rgb[pal[0x10 + (at & 3) * 4 + c] & 0x3F]
            for X in range(256):
                px[X, sl] = row[X]
        return img


# ---------------------------------------------------------------- opcode table
def _build():
    T = [None] * 256

    def rd16(m, a): return m.read(a) | m.read((a + 1) & 0xFFFF) << 8

    def rd16zp(m, a): return m.read(a & 0xFF) | m.read((a + 1) & 0xFF) << 8
    # address calculators: return (address, length)
    def imm(m, pc, b1): return ((pc + 1) & 0xFFFF, 2)
    def zp(m, pc, b1): return (b1, 2)
    def zpx(m, pc, b1): return ((b1 + m.x) & 0xFF, 2)
    def zpy(m, pc, b1): return ((b1 + m.y) & 0xFF, 2)
    def ab(m, pc, b1): return (b1 | m.read((pc + 2) & 0xFFFF) << 8, 3)
    def abx(m, pc, b1): return (((b1 | m.read((pc + 2) & 0xFFFF) << 8) + m.x) & 0xFFFF, 3)
    def aby(m, pc, b1): return (((b1 | m.read((pc + 2) & 0xFFFF) << 8) + m.y) & 0xFFFF, 3)
    def izx(m, pc, b1): return (rd16zp(m, b1 + m.x), 2)
    def izy(m, pc, b1): return ((rd16zp(m, b1) + m.y) & 0xFFFF, 2)
    MODES = dict(imm=imm, zp=zp, zpx=zpx, zpy=zpy, abs=ab, abx=abx, aby=aby, izx=izx, izy=izy)
    import sys, os
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'tools'))
    from op6502 import OPS as DEF

    def adc(m, v):
        c = m.p & 1; r = m.a + v + c
        m.p = (m.p & 0x3C) | (1 if r > 0xFF else 0) | (0x40 if (~(m.a ^ v) & (m.a ^ r) & 0x80) else 0)
        m.a = r & 0xFF; m.setnz(m.a)

    def cmp(m, reg, v):
        r = (reg - v) & 0x1FF
        m.p = (m.p & 0x7C) | (1 if reg >= v else 0)
        m.setnz(r & 0xFF)

    def mk(op, mn, md):
        if md in MODES:
            A = MODES[md]
        if mn in ('lda', 'ldx', 'ldy', 'adc', 'sbc', 'and', 'ora', 'eor', 'cmp', 'cpx', 'cpy', 'bit'):
            def f(m, pc, b1):
                a, n = A(m, pc, b1); v = m.read(a); m.pc = (pc + n) & 0xFFFF
                if mn == 'lda': m.a = v; m.setnz(v)
                elif mn == 'ldx': m.x = v; m.setnz(v)
                elif mn == 'ldy': m.y = v; m.setnz(v)
                elif mn == 'adc': adc(m, v)
                elif mn == 'sbc': adc(m, v ^ 0xFF)
                elif mn == 'and': m.a &= v; m.setnz(m.a)
                elif mn == 'ora': m.a |= v; m.setnz(m.a)
                elif mn == 'eor': m.a ^= v; m.setnz(m.a)
                elif mn == 'cmp': cmp(m, m.a, v)
                elif mn == 'cpx': cmp(m, m.x, v)
                elif mn == 'cpy': cmp(m, m.y, v)
                elif mn == 'bit': m.p = (m.p & 0x3D) | (v & 0xC0) | (0 if m.a & v else 0x02)
            return f
        if mn in ('sta', 'stx', 'sty'):
            def f(m, pc, b1):
                a, n = A(m, pc, b1); m.pc = (pc + n) & 0xFFFF
                m.write(a, m.a if mn == 'sta' else (m.x if mn == 'stx' else m.y))
            return f
        if mn in ('asl', 'lsr', 'rol', 'ror', 'inc', 'dec'):
            def calc(m, v):
                if mn == 'asl': c = v >> 7; v = (v << 1) & 0xFF
                elif mn == 'lsr': c = v & 1; v >>= 1
                elif mn == 'rol': c = v >> 7; v = ((v << 1) | (m.p & 1)) & 0xFF
                elif mn == 'ror': c = v & 1; v = (v >> 1) | ((m.p & 1) << 7)
                elif mn == 'inc': v = (v + 1) & 0xFF; c = None
                else: v = (v - 1) & 0xFF; c = None
                if c is not None: m.p = (m.p & 0xFE) | c
                m.setnz(v); return v
            if md == 'acc':
                def f(m, pc, b1): m.a = calc(m, m.a); m.pc = (pc + 1) & 0xFFFF
            else:
                def f(m, pc, b1):
                    a, n = A(m, pc, b1); m.pc = (pc + n) & 0xFFFF; m.write(a, calc(m, m.read(a)))
            return f
        if md == 'rel':
            cond = dict(bpl=lambda p: not p & 0x80, bmi=lambda p: p & 0x80, bvc=lambda p: not p & 0x40, bvs=lambda p: p & 0x40,
                        bcc=lambda p: not p & 1, bcs=lambda p: p & 1, bne=lambda p: not p & 2, beq=lambda p: p & 2)[mn]
            def f(m, pc, b1):
                if cond(m.p):
                    m.pc = (pc + 2 + (b1 - 256 if b1 > 127 else b1)) & 0xFFFF; m.cycles += 1
                else:
                    m.pc = (pc + 2) & 0xFFFF
            return f
        if mn == 'jmp':
            if md == 'abs':
                def f(m, pc, b1): m.pc = b1 | m.read((pc + 2) & 0xFFFF) << 8
            else:
                def f(m, pc, b1):
                    a = b1 | m.read((pc + 2) & 0xFFFF) << 8
                    m.pc = m.read(a) | m.read((a & 0xFF00) | ((a + 1) & 0xFF)) << 8
            return f
        if mn == 'jsr':
            def f(m, pc, b1):
                r = (pc + 2) & 0xFFFF; m.push(r >> 8); m.push(r & 0xFF)
                m.pc = b1 | m.read((pc + 2) & 0xFFFF) << 8
            return f
        def imp(fn):
            def f(m, pc, b1): m.pc = (pc + 1) & 0xFFFF; fn(m)
            return f
        if mn == 'rts': return imp(lambda m: setattr(m, 'pc', ((m.pop() | m.pop() << 8) + 1) & 0xFFFF))
        if mn == 'rti':
            def f(m, pc, b1):
                m.p = (m.pop() & 0xEF) | 0x20; m.pc = m.pop() | m.pop() << 8
            return f
        if mn == 'brk':
            def f(m, pc, b1): m.pc = (pc + 2) & 0xFFFF; m.interrupt(0xFFFE, True)
            return f
        simple = dict(
            clc=lambda m: setattr(m, 'p', m.p & 0xFE), sec=lambda m: setattr(m, 'p', m.p | 1),
            cli=lambda m: setattr(m, 'p', m.p & 0xFB), sei=lambda m: setattr(m, 'p', m.p | 4),
            clv=lambda m: setattr(m, 'p', m.p & 0xBF), cld=lambda m: setattr(m, 'p', m.p & 0xF7),
            sed=lambda m: setattr(m, 'p', m.p | 8), nop=lambda m: None,
            tax=lambda m: (setattr(m, 'x', m.a), m.setnz(m.a)), tay=lambda m: (setattr(m, 'y', m.a), m.setnz(m.a)),
            txa=lambda m: (setattr(m, 'a', m.x), m.setnz(m.x)), tya=lambda m: (setattr(m, 'a', m.y), m.setnz(m.y)),
            tsx=lambda m: (setattr(m, 'x', m.s), m.setnz(m.s)), txs=lambda m: setattr(m, 's', m.x),
            inx=lambda m: (setattr(m, 'x', (m.x + 1) & 0xFF), m.setnz(m.x)), dex=lambda m: (setattr(m, 'x', (m.x - 1) & 0xFF), m.setnz(m.x)),
            iny=lambda m: (setattr(m, 'y', (m.y + 1) & 0xFF), m.setnz(m.y)), dey=lambda m: (setattr(m, 'y', (m.y - 1) & 0xFF), m.setnz(m.y)),
            pha=lambda m: m.push(m.a), php=lambda m: m.push(m.p | 0x30),
            pla=lambda m: (setattr(m, 'a', m.pop()), m.setnz(m.a)), plp=lambda m: setattr(m, 'p', (m.pop() & 0xEF) | 0x20))
        return imp(simple[mn])
    for op, (mn, md) in DEF.items():
        T[op] = mk(op, mn, md)
    return T


OPS = _build()
