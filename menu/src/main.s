; Sup 400-in-1 menu block: file 0x70000-0x7FFFF of the 512 KiB dump
; (opcode bits 4/5 already swapped back), rebuilt as one 64 KiB image.
;
;   0x70000-0x77FFF  banks $38-$3B  separate 32 KiB program (own vectors, not
;                    run in any of the four traces) - included as binary
;   0x78000-0x7FFFF  banks $3C-$3F  English menu + boot code, disassembled
;
; Build:  make        Check:  make verify  (must say "identical")

.include "regs.inc"
.include "ram.inc"

.segment "LOWER32K"
        .incbin "romdump_sup400in1_10042024_201812_opcode_bits45_swap_70000H.bin", 0, $8000

.include "bank3c.s"     ; $8000  game names (500 x 16 bytes)
.include "bank3d.s"     ; $A000  relaunch / game launch, launch param tables
.include "bank3e.s"     ; $C000  menu screens, list drawing, input
.include "bank3f.s"     ; $E000  boot, NMI, state dispatch, game records, vectors
