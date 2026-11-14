"""The 400-in-1 English menu: patches for a custom list, and the list data.

All file offsets are in the menu region (the first 512 KiB of the flash).  English block: $8000 = bank $3C (0x78000),
$A000 = $3D (0x7A000), $C000 = $3E (0x7C000), $E000 = $3F (0x7E000)."""

def f(cpu):
    return 0x70000 + 0x8000 + (cpu - 0x8000)      # English block: CPU $8000-$FFFF = file 0x78000-0x7FFFF


# (CPU address, original bytes, new bytes, why)
PATCHES = [
    (0xFF89, bytes.fromhex('A2348E0741'), bytes.fromhex('4C7DFB'),
     'power-on goes to the English list: the boot stub jumps to english_menu_entry ($FB7D) instead of mapping the '
     'language select ($34-$37, JMP $E000). The stub has already set $410B=4 and PRG $3C-$3F, as the language '
     "select's English choice does"),
    (0xA940, bytes.fromhex('A519F011'), bytes.fromhex('4C55A9'),
     'no "list index >= 313 -> index - 313" remap in the launch path (sub_A940): every entry starts its own game'),
    (0xA960, bytes.fromhex('A518C90C'), bytes.fromhex('60'),
     'no special launch bytes for list index 12 (sub_A960 used $A980 for the original game 13)'),
    (0xF9D5, bytes.fromhex('AD2703'), bytes.fromhex('4CE4F9'),
     'no boot hot-keys (A+Select, B+Select, Select+Start started fixed game numbers 6, 49 and 158)'),
]

HEADER = 0xCE6B            # list header: 16 bytes copied to $0600
ENTRIES = 0xCE7B           # 4 bytes per entry {name pointer, launch row, sequence}
ENTRIES_END = 0xD64B       # 500 entries
PARAMS = 0xB000            # 8 launch bytes per row; entries 0-255 use $B000 + 8*row, 256+ use $B800 + 8*row
NAMES = 0x8000             # names, $FF-terminated, bank $3C ($8000-$9FFF)
NAMES_END = 0xA000
MAX_GAMES = 500
ROWS = 10
LINE = 21                  # a list line: number, '.', name
# characters the English list font has (the menu maps lower case to the same tiles)
FONT = set(' !"&\'-./0123456789:@ABCDEFGHIJKLMNOPQRSTUVWXYZ')


def name_room(n):
    """characters left for the name of game number n (1-based)"""
    return LINE - len(str(n)) - 1


def clean_name(raw, n):
    name = raw.upper()
    bad = sorted(set(c for c in name if c not in FONT))
    name = ' '.join(''.join(c if c in FONT else ' ' for c in name).split())
    notes = []
    if bad: notes.append('characters %s are not in the menu font (shown as blanks)' % ''.join(bad))
    room = name_room(n + 1)
    if len(name) > room:
        notes.append('name cut to %d characters to fit the line' % room); name = name[:room].rstrip()
    return name or 'GAME %d' % (n + 1), notes


def apply_patches(rom):
    for cpu, old, new, why in PATCHES:
        o = f(cpu)
        if bytes(rom[o:o + len(new)]) == new: continue
        if bytes(rom[o:o + len(old)]) != old:
            raise ValueError('menu code at $%04X (file 0x%05X) is not the original: %s' % (cpu, o, rom[o:o + len(old)].hex()))
        rom[o:o + len(new)] = new


def write_list(rom, games):
    """games: list of dict(name, params[8]).  Writes the header, the names, the entries and the launch table."""
    n = len(games)
    if not 1 <= n <= MAX_GAMES: raise ValueError('the list must have 1-%d games (has %d)' % (MAX_GAMES, n))
    # names
    blob = bytearray(); ptrs = []
    for g in games:
        ptrs.append(NAMES + len(blob)); blob += g['name'].encode('ascii') + b'\xFF'
    if NAMES + len(blob) > NAMES_END: raise ValueError('the names take %d bytes, more than the 8 KiB of bank $3C' % len(blob))
    rom[f(NAMES):f(NAMES_END)] = b'\xFF' * (NAMES_END - NAMES)
    rom[f(NAMES):f(NAMES) + len(blob)] = blob
    # entries and launch rows
    ent = bytearray(b'\xFF' * (ENTRIES_END - ENTRIES))
    par = bytearray(b'\xFF' * 0x1000)
    for k, g in enumerate(games):
        ent[4 * k:4 * k + 4] = bytes([ptrs[k] & 0xFF, ptrs[k] >> 8, k & 0xFF, k & 0xFF])
        par[8 * k:8 * k + 8] = g['params']
    rom[f(ENTRIES):f(ENTRIES_END)] = ent
    rom[f(PARAMS):f(PARAMS) + 0x1000] = par
    # header: count, rows per page, (1), list position $0805, entries pointer, (2 words kept), index limit
    h = bytearray(rom[f(HEADER):f(HEADER) + 16])
    h[0:4] = n.to_bytes(4, 'little'); h[4] = ROWS
    h[8], h[9] = ENTRIES & 0xFF, ENTRIES >> 8
    h[14], h[15] = n & 0xFF, n >> 8
    rom[f(HEADER):f(HEADER) + 16] = h
    return len(blob)
