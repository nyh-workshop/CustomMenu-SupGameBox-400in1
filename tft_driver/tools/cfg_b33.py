"""Sup 400-in-1 boot stage 2 (bank $33): file 0x66000-0x67FFF (8 KiB bank $33), run at CPU $A000."""
import os, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
ROMF = os.path.join(ROOT, 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_66000H_8KiB.bin')
ROM = bytes(0xA000) + open(ROMF, 'rb').read() + bytes(0x4000)   # index = CPU address
FILE_BASE = 0x66000 - 0xA000
LO, HI = 0xA000, 0xC000
VECTORS = ()
COV = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'trace_coverage_b33.json'))).items()}
STUBS = {}
EXTRA = [0xA000]
BANKS = [(0xA000, 'BANK33', 0x33)]
TITLE = 'Sup 400-in-1 boot stage 2 (bank $33)'
RAM_INC = 'ram_b33.inc'
NAME_COUNT = 0
NAMES = {0xA000: 'boot_stage2', 0xA0B3: 'clear_ram_0_3_7', 0xA0CD: 'wait_vblank'}
WORDS = {}
NAME_LO = NAME_HI = 0
REC_LO, REC_N = 0, 0
ROWS = {}
ROWSTART = {}
STUB_NOTE = {}
FOREIGN = {}
exec(open(os.path.join(HERE, 'regs_common.py')).read())
RAMV = {}
