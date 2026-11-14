/* tft.c - TFT/LCD panel detection and init, bank $15 (file 0x2A000), run at $A000.
 * Reference C translation of src/bank15.s.  Register meanings for $4FF0-$4FFA,
 * $410F, $412D, $4135, $4136, $4139 are NOT documented here: the values are the
 * ones the code writes, and the comments describe only what the code does.
 *
 * Entry: $FFB0 (bank $3F) sets $4107=$14 $4108=$15 and JMPs $A000.
 * Exit:  JMP $FF60 (bank $3F) -> boot-select stub at $0400 -> language select.
 */
#define REG8(a) (*(volatile unsigned char *)(a))
#define R4FF(n)     REG8(0x4FF0 + (n))  /* $4FF0..$4FFA: LCD interface (observed) */
#define REG_410F    REG8(0x410F)
#define REG_412D    REG8(0x412D)
#define REG_4135    REG8(0x4135)
#define REG_4136    REG8(0x4136)
#define REG_4139    REG8(0x4139)
#define PPU_STATUS  REG8(0x2002)

#define lcd_id0      REG8(0x0110)
#define lcd_id1      REG8(0x0111)
#define lcd_id2      REG8(0x0112)
#define lcd_cmd_fmt  REG8(0x0114)
#define panel_type   REG8(0x0116)
#define lcd_cmd_ptr  (*(const unsigned char **)0x00F8)

extern const char *const tbl_lcd_names[33];          /* $B80A, unused by any code in the dump */

/* $A7DC: X=0,Y=0 nested countdown (~65536 iterations of DEX/BNE) */
static void delay_long(void) { unsigned int n = 0; do { --n; } while (n); }

/* $A644 lcd_send_cmd: A -> $4FF7, $4FF8 = 0, then the $A64C strobe pattern on $4FF0 */
static void lcd_send_cmd(unsigned char c)
{
    static const unsigned char strobe[9] = { 0x51, 0x11, 0x11, 0x01, 0x01, 0x01, 0x01, 0x11, 0x11 };
    unsigned char i;
    R4FF(7) = c; R4FF(8) = 0;
    for (i = 0; i < 9; ++i) R4FF(0) = strobe[i];
}

/* $A67A lcd_send_data: A -> $4FF7, $4FF8 = 0, then the $A682 strobe pattern */
static void lcd_send_data(unsigned char d)
{
    static const unsigned char strobe[10] = { 0x31, 0x21, 0x21, 0x21, 0x21, 0x31, 0x31, 0x31, 0x31, 0x71 };
    unsigned char i;
    R4FF(7) = d; R4FF(8) = 0;
    for (i = 0; i < 10; ++i) R4FF(0) = strobe[i];
}

/* $A6B5 lcd_read_byte */
static unsigned char lcd_read_byte(void)
{
    R4FF(0) = 0x31;
    REG_4139 = 0x02; REG_4139 = 0x02; REG_4139 = 0x00; REG_4139 = 0x00;
    return REG_4135;
}

/* $A6D2 lcd_read_word: returns low in A ($4135), high in X ($4136) */
static unsigned char lcd_read_word(unsigned char *hi)
{
    R4FF(0) = 0x31;
    REG_4139 = 0x02; REG_4139 = 0x02; REG_4139 = 0x00; REG_4139 = 0x00;
    *hi = REG_4136;
    REG_4139 = 0x02; REG_4139 = 0x02; REG_4139 = 0x00; REG_4139 = 0x00;
    return REG_4135;
}

static void lcd_read_end(void) { REG_4139 = 0x02; R4FF(0) = 0x71; REG_412D = 0xDC; }

/* $A706/$A70B (-> $A712): word read into id0 (high, X) / id1 (low, A) */
static void lcd_read_id_2(unsigned char cmd)
{
    unsigned char hi;
    lcd_send_cmd(cmd);
    REG_412D = 0xFC;
    lcd_id1 = lcd_read_word(&hi);
    lcd_id0 = hi;
    lcd_read_end();
}

/* $A733/$A738 (-> $A73D): word read, low byte into id2 */
static void lcd_read_id_1(unsigned char cmd)
{
    unsigned char hi;
    lcd_send_cmd(cmd);
    REG_412D = 0xFC;
    lcd_id2 = lcd_read_word(&hi);
    lcd_read_end();
}

/* $A75B/$A760/$A765 (-> $A76A): one dummy byte, then id0, id1, id2 */
static void lcd_read_id_3(unsigned char cmd)
{
    lcd_send_cmd(cmd);
    REG_412D = 0xFC;
    lcd_read_byte();
    lcd_id0 = lcd_read_byte();
    lcd_id1 = lcd_read_byte();
    lcd_id2 = lcd_read_byte();
    lcd_read_end();
}

