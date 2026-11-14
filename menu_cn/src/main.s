; Sup 400-in-1 Chinese menu block: file 0x30000-0x3FFFF of the 512 KiB dump,
; rebuilt as one 64 KiB image.
;
;   0x30000-0x37FFF  banks $18-$1B  menu data paged in at $8000 ($4107 = $38-$3B,
;                    $410B=1 -> inner mask $1F) - included as binary
;   0x38000-0x3FFFF  banks $1C-$1F  Chinese menu code/data at $8000-$FFFF, disassembled
;
; Build:  make        Check:  make verify  (must say "identical")

.include "regs.inc"
.include "ram.inc"

.segment "DATA18_1B"
        .incbin "romdump_sup400in1_10042024_201812_opcode_bits45_swap_30000H.bin", 0, $8000

.include "bank1c.s"     ; $8000  bank $1C (data; the NMI maps it for the sound driver)
.include "bank1d.s"     ; $A000  bank $1D (data)
.include "bank1e.s"     ; $C000  screens, list, sprites, launch
.include "bank1f.s"     ; $E000  reset, NMI, state dispatch, sound, vectors
