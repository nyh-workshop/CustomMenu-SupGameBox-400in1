#!/usr/bin/env python3
"""Sup 400-in-1 menu wallpaper tool.

Exports and replaces the backgrounds of the three menu screens in the 512 KiB menu
dump (or any larger ROM that keeps the menu at the same offsets, e.g. a built
8/16 MiB image):

    langsel   language select   (file 0x68000-0x6FFFF block)
    english   English menu      (file 0x78000-0x7FFFF block)
    chinese   Chinese menu      (file 0x38000-0x3FFFF block)

How the menus draw a background (identical routine in all three blocks):
  * A descriptor holds a 2-byte pointer to the packed screen, then a 32-byte palette.
  * The packed screen is a byte stream decoded straight into PPU $2000-$23FF
    (960 tile bytes + 64 attribute bytes):
        $00        end
        $80+n      repeat the next byte n times   (n = 1..127)
        $01..$7F   copy the next n bytes
  * The tiles come from a fixed 4 KiB CHR area of the same flash (OneBus).

Commands
  export     ROM SCREEN OUTDIR            -> SCREEN.nam (1024), SCREEN.chr (4096),
                                             SCREEN.pal (16, background palette), SCREEN.png
  import     ROM SCREEN -o OUT [--nam F] [--chr F] [--pal F]
                                           NES Screen Tool / NEXXT style files
  import-png ROM SCREEN IMAGE.png -o OUT   256x240 picture made of NES colours
  colours    ROM -o OUT [--text $30] [--backdrop $01] [--cursor $25] [--title "$16 $20"]
                                           English list colours (the builder reads custom/wallpaper/colors.txt)
  info       ROM                           show where everything is

Requires Python 3; export previews and import-png need Pillow (pip install pillow).
"""
import argparse, os, sys

# ---------------------------------------------------------------- screen table
# chr: file offset of the 4 KiB background pattern table as the screen sees it.
# pages: Chinese only - the background table is one of 40 pages; tiles $00-$3F are
#        shared (identical in every page), $40-$FF are each page's glyphs.
# reserved: tiles the menu needs for text / sprites. Their pixels must not change.
# text_rect: tile columns/rows (c0, c1, r0, r1) where the menu draws list text at run time;
#       text_index: the colour index the font/glyph tiles draw with (English 3, Chinese 2).
#       In those 16x16 areas the palette keeps that colour at that index, so text keeps its colour.
# free: unused gaps in the same block (CPU-reachable when the screen is drawn) used
#       when a new packed screen does not fit where the old one was.
SCREENS = {
    'langsel': dict(name='Language select', desc=0x6E3AC, block=0x68000, cpu=0x8000, block_end=0x70000,
                    chr=0x67000, pages=None, max_tile=0xFF,
                    reserved={0xC7: 'cursor sprite', 0xD7: 'cursor sprite'}, text_rect=None, text_index=None,
                    free=[(0x6D5A7, 0x6DA04)]),
    'english': dict(name='English menu', desc=0x7E140, block=0x78000, cpu=0x8000, block_end=0x80000,
                    chr=0x62000, pages=None, max_tile=0xFF,
                    reserved=dict([(t, 'font (list text)') for t in range(0x00, 0x2E)] + [(0x2E, 'cursor sprite')]),
                    text_rect=(8, 28, 5, 23), text_index=3,
                    free=[(0x7D981, 0x7E0FF), (0x7E430, 0x7E7DF)]),
    'chinese': dict(name='Chinese menu', desc=0x3F616, block=0x38000, cpu=0x8000, block_end=0x40000,
                    chr=0x00000, pages=40, max_tile=0x3F,
                    reserved=dict([(0x00, 'blank (list panel is cleared with it)')] +
                                  [(t, 'row numbers') for t in range(0x1E, 0x32)]),
                    text_rect=(10, 25, 4, 23), text_index=2,
                    free=[(0x3B1F6, 0x3B7FF), (0x3BC00, 0x3BFFF)]),
}

