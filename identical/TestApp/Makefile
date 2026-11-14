# Sup 400-in-1 language select + test app disassembly. Needs cc65 (ca65 + ld65).
CA65   ?= ca65
LD65   ?= ld65
PYTHON ?= python3

ORIG = orig/romdump_sup400in1_10042024_201812_opcode_bits45_swap_68000H.bin
OUT  = build/langsel_testapp_68000H.bin
SRC  = src/main.s src/regs.inc src/ram.inc src/bank34.s src/bank35.s src/bank36.s src/bank37.s

all: $(OUT)

build:
	mkdir build

build/main.o: $(SRC) | build
	$(CA65) -I src -o $@ src/main.s

$(OUT): build/main.o langsel_test32k.cfg
	$(LD65) -C langsel_test32k.cfg -o $@ -m build/langsel_testapp.map -Ln build/langsel_testapp.lbl build/main.o

verify: $(OUT)
	$(PYTHON) tools/cmpbin.py $(OUT) $(ORIG) 68000 8000

clean:
	-rm -f build/main.o $(OUT) build/langsel_testapp.map build/langsel_testapp.lbl

# The same rebuild without cc65: tools/asmcheck.py (a strict stand-in for ca65 + ld65) + the comparison with the dump.
# From the project folder:  make testapp  (uses ca65 when found, else this check).
check:
	$(PYTHON) ../tools/build_blocks.py testapp --asm check

.PHONY: all verify check clean
