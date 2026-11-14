/* langsel.c - language select, bank $37 at $E000 (file 0x6E000).
 * Reference C translation of src/bank37.s.
 * Entered from the boot stub at $0400 ($FF70 in the English block: PRG $34-$37, JMP $E000)
 * and from the test app on a second reset (testapp_warm_reset_to_langsel). */
#define REG8(a) (*(volatile unsigned char *)(a))
#define PPU_CTRL    REG8(0x2000)
#define PPU_MASK    REG8(0x2001)
#define PPU_STATUS  REG8(0x2002)
#define OB_CHR_2018 REG8(0x2018)
#define OB_CHR_201A REG8(0x201A)
#define cursor      REG8(0xC1)      /* 0 = Chinese (top), 1 = English */
#define pad_new     REG8(0xF5)
#define NMI_JMP     ((volatile unsigned char *)0x06A0)

extern void langsel_init_e387(void);
extern void sound_init(void);   /* $EF55: same driver as the Chinese menu, see 400in1_menu_sound */
extern void langsel_draw_screen(unsigned char x);      /* $E1B9 */
extern void langsel_wait_vblank(void);                 /* $E154 */
extern void langsel_move_cursor(void);                 /* $E0C5: cursor sprite tiles $C7/$D7 */
extern const unsigned char ram_stub_start_chinese[0x61];   /* $EEB0 */
extern const unsigned char ram_stub_start_english[0x21];   /* $E6E4 */

/* $EAC0 */
static void langsel_install_nmi_06A0(void)
{ NMI_JMP[0] = 0x4C; NMI_JMP[1] = 0x15; NMI_JMP[2] = 0xE1; }   /* NMI -> JMP $E115 */

/* $E62D: wait until the NMI frame counter $24 reaches 12, then take new pad bits from $22;
 * repeats until Up, Down or Start ($1C) is among them */
extern void langsel_wait_frame_read_pad(void);

/* $E000 */
void langsel_entry(void)
{
    unsigned int i;
    unsigned char x;
    /* SEI; CLD; read PPU_STATUS; TXS $FF */
    PPU_CTRL = 0;
    for (i = 0; i < 0x100; ++i) REG8(0x0100 + i) = 0;
    langsel_init_e387();
    sound_init();               /* song 0 ($045D = 0) */
    langsel_install_nmi_06A0();
    OB_CHR_2018 = 0x10;          /* CHR: banks $198-$19F -> file 0x66000-0x67FFF */
    OB_CHR_201A = 0x9E;
    REG8(0xC0) = 0;
    langsel_draw_screen(0);
    langsel_wait_vblank();
    for (;;) {                   /* $E033 */
        langsel_wait_frame_read_pad();
        if (pad_new & 0x0C) { cursor ^= 1; langsel_move_cursor(); }    /* Up/Down */
        if (pad_new & 0x10) break;                                      /* Start */
    }
    PPU_CTRL = 0; PPU_MASK = 0;
    if (cursor == 0) {
        /* $EEB0 -> $0400: $410B=1, PRG $1C-$1F, $2018=$201A=0, JMP ($FFFC) = Chinese reset $F9EE */
        for (x = 0x60; ; --x) { REG8(0x0400 + x) = ram_stub_start_chinese[x]; if (!x) break; }
    } else {
        /* $E088, $E6E4 -> $0400: $410B=4, PRG $3C-$3F, JMP $FB7D = English menu entry */
        for (x = 0x20; ; --x) { REG8(0x0400 + x) = ram_stub_start_english[x]; if (!x) break; }
    }
    /* JMP $0400 */
}

/* $E115 - NMI (via $06A0): ++$1E, $E364, OAM DMA from page 2, ++$24 (frame counter), sound_tick ($EF26) */