NESPAL = [int(x, 16) for x in '''7C7C7C 0000FC 0000BC 4428BC 940084 A80020 A81000 881400 503000 007800 006800 005800 004058 000000 000000 000000
BCBCBC 0078F8 0058F8 6844FC D800CC E40058 F83800 E45C10 AC7C00 00B800 00A800 00A844 008888 000000 000000 000000
F8F8F8 3CBCFC 6888FC 9878F8 F878F8 F85898 F87858 FCA044 F8B800 B8F818 58D854 58F898 00E8D8 787878 000000 000000
FCFCFC A4E4FC B8B8F8 D8B8F8 F8B8F8 F8A4C0 F0D0B0 FCE0A8 F8D878 D8F878 B8F8B8 B8F8D8 00FCFC F8D8F8 000000 000000'''.split()]
BLACK = 0x0F
for _k, _v in SCREENS.items(): _v['key'] = _k
BLACKS = {0x0D, 0x0E, 0x0F, 0x1D, 0x1E, 0x1F, 0x2E, 0x2F, 0x3E, 0x3F}   # all show black ($0D: darker than black, avoid)


def parse_colour(v):
    """an NES colour written $30, 0x30 or 30 (hex)"""
    t = str(v).strip().lower().lstrip('$')
    if t.startswith('0x'): t = t[2:]
    try:
        c = int(t, 16)
    except ValueError:
        raise SystemExit('%r is not an NES colour: write it as hex, e.g. $30 (white), $0F (black), $01 (dark blue)' % v)
    if not 0 <= c <= 0x3F: raise SystemExit('NES colour $%X out of range: $00-$3F' % c)
    if c == 0x0D: raise SystemExit('colour $0D is darker than black and upsets some TVs: use $0F for black')
    return 0x0F if c in BLACKS else c


# the English list (what the builder's colour options change, see english_colours)
EN_CURSOR = 0x15      # palette byte: sprite palette 1, colour 1 = the arrow (sprite tile $2E, attribute 1)
EN_TITLE = 2          # background palette of "400 IN 1" in the original background


def rgb(c):
    v = NESPAL[c & 0x3F]
    return (v >> 16) & 255, (v >> 8) & 255, v & 255


# ---------------------------------------------------------------- helpers
def cpu_to_file(s, a):
    return s['block'] + (a - s['cpu'])


def file_to_cpu(s, o):
    return s['cpu'] + (o - s['block'])


def unpack(rom, off):
    out = bytearray(); o = off
    while True:
        b = rom[o]; o += 1
        if b == 0:
            return bytes(out), o - off
        if b & 0x80:
            out += bytes([rom[o]]) * (b & 0x7F); o += 1
        else:
            out += rom[o:o + b]; o += b


def pack(data):
    """Smallest encoding in the menu format (dynamic programming over literal/repeat blocks)."""
    n = len(data)
    INF = 1 << 30
    cost = [INF] * (n + 1); how = [None] * (n + 1)
    cost[n] = 1                                   # the $00 terminator
    for i in range(n - 1, -1, -1):
        r = 1
        while i + r < n and data[i + r] == data[i] and r < 127:
            r += 1
        for k in range(1, r + 1):                 # repeat block of length k
            c = 2 + cost[i + k]
            if c < cost[i]: cost[i], how[i] = c, ('r', k)
        for k in range(1, min(127, n - i) + 1):   # literal block of length k
            c = 1 + k + cost[i + k]
            if c < cost[i]: cost[i], how[i] = c, ('l', k)
    out = bytearray(); i = 0
    while i < n:
        t, k = how[i]
        if t == 'r': out += bytes([0x80 | k, data[i]])
        else: out += bytes([k]) + data[i:i + k]
        i += k
    out.append(0)
    return bytes(out)


def read_screen(rom, key):
    s = SCREENS[key]
    ptr = rom[s['desc']] | rom[s['desc'] + 1] << 8
    off = cpu_to_file(s, ptr)
    nam, packed_len = unpack(rom, off)
    pal = bytes(rom[s['desc'] + 2: s['desc'] + 34])
    chr_ = bytes(rom[s['chr']: s['chr'] + 0x1000])
    return dict(ptr=ptr, off=off, packed_len=packed_len, nam=nam, pal=pal, chr=chr_)


def tile_pixels(chr_, t):
    b = chr_[16 * t: 16 * t + 16]
    return [[((b[y] >> (7 - x)) & 1) | (((b[y + 8] >> (7 - x)) & 1) << 1) for x in range(8)] for y in range(8)]


