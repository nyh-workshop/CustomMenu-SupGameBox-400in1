# CustomMenu-SupGameBox-400in1

## For Claude's Notes, please refer to `README_Claude.md`!

# Author's Notes

## This is a Claude-assisted decompilation and analysis of the menu ROM in the Sup Game Box 400-in-1. This decompilation gives back the byte-identical code as of that dumped menu ROM when recompiled.

- The ROM of this handheld is extracted using the method from this [link](https://nyh-workshop.github.io/Custom-ROM-Sup-Game-Box-400in1/).
- As from that [link](https://nyh-workshop.github.io/Custom-ROM-Sup-Game-Box-400in1/), the address range of the menu code are mainly identified manually before sending them to Ghidra.
- In Ghidra, some of the 64KiB segments are manually identified and decompiled.
- Claude performs some more analysis and decompilation on unknown areas (Aaronix test app, music engine, menu wallpaper) and its reports have been verified on the emulator EmuVT 1.36 and FCEUX.
- Claude helps to generate helper scripts (in Python) and `make` scripts to compile the full 8/16MiB ROM for the emulator and the handheld.
- **Other games' CHR + PRG and sound engine inside the ROM have been removed and filled with 0xFFs.**
- Users can put their custom games, wallpaper and music in the menu.

# General Folders

`reference` - Claude assisted decompiled C files that are functionally equivalent to the actual binary but not binary-identical. It is for reference (understanding the code etc.) and no modifications should be done there. 

`identical` - Claude assissted decompiled C and asm files of the menu with binary-identical compilation. You get back that original binaries with this one if you compile them.

# How to build ROM

## Put the required files into the `custom` folder, and then do a `make SCAN=1`. The bin and NES file is inside the `build\rom` folder.

|`\custom` folder| |
|---|---|
|`games`| Put your NES games there. Only Mapper 0 and MMC3 games allowed!|
|`music`| Put your midi file inside. For the music, make sure the midi file is short (about 30 seconds?) and only have like 4 tracks. Check `songs.txt` and modify accordingly.|
|`wallpaper`| Put an 8-bit PNG file only, and rename it as `english.png`. Hint: Do not put complicated artwork there - keep it simple and adhere to the NES palette!|

|make| |
|---|---|
|`make SCAN=1`| Scans your custom NES games inside `\custom\games` and put these into the ROM automatically.|
|`make verify`| Rebuilds the decompiled files and test if the binaries are identical to the original one.|
