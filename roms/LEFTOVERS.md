# What is left in the stripped image (scan of 2026-11-14)

Every non-`$FF` byte of `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin` was classified. Two
sources were used. First, the OneBus model ran every program, recording every PRG byte read and every tile put on the
screen:
- boot, the language select (both choices);
- the Chinese menu: all 40 pages, rows, launches;
- the English list: all 40 pages, launches of games 1, 27, 312, 314 and 400;
- the A+B test program, with its RAM and VRAM error screens forced.

Second, the disassemblies: untraced code, and data that code refers to.

**No NES game program or game graphics are left.** The places where game data sat (GOBLET TOWER PRG, MARIO 3 CHR,
SPIDER MAN PRG/CHR) are already `$FF`. What remains that the menus never use:

## From other products

| File range | Size | What |
|---|---|---|
| 0x38000-0x39FFF | 8 KiB | bank `$1C`: **Capcom's sound engine** with Mighty Final Fight's sound list and songs (confirmed against that ROM). **Removed** from the stripped image (2026-11-14) |
| menu background tiles | 841 tiles | **Street Fighter 2010** starfield / planet tiles in the Chinese, English and language-select backgrounds. **Removed** from the stripped image, blanked to black (roms/README.md) |
| 0x79390-0x79F3F | 2.9 KiB | English names 314-500: never shown (entries 314-400 show names 1-87 through the remap; there is no entry 401-500). Names 401-500 are games not on this cart: 1942, ARKANOID, ASTRO ROBO SASA, …, ANGRY BIRD, AQUARIUM, ARENA, AIR ALERT, AWFUL RUSHING, AIMLESS, BURBLES (a 500-game list) |
| 0x34780-0x3545A, and parts of 0x30000-0x323FF | about 10.7 KiB | the Chinese menu's second list (400 ASCII names, 299 titles, e.g. COMMANDO, MORTAL KOMBAT) with its screen records and launch pointers; read only by the hidden Chinese screens that nothing selects |
| 0x7E7EC-0x7F932 | 4.4 KiB | English `tbl_game_records`: a game-record table (9-byte records with launch stubs) that no code reads |

## Older copies of the 400-in-1's own code and graphics

| File range | Size | What |
|---|---|---|
| 0x660E0-0x66EFF | 3.6 KiB | an older copy of the TFT driver in bank `$33` (65% of its 16-byte pieces also appear in bank `$15`); never reached |
| 0x6C800-0x6CFFF | 2 KiB | data next to the test program's VRAM-test source; never read |
| 0x6D000-0x6DFFF | 4 KiB | a font (0-9, A-Z) inside PRG bank `$36`; never read and never mapped as CHR. Probably from an older CHR-RAM test program: bank `$35` still has a loop that reads a 16-tile font at `$B1FA` and throws it away |
| 0x28000-0x28FFF | 92 tiles | the Chinese menu's sprite page: only the 4 cursor tiles are shown; the rest is another copy of the "400 IN 1" logo, digits and star background |
| 0x67610-0x67D3F | 17 tiles | language-select CHR never shown (texture tiles, two half-words) |

## Part of the menus, kept

Launch rows of games outside the dump (0x7B000-0x7BFFF), TFT command tables for other panel types and the panel name
strings, untraced code paths, the padding in the Chinese name-layout tables, and 5 background tiles per Chinese page.
These belong to the menus even if this run did not reach them.
