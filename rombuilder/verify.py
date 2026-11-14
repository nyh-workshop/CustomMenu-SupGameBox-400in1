"""Check a built image on the OneBus model (onebus_emu.py): boot to the list, read every page back, start games and
compare the banks the CPU/PPU see with the game's own data, read the test carts' OK/BAD lines, A+B test program,
and that the menu music plays."""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
for _d in ('music', 'tools'):                          # sndlib.py (music check), op6502.py
    sys.path.insert(1, os.path.join(HERE, '..', _d))
from emu import OneBus, Halt
import onebus400 as O

PAD = dict(A=0x80, B=0x40, SEL=0x20, START=0x10, UP=8, DOWN=4, LEFT=2, RIGHT=1)
# the English list font: tile -> character (dat_CDD0, chars $20-$5F)
FONT_TILES = [0x00, 0x01, 0x02, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x06, 0x07,
              0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22,
              0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x00, 0x00, 0x00, 0x00, 0x00]
TILE2CH = {}
for i, t in enumerate(FONT_TILES):
    TILE2CH.setdefault(t, chr(0x20 + i))
TILE2CH[0x00] = ' '


class Machine:
    def __init__(self, img):
        self.m = OneBus(bytes(img))
        self.m.pc = self.m.read(0xFFFC) | self.m.read(0xFFFD) << 8
        self.apu = 0
        ow = self.m.write
        def w(a, v):
            if 0x4000 <= a <= 0x4013: self.apu += 1
            ow(a, v)
        self.m.write = w

    def frames(self, n, pad=0):
        for _ in range(n):
            self.m.pad = pad; self.m.run_frame()

    def press(self, key, hold=7, after=14):     # the menu samples the pad every 7th frame: 7 frames = exactly one sample
        self.frames(hold, PAD[key]); self.frames(after)

    def list_lines(self):
        """the 10 list rows as text (nametable rows 5, 7, ... 23; a line is 21 tiles from column 8)"""
        out = []
        for row in range(5, 5 + 20, 2):
            t = self.m.vram[row * 32 + 8: row * 32 + 8 + 21]
            out.append(''.join(TILE2CH.get(b, '?') for b in t).rstrip())
        return out


def read_list(img, n_games, log):
    mc = Machine(img)
    mc.frames(420)
    pages = (n_games + 9) // 10
    got = []
    for p in range(pages):
        mc.frames(60)
        got.append(mc.list_lines())
        if p < pages - 1: mc.press('RIGHT')
    return got, mc


def expected_lines(names):
    pages = []
    for p in range(0, len(names), 10):
        pages.append(['%d.%s' % (p + k + 1, names[p + k]) if p + k < len(names) else '' for k in range(10)])
    return pages


def ascii_text(m):
    rows = []
    for r in range(30):
        rows.append(''.join(chr(b) if 32 <= b < 127 else ' ' for b in m.vram[r * 32:r * 32 + 32]))
    return rows


