; Boot stage 2: 8 KiB bank $33 (file 0x66000-0x67FFF), runs at $A000.
; Reached from reset via MMC3 R7=$33 + JMP $A000; ends with JMP $FFB0 (TFT init).
.include "regs.inc"
.include "ram_b33.inc"
.include "bank33.s"
