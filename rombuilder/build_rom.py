#!/usr/bin/env python3
"""Build a Sup 400-in-1 multicart image: the 400-in-1 English menu with your games, music and list background.

Writes <out>.bin (emulators), <out>.nes (FCEUX: NES 2.0, mapper 256), <out>_unit.bin (the real handheld: the reset
code's opcodes stored with bits 4/5 swapped, rombuilder/unit.py; --no-unit leaves it out), <out>_games.csv,
<out>_layout.txt and <out>_build.log.  See rombuilder/README.md and custom/README.md."""
import argparse, csv, hashlib, os, re, subprocess, sys, tempfile, time
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
for _d in ('music', 'wallpaper', 'tools'):                # menu_music.py + sndlib.py, wallpaper.py, op6502.py
    sys.path.insert(1, os.path.join(ROOT, _d))
import onebus400 as O
import menu400 as M
import english_sound as S

KB = 1024
MENU_END = 0x80000                      # 0x000000-0x07FFFF: menu region (menu, TFT, test program, sound, graphics)
DEFAULT_BASE = os.path.join(ROOT, 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin')


class BuildError(Exception):
    pass


def sha1(path):
    return hashlib.sha1(open(path, 'rb').read()).hexdigest()


# ---------------------------------------------------------------------------------------------------------------- list
def title_from_file(path):
    """menu name from a ROM file name: 'Contra (USA) (Rev 1).nes' -> 'Contra', 'Legend_of_Zelda,_The_(U)_[!].nes' ->
    'The Legend of Zelda'.  Bracketed labels, a trailing version, underscores go; 'Title, The' -> 'The Title'."""
    t = os.path.splitext(os.path.basename(path))[0].replace('_', ' ')
    while True:
        u = re.sub(r'\s*(\([^()]*\)|\[[^\[\]]*\])', ' ', t)
        if u == t: break
        t = u
    t = re.sub(r'\s*[\(\[].*$', '', t)
    t = ' '.join(t.split())
    t = re.sub(r'(?i)[\s\-]+(v\d+(\.\d+)*[a-z]?|rev\.?\s*[a-z0-9]+)$', '', t).strip(' -')
    m = re.match(r'(?i)^(.*?),\s*(the|a|an)$', t)
    if m: t = '%s %s' % (m.group(2), m.group(1))
    return t or os.path.splitext(os.path.basename(path))[0]


def num(s):
    s = (s or '').strip()
    return int(s, 0) if s else None


def read_list(args, log):
    games_dir = os.path.abspath(args.games)
    rows = []
    scanned = False
    if args.scan or not os.path.exists(args.csv):
        files = sorted((f for f in os.listdir(games_dir) if f.lower().endswith('.nes') and
                        os.path.isfile(os.path.join(games_dir, f))), key=lambda f: (title_from_file(f).lower(), f)) \
            if os.path.isdir(games_dir) else []
        if not files: raise BuildError('no game list (%s) and no .nes files in %s' % (args.csv, games_dir))
        rows = [dict(name=title_from_file(f), file=f) for f in files]
        scanned = True
    else:
        lines = [l for l in open(args.csv, newline='', encoding='utf-8-sig') if l.strip() and not l.lstrip().startswith('#')]
        for i, r in enumerate(csv.DictReader(lines)):
            r = {(k or '').strip().lower(): (v or '').strip() for k, v in r.items()}
            if not r.get('file'): raise BuildError('%s: row %d has no file' % (args.csv, i + 1))
            rows.append(r)
    if len(rows) > M.MAX_GAMES: raise BuildError('%d games: the menu takes at most %d' % (len(rows), M.MAX_GAMES))
    out = []
    for i, r in enumerate(rows):
        path = r['file'].replace('\\', '/')
        if not os.path.isabs(path):            # relative: the games folder first, then the CSV's own folder
            tries = [os.path.join(games_dir, path)] + ([os.path.join(os.path.dirname(os.path.abspath(args.csv)), path)] if not scanned else [])
            path = next((t for t in tries if os.path.isfile(t)), tries[0])
            if not os.path.isfile(path):
                raise BuildError('game %d: file not found: %s (looked in %s)' % (i + 1, r['file'], ' and '.join(os.path.relpath(os.path.dirname(os.path.normpath(t))) for t in tries)))
        elif not os.path.isfile(path): raise BuildError('game %d: file not found: %s' % (i + 1, path))
        try:
            nes = O.Nes(open(path, 'rb').read(), os.path.basename(path))
        except O.NesError as e:
            raise BuildError('game %d: %s' % (i + 1, e))
        if nes.mapper not in (0, 4):
            raise BuildError('game %d %s: mapper %d is not supported (NROM = 0 and MMC3 = 4 only)' % (i + 1, os.path.basename(path), nes.mapper))
        if len(nes.prg) > 512 * KB: raise BuildError('game %d: PRG %d KiB, at most 512 KiB' % (i + 1, len(nes.prg) // KB))
        if len(nes.chr) > 256 * KB: raise BuildError('game %d: CHR %d KiB, at most 256 KiB' % (i + 1, len(nes.chr) // KB))
        raw = r.get('name') or title_from_file(path)
        name, notes = M.clean_name(raw, i)
        for n in notes: log('  note: game %d %s: %s' % (i + 1, name, n))
        mir = (r.get('mirroring') or nes.mirror).upper()[:1]
        if mir not in 'HV': raise BuildError('game %d: mirroring must be H or V' % (i + 1))
        prg = O.pad_pow2(nes.prg, 0x4000)
        chr_ = O.pad_pow2(nes.chr, 0x2000) if nes.chr else b''
        out.append(dict(name=name, file=path, nes=nes, mapper=nes.mapper, mirror=mir, prg=prg, chr=chr_, chr_ram=not nes.chr,
                        prg_addr=num(r.get('prg_addr')), chr_addr=num(r.get('chr_addr'))))
    if scanned:
        # written next to the games folder: as games.csv when there is none yet, else as games_scanned.csv
        lst = os.path.join(os.path.dirname(games_dir), 'games.csv')
        target = lst if not os.path.exists(lst) else os.path.join(os.path.dirname(games_dir), 'games_scanned.csv')
        with open(target, 'w', newline='', encoding='utf-8') as f:
            f.write('# game list made by a scan of %s (names as the menu shows them). Edit, then: make rom\n' % args.games)
            w = csv.writer(f); w.writerow(['name', 'file', 'prg_addr', 'chr_addr', 'mirroring'])
            for g in out: w.writerow([g['name'], os.path.basename(g['file']), '', '', ''])
        log('  wrote the scanned list to %s' % os.path.relpath(target))
    return out


# ----------------------------------------------------------------------------------------------------------- placement
class Flash:
    def __init__(self, lo, hi):
        self.lo, self.hi = lo, hi; self.used = []
    def free(self, a, n):
        return a >= self.lo and a + n <= self.hi and all(a + n <= u or a >= u + l for u, l, _ in self.used)
    def take(self, a, n, what):
        if not self.free(a, n):
            if a + n > self.hi:
                hint = '\n  a 16 MiB ROM goes up to 0xFFFFFF:  make rom SIZE=16' if self.hi < 16 << 20 and a + n <= 16 << 20 else ''
                raise BuildError('%s at 0x%06X-0x%06X is past the end of the %d MiB ROM%s' % (what, a, a + n - 1, self.hi >> 20, hint))
            if a < self.lo:
                raise BuildError('%s at 0x%06X-0x%06X is inside the menu region (games start at 0x%06X)' % (what, a, a + n - 1, self.lo))
            who = [u[2] for u in self.used if not (a + n <= u[0] or a >= u[0] + u[1])]
            raise BuildError('%s at 0x%06X-0x%06X overlaps %s' % (what, a, a + n - 1, ', '.join(who)))
        self.used.append((a, n, what))
    def first_fit(self, n, what):
        a = (self.lo + n - 1) // n * n
        while a + n <= self.hi:
            clash = [u for u in self.used if not (a + n <= u[0] or a >= u[0] + u[1])]
            if not clash:
                self.used.append((a, n, what)); return a
            a = max(c[0] + c[1] for c in clash); a = (a + n - 1) // n * n
        raise BuildError('no free %d KiB block left for %s (free in total: %d KiB)' % (n // KB, what, self.total_free() // KB))
    def total_free(self):
        return self.hi - self.lo - sum(l for _, l, _ in self.used)


def capacity(games, size):
    need, seen = 0, set()
    for g in games:
        for d in (g['prg'], g['chr']):
            if not d: continue
            h = hashlib.sha1(d).hexdigest()
            if h not in seen: seen.add(h); need += len(d)
    area = size - MENU_END
    if need > area:
        big = sorted(((len(d), '%s %s' % (g['name'], k)) for g in games for k, d in (('PRG', g['prg']), ('CHR', g['chr'])) if d), reverse=True)[:4]
        msg = 'the games do not fit the %d MiB ROM: they need %d KiB, the game area 0x%06X-0x%06X holds %d KiB (%d KiB too much)' % (
            size >> 20, need // KB, MENU_END, size - 1, area // KB, (need - area) // KB)
        if size < 16 << 20 and need <= (16 << 20) - MENU_END: msg += '\n  they would fit a 16 MiB ROM:  make rom SIZE=16'
        msg += '\n  largest pieces: ' + ', '.join('%s %d KiB' % (w, n // KB) for n, w in big)
        raise BuildError(msg)
    return need


def place(games, size):
    fl = Flash(MENU_END, size); blobs = {}
    for i, g in enumerate(games):                              # fixed addresses first
        for kind in ('prg', 'chr'):
            a = g[kind + '_addr']
            if a is None or (kind == 'chr' and g['chr_ram']): continue
            d = g[kind]
            if a % len(d): raise BuildError('game %d %s address 0x%X must be a multiple of its size (%d KiB)' % (i + 1, kind.upper(), a, len(d) // KB))
            h = hashlib.sha1(d).hexdigest()
            if blobs.get(h) == a: continue
            fl.take(a, len(d), 'game %d %s' % (i + 1, kind.upper())); blobs.setdefault(h, a)
    for i, g in enumerate(games):                              # then first fit, aligned to the size, PRG then CHR
        for kind in ('prg', 'chr'):
            if kind == 'chr' and g['chr_ram']: g['chr_at'] = None; continue
            d = g[kind]; h = hashlib.sha1(d).hexdigest()
            if g[kind + '_addr'] is not None: g[kind + '_at'] = g[kind + '_addr']; continue
            if h in blobs and blobs[h] % len(d) == 0: g[kind + '_at'] = blobs[h]; g[kind + '_shared'] = True; continue
            g[kind + '_at'] = blobs[h] = fl.first_fit(len(d), 'game %d %s' % (i + 1, kind.upper()))
    return fl


# ---------------------------------------------------------------------------------------------------------------- music
def read_music(path):
    cfg = dict(song='original', options='', cursor='original')
    if path and os.path.exists(path):
        for line in open(path, encoding='utf-8'):
            line = line.split('#')[0].strip()
            if not line: continue
            if '=' not in line: raise BuildError('%s: bad line %r (use key = value)' % (path, line))
            k, v = [x.strip() for x in line.split('=', 1)]
            if k not in cfg: raise BuildError('%s: unknown key %r (song, options, cursor)' % (path, k))
            cfg[k] = v
    return cfg


COLOUR_KEYS = ('text', 'text_bg', 'cursor', 'title')


def read_colours(path):
    """custom/wallpaper/colors.txt: key = value; NES colours written $30 / 0x30 / 30 (custom/wallpaper/README.txt)"""
    import wallpaper as WT
    cfg = dict(text=None, text_bg='auto', cursor=None, title=None)
    if not (path and os.path.exists(path)): return cfg
    for n, line in enumerate(open(path, encoding='utf-8'), 1):
        line = line.split('#')[0].strip()
        if not line: continue
        if '=' not in line: raise BuildError('%s line %d: bad line %r (use key = value)' % (path, n, line))
        k, v = [x.strip() for x in line.split('=', 1)]
        k = {'background': 'text_bg', 'backdrop': 'text_bg', 'arrow': 'cursor'}.get(k.lower(), k.lower())
        if k not in COLOUR_KEYS: raise BuildError('%s line %d: unknown key %r (%s)' % (path, n, k, ', '.join(COLOUR_KEYS)))
        if not v or v.lower() == 'original':
            cfg[k] = 'auto' if k == 'text_bg' else None; continue
        try:
            if k == 'text_bg' and v.lower() in ('auto', 'picture'): cfg[k] = v.lower()
            elif k == 'title':
                cfg[k] = [WT.parse_colour(x) for x in v.replace(',', ' ').split()]
                if len(cfg[k]) != 2: raise SystemExit('title takes 2 colours, the letters and their highlight, e.g. $16 $20')
            else: cfg[k] = WT.parse_colour(v)
        except SystemExit as e:
            raise BuildError('%s line %d (%s): %s' % (path, n, k, e))
    return cfg


def music_parts(cfg, music_dir, log):
    import menu_music as MM
    song, loop = None, True
    if cfg['song'].lower() == 'none': song = []
    elif cfg['song'].lower() != 'original':
        p = cfg['song'] if os.path.isabs(cfg['song']) else os.path.join(music_dir, cfg['song'])
        if not os.path.isfile(p): raise BuildError('music: song file not found: %s' % p)
        if not p.lower().endswith(('.mid', '.midi')): raise BuildError('music: the song must be a .mid file (or original / none)')
        o = MM.parse_opts(cfg['options'].split())
        song, secs = MM.convert_song(p, o, 'English list', lambda s: log('  ' + s))
        loop = bool(o['loop'])
    cursor = None
    if cfg['cursor'].lower() == 'none': cursor = b''
    elif cfg['cursor'].lower() != 'original':
        p = cfg['cursor'] if os.path.isabs(cfg['cursor']) else os.path.join(music_dir, cfg['cursor'])
        if not os.path.isfile(p): raise BuildError('music: cursor effect file not found: %s' % p)
        cursor = MM.build_sfx_record(MM.read_sfx(p))
    return song, loop, cursor


def music_wav(img, path, seconds=60):
    """preview of the English-list music, played by the relocated driver"""
    import struct
    from sndlib import NSFPlayer, render
    e = S.ENTRY
    hdr = b'NESM\x1a\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
    p = NSFPlayer(hdr + bytes(img[S.BANK8_FILE:S.BANK8_FILE + 0x4000]) + b'\xFF' * 0x4000)
    p.mem[0x6000:0x6006] = bytes([0x8D, 0x81, 0x00, 0x4C, e['sound_init'] & 0xFF, e['sound_init'] >> 8])
    r = S.RAM_LO + S.RAM_DELTA
    loop = [0xAD, r & 0xFF, r >> 8, 0x2D, (r + 0x15) & 0xFF, (r + 0x15) >> 8, 0x2D, (r + 0x2A) & 0xFF, (r + 0x2A) >> 8,
            0x2D, (r + 0x3F) & 0xFF, (r + 0x3F) >> 8, 0xC9, 0xFF, 0xD0, 0x03, 0x20, e['start_song'] & 0xFF, e['start_song'] >> 8]
    p.mem[0x6010:0x6010 + 7 + len(loop)] = bytes([0x20, e['sfx_tick'] & 0xFF, e['sfx_tick'] >> 8,
                                                  0x20, e['music_tick'] & 0xFF, e['music_tick'] >> 8] + loop + [0x60])
    render(p.run(0, int(seconds * 60.0988)), path, fade_frames=120)


# --------------------------------------------------------------------------------------------------------------- output
def nes_header(size):
    """NES 2.0: mapper 256 (OneBus), submapper 0, the flash as PRG-ROM, no CHR-ROM, 8 KiB PRG-RAM, NTSC"""
    n = size // 0x4000
    return bytes([0x4E, 0x45, 0x53, 0x1A, n & 0xFF, 0x00, 0x00, 0x08, 0x01, (n >> 8) & 0x0F, 0x07, 0, 0, 0, 0, 0])


def vectors(img, g):
    a = g['prg_at'] + len(g['prg']) - 6
    nmi, reset, irq = (img[a + k] | img[a + k + 1] << 8 for k in (0, 2, 4))
    return nmi, reset, irq, a + 2


def write_reports(games, out, size, img, fl, info, logrows):
    base = os.path.splitext(out)[0]
    with open(base + '_games.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['game', 'name', 'file', 'mapper', 'prg_addr', 'prg_kb', 'chr_addr', 'chr_kb', 'mirroring', 'chr_ram',
                    'p0', 'p1', 'p2_201A', 'p3_prg_bank', 'p4_4100', 'p5_2018', 'p6_410B', 'p7',
                    'reg_4100', 'reg_410B', 'reg_4107_410A', 'reg_2018', 'reg_201A', 'reg_4118', 'reset_vec', 'reset_vec_file_off'])
        for i, g in enumerate(games):
            r = O.stub_registers(g['params']); nmi, reset, irq, voff = vectors(img, g)
            w.writerow([i + 1, g['name'], os.path.basename(g['file']), g['mapper'], '0x%06X' % g['prg_at'], len(g['prg']) // KB,
                        '' if g['chr_ram'] else '0x%06X' % g['chr_at'], len(g['chr']) // KB, g['mirror'], int(g['chr_ram'])]
                       + ['0x%02X' % b for b in g['params']]
                       + ['0x%02X' % r[0x4100], '0x%02X' % r[0x410B], ' '.join('%02X' % r[a] for a in (0x4107, 0x4108, 0x4109, 0x410A)),
                          '0x%02X' % r[0x2018], '0x%02X' % r[0x201A], '0x%02X' % r[0x4118], '0x%04X' % reset, '0x%06X' % voff])
    with open(base + '_layout.txt', 'w') as f:
        f.write('flash layout of %s (%d MiB)\n\n' % (os.path.basename(out), size >> 20))
        f.write('0x000000-0x07FFFF  menu region (English menu, TFT, boot, test program, Chinese menu data, sound driver)\n')
        f.write('0x070000-0x07%04X  English-list sound driver + song (banks $38/$39)\n' % (0x70000 + info['sound']['used'] - 1 - 0x70000))
        for a, n, what in sorted(fl.used):
            f.write('0x%06X-0x%06X  %5d KiB  %s\n' % (a, a + n - 1, n // KB, what))
        f.write('\nfree in the game area: %d KiB\n' % (fl.total_free() // KB))
    with open(base + '_build.log', 'w') as f:
        f.write('\n'.join(logrows) + '\n')


def usage_bar(size, used):
    tot = size // KB; u = MENU_END // KB + used // KB
    filled = int(40 * u / tot)
    return 'ROM usage   [%s%s] %d of %d KiB used (%.1f%%): menu region 512 KiB + games %d KiB; %d KiB free' % (
        '#' * filled, '.' * (40 - filled), u, tot, 100.0 * u / tot, used // KB, tot - u)


# ----------------------------------------------------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--custom', default=os.path.join(ROOT, 'custom'))
    ap.add_argument('--csv'); ap.add_argument('--games'); ap.add_argument('--scan', action='store_true')
    ap.add_argument('--music', help='music settings file (default custom/music/music.txt)')
    ap.add_argument('--wallpaper', help='english list background PNG (default custom/wallpaper/english.png if present)')
    ap.add_argument('--colors', '--colours', dest='colours', help='list colours file (default custom/wallpaper/colors.txt if present)')
    ap.add_argument('--base', default=DEFAULT_BASE, help='the 512 KiB menu image (stripped dump)')
    ap.add_argument('--size', type=int, default=8, choices=(8, 16))
    ap.add_argument('--out', default=None)
    ap.add_argument('--verify', default='none', choices=('none', 'auto', 'full', 'quick'))
    ap.add_argument('--wav', action='store_true', help='also write <out>_music.wav (preview of the list music)')
    ap.add_argument('--no-unit', action='store_true', help='do not write <out>_unit.bin (the image for the real handheld)')
    ap.add_argument('--unit-dump', help="the handheld's own flash 0x70000-0x7FFFF, to compare the rule with byte for byte")
    a = ap.parse_args()
    c = a.custom or os.path.join(ROOT, 'build', 'no_custom')          # --custom '': nothing from a custom folder
    a.csv = a.csv or os.path.join(c, 'games.csv')
    a.games = a.games or os.path.join(c, 'games')
    a.music = a.music or os.path.join(c, 'music', 'music.txt')
    if a.wallpaper and a.wallpaper.lower().startswith('english='): a.wallpaper = a.wallpaper[8:]
    if a.wallpaper == '': a.wallpaper = None
    elif a.wallpaper is None and a.custom and os.path.exists(os.path.join(c, 'wallpaper', 'english.png')):
        a.wallpaper = os.path.join(c, 'wallpaper', 'english.png')
    if a.colours == '': a.colours = None
    elif a.colours is None and a.custom and os.path.exists(os.path.join(c, 'wallpaper', 'colors.txt')):
        a.colours = os.path.join(c, 'wallpaper', 'colors.txt')
    size = a.size << 20
    out = a.out or os.path.join(ROOT, 'build', 'rom', 'multicart_%dM.bin' % a.size)
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
    rows = []
    def log(s=''):
        print(s); rows.append(s)
    t0 = time.time()
    log('Sup 400-in-1 multicart build, %s' % time.strftime('%Y-%m-%d %H:%M:%S'))
    try:
        # 1. inputs
        base = bytearray(open(a.base, 'rb').read())
        if len(base) < MENU_END: raise BuildError('%s: expected the 512 KiB menu image' % a.base)
        base = base[:MENU_END]
        log('inputs:')
        log('  base menu image  %s  sha1 %s' % (os.path.relpath(a.base), sha1(a.base)))
        games = read_list(a, log)
        log('  game list        %s (%d games)' % ('scan of ' + os.path.relpath(a.games) if a.scan or not os.path.exists(a.csv) else os.path.relpath(a.csv), len(games)))
        nb = sum(len(g['name']) + 1 for g in games)
        if nb > M.NAMES_END - M.NAMES:
            raise BuildError('the %d names take %d bytes; the list has room for %d (bank $3C, 8 KiB: on average %.1f characters per '
                             'name for %d games). Shorten some names by %d characters in total' % (
                                 len(games), nb, M.NAMES_END - M.NAMES, (M.NAMES_END - M.NAMES) / len(games) - 1, len(games),
                                 nb - (M.NAMES_END - M.NAMES)))
        need = capacity(games, size)
        # 2. list colours and wallpaper (on the 512 KiB region, before the menu patches)
        import wallpaper as WT
        col = read_colours(a.colours)
        quiet = lambda t: None
        if a.colours: log('  colours          %s' % os.path.relpath(a.colours))
        try:
            if col['text'] is not None:           # first, so that the wallpaper import keeps the new text colour
                WT.english_colours(base, text=col['text'], log=quiet, check=False)
            if a.wallpaper:
                bgs = [col['text_bg']] if isinstance(col['text_bg'], int) else {'auto': ['text', 'most'], 'picture': ['most']}[col['text_bg']]
                with tempfile.TemporaryDirectory() as td:
                    src = os.path.join(td, 'in.bin'); dst = os.path.join(td, 'out.bin')
                    open(src, 'wb').write(base)
                    for i, bg in enumerate(bgs):
                        r = subprocess.run([sys.executable, os.path.join(ROOT, 'wallpaper', 'wallpaper.py'), 'import-png', src, 'english',
                                            a.wallpaper, '-o', dst, '--bg', bg if isinstance(bg, str) else '%02X' % bg],
                                           capture_output=True, text=True)
                        if r.returncode == 0: break
                        if i + 1 < len(bgs):
                            log('  note: with the commonest colour under the list lines as colour 0 the picture does not fit (%s); '
                                'using the commonest colour of the whole picture instead' % (r.stderr.strip() or r.stdout.strip()).splitlines()[-1])
                    if r.returncode: raise BuildError('wallpaper: %s' % (r.stderr.strip() or r.stdout.strip()))
                    base = bytearray(open(dst, 'rb').read())
                log('  wallpaper        %s  sha1 %s' % (os.path.relpath(a.wallpaper), sha1(a.wallpaper)))
            else:
                log('  wallpaper        original')
            if col['title'] is not None and a.wallpaper:
                log('  note: title colours are for the original background; the wallpaper keeps its own (title ignored)')
            WT.english_colours(base, backdrop=col['text_bg'] if isinstance(col['text_bg'], int) and not a.wallpaper else None,
                               cursor=col['cursor'], title=None if a.wallpaper else col['title'], log=quiet)
        except SystemExit as e:
            raise BuildError('colours: %s' % e)
        pal = base[WT.SCREENS['english']['desc'] + 2:][:32]
        tp = WT.text_palettes(base)
        log('  list colours     text %s, around the text $%02X, cursor $%02X, title %s%s' % (
            '/'.join('$%02X' % pal[p * 4 + 3] for p in tp), pal[0], pal[WT.EN_CURSOR],
            'from the wallpaper' if a.wallpaper else '$%02X $%02X' % (pal[WT.EN_TITLE * 4 + 2], pal[WT.EN_TITLE * 4 + 1]),
            '' if a.colours else '  (custom/wallpaper/colors.txt changes them)'))
        if a.wallpaper:
            # the list writes 21 tiles per line (rows 5, 7, ... 23, columns 8-28): blanks there show the backdrop colour
            scr = WT.read_screen(base, 'english')
            hidden = sorted(set(r for r in range(5, 24, 2) for c in range(8, 29)
                                if any(any(row) for row in WT.tile_pixels(scr['chr'], scr['nam'][r * 32 + c]))))
            if hidden:
                log('  note: the list text lines cover the wallpaper at tile rows %s (y = %s), columns 8-28 (x = 64-231): '
                    'there it shows colour 0 ($%02X) around the text' % (
                        ', '.join(map(str, hidden)), ', '.join('%d-%d' % (8 * r, 8 * r + 7) for r in hidden), pal[0]))
        # 3. placement + launch bytes
        fl = place(games, size)
        for g in games:
            g['params'] = O.encode(g['prg_at'], len(g['prg']), g['chr_at'], len(g['chr']) if g['chr'] else 0, g['mirror'], g['chr_ram'])
            O.check_roundtrip(g['params'], g['prg_at'], len(g['prg']), g['chr_at'], g['chr_ram'], g['mirror'], g['mapper'])
        # 4. the image
        img = bytearray(b'\xFF' * size)
        img[:MENU_END] = base
        M.apply_patches(img)
        M.write_list(img, games)
        mcfg = read_music(a.music)
        log('  music            %s: song = %s, cursor = %s%s' % (os.path.relpath(a.music) if os.path.exists(a.music) else '(none, defaults)',
                                                                 mcfg['song'], mcfg['cursor'], ', options: ' + mcfg['options'] if mcfg['options'] else ''))
        song, loop, cursor = music_parts(mcfg, os.path.dirname(a.music), log)
        try:
            snd = S.install(img, song, loop, cursor, log=log)
        except ValueError as e:
            raise BuildError(str(e))
        for g in games:
            img[g['prg_at']:g['prg_at'] + len(g['prg'])] = g['prg']
            if not g['chr_ram']: img[g['chr_at']:g['chr_at'] + len(g['chr'])] = g['chr']
        # 5. outputs
        open(out, 'wb').write(img)
        nes = os.path.splitext(out)[0] + '.nes'
        open(nes, 'wb').write(nes_header(size) + img)
        log('menu changes: boot goes straight to the English list; no index remaps / hot-keys; list music')
        log('%d game(s) on %d page(s)' % (len(games), (len(games) + M.ROWS - 1) // M.ROWS))
        log(usage_bar(size, need))
        log('')
        log('## Games')
        log('')
        log('| # | name | file | mapper | PRG | PRG KiB | CHR | CHR KiB | mir | reset | NMI | IRQ | reset vector at | '
            '$4100 | $410B | $4107-$410A | $2018 | $201A | $4118 | launch bytes p0-p7 |')
        log('|' + '---|' * 20)
        for i, g in enumerate(games):
            nmi, reset, irq, voff = vectors(img, g); r = O.stub_registers(g['params'])
            log('| %d | %s | %s | %d | 0x%06X | %d | %s | %s | %s | $%04X | $%04X | $%04X | 0x%06X | $%02X | $%02X | %s | $%02X | $%02X | $%02X | %s |' % (
                i + 1, g['name'], os.path.basename(g['file']), g['mapper'], g['prg_at'], len(g['prg']) // KB,
                'RAM' if g['chr_ram'] else '0x%06X' % g['chr_at'], '8' if g['chr_ram'] else str(len(g['chr']) // KB), g['mirror'],
                reset, nmi, irq, voff, r[0x4100], r[0x410B], ' '.join('%02X' % r[x] for x in (0x4107, 0x4108, 0x4109, 0x410A)),
                r[0x2018], r[0x201A], r[0x4118], g['params'].hex(' ')))
        log('')
        urep = None
        if not a.no_unit:
            import unit as U
            try:
                unit_img, urep = U.make_unit_image(img, a.unit_dump)
            except ValueError as e:
                raise BuildError('handheld image: %s' % e)
            upath = os.path.splitext(out)[0] + '_unit.bin'
            open(upath, 'wb').write(unit_img)
            for l in U.report(urep): log(l)
            if not urep['ok']: raise BuildError('handheld image: a check failed (above)')
            log('')
        log('outputs:')
        log('  %s   emulators (EmuVT)' % os.path.relpath(out))
        log('  %s   FCEUX / NintendulatorNRS (NES 2.0, mapper 256)' % os.path.relpath(nes))
        if urep:
            log('  %s   the real handheld: flash this one (reset opcodes bit-swapped)' % os.path.relpath(upath))
        if a.wav:
            wp = os.path.splitext(out)[0] + '_music.wav'; music_wav(img, wp); log('  %s   preview of the list music' % os.path.relpath(wp))
        ok = True
        if a.verify != 'none':
            import verify as V
            vlog = []
            ok = V.verify(img, games, vlog, mode=a.verify, shots=os.path.splitext(out)[0] + '_shots')
            log('check on the OneBus model (%s): %s' % (a.verify, 'all checks passed' if ok else 'FAILED'))
            for l in vlog: log('  ' + l)
        write_reports(games, out, size, img, fl, dict(sound=snd), rows)
        print('done in %.1f s' % (time.time() - t0))
        return 0 if ok else 2
    except BuildError as e:
        log('ERROR: %s' % e)
        return 1


if __name__ == '__main__':
    sys.exit(main())
