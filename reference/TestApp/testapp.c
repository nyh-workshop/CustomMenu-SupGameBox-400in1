/* testapp.c - Aaronix "MAIN DEVICE TEST" app, bank $35 code / bank $36 data,
 * file 0x68000-0x6FFFF (banks $34-$37 at $8000-$FFFF).
 * Reference C translation of src/bank35.s and the reset stub in src/bank37.s.
 * It follows the original order of PPU/APU/register writes; it does not rebuild
 * the bytes (src/ does).  $4139 writes are recorded without assuming a meaning.
 *
 * How it is reached: with A+B held at boot, the English block's
 * ram_stub_support_app sets $4100=0 $410B=4 $4109=$36 $410A=$37 $2018=$10
 * $201A=$A6 $413F=$1F $4138=$0B $4139=$0F and does JMP ($FFFC) -> $FFE0 here.
 */
#define REG8(a) (*(volatile unsigned char *)(a))
#define PPU_CTRL   REG8(0x2000)
#define PPU_MASK   REG8(0x2001)
#define PPU_STATUS REG8(0x2002)
#define OAM_ADDR   REG8(0x2003)
#define OAM_DATA   REG8(0x2004)
#define PPU_SCROLL REG8(0x2005)
#define PPU_ADDR   REG8(0x2006)
#define PPU_DATA   REG8(0x2007)
#define OAM_DMA    REG8(0x4014)
#define APU(n)     REG8(0x4000 + (n))
#define APU_STATUS REG8(0x4015)
#define JOY1       REG8(0x4016)
#define JOY2       REG8(0x4017)
#define MMC3_MIRRORING REG8(0xA000)
#define REG_4139   REG8(0x4139)
#define ZP(n)      REG8(n)
#define warm_marker REG8(0x0680)          /* $57 = test app already ran */
#define NMI_JMP     ((volatile unsigned char *)0x06A0)   /* NMI vector points here */

extern const unsigned char tbl_ram_test_patterns[4];   /* $A5FC */
extern const unsigned char tbl_test_strings[];         /* $A11A, tile codes, $FF-terminated */
extern const unsigned char tbl_test_palette[0x21];     /* $A4FF (read backwards, y=$20..1) */
extern const unsigned char bank36_c000[0x800];         /* $C000-$C7FF: ROM->RAM copy test data */
extern void draw_attr_and_grid(unsigned char ctrl);    /* $B400 */
extern void testapp_main(void);
extern void langsel_entry(void);                       /* $E000 */

static void wait_vblank_ppu_off(void)                  /* $BD00 */
{ while (!(PPU_STATUS & 0x80)) ; PPU_CTRL = 0; PPU_MASK = 0; }

static void ram_test_failed(void);                     /* $A740 -> $A761 path, see listing */
static void test_vram(void);                           /* $A761 */

/* $FFE0 */
void testapp_reset(void)
{
    /* SEI; CLD */
    PPU_CTRL = 0; PPU_MASK = 0; MMC3_MIRRORING = 0;
    /* JMP $A2D0 */
}

/* $A2D0 */
void testapp_start(void)
{
    unsigned char y = 0;
    while (!(PPU_STATUS & 0x80)) ;
    PPU_CTRL = 0; PPU_MASK = 0;
    if (warm_marker == 0x57) {           /* second reset while in the test app */
        /* $B828 testapp_warm_reset_to_langsel */
        NMI_JMP[0] = 0x4C; NMI_JMP[1] = 0x32; NMI_JMP[2] = 0xE5;   /* NMI -> JMP $E532 */
        warm_marker = 0;
        wait_vblank_ppu_off();
        langsel_entry();                 /* JMP $E000 */
        return;
    }
    while (!(PPU_STATUS & 0x80)) ;
    PPU_ADDR = 0; PPU_ADDR = 0;
    do { (void)REG8(0xB1FA + y); } while (++y);     /* 256 dummy reads of $B1FA,y */
    /* JMP $A600 */
}

/* $A600: work RAM test, then $A6C5 ROM->RAM copy test, $A743 clear, $A761 VRAM test */
void test_wram(void)
{
    unsigned char y, x, p;
    volatile unsigned char *page;
    /* pass 1 ($A600): write+read each byte immediately, 4 patterns */
    for (y = 0; y < 4; ++y) {
        p = tbl_ram_test_patterns[y];
        x = 0;
        do {
            for (page = (volatile unsigned char *)0x0000; page <= (volatile unsigned char *)0x0700; page += 0x100) {
                page[x] = p;
                if (page[x] != p) { ram_test_failed(); return; }
            }
        } while (++x);
    }
    /* pass 2 ($A66D): fill all 8 pages, then compare */
    for (y = 0; y < 4; ++y) {
        p = tbl_ram_test_patterns[y];
        x = 0;
        do { for (page = 0; page <= (volatile unsigned char *)0x0700; page += 0x100) page[x] = p; } while (++x);
        do { for (page = 0; page <= (volatile unsigned char *)0x0700; page += 0x100)
                 if (page[x] != p) { ram_test_failed(); return; } } while (++x);
    }
    /* $A6C5: copy $C000-$C7FF (bank $36) into $0000-$07FF and compare */
    x = 0;
    do { for (y = 0; y < 8; ++y) REG8(y * 0x100 + x) = bank36_c000[y * 0x100 + x]; } while (++x);
    do { for (y = 0; y < 8; ++y) if (REG8(y * 0x100 + x) != bank36_c000[y * 0x100 + x]) { ram_test_failed(); return; } } while (++x);
    /* $A743: clear $0002-$07FF, then $4E/$4F = $55/$AA */
    { unsigned int a; for (a = 2; a < 0x800; ++a) REG8(a) = 0; }
    ZP(0x4E) = 0x55; ZP(0x4F) = 0xAA;
    test_vram();
}

