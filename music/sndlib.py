"""Sup 400-in-1 menu sound: tables, track parser, NSF builder, NSF player (6502 core from onebus_emu) and APU renderer."""
import os, sys, struct, wave, math
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..', 'rombuilder'))   # the OneBus model: rombuilder/emu.py

# Both blocks carry the same driver at different addresses.
BLOCKS = {
    'chinese': dict(title='Sup 400-in-1 Chinese menu', file_e000=0x3E000,
                    init=0xE379, tick=0xE34A, play=0xE351, song_var=0x0081, sfx_var=0x00DB, chan_ram=0x0300,
                    song_cnt=0xEFB9, song_ptr=0xEFBF, sfx_tbl=0xED69, nsongs=1, nsfx=43, credit=0xEB27,
                    used_sfx={4: 'cursor move (sub_DF37)'}),
    'langsel': dict(title='Sup 400-in-1 language select', file_e000=0x6E000,
                    init=0xEF55, tick=0xEF26, play=0xEF2D, song_var=0x045D, sfx_var=0x00DB, chan_ram=0x0400,
                    song_cnt=0xFDFD, song_ptr=0xFE03, sfx_tbl=0xF945, nsfx=43, nsongs=1, credit=None,
                    used_sfx={}),
}
CHAN = ['pulse1', 'pulse2', 'triangle', 'noise']
NOTE = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']


