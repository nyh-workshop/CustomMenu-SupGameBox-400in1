"""OneBus helpers for the Sup 400-in-1 English menu: iNES parsing, padding, and the 8 launch bytes per game.

The menu's launch stub (bank $3D, `ram_stub_game_launch` $AB00, run from $0400) reads 8 bytes p0-p7 (from the launch
table at $B000 + 8*row, copied to $0480-$0487) and writes:
  MMC3 $A000 (mirroring)  = p6 bit 7          (0 = vertical, 1 = horizontal)
  $410B                   = p6 & $7F           (PRG window size)
  $4107-$410A             = p3, p3+1, p3+2, p3+3      if (p6 & $0F) == 4
                            p3, p3+1, p3, p3+1        otherwise
  $2018                   = p5 & $F0           (CHR 256 KiB block inside the 2 MiB block)
  $4118                   = $80 if p0 != 0     (CHR-RAM, as in the original cartridge)
  $4100                   = (p0 << 3) | p4     (bits 4-6 PRG 2 MiB block, bits 0-2 CHR 2 MiB block)
  $201A                   = p2                 (CHR window: bits 0-2 mode, high bits base)
  CHR R0-R5               = 0, 2, 4, 5, 6, 7   (set_chr_banks_mmc3 with A = 0)
then JMP ($FFFC).  p1 and p7 are not read."""
KB = 1024
PRG_MASK = [0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01, 0x00, 0xFF]
CHR_MASKS = {0: (0xFF, 0x00), 1: (0x7F, 0x80), 2: (0x3F, 0xC0), 4: (0x1F, 0xE0), 5: (0x0F, 0xF0), 6: (0x07, 0xF8),
             3: (0xFF, 0x00), 7: (0xFF, 0x00)}
PRG_MODE = {16 * KB: 0x05, 32 * KB: 0x04, 64 * KB: 0x03, 128 * KB: 0x02, 256 * KB: 0x01, 512 * KB: 0x00}
CHR_MODE = {8 * KB: 0x06, 16 * KB: 0x05, 32 * KB: 0x04, 64 * KB: 0x02, 128 * KB: 0x01, 256 * KB: 0x00}


class NesError(Exception):
    pass


class Nes:
    """an iNES / NES 2.0 file"""
    def __init__(s, data, name='?'):
        if len(data) < 16 or data[:4] != b'NES\x1a':
            raise NesError('%s: not an iNES file (no "NES<1A>" header)' % name)
        h = data[:16]
        s.nes2 = (h[7] & 0x0C) == 0x08
        prg_n, chr_n = h[4], h[5]
        if s.nes2:
            prg_n |= (h[9] & 0x0F) << 8; chr_n |= (h[9] & 0xF0) << 4
        s.mapper = (h[6] >> 4) | (h[7] & 0xF0) | ((h[8] & 0x0F) << 8 if s.nes2 else 0)
        s.mirror = 'V' if h[6] & 1 else 'H'           # iNES bit 0: 1 = vertical arrangement
        s.four_screen = bool(h[6] & 8)
        s.battery = bool(h[6] & 2)
        off = 16 + (512 if h[6] & 4 else 0)
        s.prg = bytes(data[off:off + prg_n * 16 * KB]); off += prg_n * 16 * KB
        s.chr = bytes(data[off:off + chr_n * 8 * KB])
        if len(s.prg) != prg_n * 16 * KB: raise NesError('%s: file is shorter than its header says (PRG)' % name)
        if len(s.chr) != chr_n * 8 * KB: raise NesError('%s: file is shorter than its header says (CHR)' % name)
        if not s.prg: raise NesError('%s: no PRG-ROM' % name)


def pow2_at_least(n, lo):
    p = lo
    while p < n: p <<= 1
    return p