static void ram_test_failed(void) { test_vram(); /* original: JMP $A761 (shared VRAM test / error display path) */ }

/* $A761: fill VRAM $2000-$27FF with $FF, read back (first read is the PPU buffer dummy),
 * then continue with the pattern checks and the "RAM ERR" display path ($A7C7..), ending in
 * $A88D: JMP testapp_install_nmi_cold.  See bank35.s for the full sequence. */
static void test_vram(void)
{
    unsigned char x, y;
    PPU_ADDR = 0x20; PPU_ADDR = 0x00;
    for (x = 8; x; --x) { y = 0; do { PPU_DATA = 0xFF; } while (++y); }
    PPU_ADDR = 0x20; PPU_ADDR = 0x00;
    (void)PPU_DATA;
    for (x = 8; x; --x) { y = 0; do { if (PPU_DATA != 0xFF) { /* $A7C7 error path */ return; } } while (++y); }
    /* ... */
}

/* $B808 */
void testapp_install_nmi_cold(void)
{
    NMI_JMP[0] = 0x4C; NMI_JMP[1] = 0x00; NMI_JMP[2] = 0xA2;     /* NMI -> JMP $A200 */
    warm_marker = 0x57;
    /* SEI */
    wait_vblank_ppu_off();
    ZP(0xD0) = 0x80;
    testapp_main();
}

/* $A100: write $FF-terminated tile string tbl_test_strings[y..] at PPU ($00:$01); returns next y */
static unsigned char print_string(unsigned char y)
{
    PPU_ADDR = ZP(0x00); PPU_ADDR = ZP(0x01);
    while (tbl_test_strings[y] != 0xFF) PPU_DATA = tbl_test_strings[y++];
    return (unsigned char)(y + 1);
}

/* $A0E6 / $A0F3: read one pad bit and show it as tile '0'/'1'-ish ($30|bit, $32|bit) */
static unsigned char read_joy1_bit(void) { unsigned char v = JOY1; REG8(0x0721) = (v & 1) | 0x30; return v; }
static unsigned char read_joy2_bit(void) { unsigned char v = JOY2; REG8(0x0725) = (v & 1) | 0x32; return v; }

/* $A180: strobe, read 8 bits of pad 1 OR pad 2 into $03, then one tile per button:
 * $04 A ($0A / $52 pressed), $05 B ($0B / $53), $06 SELECT ($1C / $51), $07 START,
 * $08-$0B UP/DOWN/LEFT/RIGHT (see listing for their tile pairs) */
static void read_both_pads(void)
{
    unsigned char y, b2;
    JOY1 = 1; JOY1 = 0;
    for (y = 8; y; --y) {
        ZP(0x03) <<= 1;
        b2 = (read_joy1_bit() & 3) ? 1 : 0;
        ZP(0x02) = b2;
        ZP(0x03) |= (read_joy2_bit() & 1) | ZP(0x02);
    }
    ZP(0x04) = (ZP(0x03) & 0x80) ? 0x52 : 0x0A;
    ZP(0x05) = (ZP(0x03) & 0x40) ? 0x53 : 0x0B;
    /* ... $06-$0B the same way */
}

