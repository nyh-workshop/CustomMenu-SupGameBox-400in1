#!/usr/bin/env python3
"""Compare the dormant sound bank of the 400-in-1 (bank $1C, file 0x38000) with the Capcom sound engine in other ROMs.

  python3 tools/capcom_compare.py [--dump DUMP] GAME.nes [MORE.nes ...]   (make capcom-compare ROMS="a.nes b.nes")

Bank $1C is gone from the stripped images; it is read from menu_cn/orig/ (the original 0x30000-0x3FFFF, kept for the
byte-identical rebuild of the Chinese menu) or from your 512 KiB dump (--dump).

Bank $1C holds Capcom's NES sound engine (the variant that starts JMP $806C / JMP $80FE, used by Mega Man 3-6, Mighty
Final Fight, Darkwing Duck, TaleSpin, The Little Mermaid, Gargoyle's Quest II, Destiny of an Emperor II, Rockboard)
with one game's sound list and songs.  For every 8 KiB bank of each ROM that starts like the engine, this prints:
  * how many bytes of the engine code ($8000 up to the sound list) are the same as in bank $1C;
  * its sound count and whether its sound list / instrument table are the same;
  * for each of the 7 complete songs of bank $1C, whether that song's channel data occur anywhere in the ROM.
Identical song data in a ROM means the songs came from that game."""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ORIG = os.path.join(HERE, '..', 'menu_cn', 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_30000H.bin')
SIG = (b'\x4C\x6C\x80', b'\x4C\x3A\x80')


def load_prg(path):
    d = open(path, 'rb').read()
    if d[:4] == b'NES\x1a':
        prg = d[16 + (512 if d[6] & 4 else 0):][:d[4] * 0x4000]
        return prg
    return d


def song_channels(bank, sid):
    """(start, end) of each channel's data for sound sid of a bank mapped at $8000 (ends at the next pointer)"""
    hi, lo = bank[0xA43 + 2 * sid], bank[0xA44 + 2 * sid]
    p = (hi << 8 | lo) - 0x8000
    if not 0 <= p < 0x2000 - 9 or bank[p] != 0: return None
    return [((bank[p + 1 + 2 * c] << 8 | bank[p + 2 + 2 * c]) - 0x8000) for c in range(4)]


def main():
    args = sys.argv[1:]
    if '--dump' in args:
        i = args.index('--dump'); ref = open(args[i + 1], 'rb').read()[0x38000:0x3A000]; del args[i:i + 2]
    else:
        ref = open(ORIG, 'rb').read()[0x8000:0xA000]
    if not args: raise SystemExit(__doc__)
    sys.argv[1:] = args
    code_end = 0xA40                                    # the sound count byte; the engine code and tables come before
    songs = []
    for sid in range(7):
        ch = song_channels(ref, sid)
        ends = sorted(set(ch + [song_channels(ref, sid + 1)[0] if sid < 6 else 0x1FAE]))
        pieces = []
        for c in ch:
            nxt = min(e for e in ends if e > c)
            pieces.append(bytes(ref[c:min(nxt, c + 64)]))     # the first 64 bytes of each channel are a good fingerprint
        songs.append(pieces)
    for path in sys.argv[1:]:
        prg = load_prg(path)
        print('%s: %d KiB PRG' % (os.path.basename(path), len(prg) // 1024))
        found = False
        for b in range(0, len(prg), 0x2000):
            bank = prg[b:b + 0x2000]
            if bank[:3] not in SIG: continue
            found = True
            same = sum(1 for i in range(code_end) if bank[i] == ref[i])
            print('  bank at 0x%05X starts %s: engine code %d of %d bytes the same as bank $1C (%.0f%%); sound count %d '
                  '(bank $1C: %d); sound list %s' % (
                      b, bank[:3].hex(' '), same, code_end, 100 * same / code_end, bank[0xA40], ref[0xA40],
                      'IDENTICAL' if bank[0xA40:0xA40 + 3 + 2 * ref[0xA40]] == ref[0xA40:0xA40 + 3 + 2 * ref[0xA40]] else 'different'))
        if not found: print('  no bank starts like the Capcom engine (4C 6C 80 / 4C 3A 80)')
        for i, pieces in enumerate(songs):
            hits = [prg.find(p) for p in pieces]
            n = sum(1 for h in hits if h >= 0)
            print('  song %d of bank $1C: %d of 4 channels found%s' % (
                i, n, (' at ' + ', '.join('0x%05X' % h for h in hits if h >= 0)) if n else ''))


if __name__ == '__main__':
    main()
