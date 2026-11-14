/* Sup 400-in-1 menu sound driver (credited in the ROM as "音效制作：王超").
 * Reference C, written from the disassembly of the Chinese block ($E34A-$ED68, file 0x3E34A-0x3ED68).
 * The language-select block has the same code at +$BDC ($EF26-$F944, file 0x6EF26-0x6F944),
 * with the channel RAM at $0400 instead of $0300 and the song number at $045D instead of $0081.
 * Addresses below are the Chinese block's. This file is documentation; it is not compiled into the ROM.
 *
 * Entry points (called by the menu):
 *   sound_init  $E379   reset: stop everything, start song song_no ($0081)
 *   sound_tick  $E34A   NMI, once per frame: sfx_tick() then music_tick()
 *   sound_play  $E351   start sound effect sound_id ($DB)
 */
#include <stdint.h>
typedef uint8_t u8; typedef uint16_t u16;
#define APU(r) (*(volatile u8 *)(0x4000 + (r)))

/* ---- music: 4 slots of 21 ($15) bytes at $0300, $0315, $032A, $033F ---- */
typedef struct {
    u8 pos;          /* +00 0 = read header next, $FF = stopped, else command index (2-byte units) */
    u8 flags;        /* +01 bits0-1 APU channel (0 pulse1, 1 pulse2, 2 triangle, 3 noise); bit7 vibrato on; bits4-6 vibrato shape */
    u16 data;        /* +02 track data pointer */
    u8 tempo;        /* +04 T: a tick happens every (T+1)/16 frames */
    u8 tempo_acc;    /* +05 */
    u8 vol;          /* +06 value for register 0: duty<<6 | $10 constant volume | volume */
    u8 wait;         /* +07 ticks left on the current note */
    u8 sweep;        /* +08 register 1 */
    u8 rep[2];       /* +09/+0A repeat counters (B1-BF) */
    u8 env_shape;    /* +0B 0 = off */
    u8 env_len;      /* +0C */
    u8 env_phase;    /* +0D */
    u8 slide;        /* +0E volume slide steps (signed) */
    u8 slide_period; /* +0F */
    u8 slide_cnt;    /* +10 */
    u8 period_lo;    /* +11 base low period byte for vibrato (clamped to 2..$FD) */
    u8 loop_pos;     /* +12 set by FD */
    u8 vib_delay;    /* +13 */
    u8 vib_cnt;      /* +14 */
} slot_t;
extern slot_t slot[4];                       /* $0300 */
extern u8 song_no;                           /* $0081 */
extern u8 sfx_mask;                          /* $0080 channels taken by sound effects (and, by a quirk, music) */
extern u8 music_mask;                        /* $0358 channels the music has keyed on */
extern u8 done_mask;                         /* $0354 APU channels already written this frame */
extern u8 vib_clock;                         /* $035B */
extern const u8 tbl_song_ntracks[], tbl_song_first_track[];   /* $EFB9/$EFBA: (tracks-1, first record) per song */
extern const u16 tbl_song_records[];                          /* $EFBF: per song, base of 4-byte track records */
extern const u16 tbl_note_period[12];                         /* $EB35: C..B, C = $06AE (C2, 65.4 Hz) */
extern const u8 tbl_chan_type[4];                             /* $EB55: 00 01 82 43: bit7 triangle, bit6 noise */
extern const signed char tbl_vibrato[0x70];                   /* $EB59: 7 shapes x 16 steps, added to period_lo */
extern const u8 tbl_envelope[0xA0], tbl_volume_scale[0x100];  /* $EBC9 / $EC69 */

