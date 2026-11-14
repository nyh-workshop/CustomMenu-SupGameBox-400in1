REGS = {0x2000: 'PPU_CTRL', 0x2001: 'PPU_MASK', 0x2002: 'PPU_STATUS', 0x2003: 'OAM_ADDR',
        0x2004: 'OAM_DATA', 0x2005: 'PPU_SCROLL', 0x2006: 'PPU_ADDR', 0x2007: 'PPU_DATA',
        0x4014: 'OAM_DMA', 0x4015: 'APU_STATUS', 0x4016: 'JOY1', 0x4017: 'JOY2_FRAME',
        0x4100: 'OB_PRG_OUTER_4100', 0x4107: 'OB_PRG_8000', 0x4108: 'OB_PRG_A000',
        0x4109: 'OB_PRG_C000', 0x410A: 'OB_PRG_E000', 0x410B: 'OB_PRG_MODE_410B',
        0x2018: 'OB_CHR_2018', 0x201A: 'OB_CHR_201A', 0x2010: 'OB_VIDEO_2010',
        0x8000: 'MMC3_BANK_SELECT', 0x8001: 'MMC3_BANK_DATA', 0xA000: 'MMC3_MIRRORING', 0xA001: 'MMC3_A001'}
for r in list(range(0x4101, 0x4107)) + list(range(0x410C, 0x4140)) + [0x4034]:
    REGS.setdefault(r, 'REG_%04X' % r)     # meaning NOT assumed for this ROM
for r in range(0x2011, 0x2020):
    REGS.setdefault(r, 'OB_CHR_%04X' % r)
for r in range(0x4000, 0x4014):
    REGS.setdefault(r, 'APU_%04X' % r)
STORES = {'sta', 'stx', 'sty'}
for r in list(range(0x4200, 0x4300)) + list(range(0x4FF0, 0x4FFB)):
    REGS.setdefault(r, 'REG_%04X' % r)   # observed only, meaning not assumed