class Block:
    def __init__(self, rom, name):
        self.rom, self.name, self.cfg = rom, name, BLOCKS[name]
        self.base = self.cfg['file_e000']

    def off(self, a): return self.base + a - 0xE000
    def b(self, a): return self.rom[self.off(a)]
    def w(self, a): return self.b(a) | self.b(a + 1) << 8

    # ---------------------------------------------------------------- music
    def song_tracks(self, s):
        """Track records {slot, flags, ptr} as sub_E3A1 reads them."""
        c = self.cfg
        n = self.b(c['song_cnt'] + 2 * s) + 1
        idx = self.b(c['song_cnt'] + 2 * s + 1)
        tbl = self.w(c['song_ptr'] + 2 * s)
        out = []
        for k in range(min(n, 4)):
            r = tbl + 4 * (idx + k)
            out.append(dict(rec=r, slot=self.b(r), flags=self.b(r + 1), ptr=self.w(r + 2)))
        return out

    def parse_track(self, ptr, chan):
        """Walk a track: 4-byte header, then 2-byte commands. Returns (lines, end_address)."""
        h = [self.b(ptr + i) for i in range(4)]
        tri, noi = chan == 2, chan == 3
        T = (((h[0] << 4) | (h[0] >> 4)) + 15) & 0xFF
        lines = ['header  %02X %02X %02X %02X   tempo=%02X (%.4f frames/tick) %s=%02X vol/env=%02X sweep=%02X'
                 % (*h, h[0], (T + 1) / 16.0, 'linear' if tri else 'duty', h[1], h[2], h[3])]
        a = ptr + 4; loop = None; seen = 0
        while seen < 4000:
            c, arg = self.b(a), self.b(a + 1); pos = (a - ptr) // 2; seen += 1
            if c >= 0xF0:
                if c == 0xFD: t = 'loop_point'
                elif c == 0xFF: t = 'end'
                else: t = 'nop %02X' % c
            elif c >= 0xE0: t = 'vol_slide -%d every %d' % (c & 15, arg)
            elif c >= 0xD0: t = 'vol_slide +%d every %d' % (c & 15, arg)
            elif c >= 0xC0: t = 'envelope shape %d length %d' % (c & 15, arg)
            elif c >= 0xB0:
                n = c & 15
                t = ('goto %s' % ('loop_point' if arg == 0 else 'pos %d' % arg)) if n == 0 else 'repeat %d x to pos %d' % (n, arg)
            elif c >= 0xA0:
                t = {0xA0: 'volume %02X', 0xA1: 'sweep %02X', 0xA2: 'duty/linear %02X', 0xA3: 'vibrato %02X',
                     0xA4: 'vibrato_off', 0xAD: 'next_pattern %02X', 0xAE: 'tempo_flag %02X', 0xAF: 'tempo %02X'}.get(c, 'cmd%02X %%02X' % c)
                t = t % arg if '%' in t else t
            else:
                if noi:
                    t = ('noise %X' % c if c < 0x10 else 'rest') + '  len %d' % arg
                else:
                    t = ('%s%d' % (NOTE[c & 15], (1 if tri else 2) + (c >> 4)) if (c & 15) < 12 else 'rest') + '  len %d' % arg
            lines.append('%04X pos%3d  %02X %02X  %s' % (a, pos, c, arg, t))
            a += 2
            if c == 0xFF or (c & 0xF0 == 0xB0 and c & 15 == 0) or (c == 0xAD and arg == 0 and False):
                break
            if c == 0xAD and arg == 0:      # a new 4-byte header follows
                h = [self.b(a + i) for i in range(4)]
                lines.append('%04X        header %02X %02X %02X %02X' % (a, *h)); ptr = a; a += 4
        return lines, a

    # ---------------------------------------------------------------- sfx
    def sfx(self, i):
        """SFX record: [chan_mask] then per channel [chan_bit, regmask, frames_per_step, total_bytes, r0 r1 r2 r3, stream...]"""
        p = self.w(self.cfg['sfx_tbl'] + 2 * i)
        mask = self.b(p); a = p + 1; chans = []
        # sound_play handles exactly one channel record (sub_E43A)
        cb, rm, spd, ln = self.b(a), self.b(a + 1), self.b(a + 2), self.b(a + 3)
        init = [self.b(a + 4 + k) for k in range(4)]
        stream = [self.b(a + 8 + k) for k in range(ln)]
        chans.append(dict(chan_bit=cb, regmask=rm, speed=spd, length=ln, init=init, stream=stream))
        return dict(ptr=p, enable=mask, chans=chans, end=a + 8 + ln)

    # ---------------------------------------------------------------- NSF
    def nsf(self):
        c = self.cfg; ns, nx = c['nsongs'], c['nsfx']
        org = 0xDF00; code = []
        def emit(*bs): code.extend(bs)
        # init (A = song index)
        emit(0xC9, ns)                       # cmp #ns
        emit(0xB0, 0x09)                     # bcs sfx
        emit(0x8D, c['song_var'] & 0xFF, c['song_var'] >> 8)   # sta song_var
        emit(0x20, c['init'] & 0xFF, c['init'] >> 8)           # jsr init
        emit(0x60)                           # rts
        emit(0xEA, 0xEA)
        # sfx: start song 0, silence the 4 music slots, play sfx (A-ns)
        sfx_at = len(code)
        emit(0xE9, ns)                       # sbc #ns (carry set)
        emit(0x48)                           # pha
        emit(0xA9, 0x00, 0x8D, c['song_var'] & 0xFF, c['song_var'] >> 8)
        emit(0x20, c['init'] & 0xFF, c['init'] >> 8)
        emit(0xA9, 0xFF)
        for k in range(4):
            r = c['chan_ram'] + 0x15 * k
            emit(0x8D, r & 0xFF, r >> 8)
        emit(0xA9, 0x00, 0x8D, 0x15, 0x40)   # lda #0 / sta $4015
        emit(0x68)                           # pla
        emit(0x85, c['sfx_var'] & 0xFF)      # sta sfx_var
        emit(0x20, c['play'] & 0xFF, c['play'] >> 8)
        emit(0x60)
        play_at = len(code)
        emit(0x20, c['tick'] & 0xFF, c['tick'] >> 8, 0x60)
        assert code[2] == 0xB0
        code[3] = sfx_at - 4                 # fix bcs offset
        page = bytes(code) + b'\xFF' * (256 - len(code))
        data = page + self.rom[self.base:self.base + 0x2000]
        name = c['title'].encode()[:31]
        hdr = b'NESM\x1A' + bytes([1, ns + nx, 1]) + struct.pack('<HHH', org, org, org + play_at)
        hdr += name.ljust(32, b'\0') + b'Wang Chao (credit in ROM)'.ljust(32, b'\0') + b'unknown'.ljust(32, b'\0')
        hdr += struct.pack('<H', 16639) + bytes(8) + struct.pack('<H', 19997) + bytes([0, 0]) + bytes(4)
        assert len(hdr) == 128
        return hdr + data


