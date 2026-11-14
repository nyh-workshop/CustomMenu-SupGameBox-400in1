"""Music and sound effects for the 400-in-1 English list.

The English menu has no music player.  This copies the sound driver of the Chinese menu (code, tables, effects and its
song, CPU $E34A-$F4B1 = file 0x3E34A-0x3F4B1) to $8000 of bank $38 (file 0x70000), relocated:
  zero page $CE-$FF -> $3E-$6F, RAM $0300-$035B -> $0700-$075B, its own ROM addresses -> +($8000-$E34A).
The English NMI (`lda #$0F / sta $4015` at $FA92) becomes JSR $E220, a routine in a free part of bank $3F that maps
banks $38/$39 at $8000/$A000 (via $410B = 0), runs the driver, and restores $3C/$3D/$410B=4.
All addresses were checked against the English menu's RAM use (traces + static code): none of these are used there.
"""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..', 'tools'))   # op6502.py
from op6502 import OPS, MODES_LEN

SRC_LO, SRC_HI = 0xE34A, 0xF4B2            # copied block (CPU addresses in the Chinese block, $E000 = file 0x3E000)
CODE_HI = 0xEB27                           # driver code ends here (credit string and tables follow)
SRC_FILE = 0x3E000
NEW_BASE = 0x8000
DELTA = NEW_BASE - SRC_LO
BANK8, BANKA = 0x38, 0x39                  # mapped at $8000 / $A000 while the driver runs
BANK8_FILE = 0x70000
AREA_END = 0xC000                          # songs may use $8000-$BFFF (banks $38 + $39)
ZP_LO, ZP_HI, ZP_DELTA = 0xCE, 0xFF, -0x90
RAM_LO, RAM_HI, RAM_DELTA = 0x0300, 0x035B, 0x0400
V_INIT, V_SFX = 0x0760, 0x0761             # our two flags (RAM page 7, cleared by the menu at power-on)
NMI_HOOK = 0xFA92                          # English NMI: lda #$0F / sta $4015
NMI_CODE = 0xE220                          # free $FF run in bank $3F, 96 bytes (file 0x7E220)
NMI_CODE_FILE = 0x7E220
SFX_BEEP = 0xA28A                          # English sfx_beep (bank $3D, file 0x7A28A), 21 bytes
CURSOR_ID = 4


def R(a): return a + DELTA if SRC_LO <= a < SRC_HI else a
ENTRY = dict(sound_tick=R(0xE34A), sound_play=R(0xE351), sound_init=R(0xE379), start_song=R(0xE3A1),
             sfx_tick=R(0xE4BA), music_tick=R(0xE699), read_header=R(0xE722), continue_read=R(0xE8D2),
             ad_handler=R(0xE8BF), song_cnt=R(0xEFB9), song_ptr=R(0xEFBF), sfx_tbl=R(0xED69), credit=R(0xEB27))
SFX_AREA = (R(0xEDBF), R(0xEFB9))
SONG_FREE = SRC_HI + DELTA                  # first byte after the copied block


def relocate(rom):
    """-> bytearray of the relocated block (CPU $8000-...)"""
    src = rom[SRC_FILE + SRC_LO - 0xE000:SRC_FILE + SRC_HI - 0xE000]
    out = bytearray(src)
    a = SRC_LO
    while a < CODE_HI:                       # the driver code is one contiguous run of instructions
        i = a - SRC_LO
        op = src[i]; mn, md = OPS[op]; L = MODES_LEN[md]
        if md in ('zp', 'zpx', 'zpy', 'izx', 'izy'):
            v = src[i + 1]
            if ZP_LO <= v <= ZP_HI: out[i + 1] = v + ZP_DELTA
        elif md in ('abs', 'abx', 'aby', 'ind'):
            v = src[i + 1] | src[i + 2] << 8
            if RAM_LO <= v <= RAM_HI: v += RAM_DELTA
            elif SRC_LO <= v < SRC_HI: v += DELTA
            elif v < 0x100 or (0x4000 <= v <= 0x4017) or v in (0x0080, 0x0081): pass
            else: raise ValueError('unexpected operand $%04X at $%04X' % (v, a))
            out[i + 1] = v & 0xFF; out[i + 2] = v >> 8
        a += L
    assert a == CODE_HI
    def fixptr(cpu):
        i = cpu - SRC_LO; v = out[i] | out[i + 1] << 8
        if SRC_LO <= v < SRC_HI: v += DELTA
        out[i] = v & 0xFF; out[i + 1] = v >> 8
    for k in range(43): fixptr(0xED69 + 2 * k)                  # effect pointers
    for k in range(3): fixptr(0xEFBF + 2 * k)                   # song record pointers
    for k in range(4): fixptr(0xEFC5 + 4 * k + 2)               # song 0 track pointers
    return out


