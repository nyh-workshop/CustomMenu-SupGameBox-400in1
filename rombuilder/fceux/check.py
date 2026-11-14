#!/usr/bin/env python3
"""Run a built multicart (.nes, mapper 256) in FCEUX itself (the headless build of rombuilder/fceux/build.sh):

  python3 rombuilder/fceux/check.py build/rom/multicart_8M.nes [build/rom/multicart_8M_games.csv]     (make rom-fceux)

For every game: boot the 400-in-1 English list, page / move to it with the pad (RIGHT = next page, DOWN), press START, let it run, then
save a screenshot and read the screen.  The builder's test carts print OK / BAD for their own bank checks, which is
read back from FCEUX's nametable.  Then power-on with A+B held (the test program).  Results: a summary and a contact
sheet <rom>_fceux.png.

Known FCEUX limit: its OneBus code ignores $4118, so CHR-RAM games (CHR in the console's internal VRAM) show garbage
in FCEUX - on the handheld and in EmuVT they work."""
import os, sys, csv, subprocess, tempfile, re
HERE = os.path.dirname(os.path.abspath(__file__))
EXE = os.path.join(HERE, 'bin', 'fceux_headless' + ('.exe' if os.name == 'nt' else ''))
BOOT = 480            # frames until the list is up (TFT set-up, then the list)
HOLD = 7              # the menu reads the pad every 7th frame: hold each button 7 frames
STEP = 21             # frames from one DOWN press to the next
PAGE = 60             # frames for a page redraw
RUN = 240             # frames a game runs before the screenshot
ROWS = 10             # games per page


def run(rom, frames, presses, shot=None, nt=None, ram=None):
    args = [EXE, rom, str(frames)]
    for a, b, btn in presses: args += ['--press', '%d-%d:%s' % (a, b, btn)]
    if ram: args += ['--ram', '%d:%s' % ram]
    if shot: args += ['--shot', '%d:%s' % (frames - 1, shot)]
    if nt: args += ['--nt', '%d:%s' % (frames - 1, nt)]
    r = subprocess.run(args, capture_output=True, text=True)
    if r.returncode: raise SystemExit('fceux_headless failed: ' + r.stderr[-500:])


def nt_text(path):
    d = open(path, 'rb').read()[:0x3C0]
    rows = [''.join(chr(b) if 0x20 <= b < 0x7F else ' ' for b in d[r * 32:r * 32 + 32]).rstrip() for r in range(30)]
    return [l for l in rows if l.strip()]


def main():
    if not os.path.exists(EXE): raise SystemExit('build FCEUX first:  sh rombuilder/fceux/build.sh')
    rom = os.path.abspath(sys.argv[1])
    gcsv = sys.argv[2] if len(sys.argv) > 2 else os.path.splitext(rom)[0] + '_games.csv'
    games = list(csv.DictReader(open(gcsv)))
    tmp = tempfile.mkdtemp(prefix='fceux_')
    from PIL import Image
    shots, ok = [], True
    run(rom, BOOT, [], os.path.join(tmp, 'list.ppm')); shots.append(('list', os.path.join(tmp, 'list.ppm')))
    print('FCEUX (%s):' % os.path.basename(rom))
    for i, g in enumerate(games):
        presses, f = [], BOOT
        pages, rows = i // ROWS, i % ROWS
        for _ in range(pages): presses.append((f, f + HOLD - 1, 'RIGHT')); f += PAGE
        for _ in range(rows): presses.append((f, f + HOLD - 1, 'DOWN')); f += STEP
        presses.append((f + 10, f + 10 + HOLD + 4, 'START')); sel = f + 9; f += RUN
        shot, nt, ram = os.path.join(tmp, 'g%d.ppm' % i), os.path.join(tmp, 'g%d.nt' % i), os.path.join(tmp, 'g%d.ram' % i)
        run(rom, f, presses, shot, nt, (sel, ram))
        r = open(ram, 'rb').read(); row = r[0x64B]                                # cursor_row when START is pressed
        picked = r[0x64D + 2 * row] | r[0x64E + 2 * row] << 8                      # the list entry shown on that row
        if picked != i:
            print('  game %3d %-18s the pad reached game %d instead' % (i + 1, g['name'], picked + 1)); ok = False; continue
        text = nt_text(nt)
        cart = any('ONEBUS BUILDER TEST CART' in l for l in text)
        if cart:
            title = text[0].strip()
            res = [' '.join(l.split()) for l in text if re.match(r'\s*(PRG BANKS|CHR BANKS|CHR RAM|WRAM)\s\s+\S', l)]
            bad = [r for r in res if not r.endswith(' OK')]
            note = ''
            if g['chr_ram'] == '1' and bad: note = '  (expected: FCEUX has no OneBus CHR-RAM)'
            elif bad: ok = False
            print('  game %3d %-18s %s%s' % (i + 1, g['name'], ', '.join(res) or 'no result lines (%s)' % title, note))
        else:
            print('  game %3d %-18s started (screenshot)' % (i + 1, g['name']))
        shots.append(('%d' % (i + 1), shot))
    run(rom, 500, [(0, 200, 'A+B')], os.path.join(tmp, 'ab.ppm'), os.path.join(tmp, 'ab.nt'))
    shots.append(('A+B', os.path.join(tmp, 'ab.ppm')))
    print('  A+B: the test program screen is in the contact sheet (last picture)')
    cols = 4; rws = (len(shots) + cols - 1) // cols
    sheet = Image.new('RGB', (256 * cols, 240 * rws))
    for k, (lbl, p) in enumerate(shots): sheet.paste(Image.open(p), ((k % cols) * 256, (k // cols) * 240))
    out = os.path.splitext(rom)[0] + '_fceux.png'
    sheet.save(out)
    print('  contact sheet:', os.path.relpath(out))
    print('  RESULT:', 'all test carts report OK' if ok else 'SOME TEST CARTS REPORT BAD')
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
