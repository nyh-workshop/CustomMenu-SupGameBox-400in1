#!/usr/bin/env python3
"""Put your own MIDI songs and sound effects into the Sup 400-in-1 menus.

  python menu_music.py info SONG.mid
  python menu_music.py build ROM.bin -o NEW.bin [--cn-song A.mid] [--ls-song B.mid]
                       [--cn-cursor CURSOR.txt] [--en-beep BEEP.txt] [--ls-chime CHIME.txt]
                       [--cn-opt key=value ...] [--ls-opt key=value ...] [--preview DIR]

ROM is the 512 KiB dump or any larger image with the same first 512 KiB. The input is never modified.
See README.md for the song options and the sound-effect file format."""
import argparse, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
FPS = 60.0988

# ---------------------------------------------------------------------------- targets
# The two copies of the driver. Addresses are CPU addresses; 'map' turns a CPU address into a file offset.
TARGETS = {
    'cn': dict(name='Chinese menu', e000=0x3E000, tick=0xE34A, tick_bytes=bytes.fromhex('20BAE42099E660'),
               sfx_tick=0xE4BA, music_tick=0xE699, start_song=0xE3A1, chan_ram=0x0300,
               song_cnt=0xEFB9, song_ptr=0xEFBF, sfx_tbl=0xED69, nsfx=43, credit=0xEB27,
               hook=(0x3F726, 0xF726),                       # free $FF run in bank $1F
               ad_fix=(0xE8BF, 0xE722, 0xE8D2),              # AD handler: pla/bne/jmp, header reader, continue-reading
               # song data: bank $1C, mapped at $8000 at sound_init (reset) and in every NMI before sound_tick
               song_areas=[(0x38000, 0x3A000, 0x8000)],
               sfx_area=(0x3EDBF, 0x3EFB9), cursor_sfx=4),
    'ls': dict(name='language select', e000=0x6E000, tick=0xEF26, tick_bytes=bytes.fromhex('2096F02075F260'),
               sfx_tick=0xF096, music_tick=0xF275, start_song=0xEF7D, chan_ram=0x0400,
               song_cnt=0xFDFD, song_ptr=0xFE03, sfx_tbl=0xF945, nsfx=43, credit=0xF703,
               hook=(0x6B46A, 0xB46A),                       # free $FF run (bank $35, mapped during the language select)
               ad_fix=(0xF49B, 0xF2FE, 0xF4AE),
               # the screen maps the whole block (0x68000-0x6FFFF = $8000-$FFFF); old song area + unused $FF runs
               song_areas=[(0x6FE05, 0x6FFE0, 0x7E05 + 0x8000 - 0x7E05 + 0xFE05 - 0x8000),
                           (0x6AC26, 0x6B000, None), (0x6B843, 0x6BB7D, None), (0x6B4F7, 0x6B800, None),
                           (0x6BD0E, 0x6BFFB, None), (0x6BB7E, 0x6BD00, None), (0x68D22, 0x68DB3, None)],
               sfx_area=None, cursor_sfx=None),
}
for t in TARGETS.values():                                  # CPU address of each area start
    t['song_areas'] = [(a, b, (0x8000 + a - 0x38000) if t is TARGETS['cn'] else (0x8000 + a - 0x68000)) for a, b, _ in t['song_areas']]
CREDIT = '音效制作：王超'.encode('gb2312')
EN_BEEP = 0x7A28A          # lda #r0 sta $4004 / lda #r1 sta $4005 / lda #r2 sta $4006 / lda #r3 sta $4007 / lda #$0F sta $4015 / rts
LS_CHIME = 0x6EA80         # 24-byte routine + 8 bytes of $FF padding


def cpu_to_file(t, a):
    return t['e000'] + a - 0xE000


# ---------------------------------------------------------------------------- MIDI
def read_midi(path):
    d = open(path, 'rb').read()
    if d[:4] != b'MThd':
        raise SystemExit('%s: not a standard MIDI file' % path)
    hl = struct.unpack('>I', d[4:8])[0]
    fmt, ntr, div = struct.unpack('>HHH', d[8:14])
    p = 8 + hl; tracks = []
    while p + 8 <= len(d) and len(tracks) < ntr:
        tag, ln = d[p:p + 4], struct.unpack('>I', d[p + 4:p + 8])[0]
        if tag == b'MTrk': tracks.append(d[p + 8:p + 8 + ln])
        p += 8 + ln
    tempos = []; raw = []; names = {}; progs = {}
    for ti, tr in enumerate(tracks):
        q = 0; t = 0; run = 0
        while q < len(tr):
            v = 0
            while True:
                b = tr[q]; q += 1; v = (v << 7) | (b & 0x7F)
                if not b & 0x80: break
            t += v
            st = tr[q]
            if st & 0x80: q += 1
            else: st = run
            if st == 0xFF:
                typ = tr[q]; q += 1
                ln = 0
                while True:
                    b = tr[q]; q += 1; ln = (ln << 7) | (b & 0x7F)
                    if not b & 0x80: break
                data = tr[q:q + ln]; q += ln
                if typ == 0x51: tempos.append((t, int.from_bytes(data, 'big')))
                elif typ == 0x03: names[ti] = data.decode('latin-1', 'replace')
                elif typ == 0x2F: break
            elif st in (0xF0, 0xF7):
                ln = 0
                while True:
                    b = tr[q]; q += 1; ln = (ln << 7) | (b & 0x7F)
                    if not b & 0x80: break
                q += ln
            else:
                run = st; kind = st & 0xF0; ch = st & 15
                n = 1 if kind in (0xC0, 0xD0) else 2
                a = tr[q:q + n]; q += n
                if kind == 0x90 and a[1] > 0: raw.append((t, ti, ch, a[0], a[1]))
                elif kind == 0x80 or (kind == 0x90 and a[1] == 0): raw.append((t, ti, ch, a[0], 0))
                elif kind == 0xC0: progs.setdefault(ch, a[0])
    # ticks -> seconds
    if div & 0x8000:
        fps = 256 - (div >> 8); tps = fps * (div & 0xFF)
        sec = lambda tk: tk / tps; first_tempo = 500000
    else:
        tempos = sorted(tempos) or [(0, 500000)]
        if tempos[0][0] != 0: tempos.insert(0, (0, 500000))
        marks = []; acc = 0.0
        for i, (tk, us) in enumerate(tempos):
            if i: acc += (tk - tempos[i - 1][0]) * tempos[i - 1][1] / 1e6 / div
            marks.append((tk, acc, us))
        def sec(tk):
            m = marks[0]
            for mk in marks:
                if mk[0] <= tk: m = mk
                else: break
            return m[1] + (tk - m[0]) * m[2] / 1e6 / div
        first_tempo = tempos[0][1]
    notes = []; open_ = {}
    for t, ti, ch, k, vel in sorted(raw, key=lambda e: (e[0], e[4] != 0)):
        key = (ti, ch, k)
        if vel:
            open_.setdefault(key, []).append((t, vel))
        elif open_.get(key):
            t0, v0 = open_[key].pop(0)
            notes.append(dict(start=sec(t0), end=sec(t), track=ti, ch=ch, pitch=k, vel=v0))
    for key, lst in open_.items():
        for t0, v0 in lst:
            notes.append(dict(start=sec(t0), end=sec(t0) + 0.25, track=key[0], ch=key[1], pitch=key[2], vel=v0))
    notes.sort(key=lambda n: (n['start'], n['pitch']))
    return dict(notes=notes, tempo=first_tempo, names=names, progs=progs, ntracks=len(tracks), tempos=len(tempos))