def launch(img, idx, g, log, shots=None):
    """start game idx (0-based) from the list and check its banks at the jump to its reset vector"""
    if shots: os.makedirs(shots, exist_ok=True)
    mc = Machine(img); m = mc.m
    mc.frames(420)
    for _ in range(idx // 10): mc.press('RIGHT'); mc.frames(40)
    for _ in range(idx % 10): mc.press('DOWN')
    mc.frames(20)
    prg = g['prg']; reset = prg[-4] | prg[-3] << 8
    hit = {}
    os_ = m.step
    def st():
        if not hit and m.pc == reset and m.prg_off(0xE000) == g['prg_at'] + len(prg) - 0x2000:
            hit['prg'] = [m.prg_off(a) for a in (0x8000, 0xA000, 0xC000, 0xE000)]
            hit['chr'] = None if m.r41[0x18] & 0x80 else [b * 0x400 for b in m.chr_banks()]
            hit['mir'] = 'H' if m.mirror_h else 'V'
        os_()
    m.step = st
    try:
        mc.frames(12, PAD['START']); mc.frames(120)
    except Halt as e:
        log.append('game %d %s: CPU stopped: %s' % (idx + 1, g['name'], e)); return False
    if not hit:
        log.append('game %d %s: never reached its reset vector $%04X' % (idx + 1, g['name'], reset)); return False
    m.step = os_
    eprg, echr = O.expected_maps(g['prg_at'], len(prg), g['chr_at'], g['chr_ram'])
    errs = []
    if hit['prg'] != eprg: errs.append('PRG mapped %s, expected %s' % ([hex(x) for x in hit['prg']], [hex(x) for x in eprg]))
    if not g['chr_ram'] and hit['chr'] != echr: errs.append('CHR mapped %s, expected %s' % ([hex(x) for x in hit['chr']], [hex(x) for x in echr]))
    if g['chr_ram'] and hit['chr'] is not None: errs.append('CHR-RAM not selected')
    if g['mapper'] == 0 and hit['mir'] != g['mirror']: errs.append('mirroring %s, expected %s' % (hit['mir'], g['mirror']))
    for k in range(4):                         # the bytes themselves
        a = hit['prg'][k]
        if bytes(m.flash[a:a + 0x2000]) not in (prg[0:0x2000], prg[0x2000:0x4000], prg[-0x4000:-0x2000], prg[-0x2000:]):
            errs.append('PRG bytes at $%04X are not the game\'s' % (0x8000 + 0x2000 * k)); break
    ran = 'ran 60 frames'
    try:
        mc.frames(60)
    except Halt as e:
        ran = 'stopped: %s' % e
    text = ascii_text(m)
    if any('ONEBUS BUILDER TEST CART' in l for l in text):
        res = [' '.join(l.split()) for l in text if re.match(r'\s*(PRG BANKS|CHR BANKS|CHR RAM|WRAM)\s\s+\S', l)]
        bad = [l for l in res if not l.endswith(' OK')]
        if bad or not res: errs.append('test cart reports: %s' % '; '.join(res or ['nothing']))
        ran = 'test cart: ' + ', '.join(res)
    if shots:
        m.render().save(os.path.join(shots, 'game_%03d.png' % (idx + 1)))
    if errs:
        log.append('game %3d %-18s FAIL: %s' % (idx + 1, g['name'], '; '.join(errs))); return False
    log.append('game %3d %-18s OK  (reset $%04X, PRG 0x%06X, CHR %s, %s; %s)' % (
        idx + 1, g['name'], reset, g['prg_at'], 'RAM' if g['chr_ram'] else '0x%06X' % g['chr_at'], g['mirror'], ran))
    return True


def test_mode(img, log, shots=None):
    if shots: os.makedirs(shots, exist_ok=True)
    mc = Machine(img)
    mc.frames(150, PAD['A'] | PAD['B']); mc.frames(250)
    text = ''.join(TILE2CH.get(b, ' ') for b in mc.m.vram[:0x3C0])
    ok = mc.m.r41[0x0A] == 0x37 and mc.m.r41[0x09] == 0x36
    if shots: mc.m.render().save(os.path.join(shots, 'test_mode.png'))
    log.append('A+B test program: %s (PRG $C000/$E000 = $%02X/$%02X)' % ('OK' if ok else 'FAIL', mc.m.r41[0x09], mc.m.r41[0x0A]))
    return ok


def music(img, log, frames=1500):
    """the list music: the APU notes the menu writes (pulse 1, triangle, noise) must equal what the relocated driver
    writes when it runs alone for the same number of ticks (pulse 2 also carries the cursor sound, so it is left out)"""
    import struct
    import english_sound as E
    from sndlib import NSFPlayer
    mc = Machine(img); m = mc.m; W = []; tick = [-1]
    ow = m.write
    def w(a, v):
        if 0x4000 <= a <= 0x4015: W.append((tick[0], a, v))
        ow(a, v)
    m.write = w
    os_ = m.step
    def st():
        if m.pc == E.NMI_CODE: tick[0] += 1
        os_()
    m.step = st
    mc.frames(frames)
    def onsets(ws):
        regs = {}; out = []
        for t, a, v in ws:
            regs[a] = v
            if a in (0x4003, 0x400B, 0x400F): out.append((t, a, regs.get(a - 1, 0) | (v & 7) << 8))
        return out
    mo = [x for x in onsets(W) if x[0] >= 0]
    e = E.ENTRY; r = E.RAM_LO + E.RAM_DELTA
    hdr = b'NESM\x1a\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
    p = NSFPlayer(hdr + bytes(img[E.BANK8_FILE:E.BANK8_FILE + 0x4000]) + b'\xff' * 0x4000)
    p.mem[0x6000:0x6006] = bytes([0x8D, 0x81, 0x00, 0x4C, e['sound_init'] & 0xFF, e['sound_init'] >> 8])
    loop = [0xAD, r & 0xFF, r >> 8, 0x2D, (r + 0x15) & 0xFF, (r + 0x15) >> 8, 0x2D, (r + 0x2A) & 0xFF, (r + 0x2A) >> 8,
            0x2D, (r + 0x3F) & 0xFF, (r + 0x3F) >> 8, 0xC9, 0xFF, 0xD0, 0x03, 0x20, e['start_song'] & 0xFF, e['start_song'] >> 8]
    p.mem[0x6010:0x6017 + len(loop)] = bytes([0x20, e['sfx_tick'] & 0xFF, e['sfx_tick'] >> 8,
                                              0x20, e['music_tick'] & 0xFF, e['music_tick'] >> 8] + loop + [0x60])
    ho = [x for x in onsets([(i - 1, a, v) for i, f in enumerate(p.run(0, tick[0] + 1)) for a, v in f]) if 0 <= x[0] <= tick[0]]
    ok = mo == ho and tick[0] > 0
    log.append('menu sound: %d driver ticks in %d frames; %d note writes, %s the driver running alone' % (
        tick[0] + 1, frames, len(mo), 'identical to' if ok else 'DIFFERENT from'))
    return ok


def verify(img, games, log, mode='auto', shots=None):
    if shots: os.makedirs(shots, exist_ok=True)
    ok = True
    names = [g['name'] for g in games]
    got, mc = read_list(img, len(games), log)
    exp = expected_lines(names)
    bad = [(p + 1, k + 1, got[p][k], exp[p][k]) for p in range(len(exp)) for k in range(10)
           if exp[p][k] and got[p][k] != exp[p][k]]
    if shots: mc.m.render().save(os.path.join(shots, 'list_last_page.png'))
    if bad:
        ok = False
        log.append('list: %d line(s) differ, first: page %d row %d shows %r, expected %r' % ((len(bad),) + bad[0]))
    else:
        log.append('list: all %d page(s) read back correctly (%d games)' % (len(exp), len(games)))
    if mode == 'full' or (mode == 'auto' and len(games) <= 100):
        idxs = range(len(games))
    else:
        kinds = {}
        for i, g in enumerate(games): kinds.setdefault((g['mapper'], len(g['prg']), g['chr_ram']), i)
        idxs = sorted(set(list(kinds.values()) + [i for i in (0, 255, 256, 312, 313, len(games) - 1) if i < len(games)]))
    for i in idxs:
        ok &= launch(img, i, games[i], log, shots)
    ok &= test_mode(img, log, shots)
    ok &= music(img, log)
    return ok


def main():
    """make rom-verify OUT=build/rom/multicart_8M.bin   (re-check a built image with its _games.csv)"""
    import argparse, csv
    ap = argparse.ArgumentParser(description=main.__doc__)
    ap.add_argument('image'); ap.add_argument('games_csv', nargs='?')
    ap.add_argument('--mode', default='auto', choices=('auto', 'full', 'quick'))
    ap.add_argument('--shots', help='folder for screenshots')
    a = ap.parse_args()
    img = open(a.image, 'rb').read()
    gc = a.games_csv or os.path.splitext(a.image)[0] + '_games.csv'
    games = []
    for r in csv.DictReader(open(gc, newline='')):
        prg_at = int(r['prg_addr'], 16); ram = r['chr_ram'] == '1'
        chr_at = None if ram else int(r['chr_addr'], 16)
        games.append(dict(name=r['name'], mapper=int(r['mapper']), mirror=r['mirroring'], chr_ram=ram,
                          prg_at=prg_at, prg=img[prg_at:prg_at + int(r['prg_kb']) * 1024],
                          chr_at=chr_at, chr=b'' if ram else img[chr_at:chr_at + int(r['chr_kb']) * 1024]))
    log = []
    ok = verify(img, games, log, mode=a.mode, shots=a.shots)
    print('check of %s on the OneBus model (%s): %s' % (a.image, a.mode, 'all checks passed' if ok else 'FAILED'))
    for l in log: print('  ' + l)
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
