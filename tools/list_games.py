#!/usr/bin/env python3
"""List the games of a Sup 400-in-1 English menu: the original dump, the stripped image, or a multicart built by
`make rom` (.bin, or .nes with its 16-byte header).

  python3 tools/list_games.py IMAGE [--csv OUT.csv] [--md OUT.md] [--extract DIR]

For every list entry: number, name, launch row, the 8 launch bytes, what the menu's start stub writes to the OneBus
registers, and where the game's PRG / CHR windows are in the flash (decoded with the same rules as the builder,
rombuilder/onebus400.py).  The original menu remaps entries 314-400 to entries 1-87 (index - 313, sub_A940); a built
image has that remap patched out, and the tool reads which one it is from the code at $A940.

--extract DIR  writes every game whose PRG and CHR windows lie inside the image (and are not blank) as an iNES file:
               mapper 0 when the PRG window is 16/32 KiB and the CHR window 8 KiB (or CHR-RAM), else mapper 4 (MMC3);
               PRG = the PRG window, CHR = the CHR window.  For a multicart made by `make rom` this gives back each game
               (padded to a power of two).  The original dump holds only three games' data (MARIO 3 CHR, SPIDER MAN,
               GOBLET TOWER); all others are outside its 512 KiB.
"""
import argparse, csv, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'rombuilder'))
import onebus400 as O

ENG = 0x78000                      # English block: CPU $8000 = file 0x78000
HEADER, ENTRIES, PARAMS_LO, PARAMS_HI = 0xCE6B, 0xCE7B, 0xB000, 0xB800
PRG_MASK = {0: 0x3F, 1: 0x1F, 2: 0x0F, 3: 0x07, 4: 0x03, 5: 0x01, 6: 0x00, 7: 0xFF}
CHR_MASK = {0: 0xFF, 1: 0x7F, 2: 0x3F, 3: 0x3F, 4: 0x1F, 5: 0x0F, 6: 0x07, 7: 0x07}


def f(cpu): return ENG + cpu - 0x8000


def load(path):
    d = open(path, 'rb').read()
    if d[:4] == b'NES\x1a': d = d[16:]
    if len(d) < 0x80000: raise SystemExit('%s: expected at least the 512 KiB menu region' % path)
    return d


def read_list(d):
    h = d[f(HEADER):f(HEADER) + 16]
    count = h[0] | h[1] << 8
    ent = h[8] | h[9] << 8
    remap = d[f(0xA940):f(0xA940) + 4] == bytes.fromhex('A519F011')   # the original's "index >= 313 -> index - 313"
    games = []
    for k in range(count):
        src = k - 313 if remap and k >= 313 else k
        e = d[f(ent) + 4 * src:f(ent) + 4 * src + 4]
        ptr, row = e[0] | e[1] << 8, e[2]
        nm = bytearray()
        a = f(ptr)
        while d[a] != 0xFF and len(nm) < 32: nm.append(d[a]); a += 1
        table = PARAMS_HI if src >= 256 else PARAMS_LO
        p = bytes(d[f(table) + 8 * row:f(table) + 8 * row + 8])
        games.append(dict(k=k, src=src, name=nm.decode('ascii', 'replace'), ptr=ptr, row=row, table=table, p=p))
    return count, remap, games