/* $A797: command $0A (dummy + id0) then command $F1 (dummy + id1) */
static void lcd_read_id_cmd0A_F1(void)
{
    lcd_send_cmd(0x0A); REG_412D = 0xFC; lcd_read_byte(); lcd_id0 = lcd_read_byte(); lcd_read_end();
    lcd_send_cmd(0xF1); REG_412D = 0xFC; lcd_read_byte(); lcd_id1 = lcd_read_byte(); lcd_read_end();
}

/* $A5CF */
static void lcd_reset_pulse(void)
{
    REG_412D = 0xDC;
    R4FF(6) = 0xC1;
    R4FF(0) = 0x71;
    REG_4139 = 0x02;
    REG_410F = 0xFF; delay_long();
    REG_410F = 0xDF; delay_long();
    REG_410F = 0xFF; delay_long();
}

/* $A5FC / $A620: interface set-up written before the list runs (format 3 uses the second) */
static void lcd_set_4FF0_block_B7(void)
{ R4FF(0) = 0xB7; R4FF(1) = 0xFF; R4FF(2) = 0xA4; R4FF(3) = 0x5A; R4FF(4) = 0x9A; R4FF(5) = 0xFE; R4FF(0xA) = 0x0E; }
static void lcd_set_4FF0_block_BD(void)
{ R4FF(0) = 0xBD; R4FF(1) = 0xFF; R4FF(2) = 0x52; R4FF(3) = 0x58; R4FF(4) = 0x98; R4FF(5) = 0xFD; R4FF(0xA) = 0x0D; }

/* ---- command-list interpreters ($0114 selects the format) ------------- */

/* fmt 0 ($A527): cmd, data..., $FE, cmd, data..., ..., $FF
 * (the first byte is always sent as a command; $FE = "next byte is a command") */
static void lcd_cmds_fmt0(const unsigned char *p)
{
    for (;;) {
        lcd_send_cmd(*p++);
        for (;;) {
            unsigned char b = *p;
            if (b == 0xFE) { ++p; break; }
            if (b == 0xFF) return;
            lcd_send_data(b); ++p;
        }
    }
}

/* fmt 1 ($A545): {reg, hi, lo}...  $FF n = one fixed delay (n is not used), $FF $FF = end; then cmd $22 */
static void lcd_cmds_fmt1(const unsigned char *p)
{
    for (;;) {
        while (*p != 0xFF) {
            lcd_send_cmd(*p++);
            R4FF(8) = *p++;               /* high byte */
            R4FF(7) = *p++;               /* low byte  */
            /* $A682 data strobe */
            { static const unsigned char s[10] = { 0x31, 0x21, 0x21, 0x21, 0x21, 0x31, 0x31, 0x31, 0x31, 0x71 };
              unsigned char i; for (i = 0; i < 10; ++i) R4FF(0) = s[i]; }
        }
        ++p;
        if (*p == 0xFF) break;
        ++p; delay_long();     /* the byte is loaded into X, but delay_long resets X/Y: one fixed delay */
    }
    lcd_send_cmd(0x22);
}

/* fmt 2 ($A578): {cmd, data}...  $FF n = delay, $FF $FF = end; then cmd $22 */
static void lcd_cmds_fmt2(const unsigned char *p)
{
    for (;;) {
        while (*p != 0xFF) { lcd_send_cmd(*p++); lcd_send_data(*p++); }
        ++p;
        if (*p == 0xFF) break;
        ++p; delay_long();     /* byte ignored: one fixed delay */
    }
    lcd_send_cmd(0x22);
}

/* fmt 3 ($A5A2): {hi, lo} raw words with the command strobe, $FF n delay, $FF $FF end
 * (no panel selects this format in this dump) */
static void lcd_cmds_fmt3(const unsigned char *p)
{
    for (;;) {
        while (*p != 0xFF) {
            R4FF(8) = *p++; R4FF(7) = *p++;
            { static const unsigned char s[9] = { 0x51, 0x11, 0x11, 0x01, 0x01, 0x01, 0x01, 0x11, 0x11 };
              unsigned char i; for (i = 0; i < 9; ++i) R4FF(0) = s[i]; }
            R4FF(0) = 0x51;
        }
        ++p;
        if (*p == 0xFF) return;
        ++p; delay_long();     /* byte ignored: one fixed delay */
    }
}

/* $A4DE */
static void lcd_run_cmd_list(void)
{
    switch (lcd_cmd_fmt) {
    case 1: lcd_cmds_fmt1(lcd_cmd_ptr); lcd_set_4FF0_block_B7(); break;
    case 2: lcd_cmds_fmt2(lcd_cmd_ptr); lcd_set_4FF0_block_B7(); break;
    case 3: lcd_cmds_fmt3(lcd_cmd_ptr); lcd_set_4FF0_block_BD(); break;
    default: lcd_cmds_fmt0(lcd_cmd_ptr); lcd_set_4FF0_block_B7(); break;
    }
    while (!(PPU_STATUS & 0x80)) ;     /* two vblanks */
    while (!(PPU_STATUS & 0x80)) ;
    R4FF(6) = 0x81;
}

