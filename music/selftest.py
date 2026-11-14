#!/usr/bin/env python3
"""Self-test of the music tools:  python3 music/selftest.py [ROM]        (make music-test)

ROM defaults to roms/<stripped 512 KiB image>.  In build/music_test/:
  1. menu_music.py build: the example MIDI songs into the Chinese menu and the language select, plus the three example
     effects (Chinese cursor, English beep, language-select chime);
  2. every note the driver then plays (run alone, as an NSF) is compared with the MIDI notes, per voice, and the loop
     must restart; the same with voices chosen by track, a chord track split over two voices (pick_p1=1, pick_p2=2),
     a transposed voice and range=drop;
  3. the real menus are booted from the patched image on the OneBus model (rombuilder/emu.py): their APU writes must
     match the driver run alone, and the cursor / beep / chime must sound;
  4. the English-list copy of the driver (rombuilder/english_sound.py, used by make rom) must play exactly what the
     Chinese menu's driver plays: 18,000 frames of APU writes compared."""
import contextlib, io, os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, 'checks')); sys.path.insert(0, os.path.join(ROOT, 'rombuilder'))
OUT = os.path.join(ROOT, 'build', 'music_test')
EX = os.path.join(HERE, 'examples')


def main():
    rom = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'roms', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin')
    os.makedirs(OUT, exist_ok=True)
    res = []
    def check(name, ok, info=''):
        res.append(ok); print('%-70s %s' % (name, 'ok' if ok else 'FAILED'))
        if info and not ok: print('    ' + info.strip().replace('\n', '\n    '))
    out = os.path.join(OUT, 'music_test.bin')
    cmd = [sys.executable, os.path.join(HERE, 'menu_music.py'), 'build', rom, '-o', out,
           '--cn-song', os.path.join(EX, 'ode_format1.mid'), '--ls-song', os.path.join(EX, 'ode_format0_90bpm.mid'), '--ls-opt', 'drums=simple',
           '--cn-cursor', os.path.join(EX, 'cursor.txt'), '--en-beep', os.path.join(EX, 'beep.txt'), '--ls-chime', os.path.join(EX, 'chime.txt'),
           '--preview', os.path.join(OUT, 'previews')]
    r = subprocess.run(cmd, capture_output=True, text=True)
    check('1. menu_music build: 2 songs + 3 effects', r.returncode == 0 and os.path.exists(out), r.stdout + r.stderr)
    if r.returncode: return finish(res)
    img = bytearray(open(out, 'rb').read())
    import verify_song as V
    for key, mid, opts in (('cn', 'ode_format1.mid', ()), ('ls', 'ode_format0_90bpm.mid', ('drums=simple',))):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf): ok = V.check(img, key, os.path.join(EX, mid), opts)
        check('2. %s song: every MIDI note played on time, loop restarts' % {'cn': 'Chinese menu', 'ls': 'language select'}[key], ok, buf.getvalue())
    # 2b. voices chosen by track, a chord track split over two voices, one voice transposed, notes out of range dropped
    import menu_music as M
    opts = ['p1=t1', 'pick_p1=1', 'p2=t1', 'pick_p2=2', 'tri=t2', 'transpose_tri=12', 'noise=t4', 'auto=0', 'drums=simple']
    for key, extra in (('cn', []), ('cn', ['range=drop', 'transpose_p2=-24'])):
        o = M.parse_opts(opts + extra); logs = []
        tracks, _ = M.convert_song(os.path.join(EX, 'ode_format1.mid'), o, 'test', logs.append)
        img2 = bytearray(open(rom, 'rb').read()); M.write_song(img2, M.TARGETS[key], tracks, o['loop'], lambda s: None)
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf): ok = V.check(img2, key, os.path.join(EX, 'ode_format1.mid'), opts + extra)
        mapped = any('pulse1=t1 pulse2=t1 triangle=t2 noise=t4' in l for l in logs)
        dropped = any('left out' in l for l in logs) if extra else True
        check('2b. tracks chosen by hand, chord split over p1/p2%s: notes as chosen' % (', range=drop' if extra else ''),
              ok and mapped and dropped, buf.getvalue() + '\n'.join(logs))
    r = subprocess.run([sys.executable, os.path.join(HERE, 'checks', 'menu_emu_check.py'), out], capture_output=True, text=True)
    o = r.stdout
    import re
    m1 = re.search(r'Chinese menu boot: (\d+) APU writes compared with the harness stream, (\d+) identical', o)
    m2 = re.search(r'Language select song: (\d+) writes compared, (\d+) identical', o)
    check('3. Chinese menu booted: its APU writes = the driver run alone', bool(m1) and m1.group(1) == m1.group(2) and int(m1.group(1)) > 100, o)
    check('3. language select booted: its song writes = the driver run alone', bool(m2) and m2.group(1) == m2.group(2) and int(m2.group(1)) > 100, o)
    check('3. Chinese cursor, English beep and language-select chime are written', 'pulse-2 writes [\'' in o and 'English beep (Down): [\'' in o, o)
    # 4. English-list relocation
    import struct
    import english_sound as E
    from sndlib import NSFPlayer
    base = bytearray(open(rom, 'rb').read()[:0x80000])
    def stream(code, init, play_seq, frames):
        hdr = b'NESM\x1a\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
        p = NSFPlayer(hdr + bytes(code) + b'\xFF' * (0x8000 - len(code)))
        p.mem[0x6000:0x6006] = bytes([0x8D, 0x81, 0x00, 0x4C, init & 0xFF, init >> 8])
        p.mem[0x6010:0x6010 + len(play_seq) + 1] = bytes(play_seq + [0x60])
        return [w for f in p.run(0, frames) for w in f]
    T = E.ENTRY
    eng = bytearray(base); E.install(eng, None, False, None, log=lambda s: None)
    a = stream(eng[0x70000:0x74000], T['sound_init'], [0x20, T['sfx_tick'] & 0xFF, T['sfx_tick'] >> 8, 0x20, T['music_tick'] & 0xFF, T['music_tick'] >> 8], 18000)
    cn = base[0x38000:0x40000]                         # Chinese block at $8000-$FFFF, driver at $E34A
    b = stream(cn, 0xE379, [0x20, 0xBA, 0xE4, 0x20, 0x99, 0xE6], 18000)
    check('4. English-list driver copy = Chinese driver: %d APU writes compared' % len(a), a == b and len(a) > 1000,
          'first difference at write %s' % next((i for i, (x, y) in enumerate(zip(a, b)) if x != y), None))
    return finish(res)


def finish(res):
    print('%d of %d passed' % (sum(res), len(res)))
    sys.exit(0 if all(res) else 1)


if __name__ == '__main__':
    main()
