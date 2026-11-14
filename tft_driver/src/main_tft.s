; TFT/LCD init driver: 8 KiB bank $15 (file 0x2A000-0x2BFFF), runs at $A000
; with bank $14 at $8000 (never read). Entered from $FFB0, returns with JMP $FF60.
.include "regs.inc"
.include "ram_tft.inc"
.include "bank15.s"