def midi_info(path):
    m = read_midi(path); ns = m['notes']
    print('%s: %d notes, %d tracks, first tempo %.1f BPM%s, length %.1f s' % (
        path, len(ns), m['ntracks'], 60e6 / m['tempo'], ' (tempo changes: %d)' % (m['tempos'] - 1) if m['tempos'] > 1 else '',
        max((n['end'] for n in ns), default=0)))
    groups = {}
    for n in ns: groups.setdefault((n['track'], n['ch']), []).append(n)
    print(' track ch   notes  range      mean  poly  name / program')
    for (ti, ch), g in sorted(groups.items()):
        ps = [n['pitch'] for n in g]
        poly = max_polyphony(g)
        print(' t%-4d %-4d %-6d %3d-%-5d %5.1f  %-4d  %s%s' % (ti, ch + 1, len(g), min(ps), max(ps), sum(ps) / len(ps), poly,
              m['names'].get(ti, ''), ' (drums)' if ch == 9 else ' prog %d' % m['progs'][ch] if ch in m['progs'] else ''))
    am = auto_map(ns)
    tracks_of, chans_of = {}, {}
    for ti, ch in groups: tracks_of.setdefault(ch, set()).add(ti); chans_of.setdefault(ti, set()).add(ch)
    def as_src(v):          # a channel that is a track of its own is shown as that track
        if v is None: return None
        ts = tracks_of.get(v - 1, set())
        return 't%d' % min(ts) if len(ts) == 1 and len(chans_of[min(ts)]) == 1 else v
    as_track = {k: as_src(v) for k, v in am.items()}
    print('Automatic mapping: ' + ', '.join('%s = %s' % (k, as_track[k] if as_track[k] is not None else 'none') for k in ('p1', 'p2', 'tri', 'noise')))
    print('To choose yourself, edit this into the options (tN = track N as listed above; a plain number = MIDI channel 1-16;')
    print('a+b merges two sources; 0 = voice silent; auto=0 = voices you do not name stay silent):')
    print('  ' + ' '.join('%s=%s' % (k, as_track[k] if as_track[k] is not None else 0) for k in ('p1', 'p2', 'tri', 'noise')) + ' auto=0')
    many = [('t%d' % ti if len(chans_of[ti]) == 1 else 'channel %d' % (ch + 1)) for (ti, ch), g in sorted(groups.items())
            if max_polyphony(g) > 1 and ch != 9]
    if many:
        print('Chords in %s: one voice keeps one note at a time (pick_p1= / pick_p2= / pick_tri= choose which:' % ', '.join(sorted(set(many))))
        print('  high, low, first, last, or 1, 2, 3 = highest, 2nd highest, ...; -1, -2 = lowest, 2nd lowest)')


def max_polyphony(g):
    ev = sorted([(n['start'], 1) for n in g] + [(n['end'], -1) for n in g])
    c = best = 0
    for _, d in ev: c += d; best = max(best, c)
    return best


def auto_map(notes, voices=('p1', 'p2', 'tri', 'noise')):
    """MIDI channel 10 -> noise; of the busiest other channels (one per melodic voice to fill) the lowest goes to triangle,
    then pulse 1 = busiest, pulse 2 = next.  voices: the voices to fill (the others stay None)."""
    by = {}
    for n in notes: by.setdefault(n['ch'], []).append(n['pitch'])
    want = [v for v in ('p1', 'p2', 'tri') if v in voices]
    mel = sorted((c for c in by if c != 9), key=lambda c: -len(by[c]))[:len(want)]
    mp = {'p1': None, 'p2': None, 'tri': None, 'noise': 10 if 9 in by and 'noise' in voices else None}
    if mel:
        if 'tri' in want and (len(mel) >= 2 or want == ['tri']):
            low = min(mel, key=lambda c: sum(by[c]) / len(by[c])); mp['tri'] = low + 1; mel.remove(low)
        mel.sort(key=lambda c: -len(by[c]))              # the busiest remaining channel is usually the melody
        for v, c in zip([v for v in ('p1', 'p2') if v in want], mel): mp[v] = c + 1
    return mp