# -------------------------------------------------------------------- NSF player
from emu import OneBus, Halt


class NSFPlayer(OneBus):
    def __init__(self, nsf):
        super().__init__(bytes(16))
        self.load = struct.unpack('<H', nsf[8:10])[0]
        self.init_a, self.play_a = struct.unpack('<HH', nsf[10:14])
        self.mem = bytearray(0x10000); self.mem[self.load:self.load + len(nsf) - 128] = nsf[128:]
        self.apu = []; self.cur = []; self.reads = set()

    def read(self, a):
        if a < 0x2000: return self.ram[a & 0x7FF]
        if a >= 0x6000:
            if a >= 0x8000: self.reads.add(a)
            return self.mem[a]
        return 0

    def write(self, a, v):
        if a < 0x2000: self.ram[a & 0x7FF] = v
        elif 0x4000 <= a <= 0x4017: self.cur.append((a, v))
        elif 0x6000 <= a < 0x8000: self.mem[a] = v

    def call(self, addr, a=0, x=0, limit=200000):
        self.a, self.x, self.y = a, x, 0
        self.s = 0xFD; self.push(0xFF); self.push(0xFE)   # rts -> $FFFF sentinel
        self.pc = addr; n = 0
        while self.pc != 0xFFFF:
            self.step(); n += 1
            if n > limit: raise Halt('routine %04X did not return' % addr)

    def run(self, song, frames):
        self.ram[:] = bytes(0x800); self.p = 0x24
        self.cur = []; self.call(self.init_a, song); self.apu = [self.cur]
        for f in range(frames):
            self.cur = []; self.call(self.play_a); self.apu.append(self.cur)
        return self.apu


# -------------------------------------------------------------------- APU renderer
LEN = [10, 254, 20, 2, 40, 4, 80, 6, 160, 8, 60, 10, 14, 12, 26, 14, 12, 16, 24, 18, 48, 20, 96, 22, 192, 24, 72, 26, 16, 28, 32, 30]
NOISE = [4, 8, 16, 32, 64, 96, 128, 160, 202, 254, 380, 508, 762, 1016, 2034, 4068]
DUTY = [[0, 1, 0, 0, 0, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0], [0, 1, 1, 1, 1, 0, 0, 0], [1, 0, 0, 1, 1, 1, 1, 1]]
TRI = list(range(15, -1, -1)) + list(range(16))
CPU = 1789773.0