def windows(p):
    r = O.stub_registers(p)
    m = PRG_MASK[r[0x410B] & 7]
    prg_base = (((r[0x410A] & ~m) & 0xFF) | ((r[0x4100] >> 4) << 8)) * 0x2000
    prg_size = (m + 1) * 0x2000
    if r[0x4118] & 0x80:
        chr_base, chr_size = None, 0
    else:
        im = CHR_MASK[r[0x201A] & 7]; mm = 0xFF & ~im
        chr_base = (((r[0x4100] & 0x0F) << 11) | (((r[0x2018] >> 4) & 7) << 8) | (r[0x201A] & mm)) * 0x400
        chr_size = (im + 1) * 0x400
    return r, prg_base, prg_size, chr_base, chr_size


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('image'); ap.add_argument('--csv'); ap.add_argument('--md'); ap.add_argument('--extract')
    a = ap.parse_args()
    d = load(a.image)
    count, remap, games = read_list(d)
    rows = []
    for g in games:
        r, pb, ps, cb, cs = windows(g['p'])
        prg_in = pb + ps <= len(d) and any(b != 0xFF for b in d[pb:pb + ps])
        chr_in = cb is None or (cb + cs <= len(d) and any(b != 0xFF for b in d[cb:cb + cs]))
        mapper = 0 if ps <= 0x8000 and (cs == 0x2000 or cb is None) and ps >= 0x4000 else 4
        if ps == 0x4000 and (g['p'][6] & 0x0F) != 5: mapper = 4
        rows.append(dict(game=g['k'] + 1, name=g['name'], same_as=(g['src'] + 1) if g['src'] != g['k'] else '',
                         launch_row='$%04X+8*%d' % (g['table'], g['row']), launch_bytes=g['p'].hex(' '),
                         prg_addr='0x%06X' % pb, prg_kb=ps // 1024, chr_addr='RAM' if cb is None else '0x%06X' % cb,
                         chr_kb=cs // 1024, mirroring='H' if r['mirror'] else 'V', mapper_guess=mapper,
                         reg_4100='$%02X' % r[0x4100], reg_410B='$%02X' % r[0x410B],
                         reg_4107_410A=' '.join('%02X' % r[x] for x in (0x4107, 0x4108, 0x4109, 0x410A)),
                         reg_2018='$%02X' % r[0x2018], reg_201A='$%02X' % r[0x201A], reg_4118='$%02X' % r[0x4118],
                         data_in_image='yes' if prg_in and chr_in else ('PRG only' if prg_in else ('CHR only' if chr_in and cb is not None else 'no'))))
    kind = 'original menu (entries 314-%d repeat 1-%d)' % (count, count - 313) if remap else 'built multicart (no remap)'
    print('%s: %d list entries, %s' % (a.image, count, kind))
    inside = sum(1 for r in rows if r['data_in_image'] == 'yes')
    print('%d of them have their PRG and CHR inside this %d KiB image' % (inside, len(d) // 1024))
    for r in rows[:12] + ([] if len(rows) <= 14 else [None]) + rows[-2:] if len(rows) > 14 else rows:
        if r is None: print('  ...'); continue
        print('  %3d  %-19s  PRG %s %4d KiB  CHR %-8s %3d KiB  %s  %s%s' % (
            r['game'], r['name'], r['prg_addr'], r['prg_kb'], r['chr_addr'], r['chr_kb'], r['mirroring'], r['launch_bytes'],
            ('  = game %d' % r['same_as']) if r['same_as'] else ''))
    if a.csv:
        with open(a.csv, 'w', newline='') as fh:
            w = csv.DictWriter(fh, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
        print('wrote', a.csv)
    if a.md:
        with open(a.md, 'w') as fh:
            fh.write('# Game list of %s\n\n%d list entries, %s. Made by `tools/list_games.py` (`make games-list`).\n\n' % (
                os.path.basename(a.image), count, kind))
            fh.write('PRG / CHR: the flash windows the start stub maps (PRG window size from `$410B`, CHR window from `$201A`). '
                     '"in image": whether that data is inside this file.\n\n')
            fh.write('| # | name | = # | PRG | KiB | CHR | KiB | mir | `$4100` | `$410B` | `$4107-$410A` | `$2018` | `$201A` | `$4118` | launch bytes | in image |\n')
            fh.write('|' + '---|' * 16 + '\n')
            for r in rows:
                fh.write('| %d | %s | %s | %s | %d | %s | %d | %s | %s | %s | %s | %s | %s | %s | `%s` | %s |\n' % (
                    r['game'], r['name'], r['same_as'], r['prg_addr'], r['prg_kb'], r['chr_addr'], r['chr_kb'], r['mirroring'],
                    r['reg_4100'], r['reg_410B'], r['reg_4107_410A'], r['reg_2018'], r['reg_201A'], r['reg_4118'],
                    r['launch_bytes'], r['data_in_image']))
        print('wrote', a.md)
    if a.extract:
        os.makedirs(a.extract, exist_ok=True)
        n = 0; seen = set()
        for g, r in zip(games, rows):
            if r['data_in_image'] != 'yes' or r['same_as']: continue
            _, pb, ps, cb, cs = windows(g['p'])
            prg = d[pb:pb + ps]; chr_ = b'' if cb is None else d[cb:cb + cs]
            key = (pb, ps, cb, cs, r['mirroring'])
            if key in seen: continue
            seen.add(key)
            mapper = r['mapper_guess']
            hdr = bytes([0x4E, 0x45, 0x53, 0x1A, ps // 0x4000, cs // 0x2000,
                         ((mapper & 0x0F) << 4) | (1 if r['mirroring'] == 'V' else 0) | (2 if mapper == 4 else 0),
                         mapper & 0xF0]) + bytes(8)
            fn = '%03d_%s.nes' % (r['game'], re.sub(r'[^A-Za-z0-9]+', '_', r['name']).strip('_') or 'GAME')
            open(os.path.join(a.extract, fn), 'wb').write(hdr + prg + chr_); n += 1
        print('extracted %d game(s) to %s' % (n, a.extract))


if __name__ == '__main__':
    main()
