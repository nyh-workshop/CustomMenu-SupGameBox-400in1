"""Run the driver on the patched ROM and compare the notes it plays with the MIDI notes (after the same mono reduction)."""
import sys, struct, os
import os; sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import menu_music as M
from sndlib import NSFPlayer
def apu_stream(rom, key, frames):
    t = M.TARGETS[key]; lo = 0x38000 if key == 'cn' else 0x68000
    hdr = b'NESM\x1A\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
    p = NSFPlayer(hdr + bytes(rom[lo:lo + 0x8000]))
    sv = 0x0081 if key == 'cn' else 0x045D; init = 0xE379 if key == 'cn' else 0xEF55
    p.mem[0x6000:0x6006] = bytes([0x8D, sv & 0xFF, sv >> 8, 0x4C, init & 0xFF, init >> 8])
    p.mem[0x6010:0x6013] = bytes([0x4C, t['tick'] & 0xFF, t['tick'] >> 8])
    return p.run(0, frames)
def expected(midi, key, opts):
    o = M.parse_opts(opts); m = M.read_midi(midi); notes = m['notes']
    mp = M.voice_map(notes, o)
    f16 = m['tempo'] / 1e6 / 4 * M.FPS; k = o['ticks16'] or max(1, round(f16 / 2.4)); T = max(15, min(255, round(16 * f16 / k) - 1))
    tf = (T + 1) / 16; tick = tf / M.FPS; end = max(n['end'] for n in notes); L = -(-(int(round(end / tick)) + 1) // k) * k
    warn = dict.fromkeys(('pulse_low', 'pulse_high', 'tri_low', 'tri_high', 'dropped_pulse', 'dropped_tri'), 0)
    runs = M.voice_runs(notes, o, mp, L, tick, warn)
    res = {key2: [(s, n) for s, ln, n in runs[key2][0] if n is not None] for key2 in ('p1', 'p2', 'tri', 'noise')}
    return res, tf, L
def period_to_midi(per, tri=False):
    import math
    f = 1789773 / ((32 if tri else 16) * (per + 1))
    return round(69 + 12 * math.log2(f / 440))
def check(rom, key, midi, opts=()):
    exp, tf, L = expected(midi, key, list(opts))
    fr = apu_stream(rom, key, int(L * tf) + 600)
    regs = {}; got = {'p1': [], 'p2': [], 'tri': [], 'noise': []}
    for fi, ws in enumerate(fr):
        for a, v in ws:
            regs[a] = v
            if a in (0x4003, 0x4007, 0x400B, 0x400F):
                ch = {0x4003: 'p1', 0x4007: 'p2', 0x400B: 'tri', 0x400F: 'noise'}[a]
                per = regs.get(a - 1, 0) | (v & 7) << 8
                got[ch].append((fi, per, regs.get(a - 3, 0)))
    ok = True
    for ch in ('p1', 'p2', 'tri', 'noise'):
        e = exp[ch]
        if ch == 'tri':   # re-issued chunks and the silencing note also write $400B: keep note starts whose $4008 != 0 and pitch changes or onset
            g = [x for x in got[ch] if x[2] != 0]
        else:
            g = got[ch]
        # match each expected onset to a write in the frame window
        gi = 0; bad = 0; dt = []
        for s, n in e:
            want = s * tf
            while gi < len(g) and g[gi][0] < want - 3: gi += 1
            if gi >= len(g): bad += 1; continue
            f, per, r0 = g[gi]
            if ch == 'noise':
                ok_p = (per & 15) == M.DRUMS.get(n['pitch'], M.DRUM_DEFAULT)[0]
            else:
                p = period_to_midi(per, ch == 'tri')
                ok_p = (p - n['pitch']) % 12 == 0
            if not ok_p or abs(f - want) > 3: bad += 1
            dt.append(f - want); gi += 1
        print('  %-5s expected onsets %4d  matched %4d  bad %d  timing error frames min %.1f max %.1f'
              % (ch, len(e), len(e) - bad, bad, min(dt) if dt else 0, max(dt) if dt else 0))
        ok &= bad == 0
    # loop restart: the first pulse-1 note must come again after the song length
    first = got['p1'][0][0] if got['p1'] else None
    again = [x[0] for x in got['p1'] if x[0] > L * tf - 5]
    print('  song length %.0f frames; first p1 note at frame %s, next start after the loop at %s' % (L * tf, first, again[:1]))
    return ok
if __name__ == '__main__':
    rom = bytearray(open(sys.argv[1], 'rb').read())
    for key, midi in (('cn', sys.argv[2]), ('ls', sys.argv[3])):
        print(key, os.path.basename(midi)); check(rom, key, midi)