/* ---- detection ($A006) ------------------------------------------------
 * Each rule: read command, ID bytes to match (-1 = not compared), panel type,
 * command table ($F8) and list format ($0114).  Order matters: first match wins.
 * Rows marked SEE_LISTING compare in a way this table does not show (see bank15.s). */
typedef struct {
    unsigned char rd;             /* which read routine: see read_ids() */
    int id0, id1, id2;
    unsigned char type;
    unsigned int table;
    unsigned char fmt;
    const char *name;             /* tbl_lcd_names[type] */
} panel_rule_t;

enum { RD_0A_F1, RD_04, RD_D3, RD_D5, RD_67, RD_00, RD_CD, RD_28 };
#define SEE_LISTING (-2)

static const panel_rule_t panel_rules[] = {
    { RD_0A_F1, 0x08, 0x04,   -1, 0x1E, 0xABDD, 0, "S6D04M0" },
    { RD_04,      -1, 0x93, 0x06, 0x01, 0xA7EF, 0, "9306" },
    { RD_04,    0x85, 0x85, 0x52, 0x02, 0xA8EF, 0, "7789" },
    { RD_04,      -1, 0x93, 0x02, 0x03, 0xA949, 0, "9312" },
    { RD_04,      -1, 0x30, 0x33, 0x1B, 0xAABB, 0, "3029E" },
    { RD_D3,      -1, 0x93, 0x41, 0x04, 0xA998, 0, "9341" },
    { RD_D3,      -1, 0x31, 0x29, 0x1C, 0xAB55, 0, "3029C" },
    { RD_D5,      -1, 0x93, 0x40, 0x05, 0xA86E, 0, "9340X" },
    { RD_67,      -1, 0x47,   -1, 0x07, 0xAD57, 2, "8347A" },
    { RD_67,      -1, 0x46,   -1, 0x20, 0xADCF, 2, "8346" },
    { RD_00,    0x08, 0x09,   -1, 0x06, 0xAE37, 1, "68090" },
    { RD_00,    0x68, 0x07,   -1, 0x06, 0xAE37, 1, "68090" },
    { RD_00,    0x68, 0x01,   -1, 0x06, 0xAE37, 1, "68090" },
    { RD_CD,      -1,   -1, SEE_LISTING, 0x0A, 0xAEBD, 1, "9325" },
    { RD_CD, SEE_LISTING, -1, -1, 0x0B, 0xAEBD, 1, "9325D" },
    { RD_CD, SEE_LISTING, -1, -1, 0x0C, 0xAF52, 1, "9325C" },
    { RD_CD,    0x03, 0x28,   -1, 0x09, 0xAEBD, 1, "9328" },
    { RD_CD,    0x03, 0x20,   -1, 0x0D, 0xB0B7, 1, "9320" },
    { RD_CD,      -1, 0x47,   -1, 0x08, 0xAC55, 2, "8347D" },
    { RD_CD,      -1, 0x75,   -1, 0x1D, 0xACD5, 2, "8347G" },
    { RD_CD,    0x01, 0x39,   -1, 0x0E, 0xAFEA, 1, "0139" },
    { RD_CD,    0x05, 0x35,   -1, 0x0F, 0xB037, 1, "4535" },
    { RD_28,      -1,   -1, 0x0F, 0x11, 0xB158, 1, "61505U" },
    { RD_28, SEE_LISTING, -1, -1, 0x12, 0xB1F3, 1, "61505V" },
    { RD_28,    0x05, 0x31,   -1, 0x10, 0xB27F, 1, "4531" },
    { RD_28,    0x09, 0x89,   -1, 0x13, 0xB364, 1, "1289" },
    { RD_28,    0x09, 0x97,   -1, 0x1A, 0xB364, 1, "1297" },
    { RD_28,    0x04, 0x08,   -1, 0x14, 0xB3E1, 1, "5408A" },
    { RD_28,    0x01, 0x54,   -1, 0x16, 0xB2F0, 1, "S6D0154" },
    { RD_28,    0x05, 0x80,   -1, 0x17, 0xB5D6, 1, "61580" },
    { RD_28,    0x07, 0x83,   -1, 0x18, 0xB6CD, 1, "7781" },
    { RD_28,    0x03, 0x35,   -1, 0x19, 0xB665, 1, "9335" },
    { RD_28,    0x03, 0x31,   -1, 0x1F, 0xB665, 1, "9331" },
};
/* No rule matched: panel_type = $00 ("NO CHECK LCD"), table $A7EF, format 0. */

/* $A000 tft_entry -> $A006 tft_detect_and_init, then JMP $FF60 */
void tft_detect_and_init(void)
{
    lcd_reset_pulse();
    /* The original runs the reads in this order and checks the rules that follow
     * each read before doing the next read:
     *   $0A/$F1, $04, $D3, $D5, $67 ($A70B), $00 ($A706), $CD ($A733), $28 ($A738).
     * For the matched rule it sets panel_type, lcd_cmd_ptr, lcd_cmd_fmt and runs: */
    lcd_run_cmd_list();
}