def pad_pow2(data, lo):
    """pad to a power of two; the padding repeats the END of the data so MMC3's fixed last banks stay last."""
    size = pow2_at_least(len(data), lo)
    if size == len(data): return data
    if len(data) < lo:
        return (data * (size // len(data) + 1))[:size] if size % len(data) == 0 else data + b'\xFF' * (size - len(data))
    need = size - len(data)
    out = data + data[-need:]
    assert len(out) == size and out[-0x2000:] == data[-0x2000:]
    return out


def encode(prg_at, prg_size, chr_at, chr_size, mirror, chr_ram):
    """flash addresses -> the 8 launch bytes"""
    if prg_size not in PRG_MODE: raise ValueError('PRG size %d KiB not supported' % (prg_size // KB))
    if prg_at % prg_size: raise ValueError('PRG address 0x%X not aligned to its size' % prg_at)
    mode = PRG_MODE[prg_size]
    outer_prg = prg_at // 0x200000
    bank = (prg_at % 0x200000) // 0x2000
    if outer_prg > 7: raise ValueError('PRG beyond 16 MiB')
    if chr_ram:
        p2, p5, outer_chr, p0 = 0x06, 0x00, 0, 1
    else:
        if chr_size not in CHR_MODE: raise ValueError('CHR size %d KiB not supported' % (chr_size // KB))
        if chr_at % chr_size: raise ValueError('CHR address 0x%X not aligned to its size' % chr_at)
        c = chr_at // 0x400
        outer_chr = c >> 11
        if outer_chr > 7: raise ValueError('CHR beyond 16 MiB')
        cm = CHR_MODE[chr_size]; im, mm = CHR_MASKS[cm]
        p2 = (c & 0xFF & mm) | cm
        p5 = ((c >> 8) & 7) << 4
        p0 = 0
    p4 = (outer_prg << 4) | outer_chr
    p6 = mode | (0x80 if mirror == 'H' else 0)
    p = bytes([p0, 0, p2, bank, p4, p5, p6, 0])
    return p


def stub_registers(p):
    """what the launch stub writes for the 8 bytes (register -> value)"""
    r = {}
    r['mirror'] = 1 if p[6] & 0x80 else 0
    r[0x410B] = p[6] & 0x7F
    if (p[6] & 0x0F) == 4:
        r[0x4107], r[0x4108], r[0x4109], r[0x410A] = [(p[3] + k) & 0xFF for k in range(4)]
    else:
        r[0x4107] = r[0x4109] = p[3]; r[0x4108] = r[0x410A] = (p[3] + 1) & 0xFF
    r[0x2018] = p[5] & 0xF0
    r[0x4118] = 0x80 if p[0] else 0
    r[0x4100] = ((p[0] << 3) | p[4]) & 0xFF
    r[0x201A] = p[2]
    r['chr_regs'] = [0, 2, 4, 5, 6, 7]                    # R0-R5 -> $2016, $2017, $2012-$2015
    return r


def decode(p):
    """the 8 bytes -> (PRG file offsets of $8000/$A000/$C000/$E000, CHR file offsets of the 8 1 KiB PPU banks or None
    for CHR-RAM, mirroring 'V'/'H'), computed with the OneBus rules exactly as the chip would after the stub."""
    r = stub_registers(p)
    m = PRG_MASK[r[0x410B] & 7]
    def bank(inner): return ((inner & m) | (r[0x410A] & ~m & 0xFF) | ((r[0x4100] >> 4) << 8))
    c000 = r[0x4109] if r[0x410B] & 0x40 else 0xFE
    prg = [bank(v) * 0x2000 for v in (r[0x4107], r[0x4108], c000, 0xFF)]
    if r[0x4118] & 0x80:
        chr_ = None
    else:
        im, mm = CHR_MASKS[r[0x201A] & 7]
        base = ((r[0x4100] & 0x0F) << 11) | (((r[0x2018] >> 4) & 7) << 8)
        c = r['chr_regs']
        inner = [c[0] & 0xFE, c[0] | 1, c[1] & 0xFE, c[1] | 1, c[2], c[3], c[4], c[5]]
        chr_ = [(base | (v & im) | (r[0x201A] & mm)) * 0x400 for v in inner]
    return prg, chr_, 'H' if r['mirror'] else 'V'


def expected_maps(prg_at, prg_size, chr_at, chr_ram):
    """where a NROM / MMC3 game's banks must be at power-on"""
    n = prg_size // 0x2000
    banks = [0, 1, 0, 1] if n == 2 else [0, 1, n - 2, n - 1]
    prg = [prg_at + b * 0x2000 for b in banks]
    chr_ = None if chr_ram else [chr_at + k * 0x400 for k in range(8)]
    return prg, chr_


def check_roundtrip(p, prg_at, prg_size, chr_at, chr_ram, mirror, mapper):
    prg, chr_, mir = decode(p)
    eprg, echr = expected_maps(prg_at, prg_size, chr_at, chr_ram)
    if prg != eprg or chr_ != echr or (mapper == 0 and mir != mirror):
        raise AssertionError('launch bytes %s decode to PRG %s CHR %s %s; expected PRG %s CHR %s %s' % (
            p.hex(' '), [hex(x) for x in prg], chr_ and [hex(x) for x in chr_], mir, [hex(x) for x in eprg],
            echr and [hex(x) for x in echr], mirror))
