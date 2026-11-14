/* menu_cn.c - Chinese menu core (banks $1C-$1F, file 0x38000-0x3FFFF).
 * Reference C translation of src/bank1f.s / src/bank1e.s; it mirrors the original
 * order of register writes but is not meant to rebuild identical bytes.
 *
 * Entered from the language-select stub at $0400:
 *   $410B=1, $4107-$410A = $1C-$1F, $2018=$201A=0, JMP ($FFFC) -> reset ($F9EE)
 * With $410B=1 the inner bank mask is $1F, so $4107 = $38..$3C selects banks
 * $18..$1C (file 0x30000-0x39FFF) at $8000.
 */
#define REG8(a) (*(volatile unsigned char *)(a))
#define PPU_CTRL   REG8(0x2000)
#define PPU_MASK   REG8(0x2001)
#define PPU_STATUS REG8(0x2002)
#define OAM_ADDR   REG8(0x2003)
#define PPU_SCROLL REG8(0x2005)
#define OAM_DMA    REG8(0x4014)
#define JOY2_FRAME REG8(0x4017)
#define OB_VIDEO_2010 REG8(0x2010)
#define OB_CHR(n)  REG8(0x2012 + (n))      /* $2012-$2017 */
#define OB_PRG_8000 REG8(0x4107)
#define REG_4034   REG8(0x4034)            /* observed: 0 every NMI; meaning not assumed */
#define REG_4101   REG8(0x4101)
#define REG_4102   REG8(0x4102)
#define REG_4103   REG8(0x4103)
#define REG_4104   REG8(0x4104)
#define REG_4119   REG8(0x4119)            /* read: bits 3-4 -> flag_4119 */

/* zero page (names from use) */
#define ppu_ctrl_shadow   REG8(0x00)
#define ppu_mask_shadow   REG8(0x01)
#define video_2010_shadow REG8(0x02)
#define scroll_x_shadow   REG8(0x03)
#define scroll_y_shadow   REG8(0x04)
#define frame_counter     REG8(0x06)
#define prg8000_shadow    REG8(0x08)        /* data bank currently at $8000 */
#define flag_4119         REG8(0x0D)
#define frame_done        REG8(0x1B)
#define nmi_hook_mode     REG8(0x1C)
#define bg_chr_base       REG8(0x1D)        /* -> $2012-$2015 = base..base+3 */
#define nmi_hook_ptr      (*(void (**)(void))0x24)
#define menu_state        REG8(0x30)
#define menu_step         REG8(0x31)
#define step_exit         REG8(0x32)
#define screen_id         REG8(0x3A)
#define spr_chr_base      REG8(0x4D)        /* -> $2016 = base, $2017 = base+2 */
#define cn_page           REG8(0x0375)      /* 0..39, also read by English $AAB1 */
#define cn_row            REG8(0x03C3)

extern const unsigned char tbl_page_bg_chr[40];   /* $F6A0: 00 04 08 .. 9C */
extern void hw_init(void);              /* $C03C */
extern void init_ppu_shadows(void);     /* $C05E: ctrl=$10 mask=$06 2010=0 scroll=0 */
extern void clear_oam_and_sprite_slots(void); /* $C3E4 */
extern void sound_init(void);           /* $E379 */
extern void sound_tick(void);           /* $E34A */
extern void read_pad(void);             /* $C08C */
extern void prng_step(void);            /* $C01E */
extern void step0_screen2(void), step1_screen1(void), step2_screen3(void);

/* $C07A */
static void read_4119_flag(void) { flag_4119 = ((REG_4119 & 0x18) == 0x18) ? 0 : 1; }

