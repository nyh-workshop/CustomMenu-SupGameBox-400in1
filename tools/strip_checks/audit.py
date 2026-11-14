#!/usr/bin/env python3
"""Content audit of the two stripped images.        make strip-audit [SF2010=sf2010_chr.bin]

  python3 tools/strip_checks/audit.py [--sf2010 FILE] [--dump DUMP]

  1. Capcom sound bank: bank $1C (0x38000-0x39FFF) is all $FF; the engine's entry (JMP $806C / JMP $803A) occurs
     nowhere; no 16-byte piece of the original bank $1C (with at least 4 different bytes; taken from menu_cn/orig/, or
     from --dump) occurs anywhere.
  2. Street Fighter 2010 (needs its CHR, e.g. the fragment used to find the tiles; not shipped): every 8x8 tile of
     both images is looked up among all 16-byte windows of that CHR (every byte offset), and among its tiles flipped
     and recoloured. Only pictures count: 3+ colours, or 8+ pixels of the second colour that are not one straight line
     (single dots, lines and solid tiles occur in every game).
  3. Keep map: no byte outside tools/strip_rom.py's keep map is not $FF; in bank $34 only the 95 tiles the test program
     shows are left; every byte equals the original, $FF, $00 (blanked tiles) or the boot patch.  The original: the
     orig/ files of the five source blocks (the code banks), or all 512 KiB with --dump.
  4. Only two stripped images in roms/."""
