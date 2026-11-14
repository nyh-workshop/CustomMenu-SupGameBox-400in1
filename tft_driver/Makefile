# Sup 400-in-1 boot stage 2 (bank $33) and TFT/LCD driver (bank $15). Needs cc65.
CA65   ?= ca65
LD65   ?= ld65
PYTHON ?= python3

B33_ORIG = orig/romdump_sup400in1_10042024_201812_opcode_bits45_swap_66000H_8KiB.bin
TFT_ORIG = orig/romdump_sup400in1_10042024_201812_opcode_bits45_swap_2A000H_8KiB.bin
B33_OUT  = build/bank33_66000H.bin
TFT_OUT  = build/bank15_2A000H.bin

all: $(B33_OUT) $(TFT_OUT)

build:
	mkdir build

build/main_b33.o: src/main_b33.s src/bank33.s src/regs.inc src/ram_b33.inc | build
	$(CA65) -I src -o $@ src/main_b33.s

build/main_tft.o: src/main_tft.s src/bank15.s src/regs.inc src/ram_tft.inc | build
	$(CA65) -I src -o $@ src/main_tft.s

$(B33_OUT): build/main_b33.o bank8k.cfg
	$(LD65) -C bank8k.cfg -o $@ -m build/bank33.map -Ln build/bank33.lbl build/main_b33.o

$(TFT_OUT): build/main_tft.o bank8k.cfg
	$(LD65) -C bank8k.cfg -o $@ -m build/bank15.map -Ln build/bank15.lbl build/main_tft.o

verify: $(B33_OUT) $(TFT_OUT)
	$(PYTHON) tools/cmpbin.py $(B33_OUT) $(B33_ORIG) 66000 A000
	$(PYTHON) tools/cmpbin.py $(TFT_OUT) $(TFT_ORIG) 2A000 A000

clean:
	-rm -f build/*.o build/*.bin build/*.map build/*.lbl

# The same rebuild without cc65: tools/asmcheck.py (a strict stand-in for ca65 + ld65) + the comparison with the dump.
# From the project folder:  make boot / make tft  (uses ca65 when found, else this check).
check:
	$(PYTHON) ../tools/build_blocks.py boot tft --asm check

.PHONY: all verify check clean