/* $F9EE */
void reset(void)
{
    unsigned char x;
    PPU_CTRL = 0; PPU_MASK = 0;
    JOY2_FRAME = 0xC0;
    /* SEI; CLD; wait 3 vblanks */
    for (x = 0; x < 3; ++x) { while (!(PPU_STATUS & 0x80)) ; while (PPU_STATUS & 0x80) ; }
    for (x = 0; ; ++x) { REG8(0x0100 + x) = 0; if (x == 0xFF) break; }
    /* TXS $FF (twice); PPU off again */
    PPU_CTRL = 0; PPU_MASK = 0;
    hw_init();
    init_ppu_shadows();
    read_4119_flag();
    clear_oam_and_sprite_slots();
    REG8(0x0081) = 0;
    sound_init();
    menu_state = 0;
    menu_step = 1;                /* starts at step 1 (screen 1) */
    REG8(0x0134) = 0x20;
    for (;;) {                    /* $FA4B main_loop */
        /* $FC27 state_dispatch_main: tbl_menu_states[menu_state] -> 4-byte entries,
         * JMP (entry[menu_step].main).  State 0 steps: 0=$CD8B 1=$CDE9 2=$CE4E 3,4=RTS */
        static void (*const steps[3])(void) = { step0_screen2, step1_screen1, step2_screen3 };
        if (menu_step < 3) steps[menu_step]();
    }
}

/* $FA51 */
void nmi_handler(void)
{
    unsigned char x;
    if (nmi_hook_mode == 1 || nmi_hook_mode == 2) nmi_hook_ptr();   /* $FC19 */
    OAM_ADDR = 0;
    REG_4034 = 0;
    OAM_DMA = 0x02;
    (void)PPU_STATUS;
    /* background pattern table: 4 x 1 KiB from bg_chr_base */
    x = bg_chr_base;
    OB_CHR(0) = x; OB_CHR(1) = x + 1; OB_CHR(2) = x + 2; OB_CHR(3) = x + 3;
    /* sprite pattern table: 2 x 2 KiB from spr_chr_base */
    OB_CHR(4) = spr_chr_base;
    OB_CHR(5) = (unsigned char)(spr_chr_base + 2);
    REG8(0x07) = 0;
    if (REG8(0x003D)) { REG_4101 = REG_4102 = REG_4104 = REG8(0x003D); }   /* observed only */
    (void)PPU_STATUS;
    PPU_CTRL = ppu_ctrl_shadow;
    PPU_MASK = ppu_mask_shadow;
    OB_VIDEO_2010 = video_2010_shadow;
    PPU_SCROLL = scroll_x_shadow;
    PPU_SCROLL = scroll_y_shadow;
    /* CLI */
    ++frame_counter;
    read_pad();
    prng_step();
    OB_PRG_8000 = 0x3C;          /* bank $1C at $8000; sound_tick never reads it (bank $1C holds a dormant older driver) */
    sound_tick();
    if (frame_done) frame_done = 0;
    OB_PRG_8000 = prg8000_shadow;
}

/* $F680 - each list page has its own 4 KiB of glyph tiles: banks page*4 .. page*4+3
 * (file 0x00000 + page * 0x1000, pages 0..39 -> 0x00000-0x27FFF) */
void set_page_bg_chr(void)
{
    bg_chr_base = tbl_page_bg_chr[cn_page];
    /* JSR $F700 */
}

/* $DD6C - called from the step exits ($DBC2/$DBCC) and $D0DA with ($B2) pointing
 * into the launch pointer table at $86C3 (bank $18).  It copies an 8-byte record to
 * $0400-$0407, a 16-byte block ($DE36) to $0100, and the 218-byte stub ($DE5C) to
 * $0408, sets $2010 = $4103 = 0 and runs the stub.  The stub only does:
 *     $410B = 4; $4107..$410A = $3C..$3F; JMP $AAB1
 * i.e. it switches to the English block, whose $AAB1 (launch_from_chinese_menu)
 * computes index = cn_page*10 + cn_row and calls launch_game ($A82C) there.
 * So the game launched comes from the English tables ($CE7B/$D27B -> $B000/$B800);
 * the 8-byte record copied here is overwritten before use. */
void launch_selected_game(void)
{
    prg8000_shadow = 0x38;
    OB_PRG_8000 = 0x38;
    /* ... copy loops as described above, then JMP $0408 */
}