import argparse, collections, glob, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import strip_rom as S
NAME = os.path.join(ROOT, 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB')


def px(t): return [[((t[y] >> (7 - x)) & 1) | (((t[y + 8] >> (7 - x)) & 1) << 1) for x in range(8)] for y in range(8)]


def picture(t):
    p = px(t); cs = collections.Counter(c for r in p for c in r)
    if len(cs) >= 3: return True
    if len(cs) < 2: return False
    rows = sum(1 for r in p if len(set(r)) > 1); cols = sum(1 for x in range(8) if len({p[y][x] for y in range(8)}) > 1)
    return min(cs.values()) >= 8 and rows >= 2 and cols >= 2


def shape(t):
    p = px(t); outs = []
    for g in (p, [r[::-1] for r in p], p[::-1], [r[::-1] for r in p[::-1]]):
        m = {}; outs.append(tuple(m.setdefault(c, len(m)) for r in g for c in r))
    return min(outs)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--sf2010', help='Street Fighter 2010 CHR (raw or .nes)')
    ap.add_argument('--dump', help='your 512 KiB dump (not shipped)')
    a = ap.parse_args()
    known = bytearray(0x80000)                       # 1 where the original byte is known
    if a.dump:
        full = bytearray(open(a.dump, 'rb').read()[:0x80000]); known[:] = b'\x01' * 0x80000
    else:
        import build_blocks as BB
        full = bytearray(0x80000)
        for folder, _, _, orig, off, size, _ in BB.BLOCKS.values():
            full[off:off + size] = open(os.path.join(ROOT, folder, 'orig', orig), 'rb').read()[:size]
            known[off:off + size] = b'\x01' * size
    ims = {'stripped': open(NAME + '_stripped.bin', 'rb').read(), 'EnglishMenu': open(NAME + '_stripped_EnglishMenu.bin', 'rb').read()}
    ok = []
    def check(name, good, info=''):
        ok.append(good); print('%-100s %s%s' % (name, 'ok' if good else 'FAILED', ('  ' + info) if info else ''))
    cap = bytes(full[0x38000:0x3A000])
    pieces = {cap[o:o + 16] for o in range(0x2000 - 15) if len(set(cap[o:o + 16])) >= 4}
    for n, d in ims.items():
        check('%s: bank $1C (0x38000-0x39FFF) all $FF' % n, all(b == 0xFF for b in d[0x38000:0x3A000]))
        sig = [o for o in range(len(d) - 2) if d[o:o + 3] in (b'\x4C\x6C\x80', b'\x4C\x3A\x80')]
        check('%s: Capcom engine entry (JMP $806C / JMP $803A) nowhere' % n, not sig, ' '.join('0x%05X' % o for o in sig[:5]))
        hits = [o for o in range(len(d) - 15) if d[o:o + 16] in pieces]
        check('%s: no 16-byte piece of the old bank $1C anywhere' % n, not hits, ' '.join('0x%05X' % o for o in hits[:5]))
    if a.sf2010:
        sf = open(a.sf2010, 'rb').read()
        if sf[:4] == b'NES\x1a': sf = sf[16 + (512 if sf[6] & 4 else 0) + sf[4] * 0x4000:]
        elif len(sf) % 1024 == 16: sf = sf[16:]
        win = {}
        for o in range(len(sf) - 15): win.setdefault(sf[o:o + 16], o)
        shapes = {}
        for o in range(0, len(sf) - 15, 16):
            if len({c for r in px(sf[o:o + 16]) for c in r}) >= 3: shapes.setdefault(shape(sf[o:o + 16]), o)
        for n, d in ims.items():
            ex = [(o, win[d[o:o + 16]]) for o in range(0, 0x80000, 16) if d[o:o + 16] in win and picture(d[o:o + 16])]
            sh = [(o, shapes[shape(d[o:o + 16])]) for o in range(0, 0x80000, 16)
                  if len({c for r in px(d[o:o + 16]) for c in r}) >= 3 and shape(d[o:o + 16]) in shapes and (o, None) not in ex]
            print('%s: Street Fighter 2010 pictures: %d exact, %d flipped/recoloured' % (n, len(ex), len(sh)))
            for o, so in ex + sh:
                p = px(d[o:o + 16]); cs = collections.Counter(c for r in p for c in r)
                print('    0x%05X = SF2010 CHR 0x%05X  (%d pixels not colour 0)%s' % (
                    o, so, 64 - cs.get(0, 0), '  the English font digit 0 (7x7, same as SF2010\'s 0 one row lower)' if o == 0x62220 else ''))
            check('%s: no Street Fighter 2010 picture except the font digit 0 and tiny corner pieces' % n,
                  all(o == 0x62220 or 64 - collections.Counter(c for r in px(d[o:o + 16]) for c in r).get(0, 0) <= 12 for o, _ in ex + sh))
    else:
        print('(Street Fighter 2010 check skipped: pass --sf2010 FILE / make strip-audit SF2010=FILE)')
    for n, d in ims.items():
        keep = bytearray(0x80000)
        for x0, x1, *_ in S.KEEP: keep[x0:x1] = b'\x01' * (x1 - x0)
        for t in S.TESTAPP_TILES: keep[0x68000 + 16 * t: 0x68010 + 16 * t] = b'\x01' * 16
        patch = set()
        if n == 'EnglishMenu':
            for x0, x1, *_ in S.ENGLISH_DROP: keep[x0:x1] = bytes(x1 - x0)
            for x0, x1, *_ in S.ENGLISH_KEEP_INSIDE_DROP: keep[x0:x1] = b'\x01' * (x1 - x0)
            f = 0x78000 + S.BOOT_PATCH[0] - 0x8000; patch = set(range(f, f + len(S.BOOT_PATCH[2])))
        out = [o for o in range(0x80000) if d[o] != 0xFF and not keep[o]]
        check('%s: nothing outside the keep map (bank $34: the 95 tiles of the test program only)' % n, not out,
              ' '.join('0x%05X' % o for o in out[:5]))
        other = [o for o in range(0x80000) if known[o] and not (d[o] in (full[o], 0xFF, 0x00) or o in patch)]
        check('%s: every byte%s = the original, $FF, $00 (blanked tile)%s' % (n, '' if a.dump else ' of the code banks',
              ' or the boot patch' if patch else ''), not other)
    bins = sorted(os.path.basename(p) for p in glob.glob(os.path.join(ROOT, 'roms', '*stripped*.bin')))
    check('roms/: exactly two stripped images (%s)' % ', '.join(b.replace('romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB', '…') for b in bins),
          len(bins) == 2)
    print('%d of %d passed' % (sum(ok), len(ok)))
    sys.exit(0 if all(ok) else 1)


if __name__ == '__main__':
    main()
