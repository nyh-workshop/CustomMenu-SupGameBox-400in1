"""Extract the Sup 400-in-1 menu music and sound effects.
usage: python extract.py ROM_512KiB.bin OUTDIR [--no-wav]
Writes nsf/, wav/, data/ and txt/ under OUTDIR."""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'music'))   # sndlib.py
from sndlib import Block, NSFPlayer, render, CHAN, BLOCKS

rom = open(sys.argv[1], 'rb').read()
out = sys.argv[2]; wav = '--no-wav' not in sys.argv
for d in ('nsf', 'wav', 'wav/sfx', 'data', 'txt'):
    os.makedirs(os.path.join(out, d), exist_ok=True)
P = lambda *p: os.path.join(out, *p)

LOOP = {'chinese': 1794, 'langsel': 585}
LOOPS = {'chinese': 2, 'langsel': 4}
summary = []
for nm in ('chinese', 'langsel'):
    B = Block(rom, nm); c = B.cfg
    nsf = B.nsf(); open(P('nsf', '400in1_%s.nsf' % nm), 'wb').write(nsf)
    # ---- song listing + raw data
    tr = B.song_tracks(0)
    lines = ['%s song 0  (song table $%04X, track records $%04X = file 0x%05X)' % (c['title'], c['song_cnt'], tr[0]['rec'], B.off(tr[0]['rec'])),
             'loop length: %d frames (%.2f s at 60.1 Hz)' % (LOOP[nm], LOOP[nm] / 60.0988), '']
    lo = B.off(c['song_cnt']); hi = lo
    for t in tr:
        ch = t['flags'] & 3
        tl, end = B.parse_track(t['ptr'], ch)
        hi = max(hi, B.off(end))
        lines.append('---- %s  slot $%02X  flags $%02X  data $%04X-$%04X  file 0x%05X-0x%05X' % (CHAN[ch], t['slot'], t['flags'], t['ptr'], end - 1, B.off(t['ptr']), B.off(end - 1)))
        lines += tl + ['']
    open(P('txt', '%s_song.txt' % nm), 'w').write('\n'.join(lines))
    open(P('data', '%s_song_0x%05X-0x%05X.bin' % (nm, lo, hi - 1)), 'wb').write(rom[lo:hi])
    summary.append((nm, 'song', lo, hi - 1))
    # ---- sfx listing + raw data
    sl = ['%s sound effects  (pointer table $%04X = file 0x%05X, %d entries)' % (c['title'], c['sfx_tbl'], B.off(c['sfx_tbl']), c['nsfx']),
          'record: enable, chan_bit, regmask, frames_per_step, stream_bytes, 4 initial register values, stream', '']
    seen = {}; s_lo = B.off(c['sfx_tbl']); s_hi = s_lo
    for i in range(c['nsfx']):
        sx = B.sfx(i)
        if sx['ptr'] == c['song_cnt']:
            sl.append('#%02d  $%04X  (points at the song table: not a sound effect)' % (i, sx['ptr'])); continue
        ch = sx['chans'][0]; s_hi = max(s_hi, min(B.off(sx['end']), B.off(c['song_cnt'])))
        over = (' TRUNCATED: stream runs %d bytes into the song table' % (sx['end'] - c['song_cnt'])) if sx['end'] > c['song_cnt'] else ''
        regs = {1: 'pulse1', 2: 'pulse2', 4: 'triangle', 8: 'noise'}.get(ch['chan_bit'], '?')
        dup = (' = same data as #%02d' % seen[sx['ptr']]) if sx['ptr'] in seen else ''
        use = (' USED: ' + c['used_sfx'][i]) if i in c['used_sfx'] else ''
        sl.append('#%02d  $%04X file 0x%05X  %-8s regmask %X  every %d frames  %d bytes  init %s  stream %s%s%s'
                  % (i, sx['ptr'], B.off(sx['ptr']), regs, ch['regmask'], ch['speed'], ch['length'],
                     ' '.join('%02X' % v for v in ch['init']), ' '.join('%02X' % v for v in ch['stream']), dup, use + over))
        seen.setdefault(sx['ptr'], i)
    open(P('txt', '%s_sfx.txt' % nm), 'w').write('\n'.join(sl))
    open(P('data', '%s_sfx_0x%05X-0x%05X.bin' % (nm, s_lo, s_hi - 1)), 'wb').write(rom[s_lo:s_hi])
    summary.append((nm, 'sfx', s_lo, s_hi - 1))
    if not wav: continue
    pl = NSFPlayer(nsf)
    fr = pl.run(0, LOOP[nm] * LOOPS[nm] + 1)
    render(fr, P('wav', '%s_song.wav' % nm), fade_frames=180)
    done = {}
    for i in range(c['nsfx']):
        sx = B.sfx(i)
        if sx['ptr'] == c['song_cnt'] or sx['ptr'] in done: continue
        done[sx['ptr']] = i
        f2 = NSFPlayer(nsf).run(1 + i, 150)
        last = max((k for k, f in enumerate(f2) if f), default=0)
        render(f2[:max(last + 45, 40)], P('wav', 'sfx', '%s_sfx%02d%s.wav' % (nm, i, '_truncated' if sx['end'] > c['song_cnt'] else '')))

# dormant older driver in bank $1C (file 0x38000-0x39FFF): never called by the menu.
# Entry points inferred from its jump table: $8003 = start sound A, $8000 = tick. Numbers 0-6 are music.
import struct
b1c = rom[0x38000:0x3A000]
hdr = b'NESM\x1A' + bytes([1, 7, 1]) + struct.pack('<HHH', 0x8000, 0x8003, 0x8000)
hdr += b'Sup 400-in-1 bank $1C (dormant)'.ljust(32, b'\0') + b'unknown'.ljust(32, b'\0') + b'unknown'.ljust(32, b'\0')
hdr += struct.pack('<H', 16639) + bytes(8) + struct.pack('<H', 19997) + bytes(6)
open(P('nsf', '400in1_bank1C_dormant.nsf'), 'wb').write(hdr + b1c)
summary.append(('bank1C', 'dormant driver + 7 songs', 0x38000, 0x39FFF))
if wav:
    os.makedirs(P('wav', 'dormant_bank1C'), exist_ok=True)
    for n in range(7):
        fr = NSFPlayer(hdr + b1c).run(n, 1800)
        render(fr, P('wav', 'dormant_bank1C', 'bank1C_song%d.wav' % n), fade_frames=180)

# the two one-shot "beeps" outside the driver
beeps = {'english_menu_beep': [(0x4015, 0x0F), (0x4004, 0xFF), (0x4005, 0xAA), (0x4006, 0x78), (0x4007, 0x00), (0x4015, 0x0F)],
         'langsel_click': [(0x4015, 0x0F), (0x4000, 0x8F), (0x4001, 0xAA), (0x4002, 0xAA), (0x4003, 0x80)]}
if wav:
    for k, w in beeps.items():
        render([w] + [[(0x4015, 0x0F)]] * 40, P('wav', 'sfx', k + '.wav'))
for s in summary: print('%-8s %-5s file 0x%05X-0x%05X (%d bytes)' % (s[0], s[1], s[2], s[3], s[3] - s[2] + 1))