# ---------------------------------------------------------------------------- song conversion
NOTE = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
PERIOD = [0x06AE, 0x064E, 0x05F4, 0x059E, 0x054D, 0x0501, 0x04B9, 0x0475, 0x0435, 0x03F9, 0x03C0, 0x038A]
# GM drum note -> (noise period index 0-15, decay frames, volume)
DRUMS = {35: (13, 7, 15), 36: (13, 7, 15), 37: (6, 4, 10), 38: (7, 9, 13), 39: (5, 8, 12), 40: (7, 9, 13),
         41: (11, 10, 12), 43: (10, 10, 12), 45: (10, 9, 12), 47: (9, 9, 12), 48: (9, 8, 12), 50: (8, 8, 12),
         42: (1, 3, 8), 44: (1, 3, 7), 46: (1, 12, 8), 49: (3, 32, 11), 57: (3, 32, 11), 52: (3, 28, 10), 55: (2, 20, 10),
         51: (2, 14, 7), 59: (2, 14, 7), 53: (2, 10, 8), 54: (0, 6, 7), 56: (4, 5, 9), 69: (0, 4, 6), 70: (0, 4, 6)}
DRUM_DEFAULT = (5, 8, 10)
DEFAULTS = dict(p1=None, p2=None, tri=None, noise=None, auto=1, pick_p1='high', pick_p2='high', pick_tri='low',
                transpose=0, transpose_p1=0, transpose_p2=0, transpose_tri=0, range='fold',
                vol=10, vol_p2=8, vol_noise=12, duty1=2, duty2=1,
                decay=0, ticks16=0, start=0.0, end=0.0, speed=1.0, loop=1, drums='full')
PICK_WORDS = ('high', 'low', 'first', 'last')


def parse_opts(lst):
    o = dict(DEFAULTS)
    for kv in lst or []:
        if '=' not in kv: raise SystemExit('option %r: use key=value' % kv)
        k, v = kv.split('=', 1)
        if k not in o or k.startswith('_'): raise SystemExit('unknown option %r (known: %s)' % (k, ', '.join(x for x in o if not x.startswith('_'))))
        if k in ('p1', 'p2', 'tri', 'noise'):
            o[k] = None if v in ('0', 'none', '') else v
            o['_named'] = o.get('_named', ()) + (k,)
        elif k in ('start', 'end', 'speed'): o[k] = float(v)
        elif k == 'drums':
            if v not in ('full', 'simple'): raise SystemExit('drums=full or drums=simple')
            o[k] = v
        elif k == 'range':
            if v not in ('fold', 'drop'): raise SystemExit('range=fold (move notes by octaves into the range) or range=drop (leave them out)')
            o[k] = v
        elif k.startswith('pick_'):
            if v not in PICK_WORDS:
                try:
                    if int(v) == 0: raise ValueError
                except ValueError:
                    raise SystemExit('%s=%s: use high, low, first, last, or a rank: 1 = highest note, 2 = second highest, ..., '
                                     '-1 = lowest, -2 = second lowest' % (k, v))
            o[k] = v
        else:
            try: o[k] = int(v)
            except ValueError: raise SystemExit('option %s=%s: expected a whole number' % (k, v))
    for k in ('p1', 'p2', 'tri', 'noise'):
        if o[k] is not None:
            for part in str(o[k]).split('+'):
                if not (part.isdigit() and 1 <= int(part) <= 16) and not (part[:1] == 't' and part[1:].isdigit()):
                    raise SystemExit('%s=%s: use a MIDI channel 1-16, tN for track N (as `info` lists them), a+b to merge, '
                                     'or 0 for none' % (k, o[k]))
    return o


def make_pick(spec):
    """Which note of a chord a voice keeps: high, low, first (held longest), last (newest), or a rank
    (1 = highest, 2 = second highest, ...; -1 = lowest, -2 = second lowest; no note of that rank = the voice rests)"""
    if spec == 'high': return lambda a: max(a, key=lambda n: (n['pitch'], n['_s']))
    if spec == 'low': return lambda a: min(a, key=lambda n: (n['pitch'], -n['_s']))
    if spec == 'last': return lambda a: max(a, key=lambda n: (n['_s'], n['pitch']))
    if spec == 'first': return lambda a: min(a, key=lambda n: (n['_s'], -n['pitch']))
    r = int(spec)
    def rank(a):
        ps = sorted({n['pitch'] for n in a}, reverse=r > 0)
        if abs(r) > len(ps): return None
        want = ps[abs(r) - 1]
        return max((n for n in a if n['pitch'] == want), key=lambda n: n['_s'])
    return rank


def voice_map(notes, o):
    """the source of each voice: what the options name; with auto=1 the voices left unnamed get the automatic choice"""
    named = set(o.get('_named', ()))
    mp = {k: o[k] for k in ('p1', 'p2', 'tri', 'noise')}
    if o['auto'] and len(named) < 4:
        used = {id(n) for k in named for n in select(notes, o[k])}   # never give a voice a source already named for another
        am = auto_map([n for n in notes if id(n) not in used], [k for k in ('p1', 'p2', 'tri', 'noise') if k not in named])
        for k in ('p1', 'p2', 'tri', 'noise'):
            if k not in named: mp[k] = am[k]
    return mp


