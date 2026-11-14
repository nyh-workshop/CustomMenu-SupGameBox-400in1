#!/usr/bin/env python3
"""Self-test of the ROM builder:  python3 rombuilder/selftest.py [BASE]      (make rom-test, about 15 minutes)

BASE defaults to roms/<stripped 512 KiB image>.  Builds, in build/rom/selftest/:
  0. the defaults from custom/ (.bin, .nes, _unit.bin, _games.csv, _layout.txt, build log); the handheld image's checks
     (rombuilder/unit.py) and UNIT=0;
  1. the example list (rombuilder/examples/games_example.csv, the test carts), 8 MiB, every game checked on the OneBus
     model; the .nes header; make rom-verify on the result; the games read back out of the image by tools/list_games.py;
  2. six carts from a folder with --scan, 16 MiB: one page; the scan's games.csv builds the same list again; ROM-set
     names cleaned; the build log tables;
  3. 500 games (the maximum), quick check: 50 pages, games 1, 256, 257, 313, 314 and 500 start;
  4. a MIDI song, a cursor sound and a wallpaper chain into the build, with a WAV preview; list colours (colors.txt) with
     and without a wallpaper whose background is not black, read back from the screen on the OneBus model;
  5. errors that must be refused: an unsupported mapper, 501 games, names over 8 KiB, a misaligned / overlapping /
     menu-region / past-the-end address, games too big for 8 MiB (with the SIZE=16 hint);
  6. the same big games in 16 MiB: built.
"""
import os, re, shutil, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'wallpaper'))
OUT = os.path.join(ROOT, 'build', 'rom', 'selftest')
CARTS = os.path.join(HERE, 'examples', 'carts')
EXAMPLE = os.path.join(HERE, 'examples', 'games_example.csv')


def run(args):
    r = subprocess.run([sys.executable] + args, cwd=ROOT, capture_output=True, text=True)
    return r.returncode, r.stdout + r.stderr


def build(base, *extra):
    """build_rom.py without the custom/ folder: the example list from examples/carts/ unless a list is given"""
    extra = list(extra)
    if '--csv' not in extra and '--scan' not in extra: extra += ['--csv', EXAMPLE]
    if '--games' not in extra: extra += ['--games', CARTS]
    return run([os.path.join(HERE, 'build_rom.py'), '--base', base, '--custom', ''] + extra)


def names_of(csvpath):
    import csv
    lines = [l for l in open(csvpath, newline='') if l.strip() and not l.startswith('#')]
    return [r['name'] for r in csv.DictReader(lines)]


