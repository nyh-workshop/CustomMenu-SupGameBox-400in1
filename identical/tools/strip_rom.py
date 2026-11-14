#!/usr/bin/env python3
"""Fill everything in the Sup 400-in-1 512 KiB dump that the menus, the TFT/boot code and the test app do not use with $FF,
and blank the Street Fighter 2010 tiles of the menu backgrounds ($00: they show the black backdrop).

  python3 strip_rom.py IN_512KiB.bin OUT.bin                  both menus (language select, Chinese, English)
  python3 strip_rom.py --english-menu IN_512KiB.bin OUT.bin   English menu only: boots straight to the English list;
                                                                no Chinese menu, no language select
  python3 strip_rom.py --check [DUMP]                         make both again (from DUMP, else from the shipped stripped
                                                                image) and compare with roms/ (make base-check)
usage: python strip_rom.py [--english-menu] IN_512KiB.bin OUT.bin  |  --check [DUMP]"""
import os, sys

# (start, end_exclusive, what, why it is kept)
KEEP = [
    (0x00000, 0x29000, 'Chinese menu CHR', '40 list pages x 4 KiB (page n BG = 1K banks n*4..n*4+3), sprites $A0-$A3, '
                                           'static sprite/screen banks $0A-$0D, $7E-$81, $84-$87'),
    (0x2A000, 0x2C000, 'TFT bank $15', 'panel detection and init for every panel type (only one type runs in FCEUX)'),
    (0x30000, 0x38000, 'Chinese menu data, banks $18-$1B', 'paged at $8000 ($4107 = $38-$3B): list pages, screen records, ASCII list'),
    (0x3A000, 0x40000, 'Chinese menu banks $1D-$1F', 'data at $A000, code at $C000/$E000, sound driver and song, vectors'),
    (0x62000, 0x64000, 'English menu CHR, bank $31', '$2018=$10/$201A=$8E can reach 0x62000-0x63FFF (traced: 0x62000-0x62FFF)'),
    (0x66000, 0x68000, 'bank $33', 'boot stage 2 code at $A000 + language-select CHR (1K banks $198-$19F)'),
    (0x6A000, 0x70000, 'banks $35-$37', 'language select, Aaronix test app (code, data, ROM-test source bank $36)'),
    (0x78000, 0x80000, 'English menu, banks $3C-$3F', 'names, launch tables, list code, boot/reset/NMI, vectors'),
]
# Bank $34 (0x68000-0x69FFF) is never read as PRG; it is the Aaronix test app's CHR (1K banks $1A0-$1A7 with $2018=$10,
# $201A=$A6: background and 8x8 sprites both from 0x68000-0x68FFF).  Only the tiles the test app can show are kept
# (16 bytes each, tile n at 0x68000 + 16n); 0x69000-0x69FFF and every other tile are filled.  Found by running the test
# app on the OneBus model (all buttons on both pads, fast A/B presses, the sound test, the AARONIX sprite animation,
# and the RAM / VRAM error screens forced) plus the code: BCD press counts can show any digit, so $00-$09 are all kept.
TESTAPP_TILES = sorted(
    list(range(0x00, 0x0F)) +              # 0-9 digits (counts, sprite test rows, sound step, error sprites), A-E
    [0x11, 0x12, 0x15, 0x16, 0x17, 0x18, 0x1B, 0x1C, 0x1D, 0x1F, 0x21] +   # H I L M N O R S T V X (strings, buttons)
    [0x24] +                               # '-' (CHANNEL-n)
    [0x30, 0x31, 0x32, 0x33, 0x35, 0x36] + # space / screen fill, pad-bit sprites 0/1 (pad 1) and 2/3 (pad 2), dash line, bar sprite
    [0x50, 0x51, 0x52, 0x53] +             # highlighted O / S / A / B (button pressed)
    list(range(0x60, 0x70)) +              # the colour bar 0-7 ($21A0-$21BF, 4 tiles per colour)
    [0xD0, 0xD1, 0xD2, 0xD3] +             # the round button sprite
    list(range(0xDA, 0x100)))              # AARONIX animation sprites ($07B1 counts $DA-$EC, $07B5 counts $ED-$FF)
TESTAPP_CHR = 0x68000

# Street Fighter 2010 graphics in the menu backgrounds.  These tiles are byte-for-byte the same as 16-byte tiles of
# Street Fighter 2010's CHR (all from its 2 KiB page at CHR 0x1E000-0x1E7FF, the starfield / planet background); they
# are blanked with $00 (all pixels colour 0 = the black backdrop; tile n of a 4 KiB pattern table at base + 16n).
SF2010_TILES = (
    [(page * 0x1000, [0x01] + [0x1D] + list(range(0x32, 0x40))) for page in range(40)] +   # the star tiles of every Chinese list page (same tiles in all 40)
    [(0x28000, list(range(0x41, 0x6E)) + list(range(0x72, 0x76)))] +   # the spare copy of the English background in the Chinese sprite page
    [(0x62000, list(range(0x41, 0x72)))] +   # the English list background
    [(0x67000, list(range(0x01, 0x68)))])    # the language-select background