void apu_write(u8 chan, u8 reg, u8 v);       /* $EA99-$EAD1: skipped while a sound effect owns the channel ($EAED) */
static int is_triangle(slot_t *s) { return (s->flags & 3) == 2; }
static int is_noise(slot_t *s)    { return (s->flags & 3) == 3; }
static int chan_done(slot_t *s)   { return done_mask & (1 << (s->flags & 3)); }    /* $E994 */
static u8 read_duty(slot_t *s, u8 b)                                                /* $E9A2 */
{ return is_triangle(s) ? b & 0x7F : (u8)((b & 3) << 6); }   /* triangle: linear counter value */
int sfx_owns(u8 chan);
void snd_credit_checksum(void); void music_start_song(void); void music_read_header(slot_t *s);
void music_read_commands(slot_t *s); void music_cmd_note(slot_t *s, u8 c, u8 len); void music_cmd_rest(slot_t *s);
void music_write_volume(slot_t *s); void music_envelope(slot_t *s); void music_volume_slide(slot_t *s); void music_vibrato(slot_t *s);

void sound_init(void)                        /* $E379 */
{
    APU(0x15) = 0; music_mask = 0; sfx_mask = 0;
    for (int k = 0; k < 4; k++) slot[k].pos = 0xFF;
    snd_credit_checksum();                   /* $E425: sum of the 14 bytes at $EB27 must be $25, else jumps into the
                                                command parser at $E87C. Do not edit the credit bytes. */
    music_start_song();                      /* $E3A1 */
}

void music_start_song(void)                  /* $E3A1 */
{
    const u8 *rec = (const u8 *)tbl_song_records[song_no] + 4 * tbl_song_first_track[song_no];
    for (int k = 0; k <= tbl_song_ntracks[song_no]; k++, rec += 4) {   /* 1-4 tracks */
        slot_t *s = (slot_t *)(0x0300 + rec[0]);                       /* rec: slot offset, flags, data ptr */
        s->flags = rec[1]; s->data = rec[2] | rec[3] << 8; s->pos = 0;
    }
}

/* called once per frame */
void music_tick(void)                        /* $E699 */
{
    done_mask = 0; vib_clock++;
    for (int k = 0; k < 4; k++) {
        slot_t *s = &slot[k];
        if (s->pos == 0xFF) continue;
        if (s->pos == 0) { music_read_header(s); goto read; }          /* $E722 */
        music_vibrato(s); music_envelope(s);
        if (++s->env_phase >= s->env_len) s->env_phase = s->env_len;
        s->tempo_acc -= 0x10;
        if ((signed char)s->tempo_acc >= 0) { music_write_volume(s); goto next; }
        s->tempo_acc += s->tempo + 1;                                   /* one tick */
        music_volume_slide(s);
        if (s->vib_cnt) s->vib_cnt--;
        if (--s->wait) { music_write_volume(s); goto next; }
    read:
        s->vib_cnt = s->vib_delay;
        music_read_commands(s);                                         /* $E774 */
    next:
        done_mask |= 1 << (s->flags & 3);    /* a later slot on the same APU channel stays silent this frame */
    }
}

void music_read_header(slot_t *s)            /* $E722: 4 bytes */
{
    const u8 *d = (const u8 *)s->data;
    s->tempo = s->tempo_acc = ((d[0] << 4 | d[0] >> 4) + 0x0F) & 0xFF;   /* nibble swap + 15 */
    /* d[1]: pulse: duty in bits 0-1 (-> bits 6-7); triangle: linear counter value; d[2] is OR'd in -> vol */
    s->vol = read_duty(s, d[1]) | d[2];
    s->sweep = d[3];
    s->rep[0] = s->rep[1] = 0; s->env_shape = 0; s->slide = 0;
    s->pos = 2;                              /* commands start after the header */
}