def ad_fix_code(at):
    """the driver's AD command (new block) with a non-zero argument overwrites $D1 (here $41) while still reading through
    ($D0); reload the pointer = new base - 1, Y = 0, then continue at iny / jmp read"""
    r = RAM_LO + RAM_DELTA; hdr = ENTRY['read_header']; cont = ENTRY['continue_read']
    zp0 = 0xD0 + ZP_DELTA
    return bytes([0xD0, 0x03, 0x4C, hdr & 0xFF, hdr >> 8,
                  0xBD, (r + 2) & 0xFF, (r + 2) >> 8, 0x38, 0xE9, 0x01, 0x85, zp0,
                  0xBD, (r + 3) & 0xFF, (r + 3) >> 8, 0xE9, 0x00, 0x85, zp0 + 1,
                  0xA0, 0x00, 0x4C, cont & 0xFF, cont >> 8])


def nmi_code(loop):
    e = ENTRY; r = RAM_LO + RAM_DELTA
    c = bytearray([0xA9, 0x00, 0x8D, 0x0B, 0x41,            # $410B = 0: $8000/$A000 can hold any bank of the first 512 KiB
                   0xA9, BANK8, 0x8D, 0x07, 0x41,
                   0xA9, BANKA, 0x8D, 0x08, 0x41,
                   0xAD, V_INIT & 0xFF, V_INIT >> 8, 0xD0, 0x06,
                   0x20, e['sound_init'] & 0xFF, e['sound_init'] >> 8,
                   0xEE, V_INIT & 0xFF, V_INIT >> 8,
                   0xAD, V_SFX & 0xFF, V_SFX >> 8, 0x10, 0x0C,       # no effect pending: skip the next 12 bytes
                   0x29, 0x7F, 0x85, 0xDB + ZP_DELTA,
                   0xA9, 0x00, 0x8D, V_SFX & 0xFF, V_SFX >> 8,
                   0x20, e['sound_play'] & 0xFF, e['sound_play'] >> 8,
                   0x20, e['sfx_tick'] & 0xFF, e['sfx_tick'] >> 8,
                   0x20, e['music_tick'] & 0xFF, e['music_tick'] >> 8])
    if loop:                                                  # restart the song when all 4 tracks have ended
        c += bytes([0xAD, r & 0xFF, r >> 8, 0x2D, (r + 0x15) & 0xFF, (r + 0x15) >> 8,
                    0x2D, (r + 0x2A) & 0xFF, (r + 0x2A) >> 8, 0x2D, (r + 0x3F) & 0xFF, (r + 0x3F) >> 8,
                    0xC9, 0xFF, 0xD0, 0x03, 0x20, e['start_song'] & 0xFF, e['start_song'] >> 8])
    c += bytes([0xA9, 0x3C, 0x8D, 0x07, 0x41, 0xA9, 0x3D, 0x8D, 0x08, 0x41, 0xA9, 0x04, 0x8D, 0x0B, 0x41, 0x60])
    assert c[18:20] == bytes([0xD0, 0x06]) and c[29:31] == bytes([0x10, 0x0C]) and c[43] == 0x20   # branch targets
    assert len(c) <= 96, len(c)
    return bytes(c)


