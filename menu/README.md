# Sup 400-in-1 menu: disassembly of file 0x70000-0x7FFFF

Source ROM: `romdump_sup400in1_10042024_201812_opcode_bits45_swap_70000H.bin`
(64 KiB = file 0x70000-0x7FFFF of the 512 KiB dump, with the startup opcodes already
bit-swapped back so emulators run it).

Code/data separation is guided by the four FCEUX traces (`400in1_romdump_10042024_512KiB_*.log`).

| Folder | Contents |
|---|---|
| `src/` | CA65 source that rebuilds the 64 KiB block byte for byte |
| `../reference/menu/` | Reference C translation of the boot, menu core and game launch (for reading and rewriting; it does not rebuild the bytes) |
| `orig/` | The original 64 KiB block, used by `make verify` and for the lower 32 KiB `.incbin` |
| `tools/` | The Python scripts that produced `src/`, plus the trace coverage they use |

## Build and check

```
make          # ca65 + ld65 -> build/menu_70000H.bin (+ .map, .lbl)
make verify   # compares against orig/ ; prints "identical (65536 bytes)"
make check    # the same without cc65: tools/asmcheck.py + the comparison with the dump
```

From the project folder, `make menu` builds it with ca65 when cc65 is found (else with asmcheck), and compares it with
`orig/` and with the same bytes of `roms/<512 KiB dump>`; `make verify` does all five blocks and the whole 512 KiB image.