def render(frames, path, rate=44100, fade_frames=0):
    r = [0] * 0x18
    pul = [dict(ph=0.0, len=0, env=15, div=0, start=False, sw_div=0, sw_rel=False) for _ in range(2)]
    tri = dict(ph=0.0, len=0, lin=0, rel=False); noi = dict(sr=1, acc=0.0, len=0, env=15, div=0, start=False)
    en = 0; out = []; spf = rate / 60.0988; acc = 0.0
    def period(i): return r[2 + 4 * i] | (r[3 + 4 * i] & 7) << 8
    for fi, writes in enumerate(frames):
        for a, v in writes:
            i = a - 0x4000
            if i == 0x15:
                en = v
                for k, ch in enumerate((pul[0], pul[1], tri, noi)):
                    if not v >> k & 1: ch['len'] = 0
                continue
            if i > 0x17: continue
            r[i] = v
            if i in (3, 7):
                p = pul[i // 4]
                if en >> (i // 4) & 1: p['len'] = LEN[v >> 3]
                p['start'] = True; p['ph'] = 0.0
            elif i == 0x0B:
                if en & 4: tri['len'] = LEN[v >> 3]
                tri['rel'] = True
            elif i == 0x0F:
                if en & 8: noi['len'] = LEN[v >> 3]
                noi['start'] = True
            elif i in (1, 5): pul[i // 4]['sw_rel'] = True
        n = int(acc + spf) - int(acc); acc += spf
        # 4 quarter-frame clocks spread over the frame
        for q in range(4):
            for k, p in enumerate(pul + [noi]):
                reg = r[0] if k == 0 else r[4] if k == 1 else r[0x0C]
                if p['start']: p['start'] = False; p['env'] = 15; p['div'] = reg & 15
                elif p['div'] == 0:
                    p['div'] = reg & 15
                    if p['env']: p['env'] -= 1
                    elif reg & 0x20: p['env'] = 15
                else: p['div'] -= 1
            if tri['rel']: tri['lin'] = r[8] & 0x7F
            elif tri['lin']: tri['lin'] -= 1
            if not r[8] & 0x80: tri['rel'] = False
            if q in (1, 3):
                for k, p in enumerate(pul):
                    halt = r[4 * k] & 0x20
                    if p['len'] and not halt: p['len'] -= 1
                    s = r[1 + 4 * k]
                    if p['sw_div'] == 0 and s & 0x80 and s & 7:
                        per = period(k); ch = per >> (s & 7)
                        ch = per - ch - (1 if k == 0 else 0) if s & 8 else per + ch
                        if per >= 8 and ch <= 0x7FF:
                            r[2 + 4 * k] = ch & 0xFF; r[3 + 4 * k] = (r[3 + 4 * k] & 0xF8) | (ch >> 8)
                    if p['sw_div'] == 0 or p['sw_rel']: p['sw_div'] = (s >> 4) & 7; p['sw_rel'] = False
                    else: p['sw_div'] -= 1
                if tri['len'] and not r[8] & 0x80: tri['len'] -= 1
                if noi['len'] and not r[0x0C] & 0x20: noi['len'] -= 1
        ns = n
        for s in range(ns):
            mixp = 0; vols = []
            for k, p in enumerate(pul):
                per = period(k); reg = r[4 * k]
                vol = reg & 15 if reg & 0x10 else p['env']
                sw = r[1 + 4 * k]; tgt = per + (per >> (sw & 7)) if not sw & 8 else 0
                if not (en >> k & 1) or p['len'] == 0 or per < 8 or tgt > 0x7FF: vol = 0
                f = CPU / (16.0 * (per + 1))
                p['ph'] = (p['ph'] + f / rate) % 1.0
                mixp += DUTY[reg >> 6][int(p['ph'] * 8)] * vol
            tp = r[0x0A] | (r[0x0B] & 7) << 8
            if en & 4 and tri['len'] and tri['lin'] and tp > 1:
                tri['ph'] = (tri['ph'] + CPU / (32.0 * (tp + 1)) / rate) % 1.0
            t = TRI[int(tri['ph'] * 32)]
            reg = r[0x0C]; nv = reg & 15 if reg & 0x10 else noi['env']
            if not en & 8 or noi['len'] == 0: nv = 0
            noi['acc'] += CPU / rate / NOISE[r[0x0E] & 15]
            while noi['acc'] >= 1:
                noi['acc'] -= 1
                bit = (noi['sr'] ^ (noi['sr'] >> (6 if r[0x0E] & 0x80 else 1))) & 1
                noi['sr'] = (noi['sr'] >> 1) | (bit << 14)
            nz = 0 if noi['sr'] & 1 else nv
            po = 95.88 / (8128.0 / mixp + 100) if mixp else 0
            tn = t / 8227.0 + nz / 12241.0
            to = 159.79 / (1 / tn + 100) if tn else 0
            out.append(po + to)
    # DC-block + scale
    y = []; prev_x = 0.0; prev_y = 0.0
    for x in out:
        v = x - prev_x + 0.995 * prev_y; prev_x, prev_y = x, v; y.append(v)
    if fade_frames:
        nf = int(fade_frames * spf)
        for i in range(max(0, len(y) - nf), len(y)): y[i] *= (len(y) - i) / nf
    with wave.open(path, 'wb') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(rate)
        w.writeframes(b''.join(struct.pack('<h', max(-32767, min(32767, int(v * 40000)))) for v in y))