/* $A000 */
void testapp_main(void)
{
    unsigned char y, x;
    /* copy_a3c0_to_0700 ($A547), wait vblank ($B030), PPU_MASK = 0 */
    for (ZP(0x00) = 0x20; ZP(0x00) != 0x2C; ++ZP(0x00)) {        /* fill $2000-$2BFF with tile $30 */
        PPU_ADDR = ZP(0x00); PPU_ADDR = 0x00;
        y = 0; do { PPU_DATA = 0x30; } while (--y);
    }
    /* seven strings: "MAIN DEVICE TEST" at $2087, the dashed line at $20E6, an empty string
     * at $214A, "O" at $2226 and $22A6, the "O O S S B A" label row at $2264, "AARONIX" at $2337 */
    y = 0;
    ZP(0x00) = 0x20; ZP(0x01) = 0x87; y = print_string(y);
    ZP(0x01) = 0xE6; y = print_string(y);
    ZP(0x00) = 0x21; ZP(0x01) = 0x4A; y = print_string(y);
    ZP(0x00) = 0x22; ZP(0x01) = 0x26; y = print_string(y);
    ZP(0x01) = 0xA6; y = print_string(y);
    ZP(0x01) = 0x64; y = print_string(y);
    ZP(0x00) = 0x23; ZP(0x01) = 0x37; y = print_string(y);
    PPU_ADDR = 0x3F; PPU_ADDR = 0x00;
    for (y = 0x20; y; --y) PPU_DATA = tbl_test_palette[y];
    draw_attr_and_grid(0x0A);
    PPU_SCROLL = 0; PPU_SCROLL = 0;
    PPU_MASK = 0x08;
    PPU_CTRL = 0x80;                 /* NMI on -> testapp_nmi */
    ZP(0x0F) = 0x3C;                 /* 60-frame window for the press-rate counters */
    for (;;) {
        read_both_pads();
        for (x = 0; x < 2; ++x) {    /* x=0: A, x=1: B */
            if (((ZP(0x04 + x) & 0x40) ^ ZP(0x0C + x)) == 0) continue;
            /* $A540 count_press: BCD counter $10,x and raw counter $20,x */
            ++ZP(0x10 + x); ++ZP(0x20 + x);
            if ((ZP(0x10 + x) & 0x0F) == 0x0A) ZP(0x10 + x) += 6;
            ZP(0x0C + x) ^= 0x40;     /* counts both edges */
        }
    }
}

/* $AA00 - sound test sequencer on pulse 1, one step per call (snd_step $30, snd_timer $31) */
static void sound_test_step(void)
{
    switch (ZP(0x30)) {
    case 0: APU_STATUS = 1; APU(0) = 0xBF; APU(1) = 0x84; APU(2) = 0x10; APU(3) = 0x00; ZP(0x30) = 1; ZP(0x31) = 0x30; break;
    case 1: if (!--ZP(0x31)) ZP(0x30) = 2; break;
    case 2: APU(0) = 0xA0; APU(1) = 0x8D; APU(2) = 0xFF; APU(3) = 0x07; ZP(0x30) = 3; ZP(0x31) = 0x48; break;
    case 3: if (!--ZP(0x31)) ZP(0x30) = 4; break;
    default: /* steps 4.. continue in the listing ($AA63-) */ break;
    }
}

/* $ABD0 - show the current sound step (1..5) after the 8-tile label at $230B */
static void show_sound_step(void)
{
    extern const unsigned char dat_ABC1[8];
    unsigned char x;
    PPU_ADDR = 0x23; PPU_ADDR = 0x0B;
    for (x = 0; x < 8; ++x) PPU_DATA = dat_ABC1[x];
    switch (ZP(0x30)) {
    case 0x00: PPU_DATA = 1; break;
    case 0x04: PPU_DATA = 2; break;
    case 0x08: PPU_DATA = 3; break;
    case 0x0A: PPU_DATA = 4; break;
    case 0x0C: PPU_DATA = 5; break;
    }
    sound_test_step();
}

/* $A200 - reached through NMI vector $06A0 = JMP $A200 */
void testapp_nmi(void)
{
    static const unsigned char pos[8] = { 0x26, 0xA6, 0x64, 0x68, 0x71, 0x6D, 0x76, 0x7A };
    unsigned char i, x;
    PPU_MASK = 0; OAM_ADDR = 0; OAM_DMA = 0x07;      /* $A555 with A=0 */
    (void)PPU_STATUS;
    for (i = 0; i < 8; ++i) {                        /* button tiles $0B..$04 at $22xx */
        PPU_ADDR = 0x22; PPU_ADDR = pos[i]; PPU_DATA = ZP(0x0B - i);
    }
    if (--ZP(0x0F) == 0) {                           /* once per second: show A/B press rates */
        /* $A520 show_press_rates; then $1A = $5C */
        ZP(0x1A) = 0x5C;
        for (x = 0; x < 2; ++x) {
            ZP(0x14 + x) = ZP(0x10 + x) & 0x0F;
            ZP(0x16 + x) = (ZP(0x10 + x) >> 4) & 0x0F;
            ZP(0x10 + x) = 0;
            PPU_ADDR = 0x21;
            ZP(0x1A) -= 9; PPU_ADDR = ZP(0x1A);     /* $A5F0 -> $A0D8: $1A -= 9, returns it ($53, then $4A) */
            PPU_DATA = ZP(0x16 + x); PPU_DATA = ZP(0x14 + x);
        }
        ZP(0x0F) = 0x3C;
    }
    show_sound_step();
    PPU_SCROLL = 0; PPU_SCROLL = 0;
    PPU_MASK = 0x18;
    REG_4139 = 0x0F;
    /* RTI */
}