/* commands are 2-byte pairs {cmd, arg}; slot->pos counts pairs from the track start */
void music_read_commands(slot_t *s)          /* $E774 */
{
    for (;;) {
        const u8 *p = (const u8 *)s->data + 2 * s->pos;
        u8 c = p[0], a = p[1];
        s->pos++;
        if (c >= 0xF0) {
            if (c == 0xFD) s->loop_pos = s->pos;          /* loop point */
            else if (c == 0xFF) { s->pos = 0xFF; music_cmd_rest(s); return; }   /* end of track */
            continue;                                     /* F0-FC, FE: ignored */
        }
        if (c >= 0xD0) {                                  /* D0-DF: slide up c&15 steps, E0-EF: down */
            if (!is_triangle(s)) { s->slide = c >= 0xE0 ? -(c & 15) : (c & 15); s->slide_period = s->slide_cnt = a; }
            continue;
        }
        if (c >= 0xC0) {                                  /* C0-CF: envelope shape c&15, length a */
            if (!is_triangle(s) && (s->vol & 0x10)) { s->env_len = a; s->env_shape = c & 15; }
            continue;
        }
        if (c >= 0xB0) {                                  /* B0: goto a (0 = loop point); B1-BF: repeat */
            u8 n = c & 15;
            if (n) { u8 *r = &s->rep[a == 0 ? 0 : 1];   /* two nesting levels */
                     if (*r == 0) *r = n; else if (--*r == 0) continue; }
            s->pos = a ? a : s->loop_pos;
            continue;
        }
        if (c >= 0xA0) {
            switch (c) {
            case 0xA0: if (!is_triangle(s)) s->vol = (s->vol & 0xC0) | a; break;         /* volume byte */
            case 0xA1: s->sweep = a; break;
            case 0xA2: s->vol = is_triangle(s) ? read_duty(s, a)                         /* triangle: linear counter */
                                                : read_duty(s, a) | (s->vol & 0x1F); break; /* pulse/noise: duty */
            case 0xA3: if (a & 0x80) goto vib_off;                                       /* vibrato: delay a&15 (x2 ticks), shape a&$70 */
                       s->vib_delay = s->vib_cnt = (a & 15) * 2;
                       s->flags = (a & 0x70) | (s->flags & 3) | 0x80; break;
            case 0xA4: vib_off: s->flags &= 3; break;
            case 0xAD: s->data += 2 * s->pos; s->pos = 0;                              /* start a new block here */
                       if (a == 0) { music_read_header(s); continue; } break;          /* a = 0: a new 4-byte header follows */
            case 0xAE: s->tempo = (s->tempo & 0x7F) | (a & 0x80); break;
            case 0xAF: s->tempo = s->tempo_acc = ((a << 4 | a >> 4) + 0x0F) & 0xFF; break;
            }
            continue;
        }
        music_cmd_note(s, c, a);                          /* 00-9F */
        return;
    }
}

void music_cmd_note(slot_t *s, u8 c, u8 len)  /* $E8FC */
{
    u16 period;
    s->wait = len;                           /* in ticks */
    if (is_noise(s)) {
        if (c >= 0x10) { music_cmd_rest(s); return; }
        period = c;                          /* noise period index 0-15 */
    } else {
        if ((c & 15) >= 12) { music_cmd_rest(s); return; }   /* x C-x F = rest */
        period = tbl_note_period[c & 15] >> (c >> 4);       /* octave = 2 + (c >> 4) */
    }
    s->env_phase = 0;
    if (chan_done(s)) return;
    music_mask |= 1 << (s->flags & 3);
    sfx_mask |= music_mask; APU(0x15) = sfx_mask;            /* $EAD5 */
    music_write_volume(s);
    apu_write(s->flags & 3, 1, s->sweep);
    apu_write(s->flags & 3, 2, period & 0xFF);
    s->period_lo = (period & 0xFF) < 2 ? 2 : (period & 0xFF) >= 0xFE ? 0xFD : period & 0xFF;
    apu_write(s->flags & 3, 3, (period >> 8 & 7) | 0x08);    /* length counter index 1 = 254 frames */
}

void music_cmd_rest(slot_t *s)               /* $E984 */
{
    if (chan_done(s)) return;
    music_mask &= ~(1 << (s->flags & 3));
    sfx_mask |= music_mask; APU(0x15) = sfx_mask;            /* quirk: the channel bit stays set in $0080,
                                                                so $4015 does not switch the channel off */
}

