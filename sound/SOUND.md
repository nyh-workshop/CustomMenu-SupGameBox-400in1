# Sup 400-in-1 menu music and sound effects

What plays in the menus, where the data sits in the 512 KiB dump, how the driver works, and the songs and
sound effects extracted as NSF, WAV, raw binaries and readable listings.
Source: `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin` and the four FCEUX traces.

## What plays where

| Screen | Music | Sound effects | Code |
|---|---|---|---|
| Boot | none | none (`$4015=0`) | bank $33 |
| Language select | **song 0** of its own copy of the driver (2 pulses + triangle + noise) | **start-up chime** (`langsel_click_sfx` `$EA80`: pulse 1 `$8F $AA $AA $80`), played once from `$E41E` before the music starts. A second call at `$EBB0` never runs in the traces, and moving the cursor plays nothing | block 0x68000, driver `$EF26-$F944` |
| English menu | none | **beep** on cursor moves (`sfx_beep` `$A28A`: pulse 2 `$FF $AA $78 $00`, 9 call sites); the NMI writes `$4015=$0F` every frame | block 0x78000 |
| Chinese menu | **song 0** (a different tune) | **SFX #4** on cursor moves (`$DF37` → `sound_play`), from a 43-entry table | block 0x38000, driver `$E34A-$ED68` |
| Test app | none (its own pulse test) | - | block 0x68000 |

The language select and the Chinese menu use **the same driver**. The language-select copy is shifted by `$BDC`: its channel RAM
is at `$0400` instead of `$0300`, and its song number at `$045D` instead of `$0081`. The ROM credits the driver as
**音效制作：王超** ("sound: Wang Chao", GB2312 at `$EB27`/`$F703`).

## Where the data is (file offsets in the 512 KiB dump)

| What | Chinese menu (`$E000` = 0x3E000) | Language select (`$E000` = 0x6E000) |
|---|---|---|
| Driver code | 0x3E34A-0x3EB26 | 0x6EF26-0x6F702 |
| Credit string (checksummed) | 0x3EB27-0x3EB34 | 0x6F703-0x6F710 |
| Driver tables: pitch, channel bits, vibrato, envelope, volume | 0x3EB35-0x3ED68 | 0x6F711-0x6F944 |
| SFX pointer table (43) | 0x3ED69-0x3EDBE | 0x6F945-0x6F99A |
| SFX data | 0x3EDBF-0x3EFB8 (19 distinct) | 0x6F99B-0x6FDFC (43 distinct) |
| Song table `{tracks-1, first record}` x3 + record pointers x3 | 0x3EFB9-0x3EFC4 | 0x6FDFD-0x6FE04 |
| Track records `{slot, flags, data ptr}` x4 | 0x3EFC5-0x3EFD4 | 0x6FE05-0x6FE14 |
| Pulse 1 / pulse 2 / triangle / noise | 0x3EFD5 / 0x3F0EA / 0x3F25F / 0x3F374 | 0x6FE15 / 0x6FE78 / 0x6FED1 / 0x6FF28 |
| End of song data | 0x3F4B1 (menu code follows) | 0x6FF81 (`$FF` padding follows) |

* **Only song 0 is real.** The song table has 3 entries. In the Chinese copy, songs 1 and 2 point into song 0's pulse-1 data;
  in the language-select copy they point at nothing valid. The menus only ever start song 0.
* **The Chinese SFX table has 42 real entries and 19 different sounds.**
  * Entry 42 points at the song table.
  * Entries #28-#39 are one sound whose stream claims 66 bytes and runs 37 bytes into the song table. That copy is cut short;
    the complete version is language-select #39.
* The language-select copy holds 43 different sound effects, but that screen never calls its `sound_play` (`$EF2D`).

## The driver

| Entry | Chinese | Language select | Called from |
|---|---|---|---|
| `sound_init`: stop all, start song `song_no` | `$E379` (`song_no` = `$0081`) | `$EF55` (`$045D`) | reset `$FA39` / `$E017` |
| `sound_tick`: SFX then music, once per frame | `$E34A` | `$EF26` | NMI `$FAD7` / `$E130` |
| `sound_play`: start effect `sound_id` (`$DB`) | `$E351` | `$EF2D` | `$DF3B` / never |

RAM: four music slots of `$15` bytes at `$0300/$0315/$032A/$033F` (`$0400...` in the language select), `$0354-$035B`,
`$0080`, zero page `$CE-$FF`. The Chinese NMI maps bank `$1C` at `$8000` before `sound_tick`; the driver itself only reads `$E000-$FFFF`.