def main():
    base = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        ROOT, 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin'))
    shutil.rmtree(OUT, ignore_errors=True); os.makedirs(OUT)
    results = []
    def check(name, ok, out=''):
        results.append((name, ok))
        print('%-72s %s' % (name, 'ok' if ok else 'FAILED'), flush=True)
        if not ok: print('    ' + '\n    '.join(out.strip().splitlines()[-15:]))
    P = lambda *p: os.path.join(OUT, *p)

    rc, o = run([os.path.join(HERE, 'build_rom.py'), '--base', base, '--out', P('custom_8M.bin')])
    check('0. defaults: custom/ folder -> .bin, .nes, _unit.bin, _games.csv, _layout.txt, build log', rc == 0 and
          all(os.path.exists(P('custom_8M' + x)) for x in ('.bin', '.nes', '_unit.bin', '_games.csv', '_layout.txt', '_build.log')), o)
    if rc == 0:
        a_, b_ = open(P('custom_8M.bin'), 'rb').read(), open(P('custom_8M_unit.bin'), 'rb').read()
        d_ = [i for i in range(len(a_)) if a_[i] != b_[i]]
        check('0b. handheld image: 6 reset opcodes swapped (bits 4/5) at 0x7FFD9-0x7FFEA, its checks ok',
              d_ == [0x7FFD9, 0x7FFDA, 0x7FFDB, 0x7FFE0, 0x7FFE5, 0x7FFEA] and all(((a_[i] & 0xCF) | ((a_[i] >> 1) & 0x10) | ((a_[i] << 1) & 0x20)) == b_[i] for i in d_)
              and o.split('handheld image:')[1].split('outputs:')[0].count(' ok  ') == 4
              and 'FAILED' not in o.split('handheld image:')[1].split('outputs:')[0], o)
    rc, o = run([os.path.join(HERE, 'build_rom.py'), '--base', base, '--out', P('nounit_8M.bin'), '--no-unit'])
    check('0c. --no-unit (UNIT=0): no _unit.bin', rc == 0 and not os.path.exists(P('nounit_8M_unit.bin')), o)

    rc, o = build(base, '--out', P('example_8M.bin'), '--verify', 'full')
    check('1. example list, 8 MiB, every game checked', rc == 0 and 'all checks passed' in o and o.count(' OK  (') == 10, o)
    nes = open(P('example_8M.nes'), 'rb').read(); binf = open(P('example_8M.bin'), 'rb').read()
    check('1b. .nes = NES 2.0 mapper 256 header + the same image', nes[:4] == b'NES\x1a' and nes[7] & 0x0C == 0x08 and
          (nes[6] >> 4 | nes[7] & 0xF0 | (nes[8] & 0x0F) << 8) == 256 and (nes[4] | (nes[9] & 0x0F) << 8) * 0x4000 == len(binf)
          and nes[5] == 0 and nes[16:] == binf)
    rc, o = run([os.path.join(HERE, 'verify.py'), P('example_8M.bin'), '--mode', 'quick'])
    check('1c. make rom-verify: the built image re-checked from its _games.csv', rc == 0 and 'all checks passed' in o, o)
    rc, o = run([os.path.join(ROOT, 'tools', 'list_games.py'), P('example_8M.nes'), '--extract', P('extracted')])
    sys.path.insert(0, HERE); import onebus400 as O
    carts = {f: O.Nes(open(os.path.join(CARTS, f), 'rb').read(), f) for f in os.listdir(CARTS) if f.endswith('.nes')}
    got = sorted(os.listdir(P('extracted'))) if rc == 0 else []
    def same(e):
        n = O.Nes(open(P('extracted', e), 'rb').read(), e)
        return any(O.pad_pow2(c.prg, 0x4000) == n.prg and (O.pad_pow2(c.chr, 0x2000) if c.chr else b'') == n.chr and
                   (n.mapper == c.mapper) for c in carts.values())
    check('1d. tools/list_games.py: 10 entries listed, the 9 different games extracted = the carts', rc == 0 and
          '10 list entries, built multicart' in o and len(got) == 9 and all(same(e) for e in got), o + repr(got))

    six = P('six', 'games'); os.makedirs(six)
    for f in sorted(os.listdir(CARTS))[:6]: shutil.copy(os.path.join(CARTS, f), six)
    rc, o = build(base, '--scan', '--games', six, '--size', '16', '--out', P('six_16M.bin'), '--verify', 'full')
    check('2. --scan of 6 carts, 16 MiB: one page', rc == 0 and '6 game(s) on 1 page(s)' in o and 'all checks passed' in o, o)
    lst = P('six', 'games.csv')
    rc, o = build(base, '--csv', lst, '--games', six, '--out', P('six_again_8M.bin'))
    check('2a. the scan wrote six/games.csv, and building from it gives the same list', os.path.exists(lst) and rc == 0 and
          names_of(P('six_again_8M_games.csv')) == names_of(P('six_16M_games.csv')) and len(names_of(lst)) == 6, o)
    rc, o = build(base, '--scan', '--games', six, '--out', P('six_scan2_8M.bin'))
    check('2b. a second scan leaves games.csv alone and writes games_scanned.csv', rc == 0 and os.path.exists(P('six', 'games_scanned.csv')), o)
    nam = P('names', 'games'); os.makedirs(nam)
    for src, dst in (('nrom16_test.nes', 'Legend_of_Zelda,_The_(U)_(PRG1)_[!].nes'), ('nrom32_test.nes', 'Contra (USA) (Rev 1).NES'),
                     ('mmc3_64k.nes', 'Dr. Mario (Japan, USA) [b1].Nes'), ('mmc3_128k.nes', 'super_mario_bros_3_(E)_v1.1.nes')):
        shutil.copy(os.path.join(CARTS, src), os.path.join(nam, dst))
    rc, o = build(base, '--scan', '--games', nam, '--out', P('names_8M.bin'), '--verify', 'quick')
    names = names_of(P('names_8M_games.csv')) if rc == 0 else []
    check('2c. --scan: each file once (any .nes case), ROM-set labels removed', names ==
          ['CONTRA', 'DR. MARIO', 'SUPER MARIO BROS 3', 'THE LEGEND OF ZELDA'] and 'all checks passed' in o, o + repr(names))
    log = open(P('names_8M_build.log')).read() if rc == 0 else ''
    check('2d. build log: games table with vectors and OneBus registers', '| $4100 |' in log and '| reset |' in log and
          log.count('| $E010 |') == 4 and 'all checks passed' in log, log[-800:])

    carts_l = sorted(f for f in os.listdir(CARTS) if f.endswith('.nes'))
    big = P('g500.csv')
    with open(big, 'w') as f:
        f.write('name,file\n')
        for i in range(500): f.write('GAME %d,%s\n' % (i + 1, carts_l[i % len(carts_l)]))
    rc, o = build(base, '--csv', big, '--out', P('g500_8M.bin'), '--verify', 'quick')
    starts = all(re.search(r'game\s+%d .* OK ' % n, o) for n in (1, 256, 257, 313, 314, 500))
    check('3. 500 games: 50 pages read back, games 1/256/257/313/314/500 start', rc == 0 and '500 game(s) on 50 page(s)' in o
          and 'all 50 page(s) read back correctly' in o and starts and 'all checks passed' in o, o)

    mus = P('music.txt')
    open(mus, 'w').write('song = %s\noptions = drums=simple\ncursor = %s\n' % (
        os.path.join(HERE, 'examples', 'music', 'ode_to_joy.mid'), os.path.join(HERE, 'examples', 'music', 'cursor.txt')))
    rc, o = build(base, '--music', mus, '--wallpaper', 'english=' + os.path.join(HERE, 'examples', 'wallpaper', 'sky.png'),
                  '--out', P('tools_8M.bin'), '--verify', 'quick', '--wav')
    check('4. MIDI song + cursor sound + wallpaper chain into the build (+ WAV)', rc == 0 and 'song: MIDI' in o and
          'cursor: custom' in o and 'wallpaper        ' in o and 'sky.png' in o and 'identical to the driver running alone' in o
          and os.path.exists(P('tools_8M_music.wav')) and 'all checks passed' in o, o)

    # 4b. list colours: the screen on the OneBus model must show them
    from emu import OneBus
    import wallpaper as WT
    def screen(path):
        m = OneBus(open(path, 'rb').read())
        m.pc = m.read(0xFFFC) | m.read(0xFFFD) << 8
        for _ in range(300): m.run_frame()
        im = m.render(); return im, set(im.get_flattened_data() if hasattr(im, 'get_flattened_data') else im.getdata())
    ex = os.path.join(HERE, 'examples', 'wallpaper')
    rc, o = build(base, '--wallpaper', os.path.join(ex, 'blue.png'), '--colors', os.path.join(ex, 'colors.txt'), '--out', P('colours_wp.bin'))
    im, cols = screen(P('colours_wp.bin')) if rc == 0 else (None, set())
    check('4b. colours + a blue wallpaper: background $01 kept (also $3F10), text $38, cursor $2A', rc == 0 and im.getpixel((2, 2)) == WT.rgb(0x01)
          and im.getpixel((2, 200)) == WT.rgb(0x01) and WT.rgb(0x38) in cols and WT.rgb(0x2A) in cols, o)
    rc, o = build(base, '--colors', os.path.join(ex, 'colors.txt'), '--out', P('colours.bin'))
    im, cols = screen(P('colours.bin')) if rc == 0 else (None, set())
    check('4b. colours, original background: $0C around the text, text $38, cursor $2A, title $27/$30', rc == 0 and
          im.getpixel((2, 2)) == WT.rgb(0x0C) and all(WT.rgb(c) in cols for c in (0x38, 0x2A, 0x30, 0x27)) and WT.rgb(0x16) not in cols, o)
    bc = P('bad_colours.txt'); open(bc, 'w').write('text = $0F\n')
    rc, o = build(base, '--colors', bc, '--out', P('bad.bin'))
    check('4b. refused: text colour = the colour around it', rc != 0 and 'would not show' in o, o)

    bad = P('bad'); os.makedirs(bad)
    d = bytearray(open(os.path.join(CARTS, 'nrom32_test.nes'), 'rb').read()); d[6] = (d[6] & 0x0F) | 0x10
    open(os.path.join(bad, 'mmc1.nes'), 'wb').write(d); shutil.copy(os.path.join(CARTS, 'nrom32_test.nes'), bad)
    cases = [('mapper 1', 'name,file\nX,mmc1.nes\n', 'mapper 1 is not supported'),
             ('501 games', 'name,file\n' + 'X,nrom32_test.nes\n' * 501, 'at most 500'),
             ('names over 8 KiB', 'name,file\n' + ''.join('LONG NAME NUMBER %d,nrom32_test.nes\n' % i for i in range(500)), 'Shorten some names'),
             ('misaligned PRG address', 'name,file,prg_addr\nX,nrom32_test.nes,0x84000\n', 'multiple of its size'),
             ('address in the menu region', 'name,file,prg_addr\nX,nrom32_test.nes,0x40000\n', 'inside the menu region'),
             ('address past the end of 8 MiB', 'name,file,prg_addr\nX,nrom32_test.nes,0xFF0000\n', 'make rom SIZE=16'),
             ('overlapping addresses', 'name,file,prg_addr,chr_addr\nX,nrom32_test.nes,0x80000,0x84000\n', 'overlaps')]
    for name, text, want in cases:
        p = os.path.join(bad, 'case.csv'); open(p, 'w').write(text)
        rc, o = build(base, '--csv', p, '--games', bad, '--out', P('bad.bin'))
        check('5. refused: %s' % name, rc != 0 and want in o, o)
    bigd = P('big', 'games'); os.makedirs(bigd)
    d = open(os.path.join(CARTS, 'mmc3_512k.nes'), 'rb').read()
    for i in range(13):                                       # 13 different 512K + 256K games = 9984 KiB
        b = bytearray(d); b[16 + 0x1F00] = i; b[16 + 512 * 1024 + 0x3FF] = i
        open(os.path.join(bigd, 'big_%02d.nes' % i), 'wb').write(b)
    rc, o = build(base, '--scan', '--games', bigd, '--out', P('big8.bin'))
    check('5. refused at once: 9984 KiB of games in 8 MiB (hint: SIZE=16)', rc != 0 and 'do not fit the 8 MiB ROM' in o
          and 'SIZE=16' in o, o)
    rc, o = build(base, '--scan', '--games', bigd, '--size', '16', '--out', P('big16.bin'))
    check('6. the same games in 16 MiB: built, 10496 of 16384 KiB used', rc == 0 and '10496 of 16384 KiB used (64.1%)' in o, o)

    n = sum(1 for _, ok in results if ok)
    print('%d of %d passed' % (n, len(results)))
    sys.exit(0 if n == len(results) else 1)


if __name__ == '__main__':
    main()
