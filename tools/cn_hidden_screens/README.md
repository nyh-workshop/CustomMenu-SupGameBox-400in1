# Sup 400-in-1 Chinese menu: `$4119` and the hidden screens (step 0 / step 2)

Everything here comes from running the Chinese menu block (file 0x30000-0x3FFFF of the 512 KiB dump) in a small
Python OneBus emulator (`onebus_emu.py`). The step was forced **in emulator memory only**: the `lda #$01` operand at
`$FA42` in `reset` (`menu_step` = 1) is overridden with 0 or 2. The ROM file is not modified.

## The emulator, and how far to trust it

* Its PRG/CHR banking, the `$4101-$4104` scanline IRQ and the MMC3 `$8000-$E001` aliases follow FCEUX's `boards/onebus.cpp`.
  * The IRQ unit: `$4101` latch = `V & $FE`, `$4102` reload, `$4103` disable + acknowledge, `$4104` enable, clocked once
    per visible line.
* `$4119` is not a FCEUX register, so FCEUX returns open bus (`$41`, the high byte of the address). The emulator returns
  whatever value you pass to it.
* Not emulated: APU sound, VT extended video modes, exact PPU timing (whole-scanline steps).
* Validation on the normal path:
  * The step 1 screen is pixel-identical in layout to the FCEUX frame.
  * The set of executed addresses after reset is the same as the FCEUX Chinese trace (2105 addresses), plus 2 in the sound driver.
* None of the three screens arms the IRQ. The table at `$3D` stays 0, so the NMI never writes `$4101/$4102/$4104`,
  and the mid-frame CHR split code in the IRQ handler (`$FBC8`) never runs.

## `$4119` → `flag_4119` (`$0D`)

```
C07A  lda $4119 / and #$18 / cmp #$18 / beq C087
C083  lda #$01 / bne C089        ; bits 3-4 not both set -> flag 1
C087  lda #$00                   ; bits 3-4 both set     -> flag 0
C089  sta $0D / rts
```

| `$4119` value | flag | Run |
|---|---|---|
| `$41` (FCEUX open bus), `$00`, `$08`, `$10` | 1 | the traced path |
| `$FF`, `$18` | 0 | `beq` taken, `C087` runs |

Results (`t4119.py`, steps 0, 1 and 2, the same button script each time):

* **The only difference is the branch.**
  * Both runs rejoin at `$C089`.
  * The following 478,962 instructions are the same in both runs; the only difference is a 2-cycle timing offset.
  * RAM is identical except `$0D` itself, and the screens are identical.
* **`$0D` is never read**, by the Chinese menu or by the launch hand-off. The English code reached through `$AAB1` doesn't
  use `$0D` either, and the `$41xx`/`$201x` writes of a launch are the same under both values.
* So in this build `$4119` does **not** change the menu flow. It is read once and the result is ignored. It may be a
  hardware/version probe left in from the menu engine's template. A launched game could still read `$4119` itself, but
  that code is outside this dump.

## What forcing the hidden steps shows (`shots/`)

| Shot | What it shows |
|---|---|
| `01` | Step 1, the normal path. |
| `02-04` | **Step 0**, the ASCII list. It runs: cursor, paging and the random fill all work, but the picture is garbage. |
| `05` | Step 0 **reconstructed**: wallpaper drawn with CHR `$00`, text decoded from RAM. This is not emulator output. |
| `06-07` | **Step 2**, the two-option chooser. Down moves the cursor (`$7D` toggles), and nothing is legible. |
| `08` | Step 2, Start on option 1 → step 0. |
| `09` | Step 2, Start on option 0 → step 1, the normal Chinese list, which renders correctly. |

### Why steps 0 and 2 look broken

* Each step loads the shared wallpaper (logo in rows 1-2, starfield and sprites in rows 11-29, tiles `$00-$3F`).
  Those tiles are only correct when the BG CHR base is a multiple of 4: page *n* = `$4n`, 1 KiB banks.
