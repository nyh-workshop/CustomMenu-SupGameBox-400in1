# identical/ — the byte-identical menu sources, frozen

A self-contained copy of the four source folders as they rebuild the original dump exactly, with its own `make`.
It is there to show the 100% match at any time; never edit it for your own menu (work in `../menu`, `../menu_cn`,
`../TestApp`, `../tft_driver` and use `make custom` in the project folder).

```
make                 # all five blocks (against their orig/ files) + the blocks in ../roms/<stripped image>
make ASM=ca65        # require cc65 (CC65=/path/to/cc65/bin, or ca65/ld65 on PATH)
make ASM=check       # only tools/asmcheck.py (no cc65 needed)
make ROM=<dump>      # also compare all 512 KiB with your dump (it is not shipped)
cd menu && make verify      # one block with cc65 alone, as in each folder's own Makefile
```

| folder | file range | built from |
|---|---|---|
| `menu/` | 0x70000-0x7FFFF | 0x78000-0x7FFFF from source (English menu, banks `$3C-$3F`); 0x70000-0x77FFF `.incbin` from `orig/` |
| `menu_cn/` | 0x30000-0x3FFFF | 0x38000-0x3FFFF from source (Chinese menu, banks `$1C-$1F`); 0x30000-0x37FFF `.incbin` (menu data banks `$18-$1B`) |
| `TestApp/` | 0x68000-0x6FFFF | all from source: language select + Aaronix test program, banks `$34-$37` |
| `tft_driver/` | 0x66000-0x67FFF, 0x2A000-0x2BFFF | all from source: boot stage 2 (bank `$33`), TFT driver (bank `$15`) |

`make` prints `IDENTICAL` per block (for ca65 and for asmcheck when both ran, plus `ca65 output == asmcheck output`),
then puts the five blocks into the stripped image (`../roms/…_stripped.bin`), strips it again and compares all 524,288
bytes with it; with `ROM=<your dump>` it puts them into a copy of the dump and compares all 524,288 bytes. 112 KiB of
the menu region are assembled from source; the rest is graphics, menu data, the two `.incbin` halves above and `$FF`.
The `orig/` files are the original bytes, each checked against its SHA-1.
