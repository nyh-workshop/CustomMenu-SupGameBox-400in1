#!/usr/bin/env python3
"""Assemble the 400-in-1 menu region from source and compare it byte for byte with the original.

  python3 tools/build_blocks.py [BLOCK ...] [--rom DUMP] [--asm auto|ca65|check|both] [--image] [--custom [--out FILE]]

BLOCK: menu, menu_cn, testapp, boot, tft (default: all five).  The source folders are menu/, menu_cn/, TestApp/ and
tft_driver/ (two banks).  Each block is built

  * with ca65 + ld65 (cc65), when they are found: $CC65/ca65 or ca65 on PATH;
  * with tools/asmcheck.py, a strict stand-in that reads the same sources and linker configs by the same rules
    (always run, so the check also works where cc65 is not installed).

--asm auto  (default) both when cc65 is found, else asmcheck only;  ca65 / check: only that one;  both: both, required.
Each result must equal the block's orig/ file: those are the original bytes of the dump, each pinned by its SHA-1
(ORIG_SHA1).  When both assemblers ran, their outputs must also equal each other.  With --rom (your 512 KiB dump,
sha1 ecb67c77...) the orig/ files are also compared with it.

--image   with --rom: put the five blocks into a copy of the dump and compare all 512 KiB.  Without: put them into the
          stripped image (roms/..._stripped.bin), strip that again (tools/strip_rom.py) and compare it with the stripped
          image: every byte the stripped image keeps in those blocks must come out of the sources.
          -> build/blocks/menu_region_512KiB.bin
--custom  your own version: no match check, only a list of the blocks that differ; the five blocks are written into a
          copy of --rom, by default the stripped image (stripped again afterwards, so it stays a stripped image):
          build/custom/<name>_custom.bin, or --out FILE.  The input is never written.
"""
import argparse, hashlib, os, shutil, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import asmcheck

DUMP_NAME = 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin'            # not shipped (--rom)
DUMP_SHA1 = 'ecb67c77a8aa572bbe47d086c73a8557778fdd99'
STRIPPED_NAME = 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin'
ORIG_SHA1 = dict(menu='8aba3a6db103d731ed74201a3fa0696c051c6e49', menu_cn='3777027a07e5982756709ed34250bdd777c1f5c7',
                 testapp='217494c188a1c84b581c3fe55bf0806888992fa2', boot='f736cbe144ca03492416c1f413bd7f1066999cee',
                 tft='7e7ea18195f3e34c15cdbf548e530b1e40e5647a')

# name: (folder, main source, linker config, orig/ file, file offset in the 512 KiB dump, size, what)
BLOCKS = dict(
    menu=('menu', 'src/main.s', 'menu64k.cfg', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_70000H.bin',
          0x70000, 0x10000, 'English menu + boot code, banks $38-$3F (0x70000-0x77FFF as binary, 0x78000-0x7FFFF from source)'),
    menu_cn=('menu_cn', 'src/main.s', 'menu_cn64k.cfg', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_30000H.bin',
             0x30000, 0x10000, 'Chinese menu, banks $18-$1F (0x30000-0x37FFF as binary, 0x38000-0x3FFFF from source)'),
    testapp=('TestApp', 'src/main.s', 'langsel_test32k.cfg', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_68000H.bin',
             0x68000, 0x8000, 'language select + Aaronix test program, banks $34-$37'),
    boot=('tft_driver', 'src/main_b33.s', 'bank8k.cfg', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_66000H_8KiB.bin',
          0x66000, 0x2000, 'boot stage 2, bank $33'),
    tft=('tft_driver', 'src/main_tft.s', 'bank8k.cfg', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_2A000H_8KiB.bin',
         0x2A000, 0x2000, 'TFT panel driver, bank $15'),
)
BINARY_PARTS = {'menu': 0x8000, 'menu_cn': 0x8000}      # leading bytes taken by .incbin from orig/


def find_cc65():
    d = os.environ.get('CC65', '').strip()
    ext = '.exe' if os.name == 'nt' else ''
    if d and d != '/path/to/cc65/bin':
        ca, ld = os.path.join(d, 'ca65' + ext), os.path.join(d, 'ld65' + ext)
        if os.path.isfile(ca) and os.path.isfile(ld): return ca, ld
    ca, ld = shutil.which('ca65'), shutil.which('ld65')
    return (ca, ld) if ca and ld else (None, None)


def ca65_version(ca):
    try:
        r = subprocess.run([ca, '--version'], capture_output=True, text=True)
        return (r.stdout + r.stderr).strip().splitlines()[0]
    except OSError:
        return '?'


