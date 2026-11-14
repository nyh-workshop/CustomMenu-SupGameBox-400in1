# wallpaper/ — the Sup 400-in-1 menu backgrounds

For the custom multicart (`make rom`) just save `custom/wallpaper/english.png`; the builder runs this tool for you.

`wallpaper.py` exports and replaces the backgrounds of the three menu screens: **language select**, **English menu**
and **Chinese menu**. It works on the 512 KiB menu dump, or on any larger ROM that keeps the menu at the same offsets
(such as a built 8/16 MiB image). Needs Python 3 and Pillow (`pip install pillow`).

```
python3 wallpaper/wallpaper.py info   ROM
python3 wallpaper/wallpaper.py export ROM english out/ [--guide out/english_guide.png]   # english.nam/.chr/.pal/.png
python3 wallpaper/wallpaper.py import-png ROM english my.png -o new.bin
python3 wallpaper/wallpaper.py import ROM english --nam e.nam --chr e.chr --pal e.pal -o new.bin

make wallpaper-export [ROM=...]                     # all three -> wallpaper/out/ (+ *_guide.png: the list areas in red)
make wallpaper PNG_ENGLISH=b.png [PNG_LANGSEL=a.png] [PNG_CHINESE=c.png] [ROM=...] [OUT=my.bin]
```

Screens: `langsel`, `english`, `chinese`. The input ROM is never modified; the result goes to `-o`.

## How the menus draw a background

All three blocks contain the same routine (`$E1B9` / `unpack_nametable_rle` `$E169` in the English block):

1. A **descriptor** holds a 2-byte pointer to the packed screen, followed by the **32-byte palette** (background 16 + sprites 16).
2. The **packed screen** is decoded straight into PPU `$2000-$23FF`: 960 tile numbers plus 64 attribute bytes. The control bytes are:

   | Byte | Meaning |
   |---|---|
   | `$00` | end |
   | `$80+n` | repeat the next byte *n* times (*n* = 1-127) |
   | `$01-$7F` | copy the next *n* bytes |

3. The **tiles** come from a fixed 4 KiB CHR area of the same flash. PRG and CHR share one address space on OneBus.
4. The list text is drawn over the background afterwards, from RAM row buffers.

| | Language select | English menu | Chinese menu |
|---|---|---|---|
| Descriptor (pointer + palette) | 0x6E3AC | 0x7E140 | 0x3F616 |
| Packed screen | 0x6EC00, 553 bytes | 0x7E280, 271 bytes | 0x3B800, 341 bytes |
| Background CHR | 0x67000-0x67FFF (PPU $1000) | 0x62000-0x62FFF (PPU $0000) | tiles $00-$3F of each of 40 pages at 0x00000 + page×0x1000 (PPU $1000) |
| Tiles used now | 153 | 73 | 39 |
| Reserved tiles | $C7, $D7 (cursor sprite) | $00-$2D font, $2E cursor | $00 blank, $1E-$31 row numbers |
| Room for wallpaper tiles | 254 | 209 (font tiles can be reused) | **43** |
| Text drawn at run time | none (the text is part of the picture) | list rows: columns 8-28, rows 5-23, colour index 3 | glyph list: columns 10-25, rows 4-23, colour index 2 |

All three packed screens decoded with this format match the nametable writes in the FCEUX traces byte for byte.

Notes:
* **English:** the background and the font share one 4 KiB table, and the cursor sprite also comes from it.
* **Chinese:** every list page has its own 4 KiB of CHR. Only tiles `$00-$3F` are shared by all 40 pages (they are identical in
  every page), and `$40-$FF` are that page's name glyphs. So the background may use only `$00-$3F`, and the tool writes
  them into all 40 pages.

## Picture rules (`import-png`)

* 256×240 (or 512×480, scaled down), made of NES colours. Colours are matched to the nearest NES colour and black becomes `$0F`.
* One shared background colour (colour 0): the most common one, `--bg text` for the most common one under the English
  list lines (what the builder uses), or `--bg 0F` for a given colour. It is written to palette byte 0 and to byte 16
  (PPU `$3F10`, a mirror of the backdrop that the menu writes last; before this fix it stayed `$0F`, so the background
  always came out black).
* Each 16×16 block uses at most 3 colours besides the background, and the whole picture at most 4 such sets of 3 (the NES background palettes).
* **Areas under the menu text** (English and Chinese lists) must keep the text colour: the current index-3 colour, white `$20` in the original (English) or the
  current index-2 colour (Chinese). Those blocks can have at most 2 colours of their own plus the text colour.
  The tool says which block breaks a rule.
* Tile budget as in the table above. Identical 8×8 tiles are stored once. If the picture's colours fit the screen's current
  palettes, those palettes are kept, which also lets tiles be shared across palettes the way the original art does.

The packed screen is written in place when it fits. Otherwise it goes to a free area of the same block, and the descriptor pointer
is updated. The free areas are runs of `$00/$FF` that no trace reads or executes:

| Screen | Free areas |
|---|---|
| English | 0x7D981-0x7E0FF, 0x7E430-0x7E7DF |
| Language select | 0x6D5A7-0x6DA04 |
| Chinese | 0x3B1F6-0x3B7FF, 0x3BC00-0x3BFFF |

Only the background half of the palette is replaced; the sprite palette stays as it was.

## Editing with NES Screen Tool / NEXXT instead

`export` writes files in the usual formats: `.nam` (1024 bytes with attributes), `.chr` (4096 bytes) and `.pal` (16 bytes).
Edit them, then use `import`. This route lets you reuse one tile with different palettes by hand, which is the trick the
Chinese wallpaper needs to fit its 64 tiles. `import` refuses changes to reserved tiles, and for Chinese any tile above `$3F`
(`--force` overrides).

## Tests done

* `export` → `import` with unchanged files gives a byte-identical ROM (all three screens).
* `import-png` of each screen's own exported picture, then `export` again, gives a pixel-identical render (all three).
  The Chinese one needs the relocation path.
* A new test picture (`examples/sky.png`) imports into all three screens and renders exactly as drawn.
* Not run on the handheld or in an emulator here. Please try one in EmuVT/FCEUX before flashing.

## English list colours

```
python3 wallpaper/wallpaper.py colours ROM -o OUT [--text $38] [--backdrop $01] [--cursor $2A] [--title "$27 $30"]
```

Sets the list letters (colour 3 of the palettes under the list), colour 0 (around the letters and the picture
background), the arrow (sprite palette 1, colour 1) and the original title (background palette 2, colours 2 and 1).
`make rom` does the same from `custom/wallpaper/colors.txt` (`rombuilder/README.md`, "List colours").