`c/sound_driver.c` is a reference C version of every routine. Both disassembly projects now use these names, and still rebuild
byte for byte:
* `music_tick`, `music_read_commands`, `music_cmd_note`
* `sfx_tick_pulse1`…`noise`
* `tbl_note_period`, `tbl_sfx_ptrs`
* `song0_pulse1`…

### Music format

A **song** is 1-4 track records. Each record is `{slot offset $00/$15/$2A/$3F, flags (bits 0-1 = APU channel), data pointer}`.

A **track** starts with a 4-byte header, followed by 2-byte commands `{cmd, arg}`. A command's *position* counts 2-byte units
from the track start, so the first command after the header is position 2.

| Header byte | Meaning |
|---|---|
| 0 | tempo *b*. T = nibble-swap(*b*) + 15, and **one tick = (T+1)/16 frames**. Both songs use `$71`: 2.4375 frames per tick |
| 1 | pulse/noise: duty in bits 0-1; triangle: linear counter |
| 2 | OR'd into register 0: `$10` = constant volume, low nibble = volume |
| 3 | sweep (register 1) |

| Command | Argument | Meaning |
|---|---|---|
| `00-9F` | length in ticks | **Note.** High nibble = octave (pulse: 0 = C2…B2; triangle sounds one octave lower), low nibble = semitone 0-11 (12-15 = rest). Noise: `00-0F` = noise period, `10+` = rest |
| `A0` | value | volume byte (low 5 bits of register 0) |
| `A1` | value | sweep |
| `A2` | value | duty (pulse, bits 0-1) / linear counter (triangle) |
| `A3` | `0sssdddd` | vibrato on: shape `sss` (7 tables), delay `dddd` x2 ticks; bit 7 set = off |
| `A4` | - | vibrato off |
| `AD` | 0 / n | start a new block at this point; 0 = a new 4-byte header follows |
| `AE` | value | bit 7 of the tempo value |
| `AF` | *b* | new tempo, same formula as the header |
| `B0` | pos | go to position (0 = the loop point) |
| `B1-BF` | pos | repeat *n* more times to position (0 = the loop point); two counters |
| `C0-CF` | length | envelope shape *n* over *length* frames (only with constant volume; 0 = off) |
| `D0-DF` / `E0-EF` | period | volume slide up / down by *n* steps, one step every *period* ticks |
| `FD` | - | set the loop point |
| `FF` | - | end of track |
| `F0-FC`, `FE` | - | ignored |

Pitch table at `$EB35`: C = `$06AE` … B = `$038A` (C2-B2), shifted right by the octave. Notes write register 3 = `hi | $08`,
which loads length-counter index 1 (254 frames).

A rest does **not** turn its channel off in `$4015`. The driver merges the music mask into `$0080`, so `$4015` stays `$0F`
(checked in both songs); you hear whatever the channel's volume or envelope is doing.

### Sound-effect format

```
+0  1                 (OR'd into $E4; bit 0 enables the SFX engine)
+1  channel bit       1 pulse1, 2 pulse2, 4 triangle, 8 noise  (one channel per effect)
+2  register mask     which of the 4 registers each step writes (bit0 = reg 0 ... bit3 = reg 3)
+3  frames per step
+4  stream length in bytes
+5  4 register values written immediately
+9  stream: per step, one byte for each bit set in the mask
```

While an effect runs, the music skips writes to that channel. When the stream ends (after `frames per step` frames even for
length 0), the channel goes back to the music. Effects with length 0, like the Chinese cursor sound #4, are one-shots:
the 4 starting values plus the APU's own sweep, envelope and length counter.

## Extracted files

| Folder | Contents |
|---|---|
| `nsf/400in1_chinese.nsf`, `nsf/400in1_langsel.nsf` | **The original driver bank plus a 256-byte wrapper at `$DF00`.** Track 1 = the song; tracks 2-44 = SFX #0-#42 |
| `nsf/400in1_bank1C_dormant.nsf` | the dormant bank-`$1C` driver, 7 songs (see below) |
| `wav/` (not shipped here: `make music-export WAV=1`) | `chinese_song.wav` (2 loops, 60 s), `langsel_song.wav` (4 loops, 39 s); `sfx/` every distinct effect plus the English beep and the language-select chime; `dormant_bank1C/` 30 s of each dormant song |
| `txt/*_song.txt` | every track command with address, position, note name and length |
| `txt/*_sfx.txt` | every effect: channel, mask, speed, register values, duplicates, which one the menu uses |
| `data/` | raw bytes of each song and SFX area, named by file range |
| `tools/` | `extract.py ROM OUT [--no-wav]` regenerates everything (`make music-export [WAV=1]` writes it to `music/export/`); `tracecmp.py` (trace check); `apuscan.py`, `sndnames.py`. They use `../../music/sndlib.py` (parser, NSF builder, NSF player on the 6502 core, APU renderer) |

