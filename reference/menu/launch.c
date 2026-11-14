/* launch.c - from "Start pressed" to the game's reset vector (bank $3D, $A000-$AE30).
 * Reference C translation of src/bank3d.s.
 *
 * Path taken in the menuselect_jumptoapp trace:
 *   state0_step0_main -> relaunch_saved_game ($A000) -> relaunch_prepare ($A220)
 *   -> relaunch_continue ($A8C1) -> launch_game ($A82C) -> ram_stub_game_launch at $0400
 * Registers written by the stub in that trace:
 *   $410B=$05  $4107=$4109=$9C  $4108=$410A=$9D  $2018=$20  $4118=$00  $4100=$10  $201A=$76
 */
#include "hw.h"
#include "ram.h"

extern unsigned char read_pad_0327(void);
extern void set_chr_banks_mmc3(unsigned char base);
extern void relaunch_type_default(void);    /* $A2A4 */
extern void relaunch_type_02(void);         /* $A2EC */
extern void relaunch_type_11(void);         /* $A2C8 */
extern void relaunch_type_12(void);         /* $A310 (also $82 $92 $99 $A9) */
extern void relaunch_type_44(void);         /* $A344 (also $94) */
extern void relaunch_type_54(void);         /* $A368 */
extern void relaunch_type_64(void);         /* $A38C */
extern void relaunch_type_73(void);         /* $A3B0 */

/* ROM tables (labels in src/) */
extern const unsigned char *const tbl_list_order_ptrs[];   /* $CE30 */
extern const unsigned char *const tbl_game_records[400];   /* $E7F1 -> game_rec_NNN (9 bytes) */
extern const unsigned char tbl_list_entries_lo[256][4];    /* $CE7B */
extern const unsigned char tbl_list_entries_hi[244][4];    /* $D27B */
extern const unsigned char tbl_launch_params_b0[];         /* $B000, 8 bytes per row */
extern const unsigned char tbl_launch_params_b8[];         /* $B800 */
extern const unsigned char tbl_reg_pointers[15];           /* $A8B1: 0B 41 1A 20 00 41 18 20 3F 20 30 00 ... */
extern const unsigned char dat_A980[8];                    /* special-case launch params */
extern const unsigned char ram_stub_game_launch_rom[0x61]; /* $AB00, the bytes copied to $0400 */

void relaunch_prepare(void);
void relaunch_continue(void);
void launch_game(void);

/* $A800 */
static void store_069F_06E0(unsigned char a) { game_number_lo = a; RAM8(0x06E0) = a; }

void relaunch_by_game_number(void);

/* $A000 - entered with JMP $A000 from state0_step0_main once Start was pressed.
 * (At power-on $A000 holds bank $33, so this is not the reset path.) */
void relaunch_saved_game(void)
{
    unsigned int off;
    const unsigned char *p;
    do { read_pad_0327(); } while (pad_state);          /* wait for all buttons up */
    PPU_CTRL = 0; PPU_MASK = 0; APU_STATUS = 0;
    /* clear nametables $2000-$3FFF, palette = $0E, CHR-RAM $0000-$1FFF; RAM pages 0-5 and 7
     * (page 6 survives: cursor_row and the list entries live there) */
    /* ... see $A013-$A075 ... */
    off = (unsigned int)(RAM8(0x064D + cursor_row * 2) | (RAM8(0x064E + cursor_row * 2) << 8)) << 2;
    p = tbl_list_order_ptrs[0] + off;                   /* ($CE30) + off */
    store_069F_06E0(p[0]);
    game_number_hi = p[1];
    relaunch_by_game_number();
}

/* $A0BE - also the target of the boot hot-keys in english_menu_start */
void relaunch_by_game_number(void)
{
    unsigned char i;
    const unsigned char *p;
    p = tbl_game_records[game_number_lo | (game_number_hi << 8)];
    for (i = 0; i < 12; ++i) game_rec_copy[i] = p[i];   /* 9-byte record + 3 bytes of the next */
    relaunch_prepare();
    MMC3_MIRRORING = game_rec_copy[8];
    RAM8(0x01E0) = 0x40;
    relaunch_continue();
}

/* $A220 - choose register presets by record byte 3 (mapper/type code).
 * The results land in $0114-$011D; nothing else in this 64 KiB reads them,
 * and $0100-$0107 is overwritten later by prelaunch_mirroring_save_ptrs. */
void relaunch_prepare(void)
{
    unsigned char t = game_rec_copy[3], v;
    switch (t) {
    case 0x02: relaunch_type_02(); break;
    case 0x11: relaunch_type_11(); break;
    case 0x12: case 0x82: case 0x92: case 0x99: case 0xA9: relaunch_type_12(); break;
    case 0x44: case 0x94: relaunch_type_44(); break;
    case 0x54: relaunch_type_54(); break;
    case 0x64: relaunch_type_64(); break;
    case 0x73: relaunch_type_73(); break;
    default:   relaunch_type_default(); break;
    }
    /* $A3D4 */
    v = game_rec_copy[6];
    RAM8(0x011C) = v & 0x0F;
    RAM8(0x0114) |= (v >> 4) & 0x07;
    RAM8(0x0115) |= (v >> 3) & 0x10;
    v = game_rec_copy[7];
    RAM8(0x0115) |= (v << 2) & 0x04;
    RAM8(0x0115) |= (v << 2) & 0x08;
    RAM8(0x0114) |= (v << 2) & 0x30;
    /* $A421 */
    v = game_rec_copy[4];
    RAM8(0x0118) |= (v >> 3) & 0x07;
    RAM8(0x0119) |= (v >> 2) & 0x10;
    RAM8(0x0119) |= (v >> 5) & 0x04;
    RAM8(0x0119) |= (game_rec_copy[5] << 3) & 0x08;
    RAM8(0x0118) |= (game_rec_copy[5] << 3) & 0x30;
    RAM8(0x011B) |= (v << 1) & 0x0E;
}

