# Sup 400-in-1 boot stage 2 (bank $33) and TFT/LCD driver (bank $15)

Source: `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin`. Only the two 8 KiB banks that
run at boot are used. They run identically in all four FCEUX traces.

| File | Bank | CPU | Listing |
|---|---|---|---|
| 0x66000-0x67FFF | $33 | $A000 | `src/bank33.s` |
| 0x2A000-0x2BFFF | $15 (with $14 at $8000, never read) | $A000 | `src/bank15.s` |

## Build and check

```
make          # ca65 + ld65 -> build/bank33_66000H.bin + build/bank15_2A000H.bin (+ .map, .lbl)
make verify   # compares against orig/ ; prints "identical (8192 bytes)"
make check    # the same without cc65: tools/asmcheck.py + the comparison with the dump
```

From the project folder, `make boot` / `make tft` builds it with ca65 when cc65 is found (else with asmcheck), and compares it with
`orig/` and with the same bytes of `roms/<512 KiB dump>`; `make verify` does all five blocks and the whole 512 KiB image.

Status (2026-11-11): `tools/asmcheck.py` (a strict stand-in for ca65 + ld65 that reads `src/main*.s`, follows the
`.include` / `.incbin` chain, applies ca65's address-size rules and range checks, and links by the `.cfg` file) rebuilds
this block **identical** to the dump. ca65 itself could not be run where this was prepared; run `make verify` here (or
`make verify` in the project folder) once with cc65 2.19 to confirm with the real tools. If anything differs,
`tools/cmpbin.py` prints the first differing addresses.

`../reference/tft_driver/tft.c` is a reference C translation of the driver.

## Boot order

1. Reset (bank $3F) sets MMC3 R7=$33 and does `JMP $A000`.
2. **`boot_stage2` (bank $33)**:
   * `$4138=$0B $4139=$02 $4017=$C0`, PPU off, a ~4600-iteration delay loop;
   * clears RAM pages 0 and 3-7 (pages 1-2 are not cleared), waits two vblanks;
   * writes `$4240=$81 $4232=$02`, `$4200-$420D` = `00 02 2E 01 0E 06 00..` and `$420E=$00`. These `$42xx`
     registers are recorded with their values only;
   * ends with `JMP $FFB0` (bank $3F: `$4107=$14 $4108=$15`, `JMP $A000`).
3. **`tft_entry` (bank $15)**: runs `tft_detect_and_init`, then `JMP $FF60` (boot-select stub, then language select).

Bytes at bank $33 `$A0D8` (`JSR $A0E0; JMP $FF60`) are never reached.

## TFT driver

**Interface.** Commands and data go out through `$4FF0-$4FFA` (`$4FF7` = byte, `$4FF8` = high byte or 0,
`$4FF0` = a strobe sequence). Reads use `$4139` toggles and `$4135`/`$4136`. `$412D` switches between `$DC`
and `$FC` around reads. The reset pulse writes `$410F` = `$FF`, `$DF`, `$FF` with long delays. These meanings are
taken from the code's behaviour only. Register names stay `REG_xxxx`.

**Detection** (`tft_detect_and_init` $A006):

1. `lcd_reset_pulse`.
2. Read IDs with a series of commands in this order: `$0A/$F1`, `$04`, `$D3`, `$D5`, `$67`, `$00`, `$CD`, `$28`.
3. Compare `lcd_id0-2` ($0110-$0112) after each read. The first match sets `panel_type` ($0116), the command
   table pointer `$F8` and the list format `$0114`.

| type | name (`tbl_lcd_names`) | read | ID match | command table | format |
|---|---|---|---|---|---|
| $1E | S6D04M0 | $0A/$F1 | id0=08 id1=04 | $ABDD | 0 |
| $01 | 9306 | $04 | id1=93 id2=06 | $A7EF | 0 |
| $02 | 7789 | $04 | 85 85 52 | $A8EF | 0 |
| $03 | 9312 | $04 | id1=93 id2=02 | $A949 | 0 |
| $1B | 3029E | $04 | id1=30 id2=33 | $AABB | 0 |
| $04 | 9341 | $D3 | id1=93 id2=41 | $A998 | 0 |
| $1C | 3029C | $D3 | id1=31 id2=29 | $AB55 | 0 |
| $05 | 9340X | $D5 | id1=93 id2=40 | $A86E | 0 |
| $07 | 8347A | $67 | id1=47 | $AD57 | 2 |
| $20 | 8346 | $67 | id1=46 | $ADCF | 2 |
| $06 | 68090 | $00 | 08 09 / 68 07 / 68 01 | $AE37 | 1 |
| $0A | 9325 | $CD | see listing | $AEBD | 1 |
| $0B | 9325D | $CD | see listing | $AEBD | 1 |
| $0C | 9325C | $CD | see listing | $AF52 | 1 |
| $09 | 9328 | $CD | 03 28 | $AEBD | 1 |
| $0D | 9320 | $CD | 03 20 | $B0B7 | 1 |
| $08 | 8347D | $CD | id1=47 | $AC55 | 2 |
| $1D | 8347G | $CD | id1=75 | $ACD5 | 2 |
| $0E | 0139 | $CD | 01 39 | $AFEA | 1 |
| $0F | 4535 | $CD | 05 35 | $B037 | 1 |
| $11 | 61505U | $28 | id2=0F | $B158 | 1 |
| $12 | 61505V | $28 | see listing | $B1F3 | 1 |
| $10 | 4531 | $28 | 05 31 | $B27F | 1 |
| $13 | 1289 | $28 | 09 89 | $B364 | 1 |
| $1A | 1297 | $28 | 09 97 | $B364 | 1 |
| $14 | 5408A | $28 | 04 08 | $B3E1 | 1 |
| $16 | S6D0154 | $28 | 01 54 | $B2F0 | 1 |
| $17 | 61580 | $28 | 05 80 | $B5D6 | 1 |
| $18 | 7781 | $28 | 07 83 | $B6CD | 1 |
| $19 | 9335 | $28 | 03 35 | $B665 | 1 |
| $1F | 9331 | $28 | 03 31 | $B665 | 1 |
| $00 | NO CHECK LCD | - | nothing matched | $A7EF | 0 |

Type $15 (5408B) has a name and a command table (`$B497` via `panel_init_A40E`), but no detection rule selects it.
`$AA10` (`panel_init_A33E`) and `$B54D` (`panel_init_A41E`) are not selected either.
In FCEUX nothing matches, so the traces take the type $00 path.

**Command list formats** (`lcd_run_cmd_list` $A4DE):

| fmt | Routine | Layout |
|---|---|---|
| 0 | $A527 | `cmd, data.., $FE, cmd, data.., ..., $FF`. The first byte is always a command; `$FE` marks the next command |
| 1 | $A545 | `{reg, hi, lo}..`, `$FF n` = pause, `$FF $FF` = end, then command `$22`. 16-bit-register panels |
| 2 | $A578 | `{cmd, data}..`, `$FF n` = pause, `$FF $FF` = end, then command `$22` |
| 3 | $A5A2 | `{hi, lo}` raw words, `$FF n` = pause, `$FF $FF` = end. Not used by any panel here |

In every format the pause is one fixed `delay_long`. The byte after `$FF` is loaded into X but `delay_long`
reloads X and Y with 0, so it has no effect.
After the list the driver sets the interface block (`$4FF0-$4FFA`), waits two vblanks and writes `$4FF6=$81`.

**LCD name strings.** `tbl_lcd_names` ($B80A, file **0x2B80A**) has 33 pointers, one per panel type, to
NUL-terminated names at 0x2B84C-0x2B90E. No code in the 512 KiB dump reads them, and the test app trace doesn't either.
They are still useful as the key to `panel_type`. This list is longer than the 500-in-1's.

## Not in this project

Bank $34-$37 (language select, file 0x68000-0x6FFFF) and the test app (bank $35) run after this. They aren't disassembled yet.