* The screen record (`$8002[screen_id]` in bank $18, byte `$0A`) sets `$39`, and `bg_chr_base` = `$39 + 2`:

  | Screen | Step | `$39` | BG banks | What is there |
  |---|---|---|---|---|
  | 1 | 1 | `$7C` | overridden by `set_page_bg_chr` to `$00-$03` | correct |
  | 2 | 0 | `$00` | `$02-$05` (file 0x00800-0x017FF) | Chinese glyph halves of pages 0/1 |
  | 3 | 2 | `$80` | `$82-$85` (file 0x20800-0x217FF) | Chinese glyph halves of pages 32/33 |

  So every tile is fetched 2 KiB off.
* Step 0's names use an 8×16 font: tiles `$2D-$56` on top and `$57-$6D` below, through the char map at `$03FA`.
  **No such font exists anywhere in the 512 KiB dump.** I rendered every 1 KiB bank that has a blank tile 0 and a filled font area (126 of them), and none renders
  readable text.
* Step 2's nametable has no option labels at all, only the wallpaper and a 16×16 cursor sprite at y=`$30`/`$40`. Its
  labels must have been part of CHR art that this build no longer has.

These screens are leftovers whose graphics were not shipped in this ROM.

### What step 0 would list

The text decoded from RAM (`decode_ascii.py`, 8 rows per page, entries picked by `pick_random_unused_entry`):

```
page 1: ANGRY BIRD2, ANGRY BIRD3, PLANTS VS ZOMB, BANANA AND SHEEP, CONTRA 24IN1, ISOLATED WARRIOR, CONTRA FORCE, TURTLES1
page 2: CURLY MONKEY2, COMMANDO, THUNDER MAN, WARRIOR, MISSION IMPOSSIBL, KNOCK IT, UFO, IRRIGATE
```

The order depends on the PRNG (`$011D-$011F`, stepped every NMI), so it changes with timing.

### Launching from the hidden screens (`launch_test.py`)

* In both lists, **Start** is the launch button. A is not handled.
  * `list_input` → `goto_state_step(0,0)` sets `step_exit`, and the step's exit routine launches.
* **Step 1:** `step1_exit_launch` skips the RAM clear.
  * English `$AAB1` gets `cn_page*10+cn_row`. For example, row 3 → index 2 = **MARIO 3**.
  * It then writes `$410B=$09`, PRG `$DE/$DF`, `$2018=$10`, `$4100=$70`, `$201A=$01`.
* **Step 0:** `launch_selected_game` (`$DD6C`) first copies the ASCII entry's 8-byte record to `$0400`, then **clears
  `$0300-$03FF`**, which includes `cn_page`/`cn_row`.
  * The `$0408` stub goes to English `$AAB1`, which then computes index 0.
  * The record at `$0400` is overwritten by the English launch stub.
  * So **every step-0 launch starts SUPER MARIO**, whichever game is highlighted (`$410B=$04`, PRG `$F0-$F3`,
    `$2018=$60`, `$4100=$20`, `$201A=$66`).
  * The game's code is outside the 512 KiB dump, so the emulator stops there.

## Files

| File | Purpose |
|---|---|
| `onebus_emu.py` | 6502 + OneBus + PPU emulator (needs Pillow) |
| `run_cn.py` | boots the Chinese block the way the language-select stub does (`$410B=1`, PRG `$1C-$1F`, `JMP ($FFFC)`) |
| `force.py` | step override and input scripts |
| `decode_ascii.py` | turns step 0's tile rows back into text |
| `t4119.py` | the `$4119` comparison |
| `launch_test.py` | launch hand-off logging |
| `make_shots.py` | regenerates `shots/` |

From the project folder: `make cn-screens` (uses `roms/<512 KiB dump>`; `ROM=` for another copy). The scripts use the
OneBus model `rombuilder/emu.py`.