def build_ca65(ca, ld, root, name, outdir):
    d, main, cfg, orig, off, size, _ = BLOCKS[name]
    bd = os.path.join(root, d)
    obj = os.path.join(outdir, name + '.o'); out = os.path.join(outdir, name + '_ca65.bin')
    r = subprocess.run([ca, '-I', 'src', '--bin-include-dir', 'orig', '-o', obj, main], cwd=bd, capture_output=True, text=True)
    if r.returncode: return None, 'ca65 failed: ' + (r.stdout + r.stderr).strip()
    r = subprocess.run([ld, '-C', cfg, '-o', out, '-m', os.path.join(outdir, name + '.map'), '-Ln', os.path.join(outdir, name + '.lbl'), obj],
                       cwd=bd, capture_output=True, text=True)
    if r.returncode: return None, 'ld65 failed: ' + (r.stdout + r.stderr).strip()
    warn = (r.stdout + r.stderr).strip()
    return open(out, 'rb').read(), ('ld65: ' + warn) if warn else ''


def build_check(root, name, outdir):
    d, main, cfg, orig, off, size, _ = BLOCKS[name]
    bd = os.path.join(root, d)
    out = os.path.join(outdir, name + '.bin')
    cwd = os.getcwd()
    try:
        os.chdir(bd)
        asm = asmcheck.Asm(['src'], ['orig']); asm.file(main)
        img, syms = asmcheck.link(asm, cfg)
    except asmcheck.AsmError as e:
        return None, 'asmcheck: %s' % e
    finally:
        os.chdir(cwd)
    open(out, 'wb').write(img)
    return img, '%d labels' % len(asm.labels)


