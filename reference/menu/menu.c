/* menu.c - English menu core: main loop, state dispatch, NMI, input.
 * Reference C translation of src/bank3f.s ($FA16-$FB7C) and src/bank3e.s.
 * Routines not translated yet are declared extern with their listing names. */
#include "hw.h"
#include "ram.h"

/* not yet translated (see the .s listings) */
extern void sfx_beep(void);                    /* $A28A: pulse 2 $4004-$4007 = FF AA 78 00 */
extern void cd0c_init_list(void);              /* $CD0C */
extern void draw_screen_by_id(void);           /* $C2C5 via jt $C019 */
extern void redraw_list_page_if_dirty(void);   /* $C562 */
extern void menu_show_cursor(unsigned char x); /* $C266 via jt $C001 (X=1) */
extern void page_forward_n(void);              /* $CA51 */
extern void page_back_n(void);                 /* $CB88 */
extern void cursor_past_bottom_next_page(void);/* $CB18 */
extern void cursor_past_top_prev_page(void);   /* $CC2B */
extern void menu_input_tail_cce0(void);        /* $CCE0 */
extern void menu_input_tail_c619(void);        /* $C619 */
extern void relaunch_saved_game(void);         /* $A000, see launch.c */
extern void nmi_sound_tick(void);              /* $FB72 path when no NMI step */
extern unsigned char read_pad_0327(void);

/* ---- state tables ------------------------------------------------------
 * tbl_menu_states ($C8F6) has one entry, state 0 -> tbl_state0_steps ($C8F8):
 *   step 0: main = state0_step0_main ($C948), nmi = state0_step0_nmi ($C957)
 *   step 1: main = state0_step1_main ($C900), nmi = state0_step1_nmi ($C92E)  (not reached in traces)
 */
typedef struct { void (*main)(void); void (*nmi)(void); } step_t;
void state0_step0_main(void);
void state0_step0_nmi(void);
extern void state0_step1_main(void);
extern void state0_step1_nmi(void);
static const step_t tbl_state0_steps[2] = {
    { state0_step0_main, state0_step0_nmi },
    { state0_step1_main, state0_step1_nmi },
};
static const step_t *const tbl_menu_states[1] = { tbl_state0_steps };

void nmi_handler(void);
static void idle_hook_rts(void) { }

/* $FB0D */
static void init_palette_buffer_0E(void)
{
    unsigned char x;
    for (x = 0; x < 0x22; ++x) palette_buf[x] = 0x0E;
}

/* $FAED */
static void menu_video_init(void)
{
    init_palette_buffer_0E();
    menu_state = 0;
    menu_step = 0;
    RAM8(0x0320) = 0x20;          /* nametable high byte used by print_string_queued */
    ppu_ctrl_shadow = 0x80;       /* NMI on */
    PPU_CTRL = 0x80;
    RAM8(0x0369) = 0x1E;
}

/* $FB1A - run the main handler of the current state/step (JMP ($C5)) */
static void state_dispatch_main(void)
{
    nmi_step_on = 0;
    tbl_menu_states[menu_state][menu_step].main();
}

/* $FA16 */
void menu_main(void)
{
    RAM8(0x0698) = 0;
    idle_hook_ptr = idle_hook_rts;            /* $C8D4 */
    nmi_vector_ptr = nmi_handler;             /* $FA3A */
    menu_video_init();
    for (;;) state_dispatch_main();
}

/* $FB72 */
static void clear_oam_buffer(void)
{
    unsigned char x = 0;
    do { oam_buf[x] = 0xF0; } while (++x);
}

/* $FB40 - NMI side of the state machine */
static void nmi_state_dispatch(void)
{
    if (!nmi_dispatch_on) { clear_oam_buffer(); return; }
    if (!nmi_step_on) return;
    tbl_menu_states[menu_state][menu_step].nmi();   /* JMP ($C0) */
}

