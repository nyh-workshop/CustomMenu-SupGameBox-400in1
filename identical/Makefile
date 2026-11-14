# Frozen, self-contained copy of the 400-in-1 menu sources that rebuild the dump byte for byte.
# Never edit it for your own menu: work in ../menu, ../menu_cn, ../TestApp, ../tft_driver (make custom).
#
#   make                 all five blocks (against their orig/ files) + the blocks in ../roms/..._stripped.bin
#   make ASM=ca65        require cc65 (CC65=/path/to/cc65/bin or on PATH);  ASM=check: only tools/asmcheck.py
#   make ROM=<dump>      also compare with your 512 KiB dump (not shipped), all 512 KiB
# Each folder also builds on its own with cc65:  cd menu && make verify
PYTHON ?= python3
ASM    ?= auto
ROM    ?=

all:
	$(PYTHON) tools/build_blocks.py --root . $(if $(ROM),--rom "$(ROM)") --asm $(ASM) --image

clean:
	rm -rf build menu/build menu_cn/build TestApp/build tft_driver/build

.PHONY: all clean
