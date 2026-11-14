# Sup 400-in-1 Chinese menu disassembly. Needs cc65 (ca65 + ld65) on PATH.
CA65   ?= ca65
LD65   ?= ld65
PYTHON ?= python3

ORIG   = orig/romdump_sup400in1_10042024_201812_opcode_bits45_swap_30000H.bin
OUT    = build/menu_cn_30000H.bin
SRC    = src/main.s src/regs.inc src/ram.inc src/bank1c.s src/bank1d.s src/bank1e.s src/bank1f.s

all: $(OUT)

build/main.o: $(SRC) | build
	$(CA65) -I src --bin-include-dir orig -o $@ src/main.s

$(OUT): build/main.o menu_cn64k.cfg
	$(LD65) -C menu_cn64k.cfg -o $@ -m build/menu.map -Ln build/menu.lbl build/main.o

build:
	mkdir build

# Byte-for-byte check against the original 64 KiB block.
verify: $(OUT)
	$(PYTHON) tools/cmpbin.py $(OUT) $(ORIG) 30000 0

clean:
	-rm -f build/main.o $(OUT) build/menu.map build/menu.lbl

# The same rebuild without cc65: tools/asmcheck.py (a strict stand-in for ca65 + ld65) + the comparison with the dump.
# From the project folder:  make menu-cn  (uses ca65 when found, else this check).
check:
	$(PYTHON) ../tools/build_blocks.py menu_cn --asm check

.PHONY: all verify check clean