def install(rom, song_tracks=None, loop=True, cursor_record=None, log=print):
    """rom: bytearray (512 KiB menu region or a full image).  song_tracks: None = the original Chinese-menu song,
    [] = silence, or 4 track byte strings from menu_music.convert_song.  cursor_record: None = the original
    effect #4, b'' = no cursor sound, or a record from menu_music.build_sfx_record."""
    blk = relocate(rom)
    f8 = lambda cpu: BANK8_FILE + cpu - 0x8000                  # $8000-$BFFF = file 0x70000-0x73FFF
    area = bytearray(b'\xFF' * (AREA_END - NEW_BASE))
    area[:len(blk)] = blk
    def put(cpu, data):
        assert NEW_BASE <= cpu and cpu + len(data) <= AREA_END, hex(cpu)
        area[cpu - NEW_BASE:cpu - NEW_BASE + len(data)] = data
    free = SONG_FREE
    fix = ad_fix_code(free); fix_at = free; put(fix_at, fix); free += len(fix)
    ad = ENTRY['ad_handler']
    put(ad, bytes([0x68, 0x4C, fix_at & 0xFF, fix_at >> 8, 0xEA, 0xEA]))
    what = 'original (the Chinese menu song)'
    if song_tracks is not None:
        if not song_tracks:
            silent = bytes([0x81, 0x00, 0x10, 0x00, 0xFF, 0x00])
            song_tracks = [silent]; loop = False; what = 'none'
        else:
            what = 'MIDI, %s' % ', '.join('%d' % len(t) for t in song_tracks) + ' bytes per voice'
        recs_at = free; free += 4 * len(song_tracks)
        recs = bytearray()
        for k, t in enumerate(song_tracks):
            if free + len(t) > AREA_END:
                raise ValueError('the English-list song does not fit: %d bytes free at $%04X-$BFFF' % (AREA_END - recs_at, recs_at))
            put(free, t); recs += bytes([0x15 * k, k, free & 0xFF, free >> 8]); free += len(t)
        put(recs_at, bytes(recs))
        put(ENTRY['song_cnt'], bytes([len(song_tracks) - 1, 0]))
        put(ENTRY['song_ptr'], bytes([recs_at & 0xFF, recs_at >> 8]))
    if cursor_record is not None and cursor_record != b'':
        a, b = SFX_AREA
        if len(cursor_record) > b - a: raise ValueError('cursor effect too big')
        put(a, b'\xFF' * (b - a)); put(a, cursor_record)
        for k in range(43): put(ENTRY['sfx_tbl'] + 2 * k, bytes([a & 0xFF, a >> 8]))
    rom[BANK8_FILE:BANK8_FILE + len(area)] = area
    # the English menu side
    code = nmi_code(loop)
    if any(b != 0xFF for b in rom[NMI_CODE_FILE:NMI_CODE_FILE + 96]):
        raise ValueError('the NMI sound routine area 0x%05X is not free' % NMI_CODE_FILE)
    rom[NMI_CODE_FILE:NMI_CODE_FILE + len(code)] = code
    hf = 0x7E000 + NMI_HOOK - 0xE000
    assert bytes(rom[hf:hf + 5]) == bytes([0xA9, 0x0F, 0x8D, 0x15, 0x40]), 'English NMI changed'
    rom[hf:hf + 5] = bytes([0x20, NMI_CODE & 0xFF, NMI_CODE >> 8, 0xEA, 0xEA])
    bf = 0x7A000 + SFX_BEEP - 0xA000
    assert bytes(rom[bf:bf + 5]) == bytes([0xA9, 0xFF, 0x8D, 0x04, 0x40]), 'English sfx_beep changed'
    if cursor_record == b'':
        rom[bf:bf + 21] = bytes([0x60]) + b'\xFF' * 20
    else:
        rom[bf:bf + 21] = bytes([0xA9, 0x80 | CURSOR_ID, 0x8D, V_SFX & 0xFF, V_SFX >> 8, 0x60]) + b'\xFF' * 15
    used = free - NEW_BASE
    log('  sound: driver + data $8000-$%04X in banks $38/$39 (file 0x70000-0x%05X), %d bytes free; song: %s%s; cursor: %s'
        % (free - 1, f8(free - 1), AREA_END - free, what, ', loops' if loop else '',
           'original effect' if cursor_record is None else ('none' if cursor_record == b'' else 'custom, %d bytes' % len(cursor_record))))
    return dict(used=used, free=AREA_END - free)