def fit(kind, m, o, warn):
    """a MIDI note (already transposed) in the voice's range: moved by octaves (range=fold) or None (range=drop)"""
    if kind == 'pulse':
        lo_ok = lambda x: x >= 36
        hi_ok = lambda x: (PERIOD[(x - 36) % 12] >> ((x - 36) // 12)) >= 8
    else:
        lo_ok = lambda x: x >= 24
        hi_ok = lambda x: x <= 24 + 9 * 12 + 11
    if lo_ok(m) and hi_ok(m): return m
    if o['range'] == 'drop':
        warn['dropped_' + kind] += 1; return None
    while not lo_ok(m): m += 12; warn[kind + '_low'] += 1
    while not hi_ok(m): m -= 12; warn[kind + '_high'] += 1
    return m


def select(notes, spec):
    """spec: MIDI channel '3', track 't2', or several joined with '+'."""
    if spec is None: return []
    out = []
    for part in str(spec).split('+'):
        if part.startswith('t'): out += [n for n in notes if n['track'] == int(part[1:])]
        else: out += [n for n in notes if n['ch'] == int(part) - 1]
    return out


def mono(notes, L, tick, pick):
    """Reduce to one note per tick. Returns runs [(start, length, note_or_None)]."""
    cells = [None] * L; onset = [False] * L
    act = [[] for _ in range(L + 1)]
    for n in notes:
        s = int(round(n['start'] / tick)); e = max(s + 1, int(round(n['end'] / tick)))
        n['_s'], n['_e'] = s, min(e, L)
        for t in range(s, min(e, L)): act[t].append(n)
    for t in range(L):
        if act[t]:
            n = pick(act[t])
            if n is not None: cells[t] = n; onset[t] = n['_s'] == t
    runs = []; t = 0
    while t < L:
        n = cells[t]; s = t; t += 1
        while t < L and cells[t] is n and not onset[t]: t += 1
        runs.append((s, t - s, n))
    return runs


class Track:
    def __init__(self): self.cmds = []
    def c(self, a, b): self.cmds.append((a & 0xFF, b & 0xFF))


def chunks(n, size=255):
    while n > 0:
        k = min(n, size); yield k; n -= k


def enc_pulse(runs, tr, duty, maxvol, transpose, warn):
    cur = None
    for s, ln, n in runs:
        if n is None:
            if cur != 0: tr.c(0xA0, 0x10); cur = 0
            for k in chunks(ln): tr.c(0x0C, k)
            continue
        m = n['pitch'] + transpose
        vol = max(1, min(15, round(maxvol * n['vel'] / 127)))
        if cur != vol: tr.c(0xA0, 0x10 | vol); cur = vol
        first = True
        for k in chunks(ln):
            if first: tr.c(((m - 36) // 12) << 4 | (m - 36) % 12, k); first = False
            else: tr.c(0x0C, k)          # a rest keeps the note sounding (it does not touch the volume)


def enc_tri(runs, tr, transpose, tick_frames, warn):
    """Short notes (up to ~31 frames) end by themselves: the linear counter is set to the note length, so the following
    silence costs nothing. Long notes keep the counter at 127 and are re-issued every ~28 frames (seamless on the
    triangle); the silence after them is an explicit A2 00 plus a note write (reloads the counter with 0)."""
    lin = None; last = 0x00
    step = max(1, int(28 / tick_frames))
    i = 0
    while i < len(runs):
        s, ln, n = runs[i]
        if n is None:
            if lin != 0: tr.c(0xA2, 0x00); lin = 0
            first = True
            for k in chunks(ln):
                tr.c(last if first else 0x0C, k); first = False
            i += 1; continue
        m = n['pitch'] + transpose
        cmd = ((m - 24) // 12) << 4 | (m - 24) % 12; last = cmd
        frames = ln * tick_frames
        gap = runs[i + 1][1] if i + 1 < len(runs) and runs[i + 1][2] is None else 0
        if frames <= 31 and gap:
            want = max(1, min(127, int(round(frames * 4))))       # quarter frames
            if lin != want: tr.c(0xA2, want); lin = want
            first = True
            for k in chunks(ln + gap):
                tr.c(cmd if first else 0x0C, k); first = False   # the rests keep the channel quiet (counter ran out)
            i += 2; continue
        if lin != 0x7F: tr.c(0xA2, 0x7F); lin = 0x7F
        for k in chunks(ln, step): tr.c(cmd, k)
        i += 1


def enc_noise(runs, tr, maxvol, simple=False):
    """full: per-drum decay and volume (up to 6 bytes a hit); simple: one decay and volume for all hits (2 bytes a hit)."""
    cur_vol = cur_env = None
    if simple:
        tr.c(0xC1, 8); tr.c(0xA0, 0x10 | max(1, min(15, maxvol))); cur_env, cur_vol = 8, maxvol
    merged = []
    for r in runs:                                  # a hit lasts until the next hit: its envelope silences it anyway
        if r[2] is None and merged and merged[-1][2] is not None:
            merged[-1] = (merged[-1][0], merged[-1][1] + r[1], merged[-1][2])
        else:
            merged.append(r)
    for s, ln, n in merged:
        if n is None:
            for k in chunks(ln): tr.c(0x10, k)
            continue
        if n['ch'] == 9: idx, env, v = DRUMS.get(n['pitch'], DRUM_DEFAULT)
        else: idx, env, v = 15 - (n['pitch'] % 16), 10, 12
        vol = max(1, min(15, round(v * maxvol / 15 * n['vel'] / 127)))
        if simple: env, vol = cur_env, cur_vol
        if cur_env != env: tr.c(0xC1, env); cur_env = env
        if cur_vol != vol: tr.c(0xA0, 0x10 | vol); cur_vol = vol
        first = True
        for k in chunks(ln):
            tr.c(idx if first else 0x10, k); first = False


def ordinal(n): return {1: '1st', 2: '2nd', 3: '3rd'}.get(n, '%dth' % n)


def pick_desc(spec):
    words = {'high': 'highest', 'low': 'lowest', 'first': 'oldest', 'last': 'newest'}
    if spec in words: return words[spec]
    r = int(spec)
    if abs(r) == 1: return 'highest' if r > 0 else 'lowest'
    return '%s highest' % ordinal(r) if r > 0 else '%s lowest' % ordinal(-r)


def voice_runs(notes, o, mp, L, tick, warn):
    """per voice: (runs [(start, length, note)] with note['_m'] = the MIDI note it plays, or None = rest; source count)"""
    out = {}
    for key, kind in (('p1', 'pulse'), ('p2', 'pulse'), ('tri', 'tri'), ('noise', 'noise')):
        src = select(notes, mp[key])
        if kind == 'noise':
            runs = mono(src, L, tick, lambda a: max(a, key=lambda n: (n['_s'], DRUMS.get(n['pitch'], DRUM_DEFAULT)[2])))
        else:
            runs = mono(src, L, tick, make_pick(o['pick_' + key]))
            tp = o['transpose'] + o['transpose_' + key]
            fixed = []
            for s, ln, n in runs:
                if n is not None:
                    m = fit(kind, n['pitch'] + tp, o, warn)
                    n = None if m is None else dict(n, pitch=m)
                if n is None and fixed and fixed[-1][2] is None:
                    fixed[-1] = (fixed[-1][0], fixed[-1][1] + ln, None)
                else:
                    fixed.append((s, ln, n))
            runs = fixed
        out[key] = (runs, len(src))
    return out


def build_track(tempo_b, kind, cmds, header_vol, duty_or_lin, sweep):
    """Header + commands, an AD (new block) before the 8-bit position counter can wrap, FF at the end."""
    out = bytearray([tempo_b, duty_or_lin, header_vol, sweep])
    pos = 2
    for a, b in cmds + [(0xFF, 0x00)]:
        if pos >= 250 and (a, b) != (0xFF, 0):
            out += bytes([0xAD, 0x01]); pos = 0     # data += 2*pos, pos = 0, keep reading
        out += bytes([a, b]); pos += 1
    return bytes(out)


def convert_song(path, o, tgt_name, log):
    m = read_midi(path); notes = m['notes']
    if o['speed'] != 1.0:
        for n in notes: n['start'] /= o['speed']; n['end'] /= o['speed']
    if o['start'] or o['end']:
        e = o['end'] or 1e9
        notes = [dict(n, start=n['start'] - o['start'], end=min(n['end'], e) - o['start']) for n in notes if o['start'] <= n['start'] < e]
    if not notes: raise SystemExit('%s: no notes' % path)
    mp = voice_map(notes, o)
    # tick length: a 16th note = ticks16 ticks (auto: about 2.4 frames per tick, like the original songs)
    f16 = m['tempo'] / 1e6 / 4 / o['speed'] * FPS
    k = o['ticks16'] or max(1, round(f16 / 2.4))
    T = max(15, min(255, round(16 * f16 / k) - 1))
    tick_frames = (T + 1) / 16.0; tick = tick_frames / FPS
    tempo_b = (((T - 15) & 0xFF) << 4 | ((T - 15) & 0xFF) >> 4) & 0xFF    # inverse of nibble-swap(b) + 15
    end = max(n['end'] for n in notes)
    L = int(round(end / tick)) + 1
    L = -(-L // k) * k                                                    # whole 16ths
    warn = {'pulse_low': 0, 'pulse_high': 0, 'tri_low': 0, 'tri_high': 0, 'dropped_pulse': 0, 'dropped_tri': 0}
    tracks = []
    allruns = voice_runs(notes, o, mp, L, tick, warn)
    for key, kind in (('p1', 'pulse'), ('p2', 'pulse'), ('tri', 'tri'), ('noise', 'noise')):
        runs, nsrc = allruns[key]; tr = Track()
        if kind == 'pulse':
            if o['decay'] and nsrc: tr.cmds.append((0xC1, o['decay']))
            enc_pulse(runs, tr, o['duty1'] if key == 'p1' else o['duty2'], o['vol'] if key == 'p1' else o['vol_p2'], 0, warn)
            data = build_track(tempo_b, kind, tr.cmds, 0x10, o['duty1'] if key == 'p1' else o['duty2'], 0x08)
        elif kind == 'tri':
            enc_tri(runs, tr, 0, tick_frames, warn)
            data = build_track(tempo_b, kind, tr.cmds, 0x00, 0x00, 0x00)
        else:
            enc_noise(runs, tr, o['vol_noise'], o['drums'] == 'simple')
            data = build_track(tempo_b, kind, tr.cmds, 0x10, 0x00, 0x00)
        tracks.append((key, data, nsrc))
    secs = L * tick
    log('%s <- %s' % (tgt_name, os.path.basename(path)))
    log('  mapping: pulse1=%s pulse2=%s triangle=%s noise=%s (MIDI channel, or tN = track)%s' % (
        tuple(mp[k] if mp[k] is not None else '-' for k in ('p1', 'p2', 'tri', 'noise')) + ('' if o['auto'] else ', auto=0',)))
    picks = ['%s keeps the %s note' % (k, pick_desc(o['pick_' + k])) for k in ('p1', 'p2', 'tri') if mp[k] is not None]
    if picks: log('  chords: ' + ', '.join(picks))
    log('  tempo byte $%02X: %.4f frames/tick, %d ticks per 16th (MIDI 16th = %.3f frames, error %.2f%%), length %.1f s, %s'
        % (tempo_b, tick_frames, k, f16, 100 * (k * tick_frames - f16) / f16, secs, 'loops' if o['loop'] else 'plays once'))
    for key, data, nn in tracks:
        log('  %-5s %4d MIDI notes -> %5d bytes' % (key, nn, len(data)))
    moved = {k: v for k, v in warn.items() if v and not k.startswith('dropped')}
    dropped = {k[8:]: v for k, v in warn.items() if v and k.startswith('dropped')}
    if moved: log('  notes moved by octaves to fit the range: %s' % moved)
    if dropped: log('  notes outside the range left out (range=drop): %s' % dropped)
    return [d for _, d, _ in tracks], secs


# ---------------------------------------------------------------------------- writing into the ROM
def check_driver(rom, t):
    if bytes(rom[cpu_to_file(t, t['credit']):cpu_to_file(t, t['credit']) + 14]) != CREDIT:
        raise SystemExit('%s: sound driver not found at the expected place (is this the Sup 400-in-1 dump?)' % t['name'])


def patch_code(t, ha):
    """Code placed in the free area at ha: [loop hook][AD fix]."""
    r = t['chan_ram']
    hook = bytes([0x20, t['sfx_tick'] & 0xFF, t['sfx_tick'] >> 8, 0x20, t['music_tick'] & 0xFF, t['music_tick'] >> 8,
                  0xAD, r & 0xFF, r >> 8, 0x2D, (r + 0x15) & 0xFF, (r + 0x15) >> 8,
                  0x2D, (r + 0x2A) & 0xFF, (r + 0x2A) >> 8, 0x2D, (r + 0x3F) & 0xFF, (r + 0x3F) >> 8,
                  0xC9, 0xFF, 0xD0, 0x03, 0x20, t['start_song'] & 0xFF, t['start_song'] >> 8, 0x60])
    _, hdr, cont = t['ad_fix']
    # AD with a non-zero argument: the driver updates the track pointer but has overwritten $D1 (the high byte of the
    # pointer it is still reading through). Reload $D0/$D1 = new base - 1 and Y = 0, then continue at "iny / jmp read".
    fix = bytes([0xD0, 0x03, 0x4C, hdr & 0xFF, hdr >> 8,
                 0xBD, (r + 2) & 0xFF, (r + 2) >> 8, 0x38, 0xE9, 0x01, 0x85, 0xD0,
                 0xBD, (r + 3) & 0xFF, (r + 3) >> 8, 0xE9, 0x00, 0x85, 0xD1,
                 0xA0, 0x00, 0x4C, cont & 0xFF, cont >> 8])
    return hook, fix


def install_hook(rom, t, loop):
    """sound_tick -> JMP hook (loop=1): sfx_tick, music_tick, then restart the song (music_start_song) when all 4
    tracks have ended. loop=0 keeps the original sound_tick, so the song plays once. The AD fix is always installed."""
    f = cpu_to_file(t, t['tick'])
    hf, ha = t['hook']
    hook, fix = patch_code(t, ha)
    code = hook + fix
    cur = bytes(rom[f:f + 7])
    if cur != t['tick_bytes'] and cur[:3] != bytes([0x4C, ha & 0xFF, ha >> 8]):
        raise SystemExit('%s: sound_tick at 0x%05X is not the original code' % (t['name'], f))
    if any(b != 0xFF for b in rom[hf:hf + len(code)]) and bytes(rom[hf:hf + len(code)]) != code:
        raise SystemExit('patch area 0x%05X is not free' % hf)
    rom[hf:hf + len(code)] = code
    fa = ha + len(hook)
    af = cpu_to_file(t, t['ad_fix'][0])
    orig_ad = bytes([0x68, 0xD0, 0x10, 0x4C, t['ad_fix'][1] & 0xFF, t['ad_fix'][1] >> 8])
    if bytes(rom[af:af + 6]) not in (orig_ad, bytes([0x68, 0x4C, fa & 0xFF, fa >> 8, 0xEA, 0xEA])):
        raise SystemExit('%s: AD handler not found' % t['name'])
    rom[af:af + 6] = bytes([0x68, 0x4C, fa & 0xFF, fa >> 8, 0xEA, 0xEA])   # pla / jmp fix
    rom[f:f + 7] = (bytes([0x4C, ha & 0xFF, ha >> 8]) + t['tick_bytes'][3:]) if loop else t['tick_bytes']


def write_song(rom, t, tracks, loop, log):
    check_driver(rom, t)
    # records (16 bytes) + tracks, first-fit into the song areas
    recs_size = 16
    items = [('records', recs_size)] + [('t%d' % i, len(d)) for i, d in enumerate(tracks)]
    free = [[a, b, c] for a, b, c in t['song_areas']]
    place = {}
    for name, size in sorted(items, key=lambda x: -x[1]):
        for ar in free:
            if ar[1] - ar[0] >= size:
                place[name] = (ar[0], ar[2]); ar[0] += size; ar[2] += size; break
        else:
            raise SystemExit('%s: the song does not fit (%d bytes in tracks of %s). Shorten it (end=...), use fewer notes, '
                             'or lower ticks16.' % (t['name'], sum(s for _, s in items), [s for _, s in items[1:]]))
    for a, b, _ in t['song_areas']:               # clear the old song / free areas to $FF before writing
        rom[a:b] = b'\xFF' * (b - a)
    recs = bytearray()
    for i, d in enumerate(tracks):
        f, cpu = place['t%d' % i]
        rom[f:f + len(d)] = d
        recs += bytes([0x15 * i, i, cpu & 0xFF, cpu >> 8])
    f, cpu = place['records']; rom[f:f + 16] = recs
    sc = cpu_to_file(t, t['song_cnt']); sp = cpu_to_file(t, t['song_ptr'])
    rom[sc:sc + 2] = bytes([3, 0])                 # song 0: 4 tracks from record 0
    rom[sp:sp + 2] = bytes([cpu & 0xFF, cpu >> 8])
    install_hook(rom, t, loop)
    used = sum(len(d) for d in tracks) + 16
    log('  written: %d bytes; records at $%04X (file 0x%05X); tracks at %s' % (
        used, cpu, f, ', '.join('$%04X' % place['t%d' % i][1] for i in range(4))))


# ---------------------------------------------------------------------------- sound effects
def note_period(tok, chan):
    tok = tok.strip()
    if tok.lower().startswith('p'): return int(tok[1:].lstrip('$'), 16)
    if chan == 'noise': return int(tok, 0)
    name = tok.rstrip('0123456789-'); octv = int(tok[len(name):])
    s = NOTE.index(name.upper().replace('B#', 'C')) if name.upper() in NOTE else {'DB': 1, 'EB': 3, 'GB': 6, 'AB': 8, 'BB': 10}[name.upper()]
    base = PERIOD[s] >> max(0, octv - 2) if octv >= 2 else PERIOD[s] << (2 - octv)
    if chan == 'triangle': base = PERIOD[s] >> max(0, octv - 1) if octv >= 1 else PERIOD[s]
    return min(base, 0x7FF)


LEN_TABLE = [10, 254, 20, 2, 40, 4, 80, 6, 160, 8, 60, 10, 14, 12, 26, 14, 12, 16, 24, 18, 48, 20, 96, 22, 192, 24, 72, 26, 16, 28, 32, 30]


def read_sfx(path):
    """key = value lines; '#' comments. See README.md."""
    d = dict(channel='pulse2', speed='2', duty='2', sweep='08', steps='', length='0', decay='0', mode='0')
    for line in open(path, encoding='utf-8'):
        line = line.split('#')[0].strip()
        if not line: continue
        if '=' not in line: raise SystemExit('%s: bad line %r' % (path, line))
        k, v = [x.strip() for x in line.split('=', 1)]
        if k == 'steps': d['steps'] += ' ' + v
        else: d[k] = v
    chan = d['channel'].lower()
    if chan not in ('pulse1', 'pulse2', 'triangle', 'noise'): raise SystemExit('%s: channel must be pulse1/pulse2/triangle/noise' % path)
    steps = []; last = None
    for tok in d['steps'].split():
        p, v = tok.split(':') if ':' in tok else (tok, '15')
        per = last if p == '-' else note_period(p, chan)
        if per is None: raise SystemExit('%s: the first step needs a pitch' % path)
        steps.append((per, int(v))); last = per
    if not steps: raise SystemExit('%s: no steps' % path)
    return dict(chan=chan, speed=int(d['speed']), duty=int(d['duty']), sweep=int(d['sweep'], 16), steps=steps,
                length=int(d['length']), decay=int(d['decay']), mode=int(d['mode']))


def sfx_regs(s, per, vol, oneshot=False):
    c = s['chan']
    if c == 'triangle':
        r0 = 0xFF if vol else 0x80
        r2, r3 = per & 0xFF, (per >> 8) & 7 | 0x08
        return [r0, 0x00, r2, r3]
    if c == 'noise':
        r0 = 0x30 | vol
        if oneshot and s['decay']: r0 = s['decay'] & 15
        return [r0, 0x00, (per & 15) | (0x80 if s['mode'] else 0), 0x08]
    r0 = (s['duty'] & 3) << 6 | 0x30 | vol
    if oneshot and s['decay']: r0 = (s['duty'] & 3) << 6 | (s['decay'] & 15)
    return [r0, s['sweep'], per & 0xFF, (per >> 8) & 7 | 0x08]


def build_sfx_record(s):
    """{1, chan bit, reg mask, frames/step, stream length, r0-r3, stream}; a silent step is added at the end."""
    bit = {'pulse1': 1, 'pulse2': 2, 'triangle': 4, 'noise': 8}[s['chan']]
    regs = [sfx_regs(s, p, v) for p, v in s['steps']] + [sfx_regs(s, s['steps'][-1][0], 0)]
    his = {r[3] for r in regs}
    mask = 0x0D if (len(his) > 1 or s['chan'] == 'triangle') else 0x05     # r0, r2 (+ r3 when the high byte changes)
    stream = bytearray()
    for r in regs[1:]:
        for i in range(4):
            if mask >> i & 1: stream.append(r[i])
    if len(stream) > 255: raise SystemExit('sound effect too long (%d stream bytes, max 255)' % len(stream))
    return bytes([1, bit, mask, max(1, s['speed']), len(stream)] + regs[0]) + bytes(stream)


def oneshot_regs(s):
    per, vol = s['steps'][0]
    r = sfx_regs(s, per, vol, oneshot=True)
    if not s['length'] and not (s['sweep'] & 0x80): s = dict(s, length=12)   # a one-shot must stop by itself
    if s['length']:                       # length counter: halt off, nearest table length (frames at 120 Hz -> /2)
        want = s['length'] * 120 / FPS
        idx = min(range(32), key=lambda i: abs(LEN_TABLE[i] - want))
        if s['chan'] == 'triangle':       # triangle: control bit 7 off, linear counter = length in quarter frames
            r[0] = max(1, min(127, int(round(s['length'] * 4))))
        else:
            r[0] &= ~0x20 & 0xFF
        r[3] = (r[3] & 7) | idx << 3
    return r


def write_cn_cursor(rom, s, log):
    t = TARGETS['cn']; check_driver(rom, t)
    rec = build_sfx_record(s)
    a, b = t['sfx_area']
    if len(rec) > b - a: raise SystemExit('cursor effect too big')
    rom[a:b] = b'\xFF' * (b - a)
    rom[a:a + len(rec)] = rec
    cpu = 0xE000 + a - t['e000']
    tb = cpu_to_file(t, t['sfx_tbl'])
    for i in range(t['nsfx']):            # every table entry points at the new effect (the menu only plays #4)
        rom[tb + 2 * i:tb + 2 * i + 2] = bytes([cpu & 0xFF, cpu >> 8])
    log('Chinese cursor effect: %d bytes at $%04X (file 0x%05X), %s, %d steps every %d frames'
        % (len(rec), cpu, a, s['chan'], len(s['steps']), s['speed']))


def write_en_beep(rom, s, log):
    if s['chan'] != 'pulse2': log('  note: the English beep always plays on pulse 2')
    r = oneshot_regs(dict(s, chan='pulse2'))
    f = EN_BEEP
    if rom[f] != 0xA9 or rom[f + 2:f + 5] != b'\x8D\x04\x40': raise SystemExit('English beep routine not found')
    for i in range(4): rom[f + 1 + 5 * i] = r[i]
    log('English beep: $4004-$4007 = %s' % ' '.join('%02X' % v for v in r))


def write_ls_chime(rom, s, log):
    f = LS_CHIME
    if rom[f:f + 5] != b'\xA9\x0F\x8D\x15\x40': raise SystemExit('language-select chime routine not found')
    if s['chan'] not in ('pulse1', 'pulse2', 'noise', 'triangle'): raise SystemExit('bad channel')
    r = oneshot_regs(s)
    base = {'pulse1': 0x4000, 'pulse2': 0x4004, 'triangle': 0x4008, 'noise': 0x400C}[s['chan']]
    code = bytearray([0xA9, 0x0F, 0x8D, 0x15, 0x40])
    for i in range(4): code += bytes([0xA9, r[i], 0x8D, (base + i) & 0xFF, 0x40])
    code += b'\x60'
    if any(v != 0xFF for v in rom[f + 24:f + 32]) and len(code) > 24: raise SystemExit('no room for the chime routine')
    rom[f:f + 32] = bytes(code) + b'\xFF' * (32 - len(code))
    log('Language-select chime: %s = %s' % (s['chan'], ' '.join('%02X' % v for v in r)))


# ---------------------------------------------------------------------------- previews (6502 + APU model)
def preview_song(rom, tkey, secs, path):
    from sndlib import NSFPlayer, render
    t = TARGETS[tkey]
    lo = 0x38000 if tkey == 'cn' else 0x68000
    img = bytes(rom[lo:lo + 0x8000])
    hdr = b'NESM\x1A\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
    p = NSFPlayer(hdr + img)
    s = t['chan_ram']; song_var = 0x0081 if tkey == 'cn' else 0x045D; init = 0xE379 if tkey == 'cn' else 0xEF55
    w = bytes([0x8D, song_var & 0xFF, song_var >> 8, 0x4C, init & 0xFF, init >> 8])
    p.mem[0x6000:0x6000 + len(w)] = w
    p.mem[0x6010:0x6013] = bytes([0x4C, t['tick'] & 0xFF, t['tick'] >> 8])
    frames = int(min(secs * 2 + 1, 90) * FPS)
    render(p.run(0, frames), path, fade_frames=120)
    return frames


def preview_regs(writes_first, frames, path, extra=None):
    from sndlib import render
    render([writes_first] + [[(0x4015, 0x0F)]] * frames, path)


def preview_cn_cursor(rom, path):
    from sndlib import NSFPlayer, render
    img = bytes(rom[0x38000:0x40000])
    hdr = b'NESM\x1A\x01\x01\x01' + struct.pack('<HHH', 0x8000, 0x6000, 0x6010) + bytes(114)
    p = NSFPlayer(hdr + img)
    # silence the music, then sound_play with sound_id = 4
    w = bytes([0xA9, 0x00, 0x8D, 0x81, 0x00, 0x20, 0x79, 0xE3, 0xA9, 0xFF] + sum([[0x8D, (0x300 + 0x15 * k) & 0xFF, 0x03] for k in range(4)], [])
              + [0xA9, 0x04, 0x85, 0xDB, 0x4C, 0x51, 0xE3])
    p.mem[0x6000:0x6000 + len(w)] = w
    p.mem[0x6010:0x6013] = bytes([0x4C, 0xBA, 0xE4])          # sfx_tick only
    fr = p.run(0, 150)
    last = max((i for i, f in enumerate(fr) if f), default=0)
    render(fr[:last + 40], path)


# ---------------------------------------------------------------------------- CLI
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    i = sub.add_parser('info', help='show the channels of a MIDI file'); i.add_argument('midi')
    b = sub.add_parser('build', help='write songs / effects into a copy of the ROM')
    b.add_argument('rom'); b.add_argument('-o', '--out', required=True)
    b.add_argument('--cn-song'); b.add_argument('--ls-song')
    b.add_argument('--cn-opt', action='append', default=[]); b.add_argument('--ls-opt', action='append', default=[])
    b.add_argument('--cn-cursor'); b.add_argument('--en-beep'); b.add_argument('--ls-chime')
    b.add_argument('--preview', help='folder for WAV previews')
    a = ap.parse_args()
    if a.cmd == 'info':
        midi_info(a.midi); return
    rom = bytearray(open(a.rom, 'rb').read())
    if len(rom) < 0x80000: raise SystemExit('ROM must be at least 512 KiB')
    log = print
    if a.preview: os.makedirs(a.preview, exist_ok=True)
    for key, song, opts in (('cn', a.cn_song, a.cn_opt), ('ls', a.ls_song, a.ls_opt)):
        if not song: continue
        o = parse_opts(opts)
        tracks, secs = convert_song(song, o, TARGETS[key]['name'], log)
        write_song(rom, TARGETS[key], tracks, o['loop'], log)
        if a.preview:
            preview_song(rom, key, secs, os.path.join(a.preview, '%s_song.wav' % key))
    if a.cn_cursor:
        s = read_sfx(a.cn_cursor); write_cn_cursor(rom, s, log)
        if a.preview: preview_cn_cursor(rom, os.path.join(a.preview, 'cn_cursor.wav'))
    if a.en_beep:
        s = read_sfx(a.en_beep); write_en_beep(rom, s, log)
        if a.preview:
            r = oneshot_regs(dict(s, chan='pulse2')); preview_regs([(0x4015, 0x0F)] + [(0x4004 + i, r[i]) for i in range(4)], 60, os.path.join(a.preview, 'en_beep.wav'))
    if a.ls_chime:
        s = read_sfx(a.ls_chime); write_ls_chime(rom, s, log)
        if a.preview:
            r = oneshot_regs(s); base = {'pulse1': 0x4000, 'pulse2': 0x4004, 'triangle': 0x4008, 'noise': 0x400C}[s['chan']]
            preview_regs([(0x4015, 0x0F)] + [(base + i, r[i]) for i in range(4)], 60, os.path.join(a.preview, 'ls_chime.wav'))
    open(a.out, 'wb').write(rom)
    print('wrote', a.out)


if __name__ == '__main__':
    main()
