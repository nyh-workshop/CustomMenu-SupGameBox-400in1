/* boot.c - reset path of the 400-in-1 (bank $3F at $E000, bank $3D at $A000).
 *
 * Reference C translation of the 6502 code in src/bank3f.s / src/bank3d.s.
 * It mirrors the original control flow and register writes in order; it is
 * meant for reading and for a custom rewrite, not to rebuild identical bytes
 * (that is what the src/ listings are for).
 *
 * Power-on order seen in all four FCEUX traces:
 *   $E7E0 -> $FFD9 reset_early_init -> $FEF5 reset_main_init
 *   -> bank $33 ($A000, file 0x66000)          [not in this 64 KiB]
 *   -> $FFB0: PRG $14/$15, bank $15 ($A000, file 0x2A000), bit-bangs $412D/$4139/$410F
 *   -> run_ram_stub_boot_select ($FF60 -> $0400)
 *        A+B held  -> support/test app (ram_stub_support_app)
 *        otherwise -> PRG $34-$37, JMP $E000 = language select (file 0x68000-0x6FFFF)
 *   -> language select copies a stub to $0400:
 *        English: $410B=4, PRG $3C-$3F, JMP $FB7D english_menu_entry   (this file)
 *        Chinese: $410B=1, PRG $1C-$1F, $2018=$201A=0, JMP ($FFFC) -> $F9EE (file 0x38000)
 */
#include "hw.h"
#include "ram.h"

void set_chr_banks_mmc3(unsigned char base);   /* $A9E0 */
void menu_main(void);                          /* $FA16, see menu.c */
void relaunch_by_game_number(void);            /* $A0BE, see launch.c */
unsigned char read_pad_0327(void);             /* $C01F */

/* $FFD9 - first code after the JMP chain $E7E0->$E7E3->$E7E6->$E7E9->$FFD0->...->$FFD9 */
void reset_early_init(void)
{
    REG_4134 = 0xD0;
    REG_412D = 0xDC;
    REG_4137 = 0x81;
    REG_411C = 0x05;
    /* falls into reset_main_init ($FEF5) */
}

/* $FEF5 */
void reset_main_init(void)
{
    unsigned char i;
    /* SEI; CLD */
    REG_4138 = 0x0B;
    REG_4139 = 0x02;
    PPU_CTRL = 0;
    PPU_MASK = 0;
    OB_PRG_8000 = 0x3C;
    OB_PRG_A000 = 0x3D;
    set_chr_banks_mmc3(0);
    /* $FF40 fill_palette_0F */
    PPU_ADDR = 0x3F; PPU_ADDR = 0x00;
    for (i = 0; i < 0x20; ++i) PPU_DATA = 0x0F;
    /* $FF30: MMC3 R7 = $33 -> $A000 now shows bank $33 (file 0x66000), then JMP $A000 */
    mmc3_set(7, 0x33);
    /* JMP $A000  (continues outside this file) */
}

/* $A9E0 - CHR banks via MMC3 R0..R5: R0=b*8, R1=b*8+2, R2..R5=b*8+4..+7 */
void set_chr_banks_mmc3(unsigned char base)
{
    unsigned char a = base << 3, x;
    for (x = 0; x < 2; ++x) { mmc3_set(x, a); a += 2; }
    for (x = 2; x < 6; ++x) { mmc3_set(x, a); a += 1; }
}

/* $FFB0 - run the bank $15 code at $A000 (most likely the TFT/LCD init; it
 * bit-bangs $412D/$4139/$410F, cf. the 500-in-1 TFT driver) */
void jump_bank15(void)
{
    OB_PRG_8000 = 0x14;
    OB_PRG_A000 = 0x15;
    /* JMP $A000 */
}

/* $AA40 - pad 1 into $22 (held) and $23 (newly pressed) */
void read_pad_edge(void)
{
    unsigned char x, held = 0, prev;
    JOY1 = 1; JOY1 = 0;
    for (x = 8; x; --x) held = (unsigned char)((held << 1) | (JOY1 & 1));
    prev = pad_held_aa40;
    pad_new_aa40 = (unsigned char)((held ^ prev) & held);
    pad_held_aa40 = held;
}

/* $AA60 - A+B held ($C0) at boot: copy ram_stub_support_app ($AA78) to $0400 and run it.
 * The stub writes: $4100=0 $410B=4 $4109=$36 $410A=$37 $2018=$10 $201A=$A6
 *                  $413F=$1F $4138=$0B $4139=$0F, then JMP ($FFFC)
 * (the test-app trace then runs file 0x6A000-0x6BFFF). */
void check_AB_support_app(void)
{
    read_pad_edge();
    if (pad_held_aa40 != 0xC0) return;
    /* copy $AA78..$AAA8 to $0400, JMP $0400 */
}

/* $FF70 stub, run at $0400 by run_ram_stub_boot_select ($FF60) */
void ram_stub_boot_select(void)
{
    OB_PRG_MODE = 0x04;
    OB_PRG_8000 = 0x3C; OB_PRG_A000 = 0x3D; OB_PRG_C000 = 0x3E; OB_PRG_E000 = 0x3F;
    check_AB_support_app();          /* does not return if A+B */
    OB_PRG_8000 = 0x34; OB_PRG_A000 = 0x35; OB_PRG_C000 = 0x36; OB_PRG_E000 = 0x37;
    /* JMP $E000 -> language select program (file 0x6E000) */
}

/* $F9C0 - English menu start after english_menu_entry ($FB7D) has copied
 * ram_stub_0200_chr_setup ($FB8C) to $0200 and run it ($2018=$10, $201A=$8E,
 * set_chr_banks_mmc3(0), then JMP $FF1C -> check_AB_support_app -> $F935).
 * $F935 clears RAM and reaches this point. */
void english_menu_start(void)
{
    mmc3_set(6, 0x3C);
    mmc3_set(7, 0x3D);
    read_pad_0327();
    /* Hidden hot-keys held while the English menu starts (static code, not in the traces):
     * jump straight to a fixed game number through the relaunch path. */
    if (pad_state == (PAD_A | PAD_SELECT))     { game_number_lo = 0x05; game_number_hi = 0; relaunch_by_game_number(); }
    if (pad_state == (PAD_B | PAD_SELECT))     { game_number_lo = 0x30; game_number_hi = 0; relaunch_by_game_number(); }
    if (pad_state == (PAD_SELECT | PAD_START)) { game_number_lo = 0x9D; game_number_hi = 0; relaunch_by_game_number(); }
    menu_state = 0;
    menu_step = 0;
    menu_main();
}