Loop lengths:
* Chinese song: 1,794 frames (29.85 s), all four channels together.
* Language-select song: 585 frames (9.73 s) for the melody. Its noise track loops every 570-571 frames, so the drums drift
  against the tune. That drift is in the original data.

## How this was checked

* **The NSFs reproduce FCEUX exactly.** The NSF player's APU write stream matches every write the traces show:
  * Chinese menu: 554 of 554 writes, same order and values.
  * Language select: 1,042 of 1,042 (English and Chinese traces).
* `tools/extract.py` lays out each track exactly up to the next one, and its tick count times 2.4375 equals the measured loop.
* **The WAVs come from my own APU model**: pulse, triangle and noise with envelope, sweep and length counters; no DMC (unused).
  * The pitch is exact (246.4 Hz test tone).
  * The mix and filtering are approximate. For the authentic sound, play the NSFs in an NSF player or in FCEUX.
* The traces contain no cursor movement in the Chinese menu, so SFX #4 there is static analysis plus the NSF run.

## Putting your own music in

Use **`music/`** (`menu_music.py`, `make music`); for the custom multicart, `custom/music/music.txt`. It converts MIDI songs into this format for the Chinese menu and the language
select, and replaces the Chinese cursor effect, the English beep and the language-select chime. It also fixes a driver bug
that long songs hit (the `AD` command with a non-zero argument) and adds a restart hook so songs of any length loop.
The space limits and the patched bytes are listed in its README.

## Bank `$1C`: a dormant older driver

File 0x38000-0x39FFF starts with a jump table (`$8000` → `$806C` tick, `$8003` → `$80FE` start sound A). It is
**Capcom's NES sound engine** (the variant that begins `4C 6C 80`, used by Mega Man 3-6, Mighty Final Fight, Darkwing
Duck, TaleSpin, The Little Mermaid, Gargoyle's Quest II, Destiny of an Emperor II and Rockboard), with one Capcom game's
sound list and songs, those of **Mighty Final Fight** (checked against that ROM with `tools/capcom_compare.py`). It is
filled with `$FF` in the stripped image the builder uses; the original dump in `roms/` still has it. It matches the
published format point for point: the `4C 6C 80` start, init at `$8003` with A =
sound ID, the instrument-table pointer at bank+`$A41` and the big-endian sound list at bank+`$A43`, songs that start with
`$00` and four big-endian channel pointers, the octave table at `$8923` (`00 0C 18 24 ...`), RAM up to `$D8`, and the
command set in the song data (`05` speed, `0A` global transpose, `06` length, `07` volume, `09` octave, `18` duty, notes
`$20-$FF` with the length in the top bits). None of the 400-in-1's games is a Capcom title, so the bank was copied in from
elsewhere: Mighty Final Fight, as `make capcom-compare ROMS="game.nes ..."` (`tools/capcom_compare.py`) shows (it compares
the engine code, the sound list and the 7 songs with any ROM). Format reference: Matrixz, "Capcom 6C80 sound
engine" (romhacking.net document 274). No trace reads or executes it, and no menu code calls it. The only `JSR/JMP $8000` sit in bank
`$19` data the menu never executes.

* RAM: zero page `$C0-$D8`, `$0700-$077B`. Tempo is fractional (`$C8 += $CA` per frame, `$CA = $99` at start).
* Sound list at `$8A40`: count `$36` (54), then big-endian pointers at `$8A43 + 2n`; a first byte of 0 = music, else the
  priority of an effect. Pointers `>= $C000` are read through `$A000` with MMC3 R7 set to `$18` (`$8000/$8001` writes),
  then R7 goes back to `$17`: the driver expects `$A000` = the next bank of its original ROM.
* Entries 0-7 = songs in this bank (`$8B57-$9FAE`); 16-17 empty; 8-15 (songs) and 18-53 (effects) point to
  `$A238-$AE4A`, in that missing next bank. The 400-in-1 has no such data (bank `$17`, file 0x2E000, is `$FF` there).
* Songs 0-6 read only bank `$1C` and are complete. Loops: 46.9, 46.1, 47.5, 40.0, 35.5, 33.6 and 41.5 s; all in minor keys
  (estimated F#, G#, F#, E, A, F, D minor). Song 7 has its header here but three of its four channels start at `$A065` and
  later: only pulse 1 plays. Numbers 8 and up read the missing bank and hang (with nothing mapped at `$A000`, as in
  `nsf/400in1_bank1C_dormant.nsf`, they only silence the channels).
* The Chinese NMI's `$4107=$3C` before `sound_tick` is probably left over from a menu version that used it.