/* $FA3A - reached through the NMI vector $FA37: JMP ($D0) */
void nmi_handler(void)
{
    if (nmi_hook_pending) nmi_hook_ptr();     /* $FABF: one-shot PPU job, e.g. nmi_hook_write_string */
    OAM_DMA = 0x02;
    mmc3_set(0, chr_shadow_r0);
    mmc3_set(1, chr_shadow_r1);
    mmc3_set(2, chr_shadow_r2);
    mmc3_set(3, chr_shadow_r3);
    mmc3_set(4, chr_shadow_r4);
    mmc3_set(5, chr_shadow_r5);
    /* $FA9D nmi_set_scroll */
    if (!keep_ppu_addr) { PPU_ADDR = 0; PPU_ADDR = 0; }
    PPU_SCROLL = 0;                           /* ($036B is loaded but not used) */
    PPU_SCROLL = scroll_y_shadow;
    PPU_CTRL = ppu_ctrl_shadow;
    nmi_state_dispatch();
    /* $FAC8 nmi_frame_tail */
    if (!RAM8(0x0337)) RAM8(0x0338) = 0x0F;
    read_pad_0327();
    RAM8(0x0321) = 0;
    ++frame_counter;
    if (++frame_div7 == 7) frame_div7 = 0;
    APU_STATUS = 0x0F;
}

/* $C461 - draw the screen, then loop redrawing the list until Start */
static void menu_run_screen(void)
{
    menu_start_pressed = 0;
    cursor_sprite_inited = 0;
    RAM8(0x036A) = 0;
    draw_screen_by_id();
    sfx_beep();
    nmi_dispatch_on = 1;
    nmi_step_on = 1;
    menu_show_cursor(1);
    do { redraw_list_page_if_dirty(); } while (!menu_start_pressed);
    nmi_step_on = 0;
}

/* $C948 */
void state0_step0_main(void)
{
    screen_id = 0;
    cd0c_init_list();
    menu_run_screen();
    relaunch_saved_game();      /* JMP $A000: launches the game under the cursor */
}

/* $C963 - put the cursor sprite in OAM slot 0 once per screen */
static void menu_update_cursor_sprite(void)
{
    static const unsigned char dat_C9A5[4] = { 0x08, 0x2E, 0x01, 0x00 };  /* y-off, tile, attr, x-off */
    if (cursor_sprite_inited) return;
    cursor_sprite_inited = 0xFF;
    cursor_row = 0;
    oam_buf[0] = (unsigned char)((cursor_y_cell << 3) + dat_C9A5[0]);
    oam_buf[1] = dat_C9A5[1];
    oam_buf[2] = dat_C9A5[2];
    oam_buf[3] = (unsigned char)((cursor_x_cell << 3) + dat_C9A5[3] - 0x0C);
}

/* $C9A9 - pad handling, once per NMI (only on frames where frame_div7 == 0) */
static void menu_handle_input(void)
{
    if (frame_div7 == 0) {
        unsigned char p = pad_state;
        if (p & PAD_UP) {
            sfx_beep();
            if (cursor_row == 0) cursor_past_top_prev_page();
            else --cursor_row;
        } else if (p & PAD_DOWN) {
            sfx_beep();
            if (++cursor_row >= rows_per_page) cursor_past_bottom_next_page();
        } else if (p & PAD_LEFT)  { sfx_beep(); page_step = 1; page_back_n(); }
        else if (p & PAD_RIGHT)   { sfx_beep(); page_step = 1; page_forward_n(); }
        else if (p & PAD_START)   { menu_start_pressed = 0xFF; }
        else if (p & PAD_A)       { sfx_beep(); page_step = 5; page_forward_n(); }
        else if (p & PAD_B)       { sfx_beep(); page_step = 5; page_back_n(); }
    }
    /* $CA4A menu_input_tail */
    menu_input_tail_cce0();
    menu_input_tail_c619();
}

/* $C957 */
void state0_step0_nmi(void)
{
    menu_update_cursor_sprite();
    if (!list_dirty) menu_handle_input();
}
