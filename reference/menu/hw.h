/* hw.h - hardware registers used by the Sup 400-in-1 menu (cc65 style).
 *
 * Known: NES PPU/APU, OneBus PRG banking ($4100, $4107-$410B), OneBus CHR
 * registers ($2010-$201A) and the MMC3-compatible $8000/$8001/$A000 interface.
 * Everything else in $41xx is written with the values observed in the ROM and
 * the FCEUX traces only.  Do not assume the 500-in-1 meaning for those.
 */
#ifndef HW_H
#define HW_H

#define REG8(a)   (*(volatile unsigned char *)(a))

/* NES */
#define PPU_CTRL     REG8(0x2000)
#define PPU_MASK     REG8(0x2001)
#define PPU_STATUS   REG8(0x2002)
#define PPU_SCROLL   REG8(0x2005)
#define PPU_ADDR     REG8(0x2006)
#define PPU_DATA     REG8(0x2007)
#define OAM_DMA      REG8(0x4014)
#define APU_STATUS   REG8(0x4015)
#define JOY1         REG8(0x4016)
#define APU_REG(n)   REG8(0x4000 + (n))

/* OneBus PRG banking (8 KiB banks of the 512 KiB dump: bank = file offset / 0x2000) */
#define OB_PRG_OUTER   REG8(0x4100)
#define OB_PRG_8000    REG8(0x4107)
#define OB_PRG_A000    REG8(0x4108)
#define OB_PRG_C000    REG8(0x4109)
#define OB_PRG_E000    REG8(0x410A)
#define OB_PRG_MODE    REG8(0x410B)
#define OB_PRG(n)      REG8(0x4107 + (n))

/* OneBus CHR / video */
#define OB_CHR_2018    REG8(0x2018)
#define OB_CHR_201A    REG8(0x201A)

/* MMC3-compatible interface (R0-R5 CHR, R6/R7 PRG $8000/$A000) */
#define MMC3_BANK_SELECT REG8(0x8000)
#define MMC3_BANK_DATA   REG8(0x8001)
#define MMC3_MIRRORING   REG8(0xA000)

/* $41xx registers whose meaning is NOT assumed for this ROM */
#define REG_4118  REG8(0x4118)   /* launch: $80 when launch_p0 != 0, else $00 */
#define REG_411C  REG8(0x411C)   /* reset: $05 */
#define REG_412B  REG8(0x412B)
#define REG_412C  REG8(0x412C)
#define REG_412D  REG8(0x412D)   /* reset: $DC; also bit-banged by bank $15 */
#define REG_4134  REG8(0x4134)   /* reset: $D0 */
#define REG_4137  REG8(0x4137)   /* reset: $81 */
#define REG_4138  REG8(0x4138)   /* reset: $0B */
#define REG_4139  REG8(0x4139)   /* reset: $02; also bit-banged by bank $15 */
#define REG_413F  REG8(0x413F)

/* Pad bits as stored in pad_state ($0327) by read_pad_0327 */
#define PAD_A      0x80
#define PAD_B      0x40
#define PAD_SELECT 0x20
#define PAD_START  0x10
#define PAD_UP     0x08
#define PAD_DOWN   0x04
#define PAD_LEFT   0x02
#define PAD_RIGHT  0x01

static void mmc3_set(unsigned char reg, unsigned char val)
{
    MMC3_BANK_SELECT = reg;
    MMC3_BANK_DATA = val;
}

#endif