/* $A8C1 - linear list index = cur_page*10 + cursor_row  (into $18/$19) */
void relaunch_continue(void)
{
    unsigned char n = cur_page[0];
    while (n) { lin_index_lo += 10; --n; }
    lin_index_lo += cursor_row;
    if (cur_page[0] >= 0x19) {               /* page 25+: second half of the list */
        lin_index_hi = 1;
        if (cur_page[0] == 0x19 && lin_index_lo >= 4) lin_index_hi = 0;
    }
    launch_game();
}

/* $AAB1 - entry used by the Chinese menu (its $0408 stub maps PRG $3C-$3F and JMPs here).
 * Same as relaunch_continue, but with the Chinese menu's page ($0375) and row ($03C3). */
void launch_from_chinese_menu(void)
{
    unsigned char n = RAM8(0x0375);
    while (n) { lin_index_lo += 10; --n; }
    lin_index_lo += RAM8(0x03C3);
    if (RAM8(0x0375) >= 0x19) {
        lin_index_hi = 1;
        if (RAM8(0x0375) == 0x19 && lin_index_lo >= 4) lin_index_hi = 0;
    }
    launch_game();
}

/* $AE00 - launch_row_idx = byte 2 of the list entry */
static void fetch_launch_row(void)
{
    /* base $CE7B when lin_index_hi == 0, else $D27B; 4 bytes per entry */
    const unsigned char *e = lin_index_hi ? tbl_list_entries_hi[lin_index_lo] : tbl_list_entries_lo[lin_index_lo];
    launch_row_idx = e[2];
}

/* $A900 + $A91B - copy 8 launch bytes from $B000/$B800 + row*8 to $0480 */
static void copy_launch_params(void)
{
    const unsigned char *t = (lin_index_hi ? tbl_launch_params_b8 : tbl_launch_params_b0)
                             + ((launch_row_idx >> 5) << 8) + ((launch_row_idx << 3) & 0xFF);
    unsigned char x;
    for (x = 0; x < 8; ++x) launch_params[x] = t[x];
}

/* $A940 */
static void select_launch_params(void)
{
    unsigned char x;
    if (lin_index_hi && lin_index_lo >= 0x39) { lin_index_hi = 0; lin_index_lo -= 0x39; }
    fetch_launch_row();
    copy_launch_params();
    /* $A960: one hard-wired override */
    if (lin_index_lo == 0x0C && launch_row_idx == 0x38)
        for (x = 0; x < 8; ++x) launch_params[x] = dat_A980[x];
}

/* $AB75 */
static void prelaunch_mirroring_save_ptrs(void)
{
    unsigned char x;
    MMC3_MIRRORING = (launch_410B & 0x80) ? 1 : 0;
    launch_410B &= 0x7F;
    for (x = 0; x < 8; ++x) game_rec_copy[x] = ((volatile unsigned char *)0xD8)[x];
}

/* $ACA0 */
static void restore_ptrs_silence_apu(void)
{
    unsigned char x;
    for (x = 0; x < 8; ++x) ((volatile unsigned char *)0xD8)[x] = game_rec_copy[x];
    for (x = 0; x < 0x10; ++x) APU_REG(x) = 0;
    set_chr_banks_mmc3(0);
}

/* $A82C */
void launch_game(void)
{
    unsigned char x;
    /* $A880: PPU off, wait for vblank start; $A8A0: tbl_reg_pointers -> $D8..$E6 */
    PPU_CTRL = 0; PPU_MASK = 0;
    while (PPU_STATUS & 0x80) ;
    while (!(PPU_STATUS & 0x80)) ;
    for (x = 0; x < 15; ++x) ((volatile unsigned char *)0xD8)[x] = tbl_reg_pointers[x];
    for (x = 0; x <= 0x60; ++x) ((volatile unsigned char *)0x0400)[x] = ram_stub_game_launch_rom[x];
    select_launch_params();
    prelaunch_mirroring_save_ptrs();
    APU_STATUS = 0;
    restore_ptrs_silence_apu();
    /* JMP $0400 -> ram_stub_game_launch() below */
}

/* $AB00, runs at $0400.  The register addresses come from the pointer table at
 * $D8 ($410B, $201A, $4100, $2018), so they never appear as plain operands. */
void ram_stub_game_launch(void)
{
    unsigned char a = launch_410B;
    *regptr_410B = a;
    if ((a & 0x0F) == 4) {                     /* 32 KiB: four consecutive 8 KiB banks */
        unsigned char x, b = launch_prg_bank;
        for (x = 0; x < 4; ++x) OB_PRG(x) = b++;
    } else {                                   /* 16 KiB mirrored at $8000 and $C000 */
        OB_PRG_8000 = OB_PRG_C000 = launch_prg_bank;
        OB_PRG_A000 = OB_PRG_E000 = (unsigned char)(launch_prg_bank + 1);
    }
    *regptr_2018 = launch_2018 & 0xF0;
    REG_4118 = launch_p0 ? 0x80 : 0x00;
    *regptr_4100 = (unsigned char)((launch_p0 << 3) | launch_outer_lo);
    *regptr_201A = launch_201A;
    /* JMP ($FFFC) - the game's reset vector */
}
