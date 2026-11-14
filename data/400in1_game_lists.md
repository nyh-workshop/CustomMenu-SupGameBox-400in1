# Sup 400-in-1: the two game lists and who uses them

Evidence: every read in the four FCEUX traces was mapped to a file offset (OneBus PRG rule, checked against FCEUX's
bank prefix on every executed instruction), plus a static search of the code. "Traced" = seen in a trace;
"static" = only found in the code.

## List 1: 0x78000, English menu (banks $3C-$3F)

| What | Where |
|---|---|
| Names | 500 x 16 bytes ASCII, `$FF` padded, at `$8000-$9F3F` (bank $3C) |
| List entries | `tbl_list_entries_lo/hi` `$CE7B` (256) / `$D27B` (244), 4 bytes: `{name pointer, launch row, sequence}`. Entry *k* points to name *k* |
| Launch data | `tbl_launch_params_b0/b8` `$B000/$B800`, 8 bytes per launch row, copied to `$0480-$0487` |

Users:
* **English list drawing**, bank $3E `$C7C0-$C853` (traced; the reader is `$C835`). For each row it reads the entry's name pointer, then
  the name until `$FF`, translates each character through `$CDD0` into the row buffer at `$0626`, and records the entry index at `$064D`.
* **Launch**, `relaunch_continue` / `launch_game` (bank $3D): index = page*10 + row, then list entry byte 2, then the launch row (traced).
* **Chinese menu launch** (see list 2) also ends here: English `$AAB1` uses `cn_page*10 + cn_row`.
* `relaunch_saved_game` `$A0E0-$A122` copies 12 bytes through the `$E7F1` "game record" table. In the launch trace those 12 bytes
  are `4C FF FF FF "HAPPY MA"`, i.e. part of this name table, not a record. The values computed from them are never used, so this
  path is leftover code.

## List 2: 0x34785, Chinese menu's ASCII list (bank $1A, paged in at $8000 with `$4107=$3A`)

| What | Where (CPU, with bank $1A at $8000) | File |
|---|---|---|
| Character→tile map, 2 x 128 bytes | pointer table `$8000` → `$8004`, `$8084` | 0x34000-0x34113 |
| List headers (16 bytes), selected by `$03F7` | pointer table `$8114` → `$8123` (sel 0), `$8133` (sel 1) | 0x34114-0x34142 |
| Entry list, 400 x `{name pointer, number}`, ends with `$FF $FF` | `$8143` | 0x34143-0x34782 |
| Names, variable length, `$FF`-terminated | `$8785-$9458` | **0x34785-0x35458** |
| Launch pointers indexed by `number` | `$86C3` in bank $18 → 12-byte records from `$892B` | 0x306C3, 0x3092B- |

Both headers use the same entry list (count 400 = `90 01`). The other header bytes (`08 01 0A 06` / `0A 01 0A 04`) look like layout values.
The list has 299 different titles, and only 200 of the 400 entries name a game that is also in list 1
(e.g. ANGRY BIRD2, PLANTS VS ZOMB, COMMANDO are only here). The order and the numbers (0-306) don't match list 1.

Users (all in the Chinese block, bank $1E):

| Routine | Does | Seen |
|---|---|---|
| `load_char_tile_map` $D2A7 | copies the char→tile map (`$8000[sel]`) to `$03FA` | traced |
| `load_list_header` $D648 | maps bank $1A, resets the page counters and `cn_page`, copies the header for `$03F7` to `$035D-$036C` | traced |
| `count_list4_entries` $DA55 / `count_list2_entries` $DA99 | walk the lists to the `$FF $FF` end, counts to `$0372` / `$0374` | traced |
| `draw_header_text` $D2C0 | copies the 32-byte row from `$8116[sel]` (first 5 bytes raw, the rest through the char map) to `$037E/$039E` | static |
| `pick_random_unused_entry` $DAC2 | `prng_step` until an index below the count that isn't already used (`$03C5[]`) | static |
| `build_ascii_name_row` $DAFE/$DB66 | follows the entry's name pointer, up to 22 characters, through the char map into `$037E/$039E` | static |
| `launch_ptr_from_ascii_entry` $DC8E | entry `number` x 2 + `$86C3` → `($B2)`, then `launch_selected_game` | static |

The trace reached only the setup and counting reads (0x34000-0x34784). No name text was read.

## So: are there two menus?

Inside the Chinese block, yes:

* **Step 1 / screen 1** (`step1_screen1` `$CDE9`, `$03F7=1`) runs after reset. It is the 40-page Chinese glyph list
  (`cn_page`, `cn_row`, CHR per page). Its input is `list_input` ($D331). On Start, `step1_exit_launch` skips the record copy and the
  stub jumps to English `$AAB1`, so the game comes from **list 1's** launch tables (entry `cn_page*10+cn_row`).
* **Step 0 / screen 2** (`step0_screen2` `$CD8B`, `$03F7=0`) is the ASCII-name screen built from **list 2**. It uses random selection
  (`pick_random_unused_entry`) and launches through `launch_ptr_from_ascii_entry` and the `$86C3` records.
* **Step 2 / screen 3** (`step2_screen3` `$CE4E`) is a two-option chooser (`chooser_input` $CEC7). Up/Down toggle `$007D`, and Start
  goes to step `$007D xor 1`, i.e. screen 2 or screen 1.

Reachability (static):
* `reset` always starts at step 1.
* The only step changes are `goto_state_step` calls with step 0 (`$CEC3`, `$CEE9`, `$D35D`), step `$007D xor 1` (`$CEE9`)
  and step 4 (`$CF30`, an `RTS` step). **Nothing selects step 2.**
* Step 1's own Start does select step 0, but `step1_exit_launch` starts the game before step 0 can run.
* So in this build the chooser and the list-2 screen look **unreachable**. List 2 is only read during screen 1's setup (counting).
* Even if screen 2 ran, `launch_selected_game`'s stub still jumps to English `$AAB1`. That uses `cn_page/cn_row` with list 1's
  tables, and the 8-byte record copied from `$86C3` is overwritten. Confirming this needs a trace of screen 2, which doesn't happen
  in any of the four traces.

Nothing in the language select or the test app (0x68000-0x6FFFF) reads either list.