# Filled (for the report): 0x29000-0x29FFF unused CHR; 0x2C000-0x2FFFF GOBLET TOWER PRG;
# 0x38000-0x39FFF bank $1C: Capcom's sound engine and Mighty Final Fight's sound list and songs (never called; menu_music
# still writes new Chinese-menu songs here);
# 0x40000-0x5FFFF MARIO 3 CHR; 0x60000-0x61FFF never accessed; 0x64000-0x65FFF SPIDER MAN CHR; 0x70000-0x77FFF SPIDER MAN PRG.


def keep_ranges(keep_dormant=True):
    return sorted(KEEP)


# English menu only (--english-menu, `make EnglishMenu`): the boot stub jumps straight to the English list (the same patch
# the ROM builder makes), so the language select and the Chinese menu can never run.  Their CHR and the Chinese menu's
# code and data are filled too; only the sound driver block of the Chinese menu stays, because the ROM builder copies it
# (rombuilder/english_sound.py) to give the English list its music.
BOOT_PATCH = (0xFF89, bytes.fromhex('A2348E0741'), bytes.fromhex('4C7DFB'))   # ldx #$34 / stx $4107 -> jmp $FB7D
ENGLISH_DROP = [
    (0x00000, 0x29000, 'Chinese menu CHR', '40 list pages, sprites, screen banks'),
    (0x30000, 0x40000, 'Chinese menu banks $18-$1F', 'list data, code, vectors'),
    (0x67000, 0x68000, 'language-select CHR', 'background, Chinese / English labels'),
]
ENGLISH_KEEP_INSIDE_DROP = [
    (0x3E34A, 0x3F4B2, 'Chinese menu sound driver, its song and effects', 'copied by the ROM builder for the English list'),
]


def strip(data, keep_dormant=True, english_only=False):
    if len(data) < 0x80000:
        raise SystemExit('expected the 512 KiB dump')
    out = bytearray(b'\xFF' * 0x80000)
    for a, b, _, _ in keep_ranges(keep_dormant):
        out[a:b] = data[a:b]
    for t in TESTAPP_TILES:
        a = TESTAPP_CHR + 16 * t
        out[a:a + 16] = data[a:a + 16]
    for base, tiles in SF2010_TILES:
        for t in tiles:
            out[base + 16 * t:base + 16 * t + 16] = bytes(16)
    if english_only:
        for a, b, _, _ in ENGLISH_DROP:
            out[a:b] = b'\xFF' * (b - a)
        for a, b, _, _ in ENGLISH_KEEP_INSIDE_DROP:
            out[a:b] = data[a:b]
        f = 0x78000 + BOOT_PATCH[0] - 0x8000
        if bytes(out[f:f + len(BOOT_PATCH[2])]) != BOOT_PATCH[2]:          # not patched yet
            assert bytes(out[f:f + len(BOOT_PATCH[1])]) == BOOT_PATCH[1], 'boot stub is not the original'
            out[f:f + len(BOOT_PATCH[2])] = BOOT_PATCH[2]
    return out


DUMP_SHA1 = 'ecb67c77a8aa572bbe47d086c73a8557778fdd99'
ROMS = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'roms')
NAME = 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB'


def check(dump=None):
    """make base-check: make both images again and compare them with the shipped ones.  From your 512 KiB dump when
    given (the real test), otherwise from the shipped stripped image (stripping is idempotent: the same keep map, tiles
    and patch give the same bytes)."""
    import hashlib
    st = os.path.join(ROMS, NAME + '_stripped.bin'); en = os.path.join(ROMS, NAME + '_stripped_EnglishMenu.bin')
    if dump:
        src = open(dump, 'rb').read()[:0x80000]
        h = hashlib.sha1(src).hexdigest()
        print('source: %s (sha1 %s%s)' % (dump, h, ', the original dump' if h == DUMP_SHA1 else ', NOT the original dump ' + DUMP_SHA1[:8]))
    else:
        src = open(st, 'rb').read()
        print('source: the shipped stripped image (no dump given: DUMP=<your 512 KiB dump> for the full test)')
    ok = True
    for name, path, eng in (('stripped', st, False), ('English menu only', en, True)):
        made = bytes(strip(src, english_only=eng)); ship = open(path, 'rb').read()
        same = made == ship
        ok &= same
        print('%-18s %s: %s' % (name, os.path.basename(path), 'identical (%d bytes)' % len(made) if same else
                                'DIFFERENT at 0x%05X' % next(i for i, (x, y) in enumerate(zip(made, ship)) if x != y)))
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    if '--check' in sys.argv:
        rest = [a for a in sys.argv[1:] if not a.startswith('--')]
        check(rest[0] if rest else None)
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if len(args) != 2:
        raise SystemExit(__doc__)
    src = open(args[0], 'rb').read()
    eng = '--english-menu' in sys.argv
    out = strip(src, english_only=eng)
    open(args[1], 'wb').write(out)
    used = sum(1 for x in out if x != 0xFF)
    print('%s: %d bytes are not $FF (%.1f KiB) -> %s' % ('English menu only' if eng else 'both menus', used, used / 1024, args[1]))
