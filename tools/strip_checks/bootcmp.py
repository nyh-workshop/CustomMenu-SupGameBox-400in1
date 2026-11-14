#!/usr/bin/env python3
"""Boot comparison of the stripped images on the OneBus model (rombuilder/emu.py).    make strip-check

  python3 tools/strip_checks/bootcmp.py [--dump DUMP]      (make strip-check [DUMP=<your 512 KiB dump>])

Each image runs from its reset vector with the same button script, and every executed address (CPU path), every APU
write and every screenshot is compared:
  1. (with --dump only: the full dump is not shipped) the stripped image against the dump with only the Street
     Fighter 2010 tiles blanked (tools/strip_rom.py
     SF2010_TILES), so the screens must be equal too: language select, Chinese menu (pages 1-8 and back), English menu
     (pages 1-5, a game start) and the A+B test program;
  2. the English-menu-only image against the stripped image with the same boot patch ($FF89 -> JMP $FB7D) made in
     memory: English list (40 pages, a game start) and the A+B test program.
A run ends when a game starts (the first non-zero write to $4100: the games lie beyond these 512 KiB); the OneBus
registers at that moment must be the same.  Screenshots of the stripped image go to build/strip_checks/."""
import hashlib, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'rombuilder')); sys.path.insert(0, os.path.join(ROOT, 'tools'))
from emu import OneBus, Halt
import strip_rom as S

B = dict(A=0x80, B=0x40, SEL=0x20, START=0x10, UP=8, DOWN=4, LEFT=2, RIGHT=1)
OUT = os.path.join(ROOT, 'build', 'strip_checks')
NAME = os.path.join(ROOT, 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB')


class Launch(Exception):
    pass


def run(data, script, hold=0):
    m = OneBus(bytes(data))
    m.pc = m.read(0xFFFC) | m.read(0xFFFD) << 8
    h = hashlib.md5(); apu = hashlib.md5(); shots = []; err = None
    ow = m.write
    def w(a, v):
        if 0x4000 <= a <= 0x4013 or a == 0x4015: apu.update(bytes([a & 0xFF, v]))
        ow(a, v)
        if a == 0x4100 and v:             # a game starts: it lies outside the 512 KiB, so the run ends here
            raise Launch('game start: $4100-$410B = %s' % ' '.join('%02X' % x for x in m.r41[:0x0C]))
    m.write = w
    os_ = m.step
    def st(): h.update(m.pc.to_bytes(2, 'little')); os_()
    m.step = st
    try:
        for item in script:
            kind = item[0]
            if kind == 'wait':
                for _ in range(item[1]): m.pad = hold; m.run_frame()
            elif kind == 'press':
                for _ in range(7): m.pad = B[item[1]] | hold; m.run_frame()
                for _ in range(item[2] if len(item) > 2 else 14): m.pad = hold; m.run_frame()
            elif kind == 'shot':
                img = m.render(); shots.append((item[1], img.tobytes(), img))
    except (Halt, Launch) as e:
        err = str(e)
    return dict(pc=h.hexdigest(), apu=apu.hexdigest(), shots=shots, err=err, frames=m.frame)


EN_LIST = ([('wait', 450), ('shot', 'en_page1')] + [x for k in range(2, 41) for x in (('press', 'RIGHT', 40), ('shot', 'en_page%d' % k))]
           + [('press', 'DOWN'), ('press', 'DOWN'), ('wait', 30), ('shot', 'en_cursor'), ('press', 'START'), ('wait', 120)], 0)
TESTAPP = ([('wait', 500), ('shot', 'testapp'), ('press', 'START'), ('press', 'SEL'), ('wait', 120), ('shot', 'testapp2')], B['A'] | B['B'])
SCRIPTS_1 = {
    'langsel': ([('wait', 400), ('shot', 'langsel')], 0),
    'chinese': ([('wait', 450), ('press', 'START'), ('wait', 300), ('shot', 'cn_page1')]
                + [x for k in range(2, 9) for x in (('press', 'RIGHT', 40), ('press', 'RIGHT', 40), ('shot', 'cn_page%d' % k))]
                + [('press', 'LEFT', 40), ('press', 'LEFT', 40), ('shot', 'cn_back')], 0),
    'testapp': TESTAPP,
}


def compare(name, ref, img, script, hold, save):
    a = run(ref, script, hold); b = run(img, script, hold)
    same = [x[1] == y[1] for x, y in zip(a['shots'], b['shots'])]
    ok = a['pc'] == b['pc'] and a['apu'] == b['apu'] and all(same) and len(same) == sum(1 for s in script if s[0] == 'shot') \
        and a['err'] == b['err']
    print('  %-12s %5d frames  CPU path %s  APU %s  screens %d/%d equal  %s' % (
        name, b['frames'], 'same' if a['pc'] == b['pc'] else 'DIFF', 'same' if a['apu'] == b['apu'] else 'DIFF',
        sum(same), len(same), ('ok' if ok else 'FAILED (%s / %s)' % (a['err'], b['err'])) + (', ' + b['err'] if ok and b['err'] else '')))
    if save:
        for n, _, im in b['shots']: im.save(os.path.join(OUT, '%s.png' % n))
    return ok


def main():
    dump = sys.argv[sys.argv.index('--dump') + 1] if '--dump' in sys.argv else None
    os.makedirs(OUT, exist_ok=True)
    st = bytearray(open(NAME + '_stripped.bin', 'rb').read()); en = open(NAME + '_stripped_EnglishMenu.bin', 'rb').read()
    o, _, n = S.BOOT_PATCH
    st_en = bytearray(st); st_en[0x78000 + o - 0x8000: 0x78000 + o - 0x8000 + len(n)] = n
    res = []
    if dump:
        ref = bytearray(open(dump, 'rb').read()[:0x80000])
        for base, tiles in S.SF2010_TILES:
            for t in tiles: ref[base + 16 * t: base + 16 * t + 16] = bytes(16)
        print('1. stripped image vs the dump with only the Street Fighter 2010 tiles blanked')
        for name, (sc, hold) in SCRIPTS_1.items(): res.append(compare(name, ref, st, sc, hold, True))
        ref_en = bytearray(ref); ref_en[0x78000 + o - 0x8000: 0x78000 + o - 0x8000 + len(n)] = n
        res.append(compare('english', ref_en, st_en, *EN_LIST, True))
    else:
        print('1. stripped image vs the dump: skipped (the dump is not shipped; make strip-check DUMP=<your copy>)')
    print('2. English-menu-only image vs the stripped image with the boot patch')
    res.append(compare('english', st_en, en, *EN_LIST, False))
    res.append(compare('testapp', st_en, en, *TESTAPP, False))
    print('%d of %d comparisons equal; screenshots in %s' % (sum(res), len(res), os.path.relpath(OUT, ROOT)))
    sys.exit(0 if all(res) else 1)


if __name__ == '__main__':
    main()
