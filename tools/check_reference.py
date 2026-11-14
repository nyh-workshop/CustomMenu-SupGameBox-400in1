#!/usr/bin/env python3
"""Compile check of the readable C in reference/ (make reference-check).

With cc65 (CC65=/path/to/cc65/bin or cc65 on PATH): cc65 -t none -O --cpu 6502 for every file, the same check as the
500-in-1 project's `make menucheck`.  Without it: the host C compiler (cc / gcc / clang) with -std=c99 -fsyntax-only.
The reference C documents the code; it is not compiled into the ROM and does not rebuild the bytes."""
import glob, os, shutil, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
REF = os.path.join(ROOT, 'reference')


def main():
    files = sorted(glob.glob(os.path.join(REF, '*.c')) + glob.glob(os.path.join(REF, '*', '*.c')))
    d = os.environ.get('CC65', '').strip()
    cc65 = os.path.join(d, 'cc65') if d and os.path.isfile(os.path.join(d, 'cc65')) else shutil.which('cc65')
    out = os.path.join(ROOT, 'build', 'reference'); os.makedirs(out, exist_ok=True)
    host = next((shutil.which(c) for c in ('cc', 'gcc', 'clang') if shutil.which(c)), None)
    if not cc65 and not host: raise SystemExit('no C compiler found (cc65, cc, gcc or clang)')
    print('compiler: %s' % (cc65 + ' (cc65 -t none -O --cpu 6502)' if cc65 else host + ' (-std=c99 -fsyntax-only; cc65 not found)'))
    bad = 0
    for f in files:
        inc = ['-I', os.path.join(REF, 'menu')]
        if cc65:
            cmd = [cc65, '-t', 'none', '-O', '--cpu', '6502'] + inc + ['-o', os.path.join(out, os.path.basename(f)[:-2] + '.s'), f]
        else:
            cmd = [host, '-std=c99', '-fsyntax-only', '-Wall'] + inc + [f]
        r = subprocess.run(cmd, capture_output=True, text=True)
        msg = (r.stdout + r.stderr).strip()
        nwarn = msg.lower().count('warning')
        print('  %-28s %s%s' % (os.path.relpath(f, ROOT), 'ok' if r.returncode == 0 else 'ERROR', (' (%d warnings)' % nwarn) if nwarn else ''))
        if r.returncode:
            bad += 1; print('    ' + msg.replace('\n', '\n    ')[:2000])
    print('%d of %d files compile' % (len(files) - bad, len(files)))
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