def first_diff(a, b, base):
    bad = [i for i in range(min(len(a), len(b))) if a[i] != b[i]]
    if len(a) != len(b): return 'size %d, expected %d' % (len(a), len(b))
    if not bad: return None
    return '%d bytes differ, first at 0x%05X (%02X, expected %02X)' % (len(bad), base + bad[0], a[bad[0]], b[bad[0]])


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('blocks', nargs='*')
    ap.add_argument('--root', default=os.path.dirname(HERE), help='folder holding menu/, menu_cn/, TestApp/, tft_driver/')
    ap.add_argument('--rom', help='your 512 KiB dump (%s, sha1 %s); default: none' % (DUMP_NAME, DUMP_SHA1[:8]))
    ap.add_argument('--asm', default='auto', choices=('auto', 'ca65', 'check', 'both'))
    ap.add_argument('--image', action='store_true')
    ap.add_argument('--custom', action='store_true')
    ap.add_argument('--out')
    ap.add_argument('--build', help='output folder (default <root>/build/blocks or build/custom)')
    a = ap.parse_args()
    root = os.path.abspath(a.root)
    names = a.blocks or list(BLOCKS)
    for n in names:
        if n not in BLOCKS: raise SystemExit('unknown block %r (blocks: %s)' % (n, ', '.join(BLOCKS)))
    def find(name):
        return next((p for p in (os.path.join(root, 'roms', name), os.path.join(root, '..', 'roms', name)) if os.path.isfile(p)), None)
    rom_path = a.rom or find(DUMP_NAME)                    # a dump left in roms/ from an older package is still used
    dump = open(rom_path, 'rb').read() if rom_path else None
    if dump is not None and len(dump) < 0x80000: raise SystemExit('%s: expected a 512 KiB image' % rom_path)
    stripped_path = find(STRIPPED_NAME)
    if dump is None and (a.image or a.custom) and not stripped_path:
        raise SystemExit('roms/%s not found (or give --rom)' % STRIPPED_NAME)
    outdir = os.path.abspath(a.build or os.path.join(root, 'build', 'custom' if a.custom else 'blocks'))
    os.makedirs(outdir, exist_ok=True)

    ca, ld = find_cc65()
    use_ca = a.asm in ('ca65', 'both') or (a.asm == 'auto' and ca)
    use_chk = a.asm in ('check', 'both', 'auto')
    if use_ca and not ca:
        raise SystemExit('ca65 / ld65 not found: put cc65 on PATH or give CC65=/path/to/cc65/bin (or use ASM=check)')
    if dump is not None:
        print('dump: %s (sha1 %s)' % (os.path.relpath(rom_path), hashlib.sha1(dump[:0x80000]).hexdigest()))
    else:
        print('reference: the orig/ file of each block (original bytes, checked by SHA-1); no dump given (--rom / ROM=)')
    print('assemblers: %s%s' % ('ca65/ld65 (%s, %s)' % (ca65_version(ca), os.path.dirname(ca)) if use_ca else '',
                                (' + ' if use_ca else '') + 'tools/asmcheck.py' if use_chk else ''))
    if a.asm == 'auto' and not ca:
        print('  (ca65 not found: only the asmcheck stand-in ran; install cc65 and run again for the real tools)')
    ok, results, src_bytes = True, {}, 0
    for n in names:
        d, main, cfg, orig, off, size, what = BLOCKS[n]
        ref_orig = open(os.path.join(root, d, 'orig', orig), 'rb').read()[:size]
        ref = ref_orig
        lines, outs = [], {}
        if hashlib.sha1(ref_orig).hexdigest() != ORIG_SHA1[n] and not a.custom:
            lines.append('orig/%s is not the original (SHA-1 differs)' % orig); ok = False
        if dump is not None and not a.custom:
            ref = dump[off:off + size]
            if ref_orig != ref:
                lines.append('orig/%s is not the dump at 0x%05X' % (orig, off)); ok = False
        for tool, fn in (('ca65', lambda: build_ca65(ca, ld, root, n, outdir)) if use_ca else (None, None),
                         ('asmcheck', lambda: build_check(root, n, outdir)) if use_chk else (None, None)):
            if not tool: continue
            img, note = fn()
            if img is None:
                lines.append('%s: %s' % (tool, note)); ok = False; continue
            outs[tool] = img
            diff = first_diff(img, ref, off)
            if a.custom:
                lines.append('%-8s %s' % (tool, 'same as the original' if diff is None else 'changed: ' + diff))
            else:
                lines.append('%-8s %s%s' % (tool, 'IDENTICAL' if diff is None else 'DIFFERENT: ' + diff, ('  (%s)' % note) if note and diff is None and tool == 'ca65' else ''))
                if diff is not None: ok = False
        if len(outs) == 2:
            same = outs['ca65'] == outs['asmcheck']
            lines.append('ca65 output %s asmcheck output' % ('==' if same else '!='))
            if not same: ok = False
        results[n] = outs.get('ca65') or outs.get('asmcheck')
        src_bytes += size - BINARY_PARTS.get(n, 0)
        print('%-8s 0x%05X-0x%05X  %s' % (n, off, off + size - 1, what))
        for l in lines: print('         ' + l)

    if a.image or a.custom:
        import strip_rom
        if a.custom: src_path = a.rom or stripped_path
        else: src_path = rom_path or stripped_path
        src = open(src_path, 'rb').read()
        restrip = os.path.abspath(src_path) == os.path.abspath(stripped_path or '')
        img = bytearray(src[:0x80000]) if not a.custom else bytearray(src)
        for n in names:
            if results.get(n) is None: continue
            _, _, _, _, off, size, _ = BLOCKS[n]
            img[off:off + size] = results[n]
        if restrip:
            img[:0x80000] = strip_rom.strip(img[:0x80000])
        if a.custom:
            out = a.out or os.path.join(outdir, os.path.splitext(os.path.basename(src_path))[0] + '_custom.bin')
            if os.path.abspath(out) == os.path.abspath(src_path): raise SystemExit('--out may not be the input itself')
            open(out, 'wb').write(img)
            print('wrote %s (%d bytes differ from %s%s)' % (os.path.relpath(out), sum(1 for x, y in zip(img, src) if x != y),
                                                         os.path.basename(src_path), ', stripped again' if restrip else ''))
        else:
            out = os.path.join(outdir, 'menu_region_512KiB.bin'); open(out, 'wb').write(img)
            if not restrip:
                same = bytes(img) == dump[:0x80000]
                print('image    0x00000-0x7FFFF  %s: %s; %d KiB of it assembled from source (%s)' % (
                    os.path.relpath(out), 'IDENTICAL to the dump (524288 bytes)' if same else 'DIFFERENT', src_bytes // 1024, ', '.join(names)))
            else:
                same = bytes(img) == src[:0x80000]
                print('image    0x00000-0x7FFFF  %s: the blocks put into the stripped image and stripped again: %s; '
                      '%d KiB assembled from source (%s)' % (os.path.relpath(out), 'IDENTICAL to roms/..._stripped.bin (524288 bytes)'
                      if same else 'DIFFERENT', src_bytes // 1024, ', '.join(names)))
            ok &= same
    if not a.custom:
        print('RESULT: %s' % ('all identical' if ok else 'NOT IDENTICAL'))
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
