#!/usr/bin/env python3
"""The image for the real handheld: the same flash image with the menu's reset code stored with bit-swapped opcodes.

  python3 rombuilder/unit.py IMAGE.bin [OUT.bin] [--unit-dump UNIT_70000H.bin]     (make unit ROM=IMAGE.bin)

The Sup 400-in-1 starts with its opcode decoder scrambled: every opcode byte the CPU fetches is read with bits 4 and 5
swapped; operands and data are read as they are.  The reset code turns it off with `lda #$05 / sta $411C` at $FFEA, and
everything after that runs plain.  The project's dump has the swap undone ("opcode_bits45_swap" in its name), as
emulators need it, so for the handheld the reset code's opcodes are swapped back:

    reset vector $E7E0: jmp $E7E3 / jmp $E7E6 / jmp $E7E9 / jmp $FFD0 / jmp $FFD3 / jmp $FFD6 / jmp $FFD9
    $FFD9: nop / nop / lda #$D0 / sta $4134 / lda #$DC / sta $412D / lda #$81 / sta $4137 / lda #$05 / sta $411C

`4C` (jmp) and `8D` (sta) have bits 4 = 5, so they read the same both ways; the 2 nops (EA -> DA) and 4 lda# (A9 -> 99)
change: 6 bytes, CPU $FFD9-$FFEA (file 0x7FFD9-0x7FFEA of the menu region).  Compared with the handheld's own flash
(0x70000-0x7FFFF read from the unit, UNIT_SHA1), the rule applied to the original block (menu/orig/) gives it byte for
byte, and those 6 bytes are the only difference.  make_unit_image() applies the rule and checks it; check() prints it."""
import hashlib, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

