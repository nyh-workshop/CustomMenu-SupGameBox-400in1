# TestApp/ — Sup 400-in-1 language select + Aaronix test app: file 0x68000-0x6FFFF

Source: `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin`. Only file `0x68000-0x6FFFF` is used,
saved as `orig/..._68000H.bin`. Code/data separation comes from all four FCEUX traces: the test app from
`_testapp.log`, the language select from the other three.

| Folder | Contents |
|---|---|
| `src/` | CA65 source of banks $34-$37 (2 424 instructions: 1 546 traced, 878 static). Rebuilds the 32 KiB byte for byte |
| `../reference/TestApp/testapp.c` | Reference C of the test app: reset, RAM/VRAM tests, controller screen, NMI, sound test |
| `../reference/TestApp/langsel.c` | Reference C of the language select |
| `tools/` | `MENU=ts python tools/analyze.py && MENU=ts python tools/gen.py`, then `make check` |

## Build and check

```
make          # ca65 + ld65 -> build/langsel_testapp_68000H.bin (+ .map, .lbl)
make verify   # compares against orig/ ; prints "identical (32768 bytes)"
make check    # the same without cc65: tools/asmcheck.py + the comparison with the dump
```

From the project folder, `make testapp` builds it with ca65 when cc65 is found (else with asmcheck), and compares it with
`orig/` and with the same bytes of `roms/<512 KiB dump>`; `make verify` does all five blocks and the whole 512 KiB image.

Status (2026-11-11): `tools/asmcheck.py` (a strict stand-in for ca65 + ld65 that reads `src/main*.s`, follows the
`.include` / `.incbin` chain, applies ca65's address-size rules and range checks, and links by the `.cfg` file) rebuilds
this block **identical** to the dump. ca65 itself could not be run where this was prepared; run `make verify` here (or
`make verify` in the project folder) once with cc65 2.19 to confirm with the real tools. If anything differs,
`tools/cmpbin.py` prints the first differing addresses.

## One block, two programs

The block is mapped as banks $34-$37 at $8000-$FFFF (`$410B=4`, `$410A=$37`, so the middle bits are $34).

| Program | Entry | Code | Data |
|---|---|---|---|
| Language select | `JMP $E000` from the boot stub (`$FF70` in the English block) | bank $37 (0x6E000-0x6F702) | 0x6E3AC-, 0x6EC00-0x6EE28, 0x6F703-, 0x6FDFD-0x6FF43 |
| Aaronix test app | RESET vector `$FFE0`, reached with A+B held at boot (English `ram_stub_support_app` does `JMP ($FFFC)`) | bank $35 (0x6A000-0x6BD0D) + `$FFE0` | bank $36 `$C000-$C7FF` (0x6C000-0x6C7FF), strings/palette in bank $35 |

Vectors: NMI `$06A0` (RAM, a `JMP` written at run time), RESET `$FFE0`, IRQ `$A023` (inside `testapp_main`; no IRQ fires in the traces).
Bank $34 (0x68000-0x69FFF) is never executed or read in the traces. It is the test app's CHR (`$2018=$10 $201A=$A6`,
1K banks `$1A0-$1A7`, background and 8x8 sprites both from 0x68000-0x68FFF). The test app can show 95 of its 512 tiles:
`$00-$0E`, `$11-$12`, `$15-$18`, `$1B-$1D`, `$1F`, `$21`, `$24`, `$30-$33`, `$35-$36`, `$50-$53`, `$60-$6F`, `$D0-$D3`,
`$DA-$FF` (tile n at 0x68000 + 16n). `chr/bank34_used_tiles.png` marks them; the stripped base keeps only these
(`tools/strip_rom.py`, `TESTAPP_TILES`). Found by running the test app on the OneBus model (every button on both pads,
fast A/B presses, the sound test, the AARONIX sprite animation, the RAM and VRAM error screens forced by patching the
compares) and from the code (the BCD press counts can show any digit, so all of `$00-$09` are kept). 0x69000-0x69FFF
(more letters, symbols and game-like sprites) is never shown.

## Language select (bank $37)

