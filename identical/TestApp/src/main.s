; Sup 400-in-1 language select + Aaronix test app: file 0x68000-0x6FFFF of the
; 512 KiB dump (banks $34-$37 at $8000-$FFFF with $410B=4, $410A=$37), rebuilt
; as one 32 KiB image.
;
;   language select : entered with JMP $E000 from the boot stub at $0400
;   test app        : entered through this block's RESET vector ($FFE0) when
;                     A+B is held at boot (ram_stub_support_app in the English block)
;
; Build:  make        Check:  make verify  (must say "identical")

.include "regs.inc"
.include "ram.inc"

.include "bank34.s"     ; $8000  data
.include "bank35.s"     ; $A000  test app code
.include "bank36.s"     ; $C000  test app data (RAM test copy source $C000-$C7FF)
.include "bank37.s"     ; $E000  language select, test app reset, vectors
