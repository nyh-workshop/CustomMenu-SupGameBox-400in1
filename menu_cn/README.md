# Sup 400-in-1 Chinese menu: disassembly of file 0x30000-0x3FFFF

Source: `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin`. Only the 64 KiB the Chinese
menu maps is used here; it is saved as `orig/..._30000H.bin`.
Code/data separation comes from `400in1_romdump_10042024_512KiB_chinese.log`.

| Folder | Contents |
|---|---|
| `src/` | CA65 source. Banks $1C-$1F are disassembled; banks $18-$1B are `.incbin`. Rebuilds the 64 KiB block byte for byte |
| `../reference/menu_cn/menu_cn.c` | Reference C of reset, NMI (CHR bank handling), dispatch and the launch hand-off |
| `chr/` | Tile sheets of the CHR ranges this menu uses |
| `tools/` | Generator and verifier (`MENU=cn python tools/analyze.py && MENU=cn python tools/gen.py`) |

## Build and check

```
make          # ca65 + ld65 -> build/menu_cn_30000H.bin (+ .map, .lbl)
make verify   # compares against orig/ ; prints "identical (65536 bytes)"
make check    # the same without cc65: tools/asmcheck.py + the comparison with the dump
```

From the project folder, `make menu-cn` builds it with ca65 when cc65 is found (else with asmcheck), and compares it with
`orig/` and with the same bytes of `roms/<512 KiB dump>`; `make verify` does all five blocks and the whole 512 KiB image.