* `langsel_entry` ($E000):
  1. Clears page 1 and runs the init routines.
  2. Installs NMI `JMP $E115` at `$06A0`.
  3. Sets `$2018=$10 $201A=$9E` (CHR 0x66000-0x67FFF) and draws the screen.
* The loop waits for a pad change (`$E62D`). Up/Down toggle `langsel_cursor` ($C1) and move the sprite; Start confirms.
* **Cursor 0 = Chinese (top), 1 = English:**
  * 0: copies `ram_stub_start_chinese` ($EEB0) to `$0400`: `$410B=1`, PRG `$1C-$1F`, `$2018=$201A=0`, `JMP ($FFFC)` (Chinese reset $F9EE).
  * 1: copies `ram_stub_start_english` ($E6E4) to `$0400`: `$410B=4`, PRG `$3C-$3F`, `JMP $FB7D`.
* `$E06B-$E087` is an older inline Chinese launch that the code jumps over.
* `$EEF0` writes `$413F=$1F $4138=$0B $4139=$0F`, the same values as the English block's support-app stub (meaning not assumed).

## Aaronix test app ("MAIN DEVICE TEST")

1. `testapp_reset` ($FFE0): PPU off, mirroring 0, `JMP $A2D0`.
2. `testapp_start` ($A2D0): if `warm_marker` ($0680) = `$57`, this is a second reset. It goes to
   `testapp_warm_reset_to_langsel` ($B828): NMI → `JMP $E532`, marker cleared, `JMP $E000` (language select).
   So pressing reset in the test app returns to the language select.
3. `test_wram_patterns` ($A600): writes and reads back every byte of $0000-$07FF with the 4 patterns in
   `tbl_ram_test_patterns` ($A5FC). Then `$A66D` fills all 8 pages and compares.
4. `$A6C5`: copies bank $36 `$C000-$C7FF` into RAM and compares (a ROM→RAM copy test).
5. `clear_wram` ($A743), then `test_vram` ($A761): fills $2000-$27FF with `$FF` and reads it back.
   Error paths lead to the "RAM ERR" text in the string data.
6. `testapp_install_nmi_cold` ($B808): NMI → `JMP $A200`, `warm_marker=$57`, then `testapp_main`.
7. `testapp_main` ($A000):
   * fills the nametables with tile `$30`;
   * prints the strings (tile codes: `$00-$09` digits, `$0A-$23` A-Z, `$30` space):
     "MAIN DEVICE TEST", a dashed line, "O"/"O", the label row "O   O    S   S    B   A", and "AARONIX";
   * sets the palette from `$A4FF`, the attribute table and the grid (`$B400`), and turns on NMI.
   * Main loop: `read_both_pads` ($A180) reads pad 1 and pad 2 together. Each button gets a tile (normal/highlighted,
     e.g. A = `$0A`/`$52`). It also shows the raw bit of each read at `$0721`/`$0725`. A and B presses are
     counted in BCD (`$10`/`$11`, both edges).
8. `testapp_nmi` ($A200):
   * OAM DMA from page 7;
   * draws the 8 button tiles at `$22xx`;
   * every 60 frames shows the A/B counts (a press-rate / turbo meter) and resets them;
   * runs the sound test (`show_sound_step` $ABD0 and `sound_test_step` $AA00, a step sequencer on pulse 1);
   * sets `PPU_MASK=$18`, writes `$4139=$0F`.

## Open points

* The VRAM-test error display (`$A7C7-$A88D`) and sound steps 4+ are in the listing but not fully described here.
* `$E532` (the NMI used after a warm reset) and bank $34 are not traced.

## Sound (language select)

The language select carries the same driver as the Chinese menu, shifted by $BDC. It is now named in `src/bank37.s`:
* `sound_init` $EF55, `sound_tick` $EF26 and `sound_play` $EF2D (never called);
* channel RAM $0400, song number $045D;
* song 0 at 0x6FDFD-0x6FF81, 43 SFX at 0x6F945.

`langsel_click_sfx` ($EA80) is a one-shot pulse-1 chime played once at start-up from $E41E.
Details: `400in1_menu_sound`.
