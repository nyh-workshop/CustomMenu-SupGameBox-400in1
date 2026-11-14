# reference/ — readable C of the 400-in-1 code

Hand-written C translations of the disassembled code, for reading and for rewriting parts later. They are **not**
byte-exact: the ROM is rebuilt from the assembly in `menu/`, `menu_cn/`, `TestApp/` and `tft_driver/`. Each file
names the listing routines it translates; routines not translated yet are declared `extern` with their listing names.

| file | translates |
|---|---|
| `menu/boot.c` | English block: reset, boot stub, language-select hand-off, A+B test entry (`src/bank3f.s`) |
| `menu/menu.c` | English menu core: main loop, state dispatch, NMI, input (`src/bank3f.s`, `src/bank3e.s`) |
| `menu/launch.c` | relaunch and game launch: the list index, the 8 launch bytes, the start stub (`src/bank3d.s`) |
| `menu/hw.h`, `menu/ram.h` | registers and RAM names shared by the files here |
| `menu_cn/menu_cn.c` | Chinese menu: reset, NMI (CHR bank handling), dispatch, launch hand-off |
| `TestApp/langsel.c` | the language select |
| `TestApp/testapp.c` | the Aaronix "MAIN DEVICE TEST": RAM/VRAM tests, controller screen, NMI, sound test |
| `tft_driver/tft.c` | the TFT panel driver (bank `$15`) |
| `sound_driver.c` | the menu sound driver (Chinese copy `$E34A`; the language select's copy is the same at +`$BDC`) |

`make reference-check` compiles every file: with cc65 (`cc65 -t none -O --cpu 6502`) when it is found, else with the
host C compiler (`-std=c99 -fsyntax-only`). Checked here with gcc: all 8 files compile.