def encode_tile(px):
    b = bytearray(16)
    for y in range(8):
        for x in range(8):
            c = px[y][x]
            b[y] |= (c & 1) << (7 - x)
            b[y + 8] |= ((c >> 1) & 1) << (7 - x)
    return bytes(b)


def attr_pal(nam, tx, ty):
    a = nam[0x3C0 + (ty // 4) * 8 + tx // 4]
    return (a >> (((ty % 4) // 2) * 4 + ((tx % 4) // 2) * 2)) & 3


def render(nam, pal16, chr_):
    from PIL import Image
    img = Image.new('RGB', (256, 240)); px = img.load()
    for ty in range(30):
        for tx in range(32):
            p = attr_pal(nam, tx, ty)
            tp = tile_pixels(chr_, nam[ty * 32 + tx])
            for y in range(8):
                for x in range(8):
                    c = tp[y][x]
                    px[tx * 8 + x, ty * 8 + y] = rgb(pal16[0] if c == 0 else pal16[p * 4 + c])
    return img


# ---------------------------------------------------------------- commands
def cmd_info(rom):
    for k, s in SCREENS.items():
        r = read_screen(rom, k)
        used = sorted(set(r['nam'][:0x3C0]))
        print('%s (%s)' % (k, s['name']))
        print('  descriptor   file 0x%05X: pointer $%04X + 32-byte palette' % (s['desc'], r['ptr']))
        print('  packed screen file 0x%05X, %d bytes -> 1024 bytes (960 tiles + 64 attributes)' % (r['off'], r['packed_len']))
        if s['pages']:
            print('  CHR          tiles $00-$3F of each of %d pages: file 0x%05X + page*0x1000 (bg table at PPU $1000)' % (s['pages'], s['chr']))
        else:
            print('  CHR          file 0x%05X-0x%05X (256 tiles)' % (s['chr'], s['chr'] + 0xFFF))
        print('  tiles used   %d distinct; reserved: %s' % (len(used), ', '.join(sorted(set(s['reserved'].values())))))


def cmd_export(rom, key, outdir, guide=None):
    os.makedirs(outdir, exist_ok=True)
    r = read_screen(rom, key)
    base = os.path.join(outdir, key)
    open(base + '.nam', 'wb').write(r['nam'])
    open(base + '.chr', 'wb').write(r['chr'])
    open(base + '.pal', 'wb').write(r['pal'][:16])
    with open(base + '_reserved.txt', 'w') as f:
        f.write('Tiles %s needs unchanged (index: use)\n' % key)
        for t, why in sorted(SCREENS[key]['reserved'].items()):
            f.write('$%02X: %s\n' % (t, why))
        if SCREENS[key]['pages']:
            f.write('Background tiles must be $00-$3F (shared by all 40 pages); $40-$FF are page glyphs.\n')
    try:
        img = render(r['nam'], r['pal'], r['chr']); img.save(base + '.png')
        if guide and SCREENS[key]['text_rect']:
            from PIL import Image, ImageDraw
            g = img.convert('RGB'); ov = Image.new('RGBA', g.size, (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
            c0, c1, r0, r1 = SCREENS[key]['text_rect']
            rows = range(r0, r1 + 1, 2) if key == 'english' else range(r0, r1 + 1)
            for ty in rows:
                dr.rectangle([c0 * 8, ty * 8, c1 * 8 + 7, ty * 8 + 7], fill=(255, 0, 0, 120))
            Image.alpha_composite(g.convert('RGBA'), ov).convert('RGB').save(guide)
            print('guide (red = where the menu draws the list over the picture): %s' % guide)
    except ImportError:
        print('(Pillow not installed: no preview PNG)')
    print('exported %s to %s.{nam,chr,pal,png}' % (key, base))


def write_screen(rom, key, nam, chr_, pal16, force=False):
    """Validate and write nametable/attributes, CHR and background palette into rom (bytearray)."""
    s = SCREENS[key]
    cur = read_screen(rom, key)
    errors = []
    if len(nam) != 0x400:
        errors.append('nametable must be 1024 bytes (got %d)' % len(nam))
    if len(chr_) not in (0x1000, 0x2000):
        errors.append('CHR must be 4096 bytes (got %d)' % len(chr_))
    chr_ = chr_[:0x1000]
    if len(pal16) < 16:
        errors.append('palette must have 16 bytes')
    for t in s['reserved']:
        if chr_[16 * t: 16 * t + 16] != cur['chr'][16 * t: 16 * t + 16]:
            errors.append('tile $%02X (%s) was changed' % (t, s['reserved'][t]))
    bad = sorted({t for t in nam[:0x3C0] if t > s['max_tile']})
    if bad:
        errors.append('tiles above $%02X used: %s (Chinese pages only share $00-$3F)' % (s['max_tile'], ' '.join('$%02X' % t for t in bad[:8])))
    if s['pages'] and chr_[0x400:] != cur['chr'][0x400:]:
        print('note: tiles $40-$FF in the CHR file are ignored for the Chinese menu (they are page glyphs)')
    if errors and not force:
        raise SystemExit('refused:\n  ' + '\n  '.join(errors))
    # --- packed screen
    if nam != cur['nam']:
        packed = pack(nam)
        if len(packed) <= cur['packed_len']:
            dst = cur['off']
        else:
            dst = None
            for a, b in s['free']:
                if b - a + 1 >= len(packed) and all(rom[x] in (0x00, 0xFF) for x in range(a, a + len(packed))):
                    dst = a; break
            if dst is None:
                raise SystemExit('packed screen is %d bytes and does not fit (old slot %d bytes, no free area large enough). '
                                 'Use fewer distinct tiles / more repeated rows.' % (len(packed), cur['packed_len']))
            ptr = file_to_cpu(s, dst)
            rom[s['desc']] = ptr & 0xFF; rom[s['desc'] + 1] = ptr >> 8
            print('packed screen moved to file 0x%05X (CPU $%04X); descriptor updated' % (dst, ptr))
        rom[dst: dst + len(packed)] = packed
        print('packed screen: %d bytes at file 0x%05X' % (len(packed), dst))
    # --- CHR
    if s['pages']:
        for p in range(s['pages']):
            rom[s['chr'] + p * 0x1000: s['chr'] + p * 0x1000 + 0x400] = chr_[:0x400]
        print('CHR tiles $00-$3F written to all %d pages' % s['pages'])
    else:
        rom[s['chr']: s['chr'] + 0x1000] = chr_
        print('CHR written to file 0x%05X-0x%05X' % (s['chr'], s['chr'] + 0xFFF))
    # --- palette (background half only; the sprite half stays as it was)
    rom[s['desc'] + 2: s['desc'] + 18] = pal16[:16]
    # byte 16 is written to PPU $3F10, a mirror of the backdrop $3F00, and it is written last: it must hold the same
    # colour, or every pixel of colour 0 (the picture background and the cells around the list letters) shows it instead
    rom[s['desc'] + 18] = pal16[0]
    # check by decoding back
    chk = read_screen(rom, key)
    assert chk['nam'] == nam, 'internal error: decode mismatch'
    return rom


def cmd_import(args):
    rom = bytearray(open(args.rom, 'rb').read())
    cur = read_screen(rom, args.screen)
    nam = open(args.nam, 'rb').read() if args.nam else cur['nam']
    chr_ = open(args.chr, 'rb').read() if args.chr else cur['chr']
    pal = open(args.pal, 'rb').read()[:16] if args.pal else cur['pal'][:16]
    write_screen(rom, args.screen, nam, chr_, pal, args.force)
    open(args.out, 'wb').write(rom)
    print('wrote', args.out)


def cmd_import_png(args):
    from PIL import Image
    s = SCREENS[args.screen]
    rom = bytearray(open(args.rom, 'rb').read())
    cur = read_screen(rom, args.screen)
    img = Image.open(args.image).convert('RGB')
    if img.size == (512, 480):
        img = img.resize((256, 240), Image.NEAREST)
    if img.size != (256, 240):
        raise SystemExit('image must be 256x240 (or 512x480)')
    px = img.load()
    # map every colour to the nearest NES colour (black -> $0F)
    cache = {}

    def nes(c):
        if c not in cache:
            best = min(range(64), key=lambda i: (sum((a - b) ** 2 for a, b in zip(rgb(i), c)), 0 if i == BLACK else 1))
            cache[c] = BLACK if rgb(best) == (0, 0, 0) else best
        return cache[c]
    col = [[nes(px[x, y]) for x in range(256)] for y in range(240)]
    # background colour = most common colour
    from collections import Counter
    bg = Counter(c for row in col for c in row).most_common(1)[0][0]
    mode = (args.bg or 'most').lower()
    if mode == 'text' and s['text_rect'] and s['key'] == 'english':
        # the colour that covers most of the picture under the list lines (rows 5, 7, ... 23, x = 64-231): the menu writes
        # whole lines of tiles there, so the backdrop colour is what shows around the letters
        c0, c1, r0, r1 = s['text_rect']
        bg = Counter(col[y][x] for r in range(r0, r1 + 1, 2) for y in range(8 * r, 8 * r + 8)
                     for x in range(8 * c0, 8 * c1 + 8)).most_common(1)[0][0]
    elif mode not in ('most', 'text'):
        bg = parse_colour(mode)
    print('background (colour 0, also around the list text): $%02X' % bg)
    # colour sets per 16x16 attribute area
    areas = {}
    for ay in range(15):
        for ax in range(16):
            cs = {col[y][x] for y in range(ay * 16, ay * 16 + 16) for x in range(ax * 16, ax * 16 + 16)} - {bg}
            if len(cs) > 3:
                raise SystemExit('16x16 area at (%d,%d) has %d colours besides the background; max 3' % (ax * 16, ay * 16, len(cs)))
            areas[(ax, ay)] = frozenset(cs)
    # text areas: their palette must keep the text colour at the text index
    pin = {}
    if s['text_rect']:
        c0, c1, r0, r1 = s['text_rect']; k = s['text_index']
        for ay in range(r0 // 2, r1 // 2 + 1):
            for ax in range(c0 // 2, c1 // 2 + 1):
                pin[(ax, ay)] = cur['pal'][attr_pal(cur['nam'], ax * 2, ay * 2) * 4 + k]
    slots = [dict(cols=set(), pin=None) for _ in range(4)]

    def fits(sl, cs, pn):
        if pn is not None and sl['pin'] not in (None, pn):
            return False
        return len(sl['cols'] | cs | ({pn} if pn is not None else set())) <= 3
    items = sorted({(v, pin.get(k)) for k, v in areas.items()}, key=lambda it: (it[1] is None, -len(it[0])))
    # first choice: the screen's current palettes, if every area fits one of them
    cur_sets = [set(cur['pal'][p * 4 + 1: p * 4 + 4]) for p in range(4)]
    kk = s['text_index']
    if cur['pal'][0] == bg and all(any(set(cs) <= cur_sets[p] and (pn is None or cur['pal'][p * 4 + kk] == pn) for p in range(4))
                                   for cs, pn in items):
        slots = [dict(cols=cur_sets[p], pin=(cur['pal'][p * 4 + kk] if kk else None)) for p in range(4)]
        items = []
        print('keeping the current palettes')
    for cs, pn in items:
        if pn is not None and len(set(cs) | {pn}) > 3:
            where = [k_ for k_, v in areas.items() if v == cs and pin.get(k_) == pn][:3]
            raise SystemExit('the 16x16 area(s) at %s are under the menu text: they may use at most 2 colours of their '
                             'own plus the text colour $%02X, but use %s' % (', '.join('(%d,%d)' % (x * 16, y * 16) for x, y in where),
                             pn, ' '.join('$%02X' % c for c in sorted(cs))))
        if any(set(cs) <= sl['cols'] and (pn is None or sl['pin'] == pn) for sl in slots):
            continue
        for sl in sorted(slots, key=lambda sl: (not sl['cols'], )):   # prefer merging into used slots
            if fits(sl, cs, pn):
                sl['cols'] |= set(cs) | ({pn} if pn is not None else set())
                if pn is not None: sl['pin'] = pn
                break
        else:
            where = [k_ for k_, v in areas.items() if v == cs and pin.get(k_) == pn][:3]
            raise SystemExit('picture needs more than 4 background palettes (3 colours + shared background each). '
                             'Could not place colours %s%s, used e.g. in the 16x16 area(s) at %s. '
                             'Palettes so far: %s' % (' '.join('$%02X' % c for c in sorted(cs)),
                             (' + text colour $%02X' % pn) if pn is not None else '',
                             ', '.join('(%d,%d)' % (x * 16, y * 16) for x, y in where),
                             ' | '.join(' '.join('$%02X' % c for c in sorted(sl['cols'])) for sl in slots)))
    # colour order inside each palette: reuse the order of a current palette that
    # contains the same colours (keeps shared tiles shared), otherwise sorted
    orig = [list(cur['pal'][p * 4 + 1: p * 4 + 4]) for p in range(4)]
    k = s['text_index']
    pal_lists = []
    for sl in slots:
        lst = None
        for o in orig:
            if sl['cols'] <= set(o) and (sl['pin'] is None or o[k - 1] == sl['pin']):
                lst = list(o); break
        if lst is None and sl['pin'] is not None:
            rest = sorted(sl['cols'] - {sl['pin']})
            lst = [None, None, None]; lst[k - 1] = sl['pin']
            for i in range(3):
                if lst[i] is None: lst[i] = rest.pop(0) if rest else BLACK
        if lst is None:
            lst = sorted(sl['cols']) + [BLACK] * (3 - len(sl['cols']))
        pal_lists.append(lst)
    pal16 = bytes(sum(([bg] + pl for pl in pal_lists), []))
    # tiles: walk the 16x16 areas; where several palettes fit an area, take the one
    # whose colour->index mapping reuses the most tiles already made
    chr_ = bytearray(cur['chr'])
    reserved = s['reserved']
    known = {cur['chr'][16 * t: 16 * t + 16]: t for t in reserved}
    limit = s['max_tile'] + 1
    free = [t for t in range(limit) if t not in reserved]
    new_tiles = 0
    nam = bytearray(0x400)
    area_pal = {}

    def area_tiles(ax, ay, p):
        lut = {bg: 0}
        for i, c in enumerate(pal_lists[p]):
            lut.setdefault(c, i + 1)
        out = []
        for ty in (ay * 2, ay * 2 + 1):
            for tx in (ax * 2, ax * 2 + 1):
                if ty < 30:
                    out.append((tx, ty, encode_tile([[lut[col[ty * 8 + y][tx * 8 + x]] for x in range(8)] for y in range(8)])))
        return out
    for ay in range(15):
        for ax in range(16):
            v = areas[(ax, ay)]; pn = pin.get((ax, ay))
            cands = [i for i, sl in enumerate(slots) if set(v) <= sl['cols'] and (pn is None or sl['pin'] == pn)]
            best = max(cands, key=lambda p: (sum(1 for _, _, e in area_tiles(ax, ay, p) if e in known), -p))
            area_pal[(ax, ay)] = best
            for tx, ty, enc in area_tiles(ax, ay, best):
                if enc not in known:
                    if not free:
                        raise SystemExit('too many different tiles: %s has room for %d tiles besides the reserved ones'
                                         % (args.screen, len([x for x in range(limit) if x not in reserved])))
                    t = free.pop(0); known[enc] = t; chr_[16 * t: 16 * t + 16] = enc; new_tiles += 1
                nam[ty * 32 + tx] = known[enc]
    for ay in range(8):
        for ax in range(8):
            v = 0
            for q, (dx, dy) in enumerate(((0, 0), (1, 0), (0, 1), (1, 1))):
                axx, ayy = ax * 2 + dx, ay * 2 + dy
                v |= (area_pal.get((axx, ayy), 0) & 3) << (q * 2)
            nam[0x3C0 + ay * 8 + ax] = v
    print('palettes: %s' % ' | '.join(' '.join('%02X' % c for c in pal16[i * 4:i * 4 + 4]) for i in range(4)))
    print('tiles: %d new, %d free left' % (new_tiles, len(free)))
    write_screen(rom, args.screen, bytes(nam), bytes(chr_), pal16, args.force)
    open(args.out, 'wb').write(rom)
    print('wrote', args.out)


def text_palettes(rom, key='english'):
    """the background palettes the list area uses (16x16 areas under columns c0-c1, rows r0-r1)"""
    s = SCREENS[key]; cur = read_screen(rom, key); c0, c1, r0, r1 = s['text_rect']
    return sorted({attr_pal(cur['nam'], tx, ty) for ty in range(r0, r1 + 1) for tx in range(c0, c1 + 1)})


def english_colours(rom, text=None, backdrop=None, cursor=None, title=None, log=print, check=True):
    """Set the colours of the English list in rom (bytearray), each an NES colour or None (kept):
      text      the letters of the game list: colour 3 of every background palette used under the list
      backdrop  colour 0, shared by the whole screen: what shows around the letters (the menu writes whole lines of
                tiles) and wherever the picture has colour 0
      cursor    the arrow sprite
      title     (body, highlight) of "400 IN 1" in the original background: background palette 2, colours 2 and 1
                (the original: $16 red, $20 white)"""
    s = SCREENS['english']; d = s['desc'] + 2
    pal = bytearray(rom[d:d + 32])
    done = []
    if text is not None:
        ps = text_palettes(rom)
        for p in ps: pal[p * 4 + 3] = text
        done.append('text $%02X (palette %s colour 3)' % (text, '/'.join(map(str, ps))))
    if backdrop is not None:
        pal[0] = pal[16] = backdrop
        done.append('around the text / background $%02X' % backdrop)
    if cursor is not None:
        pal[EN_CURSOR] = cursor
        done.append('cursor $%02X' % cursor)
    if title is not None:
        pal[EN_TITLE * 4 + 2], pal[EN_TITLE * 4 + 1] = title
        done.append('title $%02X, highlight $%02X' % tuple(title))
    t3 = {pal[p * 4 + 3] for p in text_palettes(rom)}
    bd = 0x0F if pal[0] in BLACKS else pal[0]
    if check and bd in {0x0F if c in BLACKS else c for c in t3}:
        raise SystemExit('the list text colour and the colour around it are both $%02X: the names would not show' % bd)
    rom[d:d + 32] = pal
    if done: log('colours: ' + ', '.join(done))
    return pal


def cmd_colours(a):
    rom = bytearray(open(a.rom, 'rb').read())
    english_colours(rom, *(parse_colour(v) if v else None for v in (a.text, a.backdrop, a.cursor)),
                    title=[parse_colour(v) for v in a.title.replace(',', ' ').split()] if a.title else None)
    open(a.out, 'wb').write(rom); print('wrote', a.out)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = ap.add_subparsers(dest='cmd', required=True)
    p = sp.add_parser('info'); p.add_argument('rom')
    p = sp.add_parser('export'); p.add_argument('rom'); p.add_argument('screen', choices=SCREENS); p.add_argument('outdir')
    p.add_argument('--guide', help='also write a copy of the picture with the list text areas in red')
    p = sp.add_parser('import'); p.add_argument('rom'); p.add_argument('screen', choices=SCREENS)
    p.add_argument('-o', '--out', required=True); p.add_argument('--nam'); p.add_argument('--chr'); p.add_argument('--pal')
    p.add_argument('--force', action='store_true', help='write even if reserved tiles change')
    p = sp.add_parser('import-png'); p.add_argument('rom'); p.add_argument('screen', choices=SCREENS); p.add_argument('image')
    p.add_argument('-o', '--out', required=True)
    p.add_argument('--bg', help='background colour 0: an NES colour ($01), "most" (the commonest colour of the picture, default) '
                                'or "text" (english: the commonest colour under the list lines)')
    p.add_argument('--force', action='store_true')
    p = sp.add_parser('colours', aliases=['colors'], help='English list colours'); p.add_argument('rom'); p.add_argument('-o', '--out', required=True)
    p.add_argument('--text', help='list letters, e.g. $30'); p.add_argument('--backdrop', help='around the letters / background colour 0')
    p.add_argument('--cursor', help='the arrow'); p.add_argument('--title', help='"400 IN 1" of the original background: body and highlight, e.g. "$16 $20"')
    a = ap.parse_args()
    if a.cmd == 'info':
        cmd_info(open(a.rom, 'rb').read())
    elif a.cmd == 'export':
        cmd_export(open(a.rom, 'rb').read(), a.screen, a.outdir, a.guide)
    elif a.cmd == 'import':
        cmd_import(a)
    elif a.cmd in ('colours', 'colors'):
        cmd_colours(a)
    else:
        cmd_import_png(a)


if __name__ == '__main__':
    main()
