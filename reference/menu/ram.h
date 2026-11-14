/* ram.h - menu RAM variables (same names as src/ram.inc).
 * Names describe how the code uses each location; see README_Claude.md. */
#ifndef RAM_H
#define RAM_H

#define RAM8(a)  (*(volatile unsigned char *)(a))
#define RAMP(a)  (*(void (**)(void))(a))

/* zero page */
#define pad_held_aa40      RAM8(0x22)
#define pad_new_aa40       RAM8(0x23)
#define nmi_hook_ptr       RAMP(0xB0)   /* JMP ($B0) when nmi_hook_pending */
#define frame_counter      RAM8(0xC2)
#define nmi_vector_ptr     RAMP(0xD0)   /* NMI vector does JMP ($D0) */
#define idle_hook_ptr      RAMP(0xD4)
/* $D8-$E6: register pointer table copied from tbl_reg_pointers ($A8B1) */
#define regptr_410B        (*(volatile unsigned char **)0xD8)
#define regptr_201A        (*(volatile unsigned char **)0xDA)
#define regptr_4100        (*(volatile unsigned char **)0xDC)
#define regptr_2018        (*(volatile unsigned char **)0xDE)
#define lin_index_lo       RAM8(0x18)   /* page*10 + row, built by relaunch_continue */
#define lin_index_hi       RAM8(0x19)
#define launch_row_idx     RAM8(0x28)   /* row number in tbl_launch_params */

/* $0100 page: 12-byte game record copy, later reused as scratch */
#define game_rec_copy      ((volatile unsigned char *)0x0100)

/* page 2: OAM buffer ($0200-$02FF) */
#define oam_buf            ((volatile unsigned char *)0x0200)

#define nmi_hook_pending   RAM8(0x0322)
#define pad_state          RAM8(0x0327)
#define chr_shadow_r2      RAM8(0x032D)
#define chr_shadow_r3      RAM8(0x032E)
#define chr_shadow_r4      RAM8(0x032F)
#define chr_shadow_r5      RAM8(0x0330)
#define chr_shadow_r0      RAM8(0x0332)
#define chr_shadow_r1      RAM8(0x0333)
#define screen_id          RAM8(0x035B)
#define menu_state         RAM8(0x035C)
#define menu_step          RAM8(0x035D)
#define nmi_dispatch_on    RAM8(0x035E)
#define menu_start_pressed RAM8(0x035F)
#define cursor_sprite_inited RAM8(0x0360)
#define frame_div7         RAM8(0x0362)
#define nmi_step_on        RAM8(0x0363)
#define ppu_ctrl_shadow    RAM8(0x0368)
#define scroll_y_shadow    RAM8(0x036C)
#define palette_buf        ((volatile unsigned char *)0x036E)  /* 0x22 bytes */
#define keep_ppu_addr      RAM8(0x03D0)

/* launch parameters read by ram_stub_game_launch ($0400) */
#define launch_p0          RAM8(0x0480)
#define launch_201A        RAM8(0x0482)
#define launch_prg_bank    RAM8(0x0483)
#define launch_outer_lo    RAM8(0x0484)
#define launch_2018        RAM8(0x0485)
#define launch_410B        RAM8(0x0486)
#define launch_params      ((volatile unsigned char *)0x0480)

/* page 6 is NOT cleared by relaunch_saved_game: it carries menu state */
#define cursor_x_cell      RAM8(0x0606)
#define cursor_y_cell      RAM8(0x0607)
#define last_page          ((volatile unsigned char *)0x0610)  /* 32-bit */
#define cur_page           ((volatile unsigned char *)0x0618)  /* 32-bit */
#define page_step          RAM8(0x0625)
#define rows_per_page      RAM8(0x0649)
#define draw_row           RAM8(0x064A)
#define cursor_row         RAM8(0x064B)
#define list_dirty         RAM8(0x064C)
#define game_number_lo     RAM8(0x069F)
#define game_number_hi     RAM8(0x06A0)

#endif