void music_write_volume(slot_t *s)           /* $E9BC: skipped if chan_done(), then $E9BF */
{
    if (chan_done(s)) return;
    u8 ch = s->flags & 3;
    if (ch == 2) { if (!sfx_owns(2)) APU(0x08) = s->vol; return; }
    if (s->env_shape) { music_envelope(s); return; }
    apu_write(ch, 0, s->vol | (s->vol & 0x10) << 1);         /* constant volume also sets length halt */
}

void music_envelope(slot_t *s)               /* $E9E2: volume x shape[phase*16/len] */
{
    if (chan_done(s) || is_triangle(s) || !s->env_shape) return;
    u8 step = (u8)((s->env_phase * 16) / s->env_len);         /* 4-bit division loop at $E9FD */
    u8 lvl = tbl_envelope[(s->env_shape << 4) | step];        /* level in bits 4-7 */
    apu_write(s->flags & 3, 0, (s->vol & 0xC0) | tbl_volume_scale[(s->vol & 0x0F) | lvl]);
}

void music_volume_slide(slot_t *s)           /* $EA29: one volume step every slide_period ticks */
{
    if (is_triangle(s) || !s->slide || --s->slide_cnt) return;
    s->slide_cnt = s->slide_period;
    u8 v = s->vol & 0x1F;
    if (!(v & 0x10)) return;
    if ((signed char)s->slide > 0) { s->slide--; if (v != 0x1F) s->vol++; }
    else                            { s->slide++; if (v != 0x10) s->vol--; }
}

void music_vibrato(slot_t *s)                /* $EA6B: changes only the low period byte */
{
    if (chan_done(s) || is_noise(s) || s->vib_cnt || !(s->flags & 0x80)) return;
    apu_write(s->flags & 3, 2, s->period_lo + tbl_vibrato[(s->flags & 0x70) | (vib_clock & 15)]);
}

/* ---- sound effects: one channel each, a stream of raw register values ---- */
extern u8 sound_id;                          /* $DB */
extern u8 sfx_on;                            /* $E4 bit0 */
extern u8 sfx_chans;                         /* $D9: channels owned by effects (music writes are skipped) */
extern const u16 tbl_sfx_ptrs[];             /* $ED69 */
struct { u8 regmask, speed, len, cnt, done; const u8 *p; } sfx[4];   /* $E5/$F0/$EC/$F4/$E0/$F8 */

void sound_play(void)                        /* $E351 */
{
    const u8 *d = (const u8 *)tbl_sfx_ptrs[sound_id];
    sfx_on |= d[0];                          /* always 1 */
    u8 bit = d[1];                           /* 1 pulse1, 2 pulse2, 4 triangle, 8 noise */
    sfx_chans |= bit; sfx_mask |= bit | music_mask; APU(0x15) = sfx_mask;
    int x = bit == 1 ? 0 : bit == 2 ? 1 : bit == 4 ? 2 : 3;
    sfx[x].regmask = d[2];                   /* which of the 4 registers each step writes */
    sfx[x].speed = d[3];                     /* frames per step */
    sfx[x].len = d[4];                       /* stream bytes */
    sfx[x].cnt = sfx[x].done = 0;
    for (int r = 0; r < 4; r++) APU(4 * x + r) = d[5 + r];   /* the 4 starting register values */
    sfx[x].p = d + 9;
}

void sfx_tick(void)                          /* $E4BA, $E4D1/$E543/$E5B5/$E627 per channel */
{
    if (!(sfx_on & 1)) return;
    for (int x = 0; x < 4; x++) {
        if (!(sfx_chans & (1 << x)) || ++sfx[x].cnt < sfx[x].speed) continue;
        sfx[x].cnt = 0;
        if (sfx[x].done >= sfx[x].len) {     /* finished: give the channel back to the music */
            sfx_chans &= ~(1 << x); sfx_mask &= ~(1 << x); APU(0x15) = sfx_mask | music_mask; continue;
        }
        u8 n = 0;
        for (int r = 0; r < 4; r++) if (sfx[x].regmask & (1 << r)) APU(4 * x + r) = sfx[x].p[n++];
        sfx[x].done += n; sfx[x].p += n;
    }
}