MENU = 0x70000                     # file offset of the menu block (CPU $8000-$FFFF = MENU + 0x8000 ...)
ORIG = os.path.join(ROOT, 'menu', 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_70000H.bin')
UNIT_SHA1 = 'ff31d0365b46423299b5738cda0e070b9d2e3560'           # the handheld's flash 0x70000-0x7FFFF (64 KiB), as read
STA_411C = b'\x8D\x1C\x41'
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from op6502 import OPS, MODES_LEN                               # the project's table of the documented opcodes
LEN = {op: MODES_LEN[md] for op, (mn, md) in OPS.items()}


def swap45(v):
    """opcode bits 4 <-> 5 (its own inverse)"""
    return (v & 0xCF) | ((v >> 1) & 0x10) | ((v << 1) & 0x20)


def boot_range(img, menu=MENU):
    """-> [(cpu address, file offset), ...] of every opcode the CPU fetches from the reset vector up to and including
    the `sta $411C`.  The reset code is straight-line code and absolute jumps (jmp $xxxx is followed); anything else
    that leaves the straight path before $411C (jsr, rts, branches, indirect jmp) stops it with an error."""
    fo = lambda a: menu + 0x8000 + (a - 0x8000)          # the reset maps the menu block's last 32 KiB at $8000-$FFFF
    pc = img[fo(0xFFFC)] | img[fo(0xFFFD)] << 8
    out = []
    for _ in range(256):
        o = fo(pc); op = img[o]
        if op not in LEN: raise ValueError('reset code at $%04X: %02X is not a documented opcode' % (pc, op))
        out.append((pc, o))
        if img[o:o + 3] == STA_411C: return out
        if op == 0x4C: pc = img[o + 1] | img[o + 2] << 8; continue
        if OPS[op][1] == 'rel' or op in (0x20, 0x6C, 0x60, 0x40, 0x00):
            raise ValueError('reset code at $%04X leaves the straight path before the $411C write' % pc)
        pc += LEN[op]
    raise ValueError('no `sta $411C` in the first 256 instructions after reset')


def scramble(img, menu=MENU):
    """the handheld image: a copy with the reset code's opcodes swapped"""
    out = bytearray(img)
    for _, o in boot_range(img, menu): out[o] = swap45(out[o])
    return out


def boots(img, scrambled, frames=240):
    """run the image on the OneBus model from power-on -> (screen, CPU path hash, error or None)"""
    from emu import OneBus, Halt
    m = OneBus(bytes(img[:0x80000]), scrambled=scrambled)
    m.pc = m.read(0xFFFC) | m.read(0xFFFD) << 8
    h = hashlib.md5(); st = m.step
    def step(): h.update(m.pc.to_bytes(2, 'little')); st()
    m.step = step
    try:
        for _ in range(frames): m.run_frame()
    except Halt as e:
        return None, h.hexdigest(), str(e)
    return m.render().tobytes(), h.hexdigest(), None


def make_unit_image(img, unit_dump=None, model=True):
    """-> (handheld image, report).  img = the plain image (emulators); the menu region at 0x00000-0x7FFFF."""
    rng = boot_range(img)
    unit = scramble(img)
    checks = []
    def chk(name, ok, detail=''): checks.append((name, bool(ok), detail))
    # 1. the rule applied to the original block gives the handheld's own flash (by SHA-1, or byte for byte)
    orig = open(ORIG, 'rb').read()
    ref = bytearray(b'\xFF' * MENU) + bytearray(orig)
    ref_unit = scramble(ref)[MENU:MENU + 0x10000]
    if unit_dump:
        ud = open(unit_dump, 'rb').read()[:0x10000]
        diff = [i for i in range(0x10000) if ud[i] != orig[i]]
        chk('rule reproduces the unit\'s flash', bytes(ref_unit) == ud, 'original block + swap = %s, all 65536 bytes %s'
            % (os.path.basename(unit_dump), 'identical' if bytes(ref_unit) == ud else 'NOT identical'))
        chk('only reset-code opcodes differ', {MENU + i for i in diff} == {o for _, o in boot_range(ref) if swap45(ref[o]) != ref[o]},
            '%d bytes differ between the unit\'s flash and the original block, all of them opcodes in $FFD9-$FFEA' % len(diff))
    else:
        chk('rule reproduces the unit\'s flash', hashlib.sha1(ref_unit).hexdigest() == UNIT_SHA1,
            'original block (menu/orig/) + swap: SHA-1 %s = the 64 KiB read from the handheld' % UNIT_SHA1[:12])
    # 2. this image: its reset code is the original one, so its swapped bytes must be the unit's
    same_plain = all(img[o:o + LEN[img[o]]] == ref[o:o + LEN[ref[o]]] for _, o in rng)
    same_unit = all(unit[o:o + LEN[img[o]]] == ref_unit[o - MENU:o - MENU + LEN[img[o]]] for _, o in rng)
    chk('reset code = the handheld\'s', same_plain and same_unit, 'the %d opcodes from the reset vector to sta $411C equal the '
        'original, and stored swapped they equal the unit\'s bytes' % len(rng) if same_plain and same_unit else
        'the reset code of this image differs from the original (own boot code?): the rule was applied, not compared')
    # 3. only those opcodes differ from the plain image
    d = [i for i in range(len(img)) if unit[i] != img[i]]
    sw = [o for _, o in rng if swap45(img[o]) != img[o]]
    chk('only the swapped opcodes differ', d == sw, '%d bytes differ from the emulator image (file %s)' % (
        len(d), ', '.join('0x%05X' % o for o in d)))
    # 4. the model: a scrambled start runs the handheld image exactly like an emulator runs the plain one
    if model:
        a, b, c = boots(unit, True), boots(img, False), boots(unit, False)
        chk('model: power-on', a[2] is None and a[0] == b[0] and a[1] == b[1] and c[2] is not None,
            'handheld image, scrambled start: %s; the same image on a plain start (an emulator): %s' % (
                'the same CPU path and screen as the emulator image after 240 frames' if a[0] == b[0] and a[1] == b[1] else 'DIFFERENT',
                'stops at once (%s)' % c[2] if c[2] else 'runs (unexpected)'))
    rows = [('$%04X' % pc, '0x%05X' % o, ' '.join('%02X' % x for x in img[o:o + LEN[img[o]]]),
             ' '.join('%02X' % x for x in unit[o:o + LEN[img[o]]]), 'swapped' if unit[o] != img[o] else 'same (bits 4 = 5)')
            for pc, o in rng]
    return bytes(unit), dict(count=len(rng), changed=len(sw), checks=checks, rows=rows, ok=all(c[1] for c in checks))


def report(rep):
    out = ['handheld image: %d opcodes from the reset vector to sta $411C, %d stored with bits 4/5 swapped' % (rep['count'], rep['changed'])]
    for name, ok, detail in rep['checks']:
        out.append('  %-36s %s  %s' % (name, 'ok' if ok else 'FAILED', detail))
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    ud = sys.argv[sys.argv.index('--unit-dump') + 1] if '--unit-dump' in sys.argv else None
    if ud in args: args.remove(ud)
    if not args: raise SystemExit(__doc__)
    src = args[0]; out = args[1] if len(args) > 1 else os.path.splitext(src)[0] + '_unit.bin'
    img = open(src, 'rb').read()
    unit, rep = make_unit_image(img, ud)
    for l in report(rep): print(l)
    print('  %-8s %-9s %-11s %-11s' % ('CPU', 'file', 'emulator', 'handheld'))
    for r in rep['rows']: print('  %-8s %-9s %-11s %-11s %s' % r)
    if os.path.abspath(out) == os.path.abspath(src): raise SystemExit('OUT may not be the input')
    open(out, 'wb').write(unit)
    print('wrote %s' % out)
    sys.exit(0 if rep['ok'] else 1)


if __name__ == '__main__':
    main()