Status (2026-11-11): `tools/asmcheck.py` (a strict stand-in for ca65 + ld65 that reads `src/main*.s`, follows the
`.include` / `.incbin` chain, applies ca65's address-size rules and range checks, and links by the `.cfg` file) rebuilds
this block **identical** to the dump. ca65 itself could not be run where this was prepared; run `make verify` here (or
`make verify` in the project folder) once with cc65 2.19 to confirm with the real tools. If anything differs,
`tools/cmpbin.py` prints the first differing addresses.

## How it is entered and banked

Language select (banks $34-$37) puts this stub at `$0400`: `$410B=1`, `$4107-$410A` = `$1C-$1F`, `$2018=$201A=0`,
then `JMP ($FFFC)`, which is `reset` at `$F9EE`.

PRG mapping (OneBus: bank = inner & mask | `$410A` & ~mask | `$4100`<<4). With `$410B=1` the mask is `$1F`, so:

| CPU | Bank | File | Contents |
|---|---|---|---|
| $8000 | $18-$1C via `$4107`=$38-$3C (shadow `prg8000_shadow` $08) | 0x30000-0x39FFF | menu data; bank $1C is mapped by the NMI for the sound driver |
| $A000 | $1D | 0x3A000 | data (read: 0x3B800-0x3BB7B) |
| $C000 | $1E | 0x3C000 | screens, list, sprites, launch |
| $E000 | $1F | 0x3E000 | reset, NMI, dispatch, sound, vectors |

Data read in the trace: 0x30002-0x306AC, 0x32000-0x32025, 0x34000-0x34784, 0x36000-0x3613B, 0x3B800-0x3BB7B.
The trace stops at the first screen, so more of banks $18-$1B is probably used when paging.

Vectors: NMI `$FA51`, RESET `$F9EE`, IRQ `$FBC8`.

## Structure (same scheme as the English menu, different variables)

* `reset` initialises the hardware (`hw_init` $C03C, PPU shadows $C05E, `read_4119_flag` $C07A, sound $E379).
  It then sets `menu_state`($30)=0, `menu_step`($31)=1 and loops `state_dispatch_main` ($FC27).
* `tbl_menu_states` ($CD40) points to `tbl_state0_steps` ($CD42). Its 4-byte entries are `{main, $0000}`:
  * step 0: `$CD8B` (screen 2)
  * step 1: `$CDE9` (screen 1, the one reached in the trace)
  * step 2: `$CE4E` (screen 3)
  * steps 3 and 4: `RTS`

  Each step loads a 9-byte screen record (`screen_desc_1..3`, $CD56/$CD5F/$CD68), loops until `step_exit` ($32) is set,
  and then goes to `launch_selected_game` (steps 0/1) through `$DBC2`/`$DBCC`.
* The NMI does the following:
  * runs an optional hook (`JMP ($24)` when `nmi_hook_mode` = 1/2);
  * does OAM DMA;
  * loads the CHR banks from `bg_chr_base` ($1D) and `spr_chr_base` ($4D);
  * writes `$4101/$4102/$4104` from `$3D` when non-zero (meaning not assumed);
  * restores the PPU shadows and reads the pad;
  * steps the PRNG (`prng_step` $C01E, state $011D-$011F);
  * maps bank $1C and runs `sound_tick` ($E34A), then restores `$8000`.
* `REG_4119` is **read** at start-up: bits 3-4 both set gives `flag_4119`=0, otherwise 1. Meaning not assumed.
  In an emulator run, both values give the same menu: `$0D` is never read afterwards (see `400in1_cn_hidden_screens`).

## Launching a game: the Chinese menu uses the English tables

`launch_selected_game` ($DD6C):

1. Maps bank $18 and copies an 8-byte record (via `($B2)`, from the pointer table at `$86C3`) to `$0400`.
2. Copies 16 bytes from `$DE36` to `$0100`.
3. Copies 218 bytes from `$DE5C` to `$0408`.
4. Sets `$2010=$4103=0` and runs the stub at `$0408`.

The stub only switches to the English block (`$410B=4`, PRG `$3C-$3F`) and jumps to **English `$AAB1`**
(`launch_from_chinese_menu`, now named in the English listing).

That routine computes `index = cn_page`($0375)`*10 + cn_row`($03C3), then runs the English `launch_game`. The game
therefore comes from the English list/launch tables (`$CE7B/$D27B` to `$B000/$B800`). The 8-byte record copied
above gets overwritten. **For a custom ROM, Chinese page *p*, row *r* must match English list entry `p*10+r`.**
The rest of the 218-byte stub after the `JMP` (`$DE75-$DF36`) never runs.

## CHR used by the Chinese menu

OneBus CHR (2bpp, no address extension, per the nesdev VT02+ CHR page):
1 KiB bank = `($4100&$0F)<<11 | (($2018>>4)&7)<<8 | (inner & mask($201A)) | ($201A & ~mask)`.
Here `$2018=$201A=$4100=0`, so **1 KiB bank = the value written, and file offset = value x $400**.
PRG and CHR share the same flash address space.

| Use | Registers | Values | File range |
|---|---|---|---|
| Background, list page *n* (n = 0..39) | `$2012-$2015` = `bg_chr_base`..+3, set by `set_page_bg_chr` from `tbl_page_bg_chr` ($F6A0) = n*4 | $00-$9F | **0x00000-0x27FFF** (4 KiB per page) |
| Background, first screen (traced) | same | $00-$03 | 0x00000-0x00FFF (shown while rendering) |
| Background, from screen record byte $0A + 2 (`$C194`) | same | traced: $7E-$81 | 0x1F800-0x207FF (loaded, not shown in the traced frames) |
| Sprites (traced) | `$2016`=`spr_chr_base`, `$2017`=+2 | $A0-$A3 | **0x28000-0x28FFF** |
| Sprites, other object records (static only) | from `$84D2` table (bank $18) | $84-$87, $0A-$0D | 0x21000-0x21FFF, 0x02800-0x037FF |

PPU_CTRL during the menu: background pattern table at $1000, sprites at $0000, 8x8 sprites.
**Overall: the Chinese menu's CHR stays within 0x00000-0x28FFF.** Each 4 KiB list page repeats the
shared header tiles (logo, digits) followed by that page's glyphs; see `chr/chinese_list_pages_000000-027FFF.png`.

## Second (ASCII) game list and the dormant screens

Bank $1A holds a second, different game list: 400 entries of `{name pointer, number}` at `$8143`, with ASCII names at
file 0x34785-0x35458, a char→tile map, and launch pointers at `$86C3` in bank $18. Only screen 2 (`step0_screen2`) uses
it, and screen 3 (`step2_screen3`) is a two-option chooser. In this build nothing selects step 2, so both look unreachable.
Forced in an emulator, both run, but their CHR base is `$02`/`$82`, which is 2 KiB off. The graphics are therefore garbage,
and the 8×16 ASCII font they need is not in the dump. A step-0 launch always starts English entry 0 (SUPER MARIO),
because `$DD6C` clears `$0300-$03FF` before the hand-off. Details and screenshots are in `400in1_cn_hidden_screens`.
Screen 1 only counts the list during setup. Details: `400in1_game_lists.md`.

## Sound

`sound_init` $E379 / `sound_tick` $E34A / `sound_play` $E351 (bank $1F). The routines and tables are now named in `src/bank1f.s`
(`music_tick`, `music_read_commands`, `sfx_tick_*`, `tbl_note_period`, `tbl_sfx_ptrs`, `song0_pulse1`…).
* One song: song 0, data 0x3EFB9-0x3F4B1.
* SFX table 0x3ED69; the cursor sound is SFX #4.
* Bank $1C (0x38000) holds a dormant older driver that the menu never calls.

Format, extracted NSF/WAV files and a reference C version: `400in1_menu_sound`.

## Open points

* The trace covers boot to the first screen only. Steps 0 and 2, paging and the launch path were run in the Python emulator
  in `400in1_cn_hidden_screens`, not on hardware or in FCEUX.
* The meaning of the screen record fields beyond byte $0A, and of the `$86C3` launch records, is not worked out.
* Many routines in bank $1E still have `sub_`/`loc_` names.