Status (2026-11-11): `tools/asmcheck.py` (a strict stand-in for ca65 + ld65 that reads `src/main*.s`, follows the
`.include` / `.incbin` chain, applies ca65's address-size rules and range checks, and links by the `.cfg` file) rebuilds
this block **identical** to the dump. ca65 itself could not be run where this was prepared; run `make verify` here (or
`make verify` in the project folder) once with cc65 2.19 to confirm with the real tools. If anything differs,
`tools/cmpbin.py` prints the first differing addresses.

## Where everything is (8 KiB bank = file offset / 0x2000)

FCEUX prints `$BB:addr` with BB = **16 KiB** bank, so `$1F:E7E0` = file 0x7E7E0 and
`$19:A022` = file 0x66022.

| File range | 8 KiB banks | CPU | What | Seen in traces |
|---|---|---|---|---|
| 0x70000-0x77FFF | $38-$3B | $8000-$FFFF | Separate 32 KiB program with its own vectors (RESET $F000, NMI $F0C7, IRQ $F163). Neither menu maps it: the Chinese menu's `$4107=$38-$3B` selects 0x30000-0x37FFF because `$410B=1` masks the bank | never runs |
| 0x78000-0x79F3F | $3C | $8000 | **Game names**: 500 x 16 bytes ASCII, $FF padded (only 400 are used) | data |
| 0x7A000-0x7BFFF | $3D | $A000 | Relaunch + game launch code, launch parameter table $B000-$BFFF | yes |
| 0x7C000-0x7DFFF | $3E | $C000 | Menu screens, list drawing, input, list-entry tables | English |
| 0x7E000-0x7FFFF | $3F | $E000 | Reset, NMI, state dispatch, game record table, vectors | yes |

Other parts of the 512 KiB that the boot passes through (not in this 64 KiB):

| File | Bank | Role (from traces) |
|---|---|---|
| 0x66000 | $33 at $A000 | First code after reset (`$FF30` sets MMC3 R7=$33, `JMP $A000`) |
| 0x2A000 | $15 at $A000 | Entered from `$FFB0` (PRG $14/$15). Bit-bangs $412D/$4139/$410F, most likely the TFT/LCD init |
| 0x68000-0x6FFFF | $34-$37 | Language select (`JMP $E000` from the `$0400` stub) |
| 0x6A000 | $35 | Test app (A+B at boot) |
| 0x38000-0x3FFFF | $1C-$1F | **Chinese menu**. Entered with `$410B=1`, PRG $1C-$1F, `$2018=$201A=0`, `JMP ($FFFC)` = $F9EE |

## Boot sequence

1. RESET `$E7E0` goes through a JMP chain to `$FFD9` `reset_early_init`: `$4134=$D0 $412D=$DC $4137=$81 $411C=$05`.
2. `$FEF5` `reset_main_init`: `$4138=$0B $4139=$02`, PPU off, PRG $8000=$3C $A000=$3D, CHR via MMC3 R0-R5 (`$A9E0`), palette all $0F.
3. `$FF30`: MMC3 R7=$33, then `JMP $A000` into bank $33 (outside this file).
4. Bank $33 does `JMP $FFB0`, which runs bank $15 (TFT init).
5. `$FF60` copies the `$FF70` stub to `$0400`. It sets `$410B=4`, PRG $3C-$3F, then calls `check_AB_support_app`:
   * pad == $C0 (A+B): `ram_stub_support_app` ($AA78) sets `$4100=0 $410B=4 $4109=$36 $410A=$37 $2018=$10 $201A=$A6 $413F=$1F $4138=$0B $4139=$0F`, then `JMP ($FFFC)` (test app)
   * otherwise: PRG $34-$37, `JMP $E000` (language select)
6. Language select (English) puts `$410B=4`, PRG $3C-$3F and `JMP $FB7D` at `$0400`.
7. `english_menu_entry` ($FB7D) copies `$FB8C` to `$0200` and runs it there (`$2018=$10 $201A=$8E`, CHR banks).
   It then goes `$FF1C`, the A+B check, `$F935` (RAM clear), and `$F9C0`: MMC3 R6/R7 = $3C/$3D.
8. **Hidden hot-keys** at `$F9D5` (static code, not exercised in the traces). If these are held when the English menu starts, it jumps directly to a game number:
   A+Select gives game $05, B+Select $30, Select+Start $9D.
9. `menu_main` ($FA16): NMI pointer `$D0`=$FA3A, idle hook `$D4`=$C8D4, then loops `state_dispatch_main`.

## Menu architecture

* **State machine.** `menu_state` ($035C) and `menu_step` ($035D) index `tbl_menu_states` ($C8F6),
  which gives 4-byte entries `{main handler, NMI handler}`. Only state 0 exists:
  step 0 = `$C948` / `$C957`. Step 1 = `$C900` / `$C92E` is present but never reached in the traces.
* **NMI** (`$FA37: JMP ($D0)` goes to `$FA3A`):
  1. An optional one-shot PPU job runs through `JMP ($B0)` when `nmi_hook_pending` is set.
  2. OAM DMA from page 2.
  3. CHR R0-R5 are reloaded from the shadows at $0332/$0333/$032D-$0330.
  4. Scroll is set, then the state's NMI handler runs.
  5. The pad is read into `pad_state` ($0327) and the frame counters advance.
* **Input** (`menu_handle_input`, $C9A9, from the NMI, every 7th frame).
  Bits of `pad_state` are A=$80 B=$40 Select=$20 Start=$10 Up=$08 Down=$04 Left=$02 Right=$01.

  | Key | Action |
  |---|---|
  | Up | cursor up, previous page at the top |
  | Down | cursor down, next page at the bottom |
  | Left / Right | one page back / forward |
  | B / A | five pages back / forward |
  | Start | sets `menu_start_pressed` |

* `menu_run_screen` ($C461) draws the screen (`draw_screen_by_id`, $C2C5, screen table $FC3C), beeps
  (`sfx_beep`: pulse 2 `$4004-$4007 = FF AA 78 00`), and then loops `redraw_list_page_if_dirty`
  until Start is pressed. Then `state0_step0_main` jumps to `relaunch_saved_game` ($A000).
* Text is written through `print_string_struct` ($C045). It takes a 5-byte struct at `($70)`
  {x, y, ptr lo, ptr hi, len} and queues the PPU write for the NMI (`nmi_hook_write_string`, $C0BF).
* Paging uses 32-bit counters: `cur_page` $0618-$061B and `last_page` $0610-$0613. Rows per page are in `rows_per_page` ($0649),
  the cursor row is `cursor_row` ($064B) and the "redraw needed" flag is `list_dirty` ($064C).
* RAM page 6 ($0600-$06FF) is **not** cleared by `relaunch_saved_game`. The menu keeps its list state there.

## Game launch (from the menuselect_jumptoapp trace)

`relaunch_saved_game` ($A000):

1. Waits until all buttons are released.
2. Clears the nametables, palette, CHR-RAM and RAM (except page 6).
3. Looks up the game number from the row table at `$064D` and `tbl_list_order_ptrs` ($CE30).
4. Copies the 9-byte `game_rec_NNN` (via `tbl_game_records`, $E7F1) to `$0100`.
5. Runs `relaunch_prepare` ($A220), which picks presets by record byte 3: `$02 $11 $12 $44 $54 $64 $73 $82 $92 $94 $99 $A9` or a default.
6. Sets mirroring from record byte 8.
7. `relaunch_continue` ($A8C1) computes `lin_index` = page*10 + row, then calls `launch_game` ($A82C).

Note: the presets written to `$0114-$011D` are not read anywhere else in this 64 KiB. `$0100-$0107` is overwritten shortly afterwards. The parameters the launch actually uses come from:

* `tbl_list_entries_lo/hi` ($CE7B, 256 x 4 bytes / $D27B, 244 x 4 bytes = 500 entries): byte 2 is the launch row.
* `tbl_launch_params_b0/b8` ($B000 / $B800, 8 bytes per row) are copied to `$0480-$0487`:

| Byte | RAM | Used by the $0400 stub as |
|---|---|---|
| 0 | $0480 | `$4118` = $80 if non-zero else $00; also `$4100` bits 3+ |
| 1 | $0481 | (not read by the stub) |
| 2 | $0482 | `$201A` |
| 3 | $0483 | first PRG bank. If `($0486 & $0F) == 4`: banks n..n+3 into $4107-$410A. Otherwise n/n+1 mirrored ($4107=$4109, $4108=$410A) |
| 4 | $0484 | `$4100` = ($0480 << 3) \| $0484 |
| 5 | $0485 | `$2018` = value & $F0 |
| 6 | $0486 | `$410B` (bit 7 = mirroring, written to `$A000` and then cleared) |
| 7 | $0487 | (not read by the stub) |

Special case `$A960`: `lin_index` = $0C with row $38 uses the bytes at `$A980` instead.

The stub writes `$410B/$201A/$4100/$2018` through pointers at `$D8-$DF`, filled from
`tbl_reg_pointers` ($A8B1). So these registers never show up as plain operands.
Traced launch: `$410B=$05 $4107=$4109=$9C $4108=$410A=$9D $2018=$20 $4118=$00 $4100=$10 $201A=$76`, then `JMP ($FFFC)`.

## Launch from the Chinese menu

The Chinese menu (file 0x38000-0x3FFFF, separate project) launches games through this block. Its `$0408` stub sets
`$410B=4`, PRG `$3C-$3F` and jumps to **`launch_from_chinese_menu` ($AAB1)**. That code computes
`lin_index = cn_page($0375)*10 + cn_row($03C3)` the same way as `relaunch_continue` and calls `launch_game`.
Both menus therefore share the list/launch tables here.

## CHR used by the English menu (and the screens around it)

OneBus CHR rule (2bpp, no address extension): 1 KiB bank = `($4100&$0F)<<11 | (($2018>>4)&7)<<8 |
(inner & mask) | ($201A & ~mask)`, where `$201A` bits 0-2 select the mask. The file offset is bank x $400, since PRG and CHR share the flash.
Values come from replaying the traces (`tools/chrtrack.py`).

| Screen | $2018 / $201A | Inner regs | Mapped 1 KiB banks | Shown (PPU_CTRL) | File range |
|---|---|---|---|---|---|
| **English menu** | $10 / $8E (mask $07, middle $88) | MMC3 R0=0 R1=2 R2-R5=0 | $188-$18B at $0000-$0FFF | BG and sprites both at $0000 | **0x62000-0x62FFF** |
| Language select | $10 / $9E (mask $07, middle $98) | R0-R5 = 0,2,4..7 | $198-$19F | BG and sprites at $1000, i.e. $19C-$19F | 0x67000-0x67FFF shown (0x66000-0x67FFF mapped) |
| Test app | $10 / $A6 | | $1A0-$1A7 | BG/sprites at $0000 | 0x68000-0x68FFF shown (0x68000-0x69FFF mapped) |

With `$201A=$8E` only 3 inner bits are free, so the English menu can never reach outside **0x62000-0x63FFF**.
Tile sheets are in `chr/`. Only during game launch are `$2018/$201A/$4100` set from the launch parameters (that is
the game's CHR, not the menu's). `relaunch_saved_game` writes zeros to PPU $0000-$1FFF (8 KiB). On CHR-ROM that has
no effect; in the trace it targets banks $188-$18B.

Note: the language-select CHR window (0x66000-0x67FFF) includes the boot-stage-2 code at 0x66000-0x660D7. Only the
upper 4 KiB is displayed.

## Registers: known vs. only observed

Treated as known: NES PPU/APU, OneBus PRG `$4100 $4107-$410B`, OneBus CHR `$2010-$201A`, MMC3-style
`$8000/$8001/$A000`. These are written as `REG_41xx` with observed values only, and no meaning is assumed for this ROM:
`$4118` (launch: $80/$00), `$411C`, `$412B`, `$412C`, `$412D`, `$4134`, `$4137`, `$4138`, `$4139`, `$413F`,
`$410F` (bank $15 only).

## How the listing was made

* Code is every instruction seen in the four traces (1 708). Static recursive descent from those adds untraced
  branches and the targets of the indirect-jump tables (`$C8F6`, `$C2E7`, the `$B0` NMI hooks). That gives 2 527 instructions in all.
  Untraced code is marked `; static (not seen in traces)`.
* RAM stubs are kept at their ROM address with a comment saying where they run (`$0200`, `$0400`). Their branches are
  relative, so the bytes are the same.
* Absolute jumps that land in another bank at run time (`$FF3A` to bank $33, `$FFB9` to bank $15, `$FF9A` to bank $37)
  stay as numbers with a comment.
* To regenerate: `MENU=en python tools/analyze.py && MENU=en python tools/gen.py` (writes `src/bank3*.s`, `regs.inc`,
  `ram.inc`), then `make check` (the older `tools/verify.py` needs only `src/`). The same tools drive the Chinese and boot/TFT projects (`cfg_*.py`).
* `tools/prgread.py` and `tools/chrtrack.py` replay an FCEUX trace with the OneBus PRG/CHR rules and list what
  file ranges are executed, read or shown as tiles.

## Open points

* Bank $33 (file 0x66000) and bank $15 (0x2A000) run before the menu. They are not in this 64 KiB.
* The `$E7F1` 9-byte records (`4C lo hi` + 6 bytes) are leftovers. In the launch trace the 12-byte copy in `relaunch_saved_game` actually
  read name text (`4C FF FF FF "HAPPY MA"` from 0x7904C), and nothing uses the result. See `400in1_game_lists.md`.
* `$C900/$C92E` (state 0 step 1) and the hot-key paths are static only.
* Many routines in bank $3E still have `sub_`/`loc_` names, for example the list drawing below `redraw_list_page_if_dirty`.
* Language select (banks $34-$37) and the test app are not disassembled yet.
