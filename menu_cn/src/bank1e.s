; Sup 400-in-1 Chinese menu, 8 KiB PRG bank $1E (file 0x3C000), mapped at CPU $C000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK1E"

jt_C9E6:
        ; static (not seen in traces)
        jmp  loc_C9E6                   ; C000
jt_clear_oam_from_y:
        jmp  clear_oam_from_y           ; C003
jt_CAA1:
        ; static (not seen in traces)
        jmp  loc_CAA1                   ; C006
jt_CAF4:
        jmp  loc_CAF4                   ; C009
jt_CA2E:
        jmp  loc_CA2E                   ; C00C
jt_CC27:
        jmp  goto_state_step            ; C00F
jt_CC33:
        jmp  loc_CC33                   ; C012
jt_CC31:
        jmp  loc_CC31                   ; C015
jt_CC32:
        jmp  loc_CC32                   ; C018
jt_prng_step:
        jmp  prng_step                  ; C01B
prng_step:
        lda  prng_state                 ; C01E
        and  #$02                       ; C021
        sta  $0120                      ; C023
        lda  $011E                      ; C026
        and  #$02                       ; C029
        eor  $0120                      ; C02B
        clc                             ; C02E
        beq  loc_C032                   ; C02F
        sec                             ; C031
loc_C032:
        ror  prng_state                 ; C032
        ror  $011E                      ; C035
        ror  $011F                      ; C038
        rts                             ; C03B
hw_init:
        lda  #$00                       ; C03C
        sta  PPU_CTRL                   ; C03E
        sta  PPU_MASK                   ; C041
        sta  JOY1                       ; C044
        sta  APU_STATUS                 ; C047
        jsr  sub_C0E8                   ; C04A
        jsr  sub_C9CE                   ; C04D
        jsr  sub_C9CE                   ; C050
        lda  #$C0                       ; C053
        sta  JOY2_FRAME                 ; C055
        lda  #$0F                       ; C058
        sta  prng_state                 ; C05A
        rts                             ; C05D
init_ppu_shadows:
        lda  #$10                       ; C05E
        sta  ppu_ctrl_shadow            ; C060
        lda  #$06                       ; C062
        sta  ppu_mask_shadow            ; C064
        lda  #$00                       ; C066
        sta  OB_VIDEO_2010              ; C068
        sta  video_2010_shadow          ; C06B
        lda  #$00                       ; C06D
        sta  scroll_x_shadow            ; C06F
        sta  scroll_y_shadow            ; C071
        sta  $05                        ; C073
        sta  frame_counter              ; C075
        sta  $07                        ; C077
        rts                             ; C079
read_4119_flag:
        lda  REG_4119                   ; C07A
        and  #$18                       ; C07D
        cmp  #$18                       ; C07F
        beq  loc_C087                   ; C081
        lda  #$01                       ; C083
        bne  loc_C089                   ; C085
loc_C087:
        ; static (not seen in traces)
        lda  #$00                       ; C087
loc_C089:
        sta  flag_4119                  ; C089
        rts                             ; C08B
read_pad:
        lda  #$01                       ; C08C
        sta  JOY1                       ; C08E
        lda  #$00                       ; C091
        sta  JOY1                       ; C093
        ldx  #$08                       ; C096
        ldy  #$00                       ; C098
loc_C09A:
        lda  JOY1                       ; C09A
        lsr  a                          ; C09D
        bcs  loc_C0A1                   ; C09E
        lsr  a                          ; C0A0
loc_C0A1:
        rol  $0E                        ; C0A1
        dex                             ; C0A3
        bne  loc_C09A                   ; C0A4
        ldx  #$08                       ; C0A6
        ldy  #$00                       ; C0A8
loc_C0AA:
        lda  JOY2_FRAME                 ; C0AA
        lsr  a                          ; C0AD
        bcs  loc_C0B1                   ; C0AE
        lsr  a                          ; C0B0
loc_C0B1:
        rol  $0F                        ; C0B1
        dex                             ; C0B3
        bne  loc_C0AA                   ; C0B4
        rts                             ; C0B6
        .byte $48,$8A,$48,$98,$48,$A9,$01,$8D,$16,$40,$A9,$00,$8D,$16,$40,$A2 ; C0B7
        .byte $08,$A0,$00,$AD,$16,$40,$4A,$B0,$01,$4A,$CA,$D0,$F6,$A2,$08,$A0 ; C0C7
        .byte $00,$AD,$17,$40,$4A,$B0,$01,$4A,$CA,$D0,$F6,$68,$A8,$68,$AA,$68 ; C0D7
        .byte $60 ; C0E7
sub_C0E8:
        ldy  #$00                       ; C0E8
        lda  #$00                       ; C0EA
loc_C0EC:
        sta  a:ppu_ctrl_shadow,y        ; C0EC
        sta  $0200,y                    ; C0EF
        sta  $0300,y                    ; C0F2
        sta  $0400,y                    ; C0F5
        sta  $0500,y                    ; C0F8
        sta  $0600,y                    ; C0FB
        sta  $0700,y                    ; C0FE
        iny                             ; C101
        bne  loc_C0EC                   ; C102
        rts                             ; C104
sub_C105:
        lda  #$00                       ; C105
        sta  PPU_MASK                   ; C107
        sta  PPU_SCROLL                 ; C10A
        sta  PPU_SCROLL                 ; C10D
        jsr  sub_C1AA                   ; C110
        lda  a:$0033                    ; C113
        sta  prg8000_shadow             ; C116
        sta  OB_PRG_8000                ; C118
        jsr  sub_C235                   ; C11B
        lda  a:$0034                    ; C11E
        sta  prg8000_shadow             ; C121
        sta  OB_PRG_8000                ; C123
        jsr  sub_C2B5                   ; C126
        jsr  sub_F639                   ; C129
        jsr  sub_C16D                   ; C12C
        bit  dat_CB4E                   ; C12F
        jsr  sub_C1F0                   ; C132
        lda  ppu_mask_shadow            ; C135
        and  #$E7                       ; C137
        sta  ppu_mask_shadow            ; C139
        sta  PPU_MASK                   ; C13B
        rts                             ; C13E
        .byte $A9,$3F,$8D,$06,$20,$A9,$00,$8D,$06,$20,$A0,$00,$B9,$00,$04,$8D ; C13F
        .byte $07,$20,$C8,$D0,$F7,$60 ; C14F
sub_C155:
        lda  #$38                       ; C155
        sta  prg8000_shadow             ; C157
        sta  OB_PRG_8000                ; C159
        rts                             ; C15C
sub_C15D:
        lda  a:screen_id                ; C15D
        asl  a                          ; C160
        tay                             ; C161
        lda  dat_8002,y                 ; C162
        sta  $94                        ; C165
        lda  dat_8003,y                 ; C167
        sta  $95                        ; C16A
        rts                             ; C16C
sub_C16D:
        jsr  sub_C155                   ; C16D
load_screen_record_chr:
        jsr  sub_C15D                   ; C170
        ldy  #$04                       ; C173
        lda  ($94),y                    ; C175
        sta  $9A                        ; C177
        iny                             ; C179
        lda  ($94),y                    ; C17A
        sta  $9B                        ; C17C
        iny                             ; C17E
        lda  ($94),y                    ; C17F
        sta  $9C                        ; C181
        iny                             ; C183
        lda  ($94),y                    ; C184
        sta  $9D                        ; C186
        ldy  #$0A                       ; C188
        lda  ($94),y                    ; C18A
        clc                             ; C18C
        adc  #$00                       ; C18D
        sta  a:$0039                    ; C18F
        adc  #$02                       ; C192
        sta  bg_chr_base                ; C194
        adc  #$01                       ; C196
        sta  $1E                        ; C198
        iny                             ; C19A
        lda  ($94),y                    ; C19B
        clc                             ; C19D
        adc  #$38                       ; C19E
        sta  $0A                        ; C1A0
        lda  $0A                        ; C1A2
        sta  prg8000_shadow             ; C1A4
        sta  OB_PRG_8000                ; C1A6
        rts                             ; C1A9
sub_C1AA:
        jsr  sub_C155                   ; C1AA
        jsr  sub_C15D                   ; C1AD
        ldy  #$00                       ; C1B0
        lda  ($94),y                    ; C1B2
        sta  $9A                        ; C1B4
        iny                             ; C1B6
        lda  ($94),y                    ; C1B7
        sta  $9B                        ; C1B9
        iny                             ; C1BB
        lda  ($94),y                    ; C1BC
        sta  $96                        ; C1BE
        iny                             ; C1C0
        lda  ($94),y                    ; C1C1
        sta  $97                        ; C1C3
        ldy  #$08                       ; C1C5
        lda  ($94),y                    ; C1C7
        sta  $98                        ; C1C9
        iny                             ; C1CB
        lda  ($94),y                    ; C1CC
        sta  $99                        ; C1CE
        ldy  #$0C                       ; C1D0
        lda  ($94),y                    ; C1D2
        clc                             ; C1D4
        adc  #$38                       ; C1D5
        sta  a:$0033                    ; C1D7
        iny                             ; C1DA
        lda  ($94),y                    ; C1DB
        clc                             ; C1DD
        adc  #$38                       ; C1DE
        sta  a:$0034                    ; C1E0
        rts                             ; C1E3
sub_C1E4:
        lda  #$00                       ; C1E4
        tax                             ; C1E6
loc_C1E7:
        sta  a:$003D,x                  ; C1E7
        inx                             ; C1EA
        cpx  #$10                       ; C1EB
        bcc  loc_C1E7                   ; C1ED
        rts                             ; C1EF
sub_C1F0:
        jsr  sub_C1AA                   ; C1F0
        lda  $9B                        ; C1F3
        cmp  #$FF                       ; C1F5
        bne  loc_C20A                   ; C1F7
        ; static (not seen in traces)
        lda  #$38                       ; C1F9
        sta  prg8000_shadow             ; C1FB
        sta  OB_PRG_8000                ; C1FD
        lda  #$00                       ; C200
        sta  $9A                        ; C202
        lda  #$80                       ; C204
        sta  $9B                        ; C206
        bne  loc_C212                   ; C208
loc_C20A:
        lda  a:$0033                    ; C20A
        sta  prg8000_shadow             ; C20D
        sta  OB_PRG_8000                ; C20F
loc_C212:
        ldy  #$FF                       ; C212
        ldx  #$FF                       ; C214
loc_C216:
        iny                             ; C216
        inx                             ; C217
        lda  ($9A),y                    ; C218
        sta  a:$003D,x                  ; C21A
        bne  loc_C216                   ; C21D
        rts                             ; C21F
        .byte $AD,$35,$00,$D0,$05,$A9,$20,$4C,$2C,$C2,$A9,$24,$8D,$06,$20,$A9 ; C220
        .byte $00,$8D,$06,$20,$60 ; C230
sub_C235:
        lda  $96                        ; C235
        pha                             ; C237
        lda  $97                        ; C238
        pha                             ; C23A
        ldx  #$00                       ; C23B
        stx  $0118                      ; C23D
loc_C240:
        ldy  #$00                       ; C240
loc_C242:
        lda  ($96),y                    ; C242
        sta  $0400,x                    ; C244
        inx                             ; C247
        iny                             ; C248
        cpy  #$04                       ; C249
        bcc  loc_C242                   ; C24B
        clc                             ; C24D
        lda  $96                        ; C24E
        adc  #$04                       ; C250
        sta  $96                        ; C252
        lda  $97                        ; C254
        adc  #$00                       ; C256
        sta  $97                        ; C258
        clc                             ; C25A
        txa                             ; C25B
        adc  #$1C                       ; C25C
        tax                             ; C25E
        cpx  #$80                       ; C25F
        bcc  loc_C240                   ; C261
        inc  $0118                      ; C263
        lda  $0118                      ; C266
        cmp  #$04                       ; C269
        bcs  loc_C273                   ; C26B
        asl  a                          ; C26D
        asl  a                          ; C26E
        tax                             ; C26F
        jmp  loc_C240                   ; C270
loc_C273:
        ldx  #$00                       ; C273
        stx  $0118                      ; C275
loc_C278:
        ldy  #$00                       ; C278
loc_C27A:
        lda  ($96),y                    ; C27A
        sta  $0480,x                    ; C27C
        inx                             ; C27F
        iny                             ; C280
        cpy  #$04                       ; C281
        bcc  loc_C27A                   ; C283
        clc                             ; C285
        lda  $96                        ; C286
        adc  #$04                       ; C288
        sta  $96                        ; C28A
        lda  $97                        ; C28C
        adc  #$00                       ; C28E
        sta  $97                        ; C290
        clc                             ; C292
        txa                             ; C293
        adc  #$1C                       ; C294
        tax                             ; C296
        cpx  #$80                       ; C297
        bcc  loc_C278                   ; C299
        inc  $0118                      ; C29B
        lda  $0118                      ; C29E
        cmp  #$04                       ; C2A1
        bcs  loc_C2AB                   ; C2A3
        asl  a                          ; C2A5
        asl  a                          ; C2A6
        tax                             ; C2A7
        jmp  loc_C278                   ; C2A8
loc_C2AB:
        jsr  sub_C335                   ; C2AB
        pla                             ; C2AE
        sta  $97                        ; C2AF
        pla                             ; C2B1
        sta  $96                        ; C2B2
        rts                             ; C2B4
sub_C2B5:
        lda  $98                        ; C2B5
        pha                             ; C2B7
        lda  $99                        ; C2B8
        pha                             ; C2BA
        ldx  #$00                       ; C2BB
        stx  $0118                      ; C2BD
loc_C2C0:
        ldy  #$00                       ; C2C0
loc_C2C2:
        lda  ($98),y                    ; C2C2
        sta  $0410,x                    ; C2C4
        inx                             ; C2C7
        iny                             ; C2C8
        cpy  #$04                       ; C2C9
        bcc  loc_C2C2                   ; C2CB
        clc                             ; C2CD
        lda  $98                        ; C2CE
        adc  #$04                       ; C2D0
        sta  $98                        ; C2D2
        lda  $99                        ; C2D4
        adc  #$00                       ; C2D6
        sta  $99                        ; C2D8
        clc                             ; C2DA
        txa                             ; C2DB
        adc  #$1C                       ; C2DC
        tax                             ; C2DE
        cpx  #$80                       ; C2DF
        bcc  loc_C2C0                   ; C2E1
        inc  $0118                      ; C2E3
        lda  $0118                      ; C2E6
        cmp  #$04                       ; C2E9
        bcs  loc_C2F3                   ; C2EB
        asl  a                          ; C2ED
        asl  a                          ; C2EE
        tax                             ; C2EF
        jmp  loc_C2C0                   ; C2F0
loc_C2F3:
        ldx  #$00                       ; C2F3
        stx  $0118                      ; C2F5
loc_C2F8:
        ldy  #$00                       ; C2F8
loc_C2FA:
        lda  ($98),y                    ; C2FA
        sta  $0490,x                    ; C2FC
        inx                             ; C2FF
        iny                             ; C300
        cpy  #$04                       ; C301
        bcc  loc_C2FA                   ; C303
        clc                             ; C305
        lda  $98                        ; C306
        adc  #$04                       ; C308
        sta  $98                        ; C30A
        lda  $99                        ; C30C
        adc  #$00                       ; C30E
        sta  $99                        ; C310
        clc                             ; C312
        txa                             ; C313
        adc  #$1C                       ; C314
        tax                             ; C316
        cpx  #$80                       ; C317
        bcc  loc_C2F8                   ; C319
        inc  $0118                      ; C31B
        lda  $0118                      ; C31E
        cmp  #$04                       ; C321
        bcs  loc_C32B                   ; C323
        asl  a                          ; C325
        asl  a                          ; C326
        tax                             ; C327
        jmp  loc_C2F8                   ; C328
loc_C32B:
        jsr  sub_C335                   ; C32B
        pla                             ; C32E
        sta  $99                        ; C32F
        pla                             ; C331
        sta  $98                        ; C332
        rts                             ; C334
sub_C335:
        ldx  #$00                       ; C335
        lda  $0400,x                    ; C337
        sta  $0410,x                    ; C33A
        sta  $0414,x                    ; C33D
        sta  $0418,x                    ; C340
        sta  $041C,x                    ; C343
        lda  $0480,x                    ; C346
        sta  $0490,x                    ; C349
        sta  $0494,x                    ; C34C
        sta  $0498,x                    ; C34F
        sta  $049C,x                    ; C352
        rts                             ; C355
        .byte $20,$AA,$C1,$20,$8E,$C3,$A0,$05,$20,$00,$C0,$AD,$33,$00,$85,$08 ; C356
        .byte $8D,$07,$41,$20,$35,$C2,$AD,$34,$00,$85,$08,$8D,$07,$41,$20,$B5 ; C366
        .byte $C2,$20,$81,$C3,$20,$FE,$C9,$20,$0C,$CA,$60,$A9,$40,$05,$05,$85 ; C376
        .byte $05,$A5,$05,$29,$40,$D0,$FA,$60,$60,$20,$AA,$C1,$18,$A5,$96,$69 ; C386
        .byte $00,$85,$96,$A5,$97,$69,$02,$85,$97,$18,$A5,$98,$69,$00,$85,$98 ; C396
        .byte $A5,$99,$69,$02,$85,$99,$A9,$04,$8D,$1A,$01,$20,$8E,$C3,$A0,$05 ; C3A6
        .byte $20,$00,$C0,$AD,$33,$00,$85,$08,$8D,$07,$41,$20,$35,$C2,$AD,$34 ; C3B6
        .byte $00,$85,$08,$8D,$07,$41,$20,$B5,$C2,$A9,$40,$05,$05,$85,$05,$60 ; C3C6
clear_oam_from_y:
        lda  a:$004F                    ; C3D6
        cmp  #$40                       ; C3D9
        bcs  loc_C3E3                   ; C3DB
        asl  a                          ; C3DD
        asl  a                          ; C3DE
        tay                             ; C3DF
        jsr  sub_C3F6                   ; C3E0
loc_C3E3:
        rts                             ; C3E3
clear_oam_and_sprite_slots:
        ldx  #$00                       ; C3E4
loc_C3E6:
        lda  #$FF                       ; C3E6
        sta  $0170,x                    ; C3E8
        txa                             ; C3EB
        clc                             ; C3EC
        adc  #$08                       ; C3ED
        tax                             ; C3EF
        cpx  #$10                       ; C3F0
        bcc  loc_C3E6                   ; C3F2
        ldy  #$00                       ; C3F4
sub_C3F6:
        lda  #$F0                       ; C3F6
loc_C3F8:
        sta  $0200,y                    ; C3F8
        iny                             ; C3FB
        iny                             ; C3FC
        iny                             ; C3FD
        iny                             ; C3FE
        bne  loc_C3F8                   ; C3FF
        rts                             ; C401
update_sprite_slots:
        ldx  #$00                       ; C402
        stx  a:$004F                    ; C404
loc_C407:
        lda  #$38                       ; C407
        sta  prg8000_shadow             ; C409
        sta  OB_PRG_8000                ; C40B
        jsr  sub_C41E                   ; C40E
        txa                             ; C411
        clc                             ; C412
        adc  #$08                       ; C413
        tax                             ; C415
        cpx  #$10                       ; C416
        bcc  loc_C407                   ; C418
        jsr  jt_clear_oam_from_y        ; C41A
        rts                             ; C41D
sub_C41E:
        lda  $0170,x                    ; C41E
        cmp  #$FF                       ; C421
        bne  loc_C428                   ; C423
        jmp  loc_C4DE                   ; C425
loc_C428:
        sta  a:$0055                    ; C428
        lda  $0171,x                    ; C42B
        sta  a:$0056                    ; C42E
        lda  $0172,x                    ; C431
        sta  a:$0057                    ; C434
        lda  $0173,x                    ; C437
        sta  a:$0061                    ; C43A
        lda  $0174,x                    ; C43D
        sta  a:$0058                    ; C440
        lda  $0175,x                    ; C443
        sta  a:$0059                    ; C446
        lda  $0176,x                    ; C449
        sec                             ; C44C
        sbc  scroll_x_shadow            ; C44D
        sta  a:$005A                    ; C44F
        lda  $0177,x                    ; C452
        sbc  $1A                        ; C455
        sta  a:$005B                    ; C457
        lda  a:$0055                    ; C45A
        asl  a                          ; C45D
        tay                             ; C45E
        lda  dat_84D2,y                 ; C45F
        sta  $A4                        ; C462
        lda  dat_84D3,y                 ; C464
        sta  $A5                        ; C467
        lda  a:$0056                    ; C469
        asl  a                          ; C46C
        asl  a                          ; C46D
        asl  a                          ; C46E
        tay                             ; C46F
        lda  ($A4),y                    ; C470
        sta  $A0                        ; C472
        iny                             ; C474
        lda  ($A4),y                    ; C475
        sta  $A1                        ; C477
        iny                             ; C479
        lda  ($A4),y                    ; C47A
        clc                             ; C47C
        adc  #$00                       ; C47D
        sta  a:spr_chr_base             ; C47F
        iny                             ; C482
        lda  ($A4),y                    ; C483
        sta  a:$0060                    ; C485
        iny                             ; C488
        lda  ($A4),y                    ; C489
        sta  a:$005E                    ; C48B
        iny                             ; C48E
        iny                             ; C48F
        lda  ($A4),y                    ; C490
        clc                             ; C492
        adc  #$38                       ; C493
        sta  $16                        ; C495
        lda  $16                        ; C497
        sta  prg8000_shadow             ; C499
        sta  OB_PRG_8000                ; C49B
        lda  a:$0057                    ; C49E
        asl  a                          ; C4A1
        asl  a                          ; C4A2
        tay                             ; C4A3
        lda  ($A0),y                    ; C4A4
        sta  $A2                        ; C4A6
        iny                             ; C4A8
        lda  ($A0),y                    ; C4A9
        sta  $A3                        ; C4AB
        iny                             ; C4AD
        iny                             ; C4AE
        lda  ($A0),y                    ; C4AF
        clc                             ; C4B1
        adc  #$38                       ; C4B2
        sta  $16                        ; C4B4
        lda  $16                        ; C4B6
        sta  prg8000_shadow             ; C4B8
        sta  OB_PRG_8000                ; C4BA
        ldy  #$02                       ; C4BD
        lda  ($A2),y                    ; C4BF
        sta  a:$0050                    ; C4C1
        iny                             ; C4C4
        iny                             ; C4C5
        iny                             ; C4C6
        lda  a:$0060                    ; C4C7
        and  #$C0                       ; C4CA
        beq  loc_C4D5                   ; C4CC
        ; static (not seen in traces)
        cmp  #$40                       ; C4CE
        beq  loc_C4DB                   ; C4D0
        jmp  loc_C4DE                   ; C4D2
loc_C4D5:
        jsr  sub_C4DF                   ; C4D5
        jmp  loc_C4DE                   ; C4D8
loc_C4DB:
        ; static (not seen in traces)
        jsr  sub_C55C                   ; C4DB
loc_C4DE:
        rts                             ; C4DE
sub_C4DF:
        iny                             ; C4DF
        lda  ($A2),y                    ; C4E0
        sta  a:$0054                    ; C4E2
        iny                             ; C4E5
        lda  ($A2),y                    ; C4E6
        sta  a:$0052                    ; C4E8
        iny                             ; C4EB
        lda  ($A2),y                    ; C4EC
        ora  a:$0060                    ; C4EE
        sta  a:$0053                    ; C4F1
        iny                             ; C4F4
        lda  ($A2),y                    ; C4F5
        sta  a:$0051                    ; C4F7
        tya                             ; C4FA
        pha                             ; C4FB
        lda  a:$0053                    ; C4FC
        and  #$1C                       ; C4FF
        bne  loc_C50A                   ; C501
        lda  a:$0052                    ; C503
        cmp  #$02                       ; C506
        beq  loc_C551                   ; C508
loc_C50A:
        lda  a:$0058                    ; C50A
        clc                             ; C50D
        adc  a:$0054                    ; C50E
        sta  a:$005C                    ; C511
        lda  a:$0059                    ; C514
        adc  #$00                       ; C517
        bne  loc_C551                   ; C519
        lda  a:$005A                    ; C51B
        clc                             ; C51E
        adc  a:$0051                    ; C51F
        sta  a:$005D                    ; C522
        lda  a:$005B                    ; C525
        adc  #$00                       ; C528
        bne  loc_C551                   ; C52A
        lda  a:$004F                    ; C52C
        cmp  #$40                       ; C52F
        bcs  loc_C551                   ; C531
        inc  a:$004F                    ; C533
        asl  a                          ; C536
        asl  a                          ; C537
        tay                             ; C538
        lda  a:$005C                    ; C539
        sta  $0200,y                    ; C53C
        lda  a:$005D                    ; C53F
        sta  $0203,y                    ; C542
        lda  a:$0052                    ; C545
        sta  $0201,y                    ; C548
        lda  a:$0053                    ; C54B
        sta  $0202,y                    ; C54E
loc_C551:
        pla                             ; C551
        tay                             ; C552
        dec  a:$0050                    ; C553
        beq  loc_C55B                   ; C556
        jmp  sub_C4DF                   ; C558
loc_C55B:
        rts                             ; C55B
sub_C55C:
        ; static (not seen in traces)
        iny                             ; C55C
        lda  ($A2),y                    ; C55D
        sta  a:$0054                    ; C55F
        iny                             ; C562
        lda  ($A2),y                    ; C563
        sta  a:$0052                    ; C565
        iny                             ; C568
        lda  ($A2),y                    ; C569
        ora  a:$0060                    ; C56B
        sta  a:$0053                    ; C56E
        iny                             ; C571
        lda  ($A2),y                    ; C572
        sta  a:$0051                    ; C574
        tya                             ; C577
        pha                             ; C578
        lda  a:$0053                    ; C579
        and  #$1C                       ; C57C
        bne  loc_C587                   ; C57E
        lda  a:$0052                    ; C580
        cmp  #$02                       ; C583
        beq  loc_C5D2                   ; C585
loc_C587:
        lda  a:$0058                    ; C587
        clc                             ; C58A
        adc  a:$0054                    ; C58B
        sta  a:$005C                    ; C58E
        lda  a:$0059                    ; C591
        adc  #$00                       ; C594
        bne  loc_C5D2                   ; C596
        lda  a:$005E                    ; C598
        sec                             ; C59B
        sbc  a:$0051                    ; C59C
        clc                             ; C59F
        adc  a:$005A                    ; C5A0
        sta  a:$005D                    ; C5A3
        lda  a:$005B                    ; C5A6
        adc  #$00                       ; C5A9
        bne  loc_C5D2                   ; C5AB
        lda  a:$004F                    ; C5AD
        cmp  #$40                       ; C5B0
        bcs  loc_C5D2                   ; C5B2
        inc  a:$004F                    ; C5B4
        asl  a                          ; C5B7
        asl  a                          ; C5B8
        tay                             ; C5B9
        lda  a:$005C                    ; C5BA
        sta  $0200,y                    ; C5BD
        lda  a:$005D                    ; C5C0
        sta  $0203,y                    ; C5C3
        lda  a:$0052                    ; C5C6
        sta  $0201,y                    ; C5C9
        lda  a:$0053                    ; C5CC
        sta  $0202,y                    ; C5CF
loc_C5D2:
        pla                             ; C5D2
        tay                             ; C5D3
        dec  a:$0050                    ; C5D4
        bne  sub_C55C                   ; C5D7
        rts                             ; C5D9
load_screen_desc:
        ldx  #$00                       ; C5DA
        ldy  #$00                       ; C5DC
        lda  (screen_desc_ptr),y        ; C5DE
        sta  $0118                      ; C5E0
loc_C5E3:
        iny                             ; C5E3
        lda  (screen_desc_ptr),y        ; C5E4
        sta  $0170,x                    ; C5E6
        iny                             ; C5E9
        lda  (screen_desc_ptr),y        ; C5EA
        sta  $0171,x                    ; C5EC
        iny                             ; C5EF
        lda  (screen_desc_ptr),y        ; C5F0
        sta  $0172,x                    ; C5F2
        iny                             ; C5F5
        lda  (screen_desc_ptr),y        ; C5F6
        sta  $0173,x                    ; C5F8
        iny                             ; C5FB
        lda  (screen_desc_ptr),y        ; C5FC
        sta  $0174,x                    ; C5FE
        iny                             ; C601
        lda  (screen_desc_ptr),y        ; C602
        sta  $0175,x                    ; C604
        iny                             ; C607
        lda  (screen_desc_ptr),y        ; C608
        sta  $0176,x                    ; C60A
        iny                             ; C60D
        lda  (screen_desc_ptr),y        ; C60E
        sta  $0177,x                    ; C610
        dec  $0118                      ; C613
        beq  loc_C621                   ; C616
        ; static (not seen in traces)
        txa                             ; C618
        clc                             ; C619
        adc  #$08                       ; C61A
        tax                             ; C61C
        cpx  #$10                       ; C61D
        bcc  loc_C5E3                   ; C61F
loc_C621:
        rts                             ; C621
sub_C622:
        ; static (not seen in traces)
        lda  #$38                       ; C622
        sta  prg8000_shadow             ; C624
        sta  OB_PRG_8000                ; C626
        lda  $0170,x                    ; C629
        cmp  #$FF                       ; C62C
        beq  loc_C69B                   ; C62E
        asl  a                          ; C630
        tay                             ; C631
        lda  dat_84D2,y                 ; C632
        sta  $A2                        ; C635
        lda  dat_84D3,y                 ; C637
        sta  $A3                        ; C63A
        lda  $0171,x                    ; C63C
        asl  a                          ; C63F
        asl  a                          ; C640
        asl  a                          ; C641
        tay                             ; C642
        lda  ($A2),y                    ; C643
        sta  $A4                        ; C645
        iny                             ; C647
        lda  ($A2),y                    ; C648
        sta  $A5                        ; C64A
        iny                             ; C64C
        iny                             ; C64D
        iny                             ; C64E
        iny                             ; C64F
        lda  ($A2),y                    ; C650
        sta  $011C                      ; C652
        cmp  #$FF                       ; C655
        beq  loc_C69B                   ; C657
        iny                             ; C659
        lda  ($A2),y                    ; C65A
        clc                             ; C65C
        adc  #$38                       ; C65D
        sta  $16                        ; C65F
        lda  $16                        ; C661
        sta  prg8000_shadow             ; C663
        sta  OB_PRG_8000                ; C665
        jsr  sub_C69C                   ; C668
        iny                             ; C66B
        lda  ($A4),y                    ; C66C
        sta  $011B                      ; C66E
        inc  $0173,x                    ; C671
        lda  $0173,x                    ; C674
        cmp  $011B                      ; C677
        bcc  loc_C69B                   ; C67A
        lda  #$00                       ; C67C
        sta  $0173,x                    ; C67E
        inc  $0172,x                    ; C681
        jsr  sub_C69C                   ; C684
        lda  $A7                        ; C687
        cmp  #$FF                       ; C689
        beq  loc_C690                   ; C68B
        jmp  loc_C69B                   ; C68D
loc_C690:
        lda  $011C                      ; C690
        sta  $0171,x                    ; C693
        lda  #$00                       ; C696
        sta  $0172,x                    ; C698
loc_C69B:
        rts                             ; C69B
sub_C69C:
        lda  $0172,x                    ; C69C
        asl  a                          ; C69F
        asl  a                          ; C6A0
        tay                             ; C6A1
        lda  ($A4),y                    ; C6A2
        sta  $A6                        ; C6A4
        iny                             ; C6A6
        lda  ($A4),y                    ; C6A7
        sta  $A7                        ; C6A9
        rts                             ; C6AB
sub_C6AC:
        ldx  #$00                       ; C6AC
loc_C6AE:
        lda  #$FF                       ; C6AE
        sta  $0100,x                    ; C6B0
        lda  #$00                       ; C6B3
        sta  $0102,x                    ; C6B5
        sta  $0104,x                    ; C6B8
        sta  $0106,x                    ; C6BB
        inx                             ; C6BE
        cpx  #$02                       ; C6BF
        bcc  loc_C6AE                   ; C6C1
        rts                             ; C6C3
screen_exit:
        ; static (not seen in traces)
        lda  #$00                       ; C6C4
        sta  $0C                        ; C6C6
        jsr  sub_C9A9                   ; C6C8
        jsr  sub_CA05                   ; C6CB
        jsr  sub_CA13                   ; C6CE
        jsr  clear_oam_and_sprite_slots ; C6D1
        lda  $17                        ; C6D4
        sta  a:menu_state               ; C6D6
        lda  $18                        ; C6D9
        sta  a:menu_step                ; C6DB
        rts                             ; C6DE
sub_C6DF:
        jsr  sub_CA24                   ; C6DF
        jsr  sub_CA05                   ; C6E2
        jsr  sub_CA13                   ; C6E5
        jsr  sub_C1E4                   ; C6E8
        jsr  sub_C6AC                   ; C6EB
        lda  #$00                       ; C6EE
        sta  a:step_exit                ; C6F0
        sta  $05                        ; C6F3
        sta  $1A                        ; C6F5
        sta  a:$0062                    ; C6F7
        sta  $0C                        ; C6FA
        sta  scroll_x_shadow            ; C6FC
        sta  scroll_y_shadow            ; C6FE
        sta  a:$003C                    ; C700
        sta  a:$004E                    ; C703
        sta  nmi_hook_mode              ; C706
        lda  ppu_ctrl_shadow            ; C708
        and  #$FC                       ; C70A
        sta  ppu_ctrl_shadow            ; C70C
        rts                             ; C70E
screen_enable:
        jsr  sub_C9CE                   ; C70F
        jsr  sub_C9CE                   ; C712
        jsr  sub_C9CE                   ; C715
        jsr  sub_C9CE                   ; C718
        jsr  sub_C9CE                   ; C71B
        jsr  sub_C9FE                   ; C71E
        jsr  sub_CA0C                   ; C721
        lda  $0E                        ; C724
        sta  a:$0038                    ; C726
        lda  #$01                       ; C729
        sta  a:$004E                    ; C72B
        sta  $0C                        ; C72E
        rts                             ; C730
        .byte $A9,$38,$8D,$07,$41,$60,$AD,$32,$00,$F0,$03,$4C,$F4,$C7,$A9,$38 ; C731
        .byte $85,$08,$8D,$07,$41,$AD,$65,$00,$0A,$A8,$B9,$44,$80,$85,$B4,$B9 ; C741
        .byte $45,$80,$85,$B5,$A2,$00,$8E,$63,$00,$A9,$38,$85,$08,$8D,$07,$41 ; C751
        .byte $BD,$00,$01,$C9,$FF,$F0,$7C,$0A,$0A,$A8,$B1,$B4,$85,$B6,$C8,$B1 ; C761
        .byte $B4,$85,$B7,$C8,$B1,$B4,$8D,$36,$00,$C8,$B1,$B4,$8D,$3B,$00,$20 ; C771
        .byte $4C,$C8,$AD,$08,$01,$C9,$FF,$F0,$2A,$FE,$06,$01,$BD,$06,$01,$CD ; C781
        .byte $1B,$01,$90,$1F,$A9,$00,$9D,$06,$01,$FE,$04,$01,$20,$7D,$C8,$A5 ; C791
        .byte $BB,$C9,$FF,$D0,$11,$AD,$08,$01,$9D,$02,$01,$A9,$00,$9D,$04,$01 ; C7A1
        .byte $20,$4C,$C8,$20,$7D,$C8,$A5,$05,$D0,$29,$AD,$3C,$00,$D0,$24,$AD ; C7B1
        .byte $36,$00,$CD,$35,$00,$F0,$0C,$8D,$35,$00,$AD,$3B,$00,$8D,$3A,$00 ; C7C1
        .byte $EE,$3C,$00,$A5,$16,$85,$08,$8D,$07,$41,$20,$9B,$C8,$20,$E3,$C8 ; C7D1
        .byte $EE,$63,$00,$E8,$E0,$02,$B0,$03,$4C,$5A,$C7,$AD,$63,$00,$F0,$03 ; C7E1
        .byte $20,$75,$C9,$60,$A9,$38,$8D,$07,$41,$A5,$94,$48,$A5,$95,$48,$A5 ; C7F1
        .byte $9A,$48,$A5,$9B,$48,$20,$5D,$C1,$A0,$00,$B1,$94,$85,$9A,$C8,$B1 ; C801
        .byte $94,$85,$9B,$A0,$0A,$B1,$94,$18,$69,$00,$8D,$39,$00,$A0,$0C,$B1 ; C811
        .byte $94,$18,$69,$38,$8D,$33,$00,$AD,$33,$00,$8D,$07,$41,$20,$12,$C2 ; C821
        .byte $A5,$00,$29,$FC,$0D,$35,$00,$85,$00,$A9,$00,$8D,$3C,$00,$68,$85 ; C831
        .byte $9B,$68,$85,$9A,$68,$85,$95,$68,$85,$94,$60,$BD,$02,$01,$0A,$0A ; C841
        .byte $0A,$A8,$B1,$B6,$85,$BC,$C8,$B1,$B6,$85,$BD,$C8,$B1,$B6,$85,$14 ; C851
        .byte $C8,$B1,$B6,$85,$15,$C8,$B1,$B6,$85,$12,$C8,$B1,$B6,$85,$13,$C8 ; C861
        .byte $B1,$B6,$8D,$1B,$01,$C8,$B1,$B6,$8D,$08,$01,$60,$BD,$04,$01,$0A ; C871
        .byte $0A,$A8,$B1,$BC,$85,$BA,$C8,$B1,$BC,$85,$BB,$C8,$B1,$BC,$18,$69 ; C881
        .byte $38,$85,$16,$C8,$B1,$BC,$8D,$64,$00,$60,$20,$A2,$C8,$20,$CA,$C8 ; C891
        .byte $60,$A9,$00,$8D,$1B,$01,$A5,$15,$0A,$2E,$1B,$01,$0A,$2E,$1B,$01 ; C8A1
        .byte $0A,$2E,$1B,$01,$0A,$2E,$1B,$01,$0A,$2E,$1B,$01,$18,$65,$14,$85 ; C8B1
        .byte $B8,$AD,$1B,$01,$69,$04,$85,$B9,$60,$A5,$15,$0A,$8D,$1B,$01,$A5 ; C8C1
        .byte $14,$4A,$4A,$18,$6D,$1B,$01,$69,$C0,$85,$BE,$A9,$00,$69,$07,$85 ; C8D1
        .byte $BF,$60,$20,$F6,$C8,$A5,$12,$C9,$04,$90,$09,$A5,$13,$C9,$04,$90 ; C8E1
        .byte $03,$20,$37,$C9,$60,$08,$48,$98,$48,$8A,$48,$A6,$13,$E0,$20,$90 ; C8F1
        .byte $02,$CA,$CA,$A0,$00,$B1,$BA,$18,$6D,$64,$00,$91,$B8,$C8,$C4,$12 ; C901
        .byte $90,$F3,$A5,$BA,$18,$65,$12,$85,$BA,$A5,$BB,$69,$00,$85,$BB,$A5 ; C911
        .byte $B8,$18,$69,$20,$85,$B8,$A5,$B9,$69,$00,$85,$B9,$CA,$D0,$D4,$68 ; C921
        .byte $AA,$68,$A8,$68,$28,$60,$08,$48,$98,$48,$8A,$48,$46,$12,$46,$12 ; C931
        .byte $46,$13,$46,$13,$A0,$00,$B1,$BA,$91,$BE,$C8,$C4,$12,$90,$F7,$A5 ; C941
        .byte $BA,$18,$65,$12,$85,$BA,$A5,$BB,$69,$00,$85,$BB,$A5,$BE,$18,$69 ; C951
        .byte $08,$85,$BE,$A5,$BF,$69,$00,$85,$BF,$C6,$13,$D0,$D7,$68,$AA,$68 ; C961
        .byte $A8,$68,$28,$60,$A9,$00,$85,$92,$85,$90,$AD,$35,$00,$D0,$05,$A9 ; C971
        .byte $20,$4C,$87,$C9,$A9,$24,$85,$93,$A9,$04,$85,$91,$A9,$80,$05,$05 ; C981
        .byte $85,$05,$20,$05,$CA,$60,$A9,$00,$8D,$15,$40,$8D,$30,$40,$8D,$31 ; C991
        .byte $40,$8D,$12,$40,$8D,$13,$40,$60 ; C9A1
sub_C9A9:
        ; static (not seen in traces)
        lda  #$00                       ; C9A9
        sta  $0C                        ; C9AB
        lda  #$00                       ; C9AD
        sta  APU_STATUS                 ; C9AF
        sta  APU_4000                   ; C9B2
        sta  APU_4004                   ; C9B5
        sta  APU_4008                   ; C9B8
        sta  APU_400C                   ; C9BB
        sta  APU_4010                   ; C9BE
        rts                             ; C9C1
        .byte $A9,$31,$85,$09,$8D,$08,$41,$A9,$00,$E6,$0C,$60 ; C9C2
sub_C9CE:
        lda  ppu_ctrl_shadow            ; C9CE
        bmi  loc_C9DD                   ; C9D0
loc_C9D2:
        lda  PPU_STATUS                 ; C9D2
        bpl  loc_C9D2                   ; C9D5
loc_C9D7:
        lda  PPU_STATUS                 ; C9D7
        bmi  loc_C9D7                   ; C9DA
        rts                             ; C9DC
loc_C9DD:
        lda  frame_counter              ; C9DD
loc_C9DF:
        inc  $10                        ; C9DF
        cmp  frame_counter              ; C9E1
        beq  loc_C9DF                   ; C9E3
        rts                             ; C9E5
loc_C9E6:
        ; static (not seen in traces)
        cpy  #$00                       ; C9E6
        beq  loc_C9F0                   ; C9E8
loc_C9EA:
        jsr  sub_C9CE                   ; C9EA
        dey                             ; C9ED
        bne  loc_C9EA                   ; C9EE
loc_C9F0:
        rts                             ; C9F0
        .byte $A5,$05,$29,$20,$D0,$FA,$60,$E6,$10,$D0,$FC,$60,$60 ; C9F1
sub_C9FE:
        lda  #$08                       ; C9FE
        ora  ppu_mask_shadow            ; CA00
        sta  ppu_mask_shadow            ; CA02
        rts                             ; CA04
sub_CA05:
        lda  ppu_mask_shadow            ; CA05
        and  #$F7                       ; CA07
        sta  ppu_mask_shadow            ; CA09
        rts                             ; CA0B
sub_CA0C:
        lda  #$10                       ; CA0C
        ora  ppu_mask_shadow            ; CA0E
        sta  ppu_mask_shadow            ; CA10
        rts                             ; CA12
sub_CA13:
        lda  #$EF                       ; CA13
        and  ppu_mask_shadow            ; CA15
        sta  ppu_mask_shadow            ; CA17
        rts                             ; CA19
sub_CA1A:
        lda  #$80                       ; CA1A
        ora  ppu_ctrl_shadow            ; CA1C
        sta  ppu_ctrl_shadow            ; CA1E
        sta  PPU_CTRL                   ; CA20
        rts                             ; CA23
sub_CA24:
        lda  #$7F                       ; CA24
        and  ppu_ctrl_shadow            ; CA26
        sta  ppu_ctrl_shadow            ; CA28
        sta  PPU_CTRL                   ; CA2A
        rts                             ; CA2D
loc_CA2E:
        ; static (not seen in traces)
        lda  #$00                       ; CA2E
        sta  $010D                      ; CA30
        sta  $010E                      ; CA33
        sta  $010F                      ; CA36
        sta  $0110                      ; CA39
loc_CA3C:
        sec                             ; CA3C
        lda  $0116                      ; CA3D
        sbc  #$E8                       ; CA40
        lda  $0117                      ; CA42
        sbc  #$03                       ; CA45
        bmi  loc_CA60                   ; CA47
        sec                             ; CA49
        lda  $0116                      ; CA4A
        sbc  #$E8                       ; CA4D
        sta  $0116                      ; CA4F
        lda  $0117                      ; CA52
        sbc  #$03                       ; CA55
        sta  $0117                      ; CA57
        inc  $0110                      ; CA5A
        jmp  loc_CA3C                   ; CA5D
loc_CA60:
        sec                             ; CA60
        lda  $0116                      ; CA61
        sbc  #$64                       ; CA64
        lda  $0117                      ; CA66
        sbc  #$00                       ; CA69
        bmi  loc_CA84                   ; CA6B
        sec                             ; CA6D
        lda  $0116                      ; CA6E
        sbc  #$64                       ; CA71
        sta  $0116                      ; CA73
        lda  $0117                      ; CA76
        sbc  #$00                       ; CA79
        sta  $0117                      ; CA7B
        inc  $010F                      ; CA7E
        jmp  loc_CA60                   ; CA81
loc_CA84:
        lda  $0116                      ; CA84
        cmp  #$0A                       ; CA87
        bcc  loc_CA9A                   ; CA89
        sec                             ; CA8B
        lda  $0116                      ; CA8C
        sbc  #$0A                       ; CA8F
        sta  $0116                      ; CA91
        inc  $010E                      ; CA94
        jmp  loc_CA84                   ; CA97
loc_CA9A:
        lda  $0116                      ; CA9A
        sta  $010D                      ; CA9D
        rts                             ; CAA0
loc_CAA1:
        lda  #$00                       ; CAA1
        sta  $0113                      ; CAA3
        sta  $0114                      ; CAA6
        sta  $010D                      ; CAA9
        sta  $010E                      ; CAAC
        sta  $010F                      ; CAAF
        sta  $0110                      ; CAB2
        ldx  #$10                       ; CAB5
loc_CAB7:
        lsr  $0116                      ; CAB7
        ror  $0115                      ; CABA
        bcc  loc_CAE4                   ; CABD
        clc                             ; CABF
        lda  $010D                      ; CAC0
        adc  $0111                      ; CAC3
        sta  $010D                      ; CAC6
        lda  $010E                      ; CAC9
        adc  $0112                      ; CACC
        sta  $010E                      ; CACF
        lda  $010F                      ; CAD2
        adc  $0113                      ; CAD5
        sta  $010F                      ; CAD8
        lda  $0110                      ; CADB
        adc  $0114                      ; CADE
        sta  $0110                      ; CAE1
loc_CAE4:
        asl  $0111                      ; CAE4
        rol  $0112                      ; CAE7
        rol  $0113                      ; CAEA
        rol  $0114                      ; CAED
        dex                             ; CAF0
        bne  loc_CAB7                   ; CAF1
        rts                             ; CAF3
loc_CAF4:
        lda  #$00                       ; CAF4
        sta  $0115                      ; CAF6
        sta  $010D                      ; CAF9
        sta  $010E                      ; CAFC
        sta  $010F                      ; CAFF
        sta  $0110                      ; CB02
        ldx  #$18                       ; CB05
loc_CB07:
        asl  $0111                      ; CB07
        rol  $0112                      ; CB0A
        rol  $0113                      ; CB0D
        rol  $0114                      ; CB10
        rol  $0115                      ; CB13
        bcs  loc_CB2A                   ; CB16
        lda  $0115                      ; CB18
        cmp  $0117                      ; CB1B
        bcc  loc_CB3E                   ; CB1E
        bne  loc_CB2A                   ; CB20
        lda  $0114                      ; CB22
        cmp  $0116                      ; CB25
        bcc  loc_CB3E                   ; CB28
loc_CB2A:
        sec                             ; CB2A
        lda  $0114                      ; CB2B
        sbc  $0116                      ; CB2E
        sta  $0114                      ; CB31
        lda  $0115                      ; CB34
        sbc  $0117                      ; CB37
        sta  $0115                      ; CB3A
        sec                             ; CB3D
loc_CB3E:
        rol  $010D                      ; CB3E
        rol  $010E                      ; CB41
        rol  $010F                      ; CB44
        rol  $0110                      ; CB47
        dex                             ; CB4A
        bne  loc_CB07                   ; CB4B
        rts                             ; CB4D
dat_CB4E:
        .byte $A5,$9A,$48,$A5,$9B,$48,$20,$20,$C2,$A0,$00,$B1,$9A,$F0,$35,$C9 ; CB4E
        .byte $80,$B0,$1F,$B1,$9A,$29,$7F,$AA,$C8,$B1,$9A,$49,$FF,$8D,$07,$20 ; CB5E
        .byte $CA,$D0,$FA,$C8,$98,$18,$65,$9A,$85,$9A,$A5,$9B,$69,$00,$85,$9B ; CB6E
        .byte $D0,$D7,$B1,$9A,$29,$7F,$AA,$C8,$B1,$9A,$49,$FF,$8D,$07,$20,$CA ; CB7E
        .byte $D0,$F5,$F0,$DF,$68,$85,$9B,$68,$85,$9A,$60,$A9,$00,$85,$98,$A9 ; CB8E
        .byte $04,$85,$99,$A9,$00,$8D,$19,$01,$A8,$B1,$9A,$F0,$7B,$C9,$80,$B0 ; CB9E
        .byte $3A,$B1,$9A,$29,$7F,$48,$AA,$C8,$B1,$9A,$49,$FF,$8D,$18,$01,$C8 ; CBAE
        .byte $98,$48,$AC,$19,$01,$AD,$18,$01,$91,$98,$EE,$19,$01,$C8,$CA,$D0 ; CBBE
        .byte $F4,$68,$18,$65,$9A,$85,$9A,$A5,$9B,$69,$00,$85,$9B,$68,$18,$65 ; CBCE
        .byte $98,$85,$98,$A5,$99,$69,$00,$85,$99,$D0,$B8,$B1,$9A,$29,$7F,$48 ; CBDE
        .byte $AA,$C8,$B1,$9A,$49,$FF,$8D,$18,$01,$98,$48,$AC,$19,$01,$AD,$18 ; CBEE
        .byte $01,$91,$98,$EE,$19,$01,$68,$A8,$CA,$D0,$E6,$68,$A8,$18,$65,$98 ; CBFE
        .byte $85,$98,$A5,$99,$69,$00,$85,$99,$C8,$98,$18,$65,$9A,$85,$9A,$A5 ; CC0E
        .byte $9B,$69,$00,$85,$9B,$4C,$A1,$CB,$60 ; CC1E
goto_state_step:
        ; static (not seen in traces)
        sta  $17                        ; CC27
        stx  $18                        ; CC29
        lda  #$FF                       ; CC2B
        sta  a:step_exit                ; CC2D
        rts                             ; CC30
loc_CC31:
        rts                             ; CC31
loc_CC32:
        rts                             ; CC32
loc_CC33:
        rts                             ; CC33
        .byte $60 ; CC34
sub_CC35:
        txa                             ; CC35
        pha                             ; CC36
        tya                             ; CC37
        pha                             ; CC38
        lda  #$00                       ; CC39
        sta  $012B                      ; CC3B
        sta  $012C                      ; CC3E
        sta  $012D                      ; CC41
        sta  $012E                      ; CC44
        ldx  #$20                       ; CC47
loc_CC49:
        asl  $0123                      ; CC49
        rol  $0124                      ; CC4C
        rol  $0125                      ; CC4F
        rol  $0126                      ; CC52
        rol  $012B                      ; CC55
        rol  $012C                      ; CC58
        rol  $012D                      ; CC5B
        rol  $012E                      ; CC5E
        sec                             ; CC61
        lda  $012B                      ; CC62
        sbc  $0127                      ; CC65
        lda  $012C                      ; CC68
        sbc  $0128                      ; CC6B
        lda  $012D                      ; CC6E
        sbc  $0129                      ; CC71
        lda  $012E                      ; CC74
        sbc  $012A                      ; CC77
        bcc  loc_CCA3                   ; CC7A
        inc  $0123                      ; CC7C
        lda  $012B                      ; CC7F
        sbc  $0127                      ; CC82
        sta  $012B                      ; CC85
        lda  $012C                      ; CC88
        sbc  $0128                      ; CC8B
        sta  $012C                      ; CC8E
        lda  $012D                      ; CC91
        sbc  $0129                      ; CC94
        sta  $012D                      ; CC97
        lda  $012E                      ; CC9A
        sbc  $012A                      ; CC9D
        sta  $012E                      ; CCA0
loc_CCA3:
        dex                             ; CCA3
        bne  loc_CC49                   ; CCA4
        pla                             ; CCA6
        tay                             ; CCA7
        pla                             ; CCA8
        tax                             ; CCA9
        rts                             ; CCAA
sub_CCAB:
        ; static (not seen in traces)
        lda  #$00                       ; CCAB
        sta  $0132                      ; CCAD
        sta  $0131                      ; CCB0
        sta  $0130                      ; CCB3
        sta  $012F                      ; CCB6
        ldx  #$20                       ; CCB9
loc_CCBB:
        lsr  $012A                      ; CCBB
        ror  $0129                      ; CCBE
        ror  $0128                      ; CCC1
        ror  $0127                      ; CCC4
        bcc  loc_CCEE                   ; CCC7
        lda  $012F                      ; CCC9
        clc                             ; CCCC
        adc  $0123                      ; CCCD
        sta  $012F                      ; CCD0
        lda  $0130                      ; CCD3
        adc  $0124                      ; CCD6
        sta  $0130                      ; CCD9
        lda  $0131                      ; CCDC
        adc  $0125                      ; CCDF
        sta  $0131                      ; CCE2
        lda  $0132                      ; CCE5
        adc  $0126                      ; CCE8
        sta  $0132                      ; CCEB
loc_CCEE:
        lsr  $0132                      ; CCEE
        ror  $0131                      ; CCF1
        ror  $0130                      ; CCF4
        ror  $012F                      ; CCF7
        ror  $012E                      ; CCFA
        ror  $012D                      ; CCFD
        ror  $012C                      ; CD00
        ror  $012B                      ; CD03
        dex                             ; CD06
        bne  loc_CCBB                   ; CD07
        rts                             ; CD09
sub_CD0A:
        cld                             ; CD0A
        lda  #$00                       ; CD0B
        sta  $0133                      ; CD0D
        sta  $0131                      ; CD10
        sta  $0132                      ; CD13
loc_CD16:
        lsr  $012F                      ; CD16
        bcc  loc_CD2E                   ; CD19
        clc                             ; CD1B
        lda  $0130                      ; CD1C
        adc  $0131                      ; CD1F
        sta  $0131                      ; CD22
        lda  $0133                      ; CD25
        adc  $0132                      ; CD28
        sta  $0132                      ; CD2B
loc_CD2E:
        asl  $0130                      ; CD2E
        rol  $0133                      ; CD31
        lda  $012F                      ; CD34
        bne  loc_CD16                   ; CD37
        rts                             ; CD39
        .byte $EA,$EA,$14,$1C,$04,$0C ; CD3A
tbl_menu_states:
        .word tbl_state0_steps ; CD40
tbl_state0_steps:
        .word step0_screen2 ; CD42
        .word $0000 ; CD44
        .word step1_screen1 ; CD46
        .word $0000 ; CD48
        .word step2_screen3 ; CD4A
        .word $0000 ; CD4C
        .word step3_rts ; CD4E
        .word $0000 ; CD50
        .word step4_rts ; CD52
        .word $0000 ; CD54
screen_desc_1:
        .byte $01,$00,$00,$00,$80,$3E,$00,$20,$00 ; CD56  screen_desc 0
screen_desc_2:
        .byte $01,$00,$00,$00,$80,$20,$00,$30,$00 ; CD5F  screen_desc 1
screen_desc_3:
        .byte $01,$00,$00,$00,$80,$30,$00,$28,$00 ; CD68  screen_desc 2
        .byte $64,$74,$9C,$9E,$3A,$1A ; CD71
step_common_init:
        cli                             ; CD77
        jsr  sub_C6DF                   ; CD78
        lda  #$00                       ; CD7B
        sta  a:$0035                    ; CD7D
        sta  a:$0037                    ; CD80
        jsr  sub_CA1A                   ; CD83
        jsr  sub_C105                   ; CD86
        rts                             ; CD89
        .byte $60 ; CD8A
step0_screen2:
        ; static (not seen in traces)
        cli                             ; CD8B
        lda  #$02                       ; CD8C
        sta  a:screen_id                ; CD8E
        jsr  step_common_init           ; CD91
        jsr  select_screen_desc_1       ; CD94
        lda  #$3A                       ; CD97
        sta  prg8000_shadow             ; CD99
        sta  OB_PRG_8000                ; CD9B
        lda  #$00                       ; CD9E
        sta  list_header_sel            ; CDA0
        jsr  load_char_tile_map         ; CDA3
        jsr  draw_header_text           ; CDA6
        jsr  load_list_header           ; CDA9
        lda  #$01                       ; CDAC
        sta  $03C4                      ; CDAE
        jsr  sub_D734                   ; CDB1
        jsr  screen_enable              ; CDB4
        lda  #$00                       ; CDB7
        sta  a:$0066                    ; CDB9
        lda  #$FF                       ; CDBC
        sta  $015F                      ; CDBE
loc_CDC1:
        lda  frame_done                 ; CDC1
        bne  loc_CDD8                   ; CDC3
        ldx  #$00                       ; CDC5
        jsr  sub_C622                   ; CDC7
        jsr  list_input                 ; CDCA
        jsr  update_sprite_slots        ; CDCD
        jsr  sub_D734                   ; CDD0
        jsr  sub_E178                   ; CDD3
        inc  frame_done                 ; CDD6
loc_CDD8:
        lda  a:step_exit                ; CDD8
        beq  loc_CDC1                   ; CDDB
        jsr  screen_exit                ; CDDD
        ldy  #$0F                       ; CDE0
        jsr  jt_C9E6                    ; CDE2
        jsr  step0_exit_launch          ; CDE5
        rts                             ; CDE8
step1_screen1:
        cli                             ; CDE9
        lda  #$01                       ; CDEA
        sta  a:screen_id                ; CDEC
        jsr  step_common_init           ; CDEF
        lda  #$3A                       ; CDF2
        sta  prg8000_shadow             ; CDF4
        sta  OB_PRG_8000                ; CDF6
        lda  #$01                       ; CDF9
        sta  list_header_sel            ; CDFB
        jsr  load_char_tile_map         ; CDFE
        jsr  select_screen_desc_2       ; CE01
        jsr  load_list_header           ; CE04
        lda  #$3A                       ; CE07
        sta  prg8000_shadow             ; CE09
        sta  OB_PRG_8000                ; CE0B
        jsr  sub_D79A                   ; CE0E
        lda  #$01                       ; CE11
        sta  a:$0065                    ; CE13
        lda  #$00                       ; CE16
        sta  a:$0035                    ; CE18
        sta  $0100                      ; CE1B
        sta  $0104                      ; CE1E
        sta  $0105                      ; CE21
        lda  #$01                       ; CE24
        sta  $0101                      ; CE26
        jsr  sub_CFF3                   ; CE29
        jsr  update_sprite_slots        ; CE2C
        jsr  screen_enable              ; CE2F
loc_CE32:
        jsr  sub_D78D                   ; CE32
        jsr  list_input                 ; CE35
        jsr  update_sprite_slots        ; CE38
        inc  frame_done                 ; CE3B
        lda  a:step_exit                ; CE3D
        beq  loc_CE32                   ; CE40
        ; static (not seen in traces)
        jsr  screen_exit                ; CE42
        ldy  #$02                       ; CE45
        jsr  jt_C9E6                    ; CE47
        jsr  step1_exit_launch          ; CE4A
        rts                             ; CE4D
step2_screen3:
        cli                             ; CE4E
        lda  #$03                       ; CE4F
        sta  a:screen_id                ; CE51
        jsr  step_common_init           ; CE54
        jsr  select_screen_desc_3       ; CE57
        lda  #$32                       ; CE5A
        sta  $0122                      ; CE5C
        jsr  screen_enable              ; CE5F
loc_CE62:
        lda  frame_done                 ; CE62
        bne  loc_CE71                   ; CE64
        jsr  update_sprite_slots        ; CE66
        jsr  chooser_input              ; CE69
        jsr  sub_D0AB                   ; CE6C
        inc  frame_done                 ; CE6F
loc_CE71:
        lda  a:step_exit                ; CE71
        beq  loc_CE62                   ; CE74
        jsr  screen_exit                ; CE76
        rts                             ; CE79
step3_rts:
        rts                             ; CE7A
step4_rts:
        rts                             ; CE7B
select_screen_desc_1:
        lda  #$56                       ; CE7C
        sta  screen_desc_ptr            ; CE7E
        lda  #$CD                       ; CE80
        sta  $B5                        ; CE82
        jsr  load_screen_desc           ; CE84
        rts                             ; CE87
select_screen_desc_2:
        lda  #$5F                       ; CE88
        sta  screen_desc_ptr            ; CE8A
        lda  #$CD                       ; CE8C
        sta  $B5                        ; CE8E
        jsr  load_screen_desc           ; CE90
        rts                             ; CE93
select_screen_desc_3:
        ; static (not seen in traces)
        lda  #$68                       ; CE94
        sta  screen_desc_ptr            ; CE96
        lda  #$CD                       ; CE98
        sta  $B5                        ; CE9A
        jsr  load_screen_desc           ; CE9C
        rts                             ; CE9F
        .byte $A5,$0E,$CD,$38,$00,$F0,$1F,$8D,$38,$00,$A5,$0E,$29,$80,$C9,$80 ; CEA0
        .byte $F0,$14,$A5,$0E,$29,$10,$C9,$10,$F0,$03,$4C,$C6,$CE,$EE,$66,$00 ; CEB0
        .byte $A9,$00,$AA,$20,$0F,$C0,$60 ; CEC0
chooser_input:
        ; static (not seen in traces)
        lda  $0E                        ; CEC7
        cmp  a:$0038                    ; CEC9
        beq  loc_CF00                   ; CECC
        sta  a:$0038                    ; CECE
        and  #$08                       ; CED1
        bne  loc_CEEE                   ; CED3
        lda  $0E                        ; CED5
        and  #$04                       ; CED7
        bne  loc_CEEE                   ; CED9
        lda  $0E                        ; CEDB
        and  #$10                       ; CEDD
        beq  loc_CF00                   ; CEDF
        lda  a:chooser_option           ; CEE1
        eor  #$01                       ; CEE4
        tax                             ; CEE6
        lda  #$00                       ; CEE7
        jsr  jt_CC27                    ; CEE9
        bne  loc_CF00                   ; CEEC
loc_CEEE:
        lda  a:chooser_option           ; CEEE
        eor  #$01                       ; CEF1
        sta  a:chooser_option           ; CEF3
        tay                             ; CEF6
        lda  dat_CF01,y                 ; CEF7
        sta  $0174                      ; CEFA
        jsr  sub_DF37                   ; CEFD
loc_CF00:
        rts                             ; CF00
dat_CF01:
        .byte $30,$40,$A5,$0E,$CD,$38,$00,$F0,$1F,$8D,$38,$00,$29,$08,$D0,$5D ; CF01
        .byte $A5,$0E,$29,$04,$D0,$7A,$A5,$0E,$29,$02,$D0,$22,$A5,$0E,$29,$01 ; CF11
        .byte $D0,$35,$A5,$0E,$29,$80,$D0,$03,$4C,$F2,$CF,$A9,$00,$A2,$04,$20 ; CF21
        .byte $0F,$C0,$4C,$F2,$CF,$AD,$6B,$00,$38,$E9,$01,$8D,$74,$00,$AD,$73 ; CF31
        .byte $00,$F0,$06,$CE,$73,$00,$4C,$B5,$CF,$AD,$71,$00,$8D,$73,$00,$4C ; CF41
        .byte $B5,$CF,$A9,$00,$8D,$74,$00,$AD,$73,$00,$CD,$71,$00,$F0,$06,$EE ; CF51
        .byte $73,$00,$4C,$B5,$CF,$A9,$00,$8D,$73,$00,$4C,$B5,$CF,$AD,$74,$00 ; CF61
        .byte $F0,$C3,$CE,$74,$00,$4C,$D5,$CF,$AD,$73,$00,$CD,$71,$00,$90,$06 ; CF71
        .byte $AC,$72,$00,$4C,$8A,$CF,$AC,$6B,$00,$88,$8C,$74,$00,$4C,$D5,$CF ; CF81
        .byte $AD,$74,$00,$18,$69,$01,$48,$AD,$73,$00,$CD,$71,$00,$90,$09,$68 ; CF91
        .byte $CD,$72,$00,$B0,$AD,$4C,$AF,$CF,$68,$CD,$6B,$00,$B0,$A4,$EE,$74 ; CFA1
        .byte $00,$4C,$D5,$CF,$AD,$73,$00,$CD,$71,$00,$D0,$18,$AD,$74,$00,$18 ; CFB1
        .byte $69,$01,$CD,$72,$00,$90,$0D,$F0,$0B,$CE,$74,$00,$4C,$BD,$CF,$A9 ; CFC1
        .byte $00,$8D,$74,$00,$AD,$73,$00,$CD,$04,$01,$F0,$0F,$8D,$04,$01,$8D ; CFD1
        .byte $05,$01,$20,$F3,$CF,$20,$FE,$C9,$8D,$01,$20,$20,$0E,$D0,$20,$37 ; CFE1
        .byte $DF,$60 ; CFF1
sub_CFF3:
        rts                             ; CFF3
        .byte $AD,$04,$01,$0A,$18,$69,$90,$8D,$7E,$00,$85,$1D,$8D,$14,$20,$69 ; CFF4
        .byte $01,$8D,$7F,$00,$85,$1E,$8D,$15,$20,$60,$AC,$74,$00,$B9,$1E,$D0 ; D004
        .byte $8D,$74,$01,$60,$EA,$EA,$14,$1C,$04,$0C,$20,$30,$40,$50,$60,$70 ; D014
        .byte $80,$90,$A0,$B0,$C0,$D0,$64,$74,$9C,$9E,$3A,$1A,$A9,$3A,$85,$08 ; D024
        .byte $8D,$07,$41,$A9,$00,$8D,$73,$00,$8D,$74,$00,$AD,$F7,$03,$0A,$0A ; D034
        .byte $A8,$B9,$14,$81,$85,$B6,$B9,$15,$81,$85,$B7,$A0,$00,$B1,$B6,$99 ; D044
        .byte $67,$00,$C8,$C0,$0A,$90,$F6,$AD,$67,$00,$8D,$11,$01,$AD,$68,$00 ; D054
        .byte $8D,$12,$01,$A9,$00,$8D,$13,$01,$8D,$14,$01,$AD,$6B,$00,$8D,$16 ; D064
        .byte $01,$A9,$00,$8D,$17,$01,$20,$09,$C0,$AD,$0D,$01,$8D,$71,$00,$AD ; D074
        .byte $14,$01,$F0,$06,$8D,$72,$00,$4C,$97,$D0,$AD,$6B,$00,$8D,$72,$00 ; D084
        .byte $CE,$71,$00,$AD,$6D,$00,$AC,$6E,$00,$60,$60,$04,$00,$04,$00,$F8 ; D094
        .byte $0F,$F8,$0F,$00,$00,$00,$00 ; D0A4
sub_D0AB:
        ; static (not seen in traces)
        lda  $0E                        ; D0AB
        cmp  #$C0                       ; D0AD
        bne  loc_D0DD                   ; D0AF
        jsr  sub_DBD6                   ; D0B1
        lda  #$3A                       ; D0B4
        sta  prg8000_shadow             ; D0B6
        sta  OB_PRG_8000                ; D0B8
        lda  #$01                       ; D0BB
        sta  $03F9                      ; D0BD
        lda  #$33                       ; D0C0
        sta  $03F8                      ; D0C2
        asl  $03F8                      ; D0C5
        rol  $03F9                      ; D0C8
        lda  $03F8                      ; D0CB
        clc                             ; D0CE
        adc  #$C3                       ; D0CF
        sta  handler_ptr                ; D0D1
        lda  #$86                       ; D0D3
        adc  $03F9                      ; D0D5
        sta  $B3                        ; D0D8
        jsr  launch_selected_game       ; D0DA
loc_D0DD:
        rts                             ; D0DD
        .byte $A9,$00,$AA,$95,$00,$9D,$00,$02,$9D,$00,$03,$9D,$00,$04,$9D,$00 ; D0DE
        .byte $05,$9D,$00,$06,$9D,$00,$07,$E8,$D0,$E9,$20,$E4,$C3,$A9,$00,$8D ; D0EE
        .byte $03,$20,$8D,$34,$40,$A9,$02,$8D,$14,$40,$A0,$01,$20,$00,$C0,$A9 ; D0FE
        .byte $00,$8D,$00,$20,$8D,$01,$20,$A9,$00,$8D,$12,$20,$18,$69,$01,$8D ; D10E
        .byte $13,$20,$69,$01,$8D,$14,$20,$69,$01,$8D,$15,$20,$A9,$04,$8D,$16 ; D11E
        .byte $20,$18,$69,$02,$8D,$17,$20,$A2,$00,$BD,$46,$D1,$9D,$00,$03,$E8 ; D12E
        .byte $E0,$33,$90,$F5,$4C,$00,$03,$60,$A9,$00,$8D,$00,$20,$8D,$01,$20 ; D13E
        .byte $8D,$00,$A0,$A9,$04,$8D,$0B,$41,$A2,$FC,$8E,$07,$41,$E8,$8E,$08 ; D14E
        .byte $41,$E8,$8E,$09,$41,$E8,$8E,$0A,$41,$A9,$77,$8D,$00,$41,$A9,$70 ; D15E
        .byte $8D,$18,$20,$A9,$E6,$8D,$1A,$20,$6C,$FC,$FF,$60,$20,$05,$CA,$8D ; D16E
        .byte $01,$20,$20,$55,$C1,$A9,$7C,$85,$BC,$A9,$80,$85,$BD,$A2,$00,$20 ; D17E
        .byte $7D,$C8,$A5,$16,$85,$08,$8D,$07,$41,$A9,$20,$8D,$06,$20,$A9,$88 ; D18E
        .byte $8D,$06,$20,$20,$72,$D2,$A9,$20,$8D,$06,$20,$A9,$A8,$8D,$06,$20 ; D19E
        .byte $20,$72,$D2,$A9,$20,$8D,$06,$20,$A9,$C8,$8D,$06,$20,$20,$72,$D2 ; D1AE
        .byte $A9,$20,$8D,$06,$20,$A9,$E8,$8D,$06,$20,$20,$72,$D2,$A9,$21,$8D ; D1BE
        .byte $06,$20,$A9,$08,$8D,$06,$20,$20,$72,$D2,$A9,$21,$8D,$06,$20,$A9 ; D1CE
        .byte $28,$8D,$06,$20,$20,$72,$D2,$A9,$21,$8D,$06,$20,$A9,$48,$8D,$06 ; D1DE
        .byte $20,$20,$72,$D2,$A9,$21,$8D,$06,$20,$A9,$68,$8D,$06,$20,$20,$72 ; D1EE
        .byte $D2,$A9,$21,$8D,$06,$20,$A9,$88,$8D,$06,$20,$20,$72,$D2,$A9,$21 ; D1FE
        .byte $8D,$06,$20,$A9,$A8,$8D,$06,$20,$20,$72,$D2,$A9,$21,$8D,$06,$20 ; D20E
        .byte $A9,$C8,$8D,$06,$20,$20,$72,$D2,$A9,$21,$8D,$06,$20,$A9,$E8,$8D ; D21E
        .byte $06,$20,$20,$72,$D2,$A9,$22,$8D,$06,$20,$A9,$08,$8D,$06,$20,$20 ; D22E
        .byte $72,$D2,$A9,$22,$8D,$06,$20,$A9,$28,$8D,$06,$20,$20,$72,$D2,$A9 ; D23E
        .byte $22,$8D,$06,$20,$A9,$48,$8D,$06,$20,$20,$72,$D2,$A9,$22,$8D,$06 ; D24E
        .byte $20,$A9,$68,$8D,$06,$20,$20,$72,$D2,$A9,$22,$8D,$06,$20,$A9,$00 ; D25E
        .byte $8D,$06,$20,$60,$A0,$00,$B1,$BA,$8D,$07,$20,$C8,$B1,$BA,$8D,$07 ; D26E
        .byte $20,$C8,$B1,$BA,$8D,$07,$20,$C8,$B1,$BA,$8D,$07,$20,$C8,$B1,$BA ; D27E
        .byte $18,$69,$80,$8D,$07,$20,$C8,$C0,$10,$90,$F3,$A5,$BA,$18,$69,$10 ; D28E
        .byte $85,$BA,$A5,$BB,$69,$00,$85,$BB,$60 ; D29E
load_char_tile_map:
        asl  a                          ; D2A7
        tay                             ; D2A8
        lda  dat_8000,y                 ; D2A9
        sta  $B6                        ; D2AC
        lda  dat_8001,y                 ; D2AE
        sta  $B7                        ; D2B1
        ldy  #$00                       ; D2B3
loc_D2B5:
        lda  ($B6),y                    ; D2B5
        sta  $03FA,y                    ; D2B7
        iny                             ; D2BA
        cpy  #$80                       ; D2BB
        bcc  loc_D2B5                   ; D2BD
        rts                             ; D2BF
draw_header_text:
        ; static (not seen in traces)
        lda  #$3A                       ; D2C0
        sta  prg8000_shadow             ; D2C2
        sta  OB_PRG_8000                ; D2C4
        lda  list_header_sel            ; D2C7
        asl  a                          ; D2CA
        asl  a                          ; D2CB
        tay                             ; D2CC
        lda  dat_8116,y                 ; D2CD
        sta  state_tbl_ptr              ; D2D0
        lda  dat_8117,y                 ; D2D2
        sta  $B1                        ; D2D5
        ldy  #$00                       ; D2D7
loc_D2D9:
        lda  (state_tbl_ptr),y          ; D2D9
        cpy  #$05                       ; D2DB
        bcc  loc_D2F2                   ; D2DD
        sec                             ; D2DF
        sbc  #$20                       ; D2E0
        tax                             ; D2E2
        lda  $03FA,x                    ; D2E3
        sta  $037E,y                    ; D2E6
        lda  $043A,x                    ; D2E9
        sta  $039E,y                    ; D2EC
        jmp  loc_D2F8                   ; D2EF
loc_D2F2:
        sta  $037E,y                    ; D2F2
        sta  $039E,y                    ; D2F5
loc_D2F8:
        iny                             ; D2F8
        cpy  #$20                       ; D2F9
        bne  loc_D2D9                   ; D2FB
        lda  #$7E                       ; D2FD
        sta  $AE                        ; D2FF
        lda  #$03                       ; D301
        sta  $AF                        ; D303
        jsr  sub_E105                   ; D305
        lda  #$9E                       ; D308
        sta  $AE                        ; D30A
        lda  #$03                       ; D30C
        sta  $AF                        ; D30E
        jsr  sub_E13D                   ; D310
        ldx  #$00                       ; D313
        lda  #$00                       ; D315
loc_D317:
        sta  $037E,x                    ; D317
        sta  $039E,x                    ; D31A
        inx                             ; D31D
        cpx  #$20                       ; D31E
        bne  loc_D317                   ; D320
        rts                             ; D322
        .byte $A5,$B8,$18,$69,$20,$85,$BA,$A5,$B9,$69,$00,$85,$BB,$60 ; D323
list_input:
        lda  $0E                        ; D331
        cmp  a:$0038                    ; D333
        beq  loc_D357                   ; D336
        ; static (not seen in traces)
        sta  a:$0038                    ; D338
        and  #$08                       ; D33B
        bne  loc_D378                   ; D33D
        lda  $0E                        ; D33F
        and  #$04                       ; D341
        bne  loc_D386                   ; D343
        lda  $0E                        ; D345
        and  #$02                       ; D347
        bne  loc_D366                   ; D349
        lda  $0E                        ; D34B
        and  #$01                       ; D34D
        bne  loc_D36F                   ; D34F
        lda  $0E                        ; D351
        and  #$10                       ; D353
        bne  loc_D35A                   ; D355
loc_D357:
        jmp  loc_D3A0                   ; D357
loc_D35A:
        ; static (not seen in traces)
        lda  #$00                       ; D35A
        tax                             ; D35C
        jsr  jt_CC27                    ; D35D
        jmp  loc_D3A0                   ; D360
        .byte $4C,$A0,$D3 ; D363
loc_D366:
        ; static (not seen in traces)
        jsr  sub_DF37                   ; D366
        jsr  sub_D4B6                   ; D369
        jmp  loc_D3A0                   ; D36C
loc_D36F:
        jsr  sub_DF37                   ; D36F
        jsr  sub_D3A7                   ; D372
        jmp  loc_D3A0                   ; D375
loc_D378:
        jsr  sub_DF37                   ; D378
        lda  cn_row                     ; D37B
        beq  loc_D397                   ; D37E
        dec  cn_row                     ; D380
        jmp  loc_D3A0                   ; D383
loc_D386:
        jsr  sub_DF37                   ; D386
        inc  cn_row                     ; D389
        lda  cn_row                     ; D38C
        cmp  $03C1                      ; D38F
        bcs  loc_D39D                   ; D392
        jmp  loc_D3A0                   ; D394
loc_D397:
        jsr  sub_D56A                   ; D397
        jmp  loc_D3A0                   ; D39A
loc_D39D:
        jsr  sub_D446                   ; D39D
loc_D3A0:
        jsr  sub_D61F                   ; D3A0
        jsr  sub_D8E4                   ; D3A3
        rts                             ; D3A6
sub_D3A7:
        ; static (not seen in traces)
        lda  #$FF                       ; D3A7
        sta  $03C4                      ; D3A9
        lda  cn_page                    ; D3AC
        cmp  $036D                      ; D3AF
        bne  loc_D3F0                   ; D3B2
        lda  $0376                      ; D3B4
        cmp  $036E                      ; D3B7
        bne  loc_D3F0                   ; D3BA
        lda  $0377                      ; D3BC
        cmp  $036F                      ; D3BF
        bne  loc_D3F0                   ; D3C2
        lda  $0378                      ; D3C4
        cmp  $0370                      ; D3C7
        bne  loc_D3F0                   ; D3CA
        lda  #$00                       ; D3CC
        sta  cn_page                    ; D3CE
        sta  $0376                      ; D3D1
        sta  $0377                      ; D3D4
        sta  $0378                      ; D3D7
        sta  cn_row                     ; D3DA
        lda  #$01                       ; D3DD
        sta  $0379                      ; D3DF
        lda  #$00                       ; D3E2
        sta  $037A                      ; D3E4
        sta  $037B                      ; D3E7
        sta  $037C                      ; D3EA
        jmp  loc_D445                   ; D3ED
loc_D3F0:
        lda  cn_page                    ; D3F0
        clc                             ; D3F3
        adc  #$01                       ; D3F4
        sta  cn_page                    ; D3F6
        lda  $0376                      ; D3F9
        adc  #$00                       ; D3FC
        sta  $0376                      ; D3FE
        lda  $0377                      ; D401
        adc  #$00                       ; D404
        sta  $0377                      ; D406
        lda  $0378                      ; D409
        adc  #$00                       ; D40C
        sta  $0378                      ; D40E
        lda  cn_page                    ; D411
        cmp  $036D                      ; D414
        bne  loc_D445                   ; D417
        lda  $0376                      ; D419
        cmp  $036E                      ; D41C
        bne  loc_D445                   ; D41F
        lda  $0377                      ; D421
        cmp  $036F                      ; D424
        bne  loc_D445                   ; D427
        lda  $0378                      ; D429
        cmp  $0370                      ; D42C
        bne  loc_D445                   ; D42F
        lda  cn_row                     ; D431
        cmp  $0371                      ; D434
        bcc  loc_D445                   ; D437
        lda  $0371                      ; D439
        sec                             ; D43C
        sbc  #$01                       ; D43D
        sta  cn_row                     ; D43F
        jmp  loc_D445                   ; D442
loc_D445:
        rts                             ; D445
sub_D446:
        lda  #$FF                       ; D446
        sta  $03C4                      ; D448
        lda  cn_page                    ; D44B
        cmp  $036D                      ; D44E
        bne  loc_D48F                   ; D451
        lda  $0376                      ; D453
        cmp  $036E                      ; D456
        bne  loc_D48F                   ; D459
        lda  $0377                      ; D45B
        cmp  $036F                      ; D45E
        bne  loc_D48F                   ; D461
        lda  $0378                      ; D463
        cmp  $0370                      ; D466
        bne  loc_D48F                   ; D469
        lda  #$00                       ; D46B
        sta  cn_page                    ; D46D
        sta  $0376                      ; D470
        sta  $0377                      ; D473
        sta  $0378                      ; D476
        lda  #$01                       ; D479
        sta  $0379                      ; D47B
        lda  #$00                       ; D47E
        sta  $037A                      ; D480
        sta  $037B                      ; D483
        sta  $037C                      ; D486
        sta  cn_row                     ; D489
        jmp  loc_D4B5                   ; D48C
loc_D48F:
        lda  cn_page                    ; D48F
        clc                             ; D492
        adc  #$01                       ; D493
        sta  cn_page                    ; D495
        lda  $0376                      ; D498
        adc  #$00                       ; D49B
        sta  $0376                      ; D49D
        lda  $0377                      ; D4A0
        adc  #$00                       ; D4A3
        sta  $0377                      ; D4A5
        lda  $0378                      ; D4A8
        adc  #$00                       ; D4AB
        sta  $0378                      ; D4AD
        lda  #$00                       ; D4B0
        sta  cn_row                     ; D4B2
loc_D4B5:
        rts                             ; D4B5
sub_D4B6:
        lda  #$FF                       ; D4B6
        sta  $03C4                      ; D4B8
        lda  cn_page                    ; D4BB
        bne  loc_D4FB                   ; D4BE
        lda  $0376                      ; D4C0
        bne  loc_D4FB                   ; D4C3
        lda  $0377                      ; D4C5
        bne  loc_D4FB                   ; D4C8
        lda  $0378                      ; D4CA
        bne  loc_D4FB                   ; D4CD
        lda  $036D                      ; D4CF
        sta  cn_page                    ; D4D2
        lda  $036E                      ; D4D5
        sta  $0376                      ; D4D8
        lda  $036F                      ; D4DB
        sta  $0377                      ; D4DE
        lda  $0370                      ; D4E1
        sta  $0378                      ; D4E4
        lda  cn_row                     ; D4E7
        cmp  $0371                      ; D4EA
        bcc  loc_D51C                   ; D4ED
        lda  $0371                      ; D4EF
        sec                             ; D4F2
        sbc  #$01                       ; D4F3
        sta  cn_row                     ; D4F5
        jmp  loc_D51C                   ; D4F8
loc_D4FB:
        lda  cn_page                    ; D4FB
        sec                             ; D4FE
        sbc  #$01                       ; D4FF
        sta  cn_page                    ; D501
        lda  $0376                      ; D504
        sbc  #$00                       ; D507
        sta  $0376                      ; D509
        lda  $0377                      ; D50C
        sbc  #$00                       ; D50F
        sta  $0377                      ; D511
        lda  $0378                      ; D514
        sbc  #$00                       ; D517
        sta  $0378                      ; D519
loc_D51C:
        lda  cn_page                    ; D51C
        sta  $0123                      ; D51F
        lda  $0376                      ; D522
        sta  $0124                      ; D525
        lda  $0377                      ; D528
        sta  $0125                      ; D52B
        lda  $0378                      ; D52E
        sta  $0126                      ; D531
        lda  $0361                      ; D534
        sta  $0127                      ; D537
        lda  #$00                       ; D53A
        sta  $0128                      ; D53C
        sta  $0129                      ; D53F
        sta  $012A                      ; D542
        jsr  sub_CCAB                   ; D545
        lda  $012B                      ; D548
        clc                             ; D54B
        adc  #$01                       ; D54C
        sta  $0379                      ; D54E
        lda  $012C                      ; D551
        adc  #$00                       ; D554
        sta  $037A                      ; D556
        lda  $012D                      ; D559
        adc  #$00                       ; D55C
        sta  $037B                      ; D55E
        lda  $012E                      ; D561
        adc  #$00                       ; D564
        sta  $037C                      ; D566
        rts                             ; D569
sub_D56A:
        lda  #$FF                       ; D56A
        sta  $03C4                      ; D56C
        lda  cn_page                    ; D56F
        bne  loc_D5A7                   ; D572
        lda  $0376                      ; D574
        bne  loc_D5A7                   ; D577
        lda  $0377                      ; D579
        bne  loc_D5A7                   ; D57C
        lda  $0378                      ; D57E
        bne  loc_D5A7                   ; D581
        lda  $036D                      ; D583
        sta  cn_page                    ; D586
        lda  $036E                      ; D589
        sta  $0376                      ; D58C
        lda  $036F                      ; D58F
        sta  $0377                      ; D592
        lda  $0370                      ; D595
        sta  $0378                      ; D598
        lda  $0371                      ; D59B
        sec                             ; D59E
        sbc  #$01                       ; D59F
        sta  cn_row                     ; D5A1
        jmp  loc_D5D1                   ; D5A4
loc_D5A7:
        lda  cn_page                    ; D5A7
        sec                             ; D5AA
        sbc  #$01                       ; D5AB
        sta  cn_page                    ; D5AD
        lda  $0376                      ; D5B0
        sbc  #$00                       ; D5B3
        sta  $0376                      ; D5B5
        lda  $0377                      ; D5B8
        sbc  #$00                       ; D5BB
        sta  $0377                      ; D5BD
        lda  $0378                      ; D5C0
        sbc  #$00                       ; D5C3
        sta  $0378                      ; D5C5
        lda  $0361                      ; D5C8
        sec                             ; D5CB
        sbc  #$01                       ; D5CC
        sta  cn_row                     ; D5CE
loc_D5D1:
        lda  cn_page                    ; D5D1
        sta  $0123                      ; D5D4
        lda  $0376                      ; D5D7
        sta  $0124                      ; D5DA
        lda  $0377                      ; D5DD
        sta  $0125                      ; D5E0
        lda  $0378                      ; D5E3
        sta  $0126                      ; D5E6
        lda  $0361                      ; D5E9
        sta  $0127                      ; D5EC
        lda  #$00                       ; D5EF
        sta  $0128                      ; D5F1
        sta  $0129                      ; D5F4
        sta  $012A                      ; D5F7
        jsr  sub_CCAB                   ; D5FA
        lda  $012B                      ; D5FD
        clc                             ; D600
        adc  #$01                       ; D601
        sta  $0379                      ; D603
        lda  $012C                      ; D606
        adc  #$00                       ; D609
        sta  $037A                      ; D60B
        lda  $012D                      ; D60E
        adc  #$00                       ; D611
        sta  $037B                      ; D613
        lda  $012E                      ; D616
        adc  #$00                       ; D619
        sta  $037C                      ; D61B
        rts                             ; D61E
sub_D61F:
        lda  $0362                      ; D61F
        clc                             ; D622
        adc  #$01                       ; D623
        asl  a                          ; D625
        asl  a                          ; D626
        asl  a                          ; D627
        sta  $012F                      ; D628
        lda  cn_row                     ; D62B
        sta  $0130                      ; D62E
        jsr  sub_CD0A                   ; D631
        lda  $0131                      ; D634
        sta  $0174                      ; D637
        lda  $0364                      ; D63A
        asl  a                          ; D63D
        asl  a                          ; D63E
        asl  a                          ; D63F
        clc                             ; D640
        adc  $0174                      ; D641
        sta  $0174                      ; D644
        rts                             ; D647
load_list_header:
        lda  #$3A                       ; D648
        sta  prg8000_shadow             ; D64A
        sta  OB_PRG_8000                ; D64C
        lda  #$01                       ; D64F
        sta  $0379                      ; D651
        lda  #$00                       ; D654
        sta  $037A                      ; D656
        sta  $037B                      ; D659
        sta  $037C                      ; D65C
        sta  cn_page                    ; D65F
        sta  $0376                      ; D662
        sta  $0377                      ; D665
        sta  $0378                      ; D668
        lda  list_header_sel            ; D66B
        asl  a                          ; D66E
        asl  a                          ; D66F
        tay                             ; D670
        lda  dat_8114,y                 ; D671
        sta  state_tbl_ptr              ; D674
        lda  dat_8115,y                 ; D676
        sta  $B1                        ; D679
        ldy  #$00                       ; D67B
loc_D67D:
        lda  (state_tbl_ptr),y          ; D67D
        sta  $035D,y                    ; D67F
        iny                             ; D682
        cpy  #$10                       ; D683
        bne  loc_D67D                   ; D685
        jsr  count_list4_entries        ; D687
        jsr  count_list2_entries        ; D68A
        lda  $035D                      ; D68D
        sta  $0123                      ; D690
        lda  $035E                      ; D693
        sta  $0124                      ; D696
        lda  $035F                      ; D699
        sta  $0125                      ; D69C
        lda  $0360                      ; D69F
        sta  $0126                      ; D6A2
        lda  $0361                      ; D6A5
        sta  $0127                      ; D6A8
        lda  #$00                       ; D6AB
        sta  $0128                      ; D6AD
        sta  $0129                      ; D6B0
        sta  $012A                      ; D6B3
        jsr  sub_CC35                   ; D6B6
        lda  $012B                      ; D6B9
        bne  loc_D6F7                   ; D6BC
        lda  $012C                      ; D6BE
        bne  loc_D6F7                   ; D6C1
        lda  $012D                      ; D6C3
        bne  loc_D6F7                   ; D6C6
        lda  $012E                      ; D6C8
        bne  loc_D6F7                   ; D6CB
        sec                             ; D6CD
        lda  $0123                      ; D6CE
        sbc  #$01                       ; D6D1
        sta  $036D                      ; D6D3
        lda  $0124                      ; D6D6
        sbc  #$00                       ; D6D9
        sta  $036E                      ; D6DB
        lda  $0125                      ; D6DE
        sbc  #$00                       ; D6E1
        sta  $036F                      ; D6E3
        lda  $0126                      ; D6E6
        sbc  #$00                       ; D6E9
        sta  $0370                      ; D6EB
        lda  $0361                      ; D6EE
        sta  $0371                      ; D6F1
        jmp  loc_D715                   ; D6F4
loc_D6F7:
        ; static (not seen in traces)
        lda  $0123                      ; D6F7
        sta  $036D                      ; D6FA
        lda  $0124                      ; D6FD
        sta  $036E                      ; D700
        lda  $0125                      ; D703
        sta  $036F                      ; D706
        lda  $0126                      ; D709
        sta  $0370                      ; D70C
        lda  $012B                      ; D70F
        sta  $0371                      ; D712
loc_D715:
        jsr  sub_D719                   ; D715
        rts                             ; D718
sub_D719:
        lda  #$00                       ; D719
        sta  $0170                      ; D71B
        lda  $0363                      ; D71E
        sec                             ; D721
        sbc  #$02                       ; D722
        asl  a                          ; D724
        asl  a                          ; D725
        asl  a                          ; D726
        sta  $0176                      ; D727
        lda  $0364                      ; D72A
        asl  a                          ; D72D
        asl  a                          ; D72E
        asl  a                          ; D72F
        sta  $0174                      ; D730
        rts                             ; D733
sub_D734:
        ; static (not seen in traces)
        lda  $03C4                      ; D734
        bne  loc_D73A                   ; D737
        rts                             ; D739
loc_D73A:
        lda  #$3A                       ; D73A
        sta  prg8000_shadow             ; D73C
        sta  OB_PRG_8000                ; D73E
        jsr  sub_D8BE                   ; D741
        lda  cn_page                    ; D744
        sta  prng_state                 ; D747
        lda  $0376                      ; D74A
        sta  $011E                      ; D74D
loc_D750:
        jsr  sub_D97A                   ; D750
        jsr  sub_DAEE                   ; D753
        jsr  build_ascii_name_row       ; D756
        jsr  sub_D914                   ; D759
        jsr  sub_D879                   ; D75C
        inc  $03C2                      ; D75F
        lda  $03C2                      ; D762
        cmp  $03C1                      ; D765
        bcc  loc_D750                   ; D768
loc_D76A:
        lda  $03C2                      ; D76A
        cmp  $0361                      ; D76D
        beq  loc_D787                   ; D770
        jsr  sub_D914                   ; D772
        inc  $03C2                      ; D775
        lda  $015A                      ; D778
        clc                             ; D77B
        adc  $0362                      ; D77C
        adc  #$01                       ; D77F
        sta  $015A                      ; D781
        jmp  loc_D76A                   ; D784
loc_D787:
        lda  #$00                       ; D787
        sta  $03C4                      ; D789
        rts                             ; D78C
sub_D78D:
        lda  #$3A                       ; D78D
        sta  prg8000_shadow             ; D78F
        sta  OB_PRG_8000                ; D791
        lda  $03C4                      ; D794
        bne  sub_D79A                   ; D797
        rts                             ; D799
sub_D79A:
        jsr  sub_E312                   ; D79A
        jsr  sub_D8BE                   ; D79D
        lda  cn_page                    ; D7A0
        sta  prng_state                 ; D7A3
        lda  $0376                      ; D7A6
        sta  $011E                      ; D7A9
loc_D7AC:
        jsr  sub_D97A                   ; D7AC
        jsr  sub_DAEE                   ; D7AF
        jsr  sub_D7E9                   ; D7B2
        jsr  sub_D914                   ; D7B5
        jsr  sub_D879                   ; D7B8
        inc  $03C2                      ; D7BB
        lda  $03C2                      ; D7BE
        cmp  $03C1                      ; D7C1
        bcc  loc_D7AC                   ; D7C4
loc_D7C6:
        lda  $03C2                      ; D7C6
        cmp  $0361                      ; D7C9
        beq  loc_D7E3                   ; D7CC
        ; static (not seen in traces)
        jsr  sub_D914                   ; D7CE
        inc  $03C2                      ; D7D1
        lda  $015A                      ; D7D4
        clc                             ; D7D7
        adc  $0362                      ; D7D8
        adc  #$01                       ; D7DB
        sta  $015A                      ; D7DD
        jmp  loc_D7C6                   ; D7E0
loc_D7E3:
        lda  #$00                       ; D7E3
        sta  $03C4                      ; D7E5
        rts                             ; D7E8
sub_D7E9:
        lda  #$39                       ; D7E9
        sta  prg8000_shadow             ; D7EB
        sta  OB_PRG_8000                ; D7ED
        inc  $03BE                      ; D7F0
        lda  #$00                       ; D7F3
        sta  $03F9                      ; D7F5
        lda  cn_page                    ; D7F8
        bne  loc_D805                   ; D7FB
        lda  #$00                       ; D7FD
        sta  state_tbl_ptr              ; D7FF
        lda  #$80                       ; D801
        sta  $B1                        ; D803
loc_D805:
        nop                             ; D805
        nop                             ; D806
        nop                             ; D807
        nop                             ; D808
        nop                             ; D809
        nop                             ; D80A
        nop                             ; D80B
        nop                             ; D80C
        nop                             ; D80D
        nop                             ; D80E
        nop                             ; D80F
        nop                             ; D810
        nop                             ; D811
        nop                             ; D812
        nop                             ; D813
        nop                             ; D814
        nop                             ; D815
        nop                             ; D816
        nop                             ; D817
        nop                             ; D818
        nop                             ; D819
        nop                             ; D81A
        jsr  set_page_bg_chr            ; D81B
        nop                             ; D81E
        nop                             ; D81F
        nop                             ; D820
        clc                             ; D821
        adc  #$01                       ; D822
        sta  $1E                        ; D824
        lda  $03C2                      ; D826
        asl  a                          ; D829
        asl  a                          ; D82A
        clc                             ; D82B
        adc  state_tbl_ptr              ; D82C
        sta  state_tbl_ptr              ; D82E
        lda  $B1                        ; D830
        adc  #$00                       ; D832
        sta  $B1                        ; D834
        ldy  #$00                       ; D836
        lda  (state_tbl_ptr),y          ; D838
        sta  handler_ptr                ; D83A
        iny                             ; D83C
        lda  (state_tbl_ptr),y          ; D83D
        sta  $B3                        ; D83F
        lda  #$3B                       ; D841
        sta  prg8000_shadow             ; D843
        sta  OB_PRG_8000                ; D845
        ldy  #$00                       ; D848
        ldx  $03BE                      ; D84A
loc_D84D:
        lda  (handler_ptr),y            ; D84D
        clc                             ; D84F
        adc  #$40                       ; D850
        sta  $037E,x                    ; D852
        tya                             ; D855
        pha                             ; D856
        clc                             ; D857
        adc  #$10                       ; D858
        tay                             ; D85A
        lda  (handler_ptr),y            ; D85B
        clc                             ; D85D
        adc  #$40                       ; D85E
        sta  $039E,x                    ; D860
        pla                             ; D863
        tay                             ; D864
        iny                             ; D865
        cpy  #$0C                       ; D866
        bcs  loc_D871                   ; D868
        inx                             ; D86A
        inc  $03BE                      ; D86B
        jmp  loc_D84D                   ; D86E
loc_D871:
        lda  #$3A                       ; D871
        sta  prg8000_shadow             ; D873
        sta  OB_PRG_8000                ; D875
        rts                             ; D878
sub_D879:
        lda  $0379                      ; D879
        clc                             ; D87C
        adc  #$01                       ; D87D
        sta  $0379                      ; D87F
        lda  $037A                      ; D882
        adc  #$00                       ; D885
        sta  $037A                      ; D887
        lda  $037B                      ; D88A
        adc  #$00                       ; D88D
        sta  $037B                      ; D88F
        lda  $037C                      ; D892
        adc  #$00                       ; D895
        sta  $037C                      ; D897
        lda  $015A                      ; D89A
        clc                             ; D89D
        adc  $0362                      ; D89E
        adc  #$01                       ; D8A1
        sta  $015A                      ; D8A3
        lda  #$00                       ; D8A6
        sta  $03BE                      ; D8A8
        sta  $03C0                      ; D8AB
        ldx  #$00                       ; D8AE
        lda  #$00                       ; D8B0
loc_D8B2:
        sta  $037E,x                    ; D8B2
        sta  $039E,x                    ; D8B5
        inx                             ; D8B8
        cpx  #$20                       ; D8B9
        bne  loc_D8B2                   ; D8BB
        rts                             ; D8BD
sub_D8BE:
        ldx  #$00                       ; D8BE
        lda  #$FF                       ; D8C0
loc_D8C2:
        sta  $03C5,x                    ; D8C2
        sta  $03DE,x                    ; D8C5
        inx                             ; D8C8
        cpx  #$19                       ; D8C9
        bne  loc_D8C2                   ; D8CB
        lda  $0363                      ; D8CD
        sta  $015B                      ; D8D0
        lda  $0364                      ; D8D3
        sta  $015A                      ; D8D6
        lda  #$00                       ; D8D9
        sta  $03BE                      ; D8DB
        sta  $03C0                      ; D8DE
        sta  $03C2                      ; D8E1
sub_D8E4:
        lda  cn_page                    ; D8E4
        cmp  $036D                      ; D8E7
        bne  loc_D90D                   ; D8EA
        ; static (not seen in traces)
        lda  $0376                      ; D8EC
        cmp  $036E                      ; D8EF
        bne  loc_D90D                   ; D8F2
        lda  $0377                      ; D8F4
        cmp  $036F                      ; D8F7
        bne  loc_D90D                   ; D8FA
        lda  $0378                      ; D8FC
        cmp  $0370                      ; D8FF
        bne  loc_D90D                   ; D902
        lda  $0371                      ; D904
        sta  $03C1                      ; D907
        jmp  loc_D913                   ; D90A
loc_D90D:
        lda  $0361                      ; D90D
        sta  $03C1                      ; D910
loc_D913:
        rts                             ; D913
sub_D914:
        lda  #$16                       ; D914
        sta  $015D                      ; D916
        lda  #$02                       ; D919
        sta  $015E                      ; D91B
        lda  #$7E                       ; D91E
        sta  $AE                        ; D920
        lda  #$03                       ; D922
        sta  $AF                        ; D924
        lda  #$00                       ; D926
        sta  $015C                      ; D928
        jsr  sub_DF3F                   ; D92B
        rts                             ; D92E
        .byte $A9,$00,$8D,$75,$00,$AD,$5A,$01,$0A,$2E,$75,$00,$0A,$2E,$75,$00 ; D92F
        .byte $0A,$2E,$75,$00,$0A,$2E,$75,$00,$0A,$2E,$75,$00,$18,$6D,$63,$03 ; D93F
        .byte $85,$B8,$AD,$75,$00,$69,$04,$85,$B9,$A5,$B8,$18,$69,$20,$85,$BA ; D94F
        .byte $A5,$B9,$69,$00,$85,$BB,$A0,$00,$A2,$00,$BD,$7E,$03,$91,$B8,$BD ; D95F
        .byte $9E,$03,$91,$BA,$E8,$C8,$C0,$16,$90,$F0,$60 ; D96F
sub_D97A:
        lda  $0379                      ; D97A
        sta  $0123                      ; D97D
        lda  $037A                      ; D980
        sta  $0124                      ; D983
        lda  $037B                      ; D986
        sta  $0125                      ; D989
        lda  $037C                      ; D98C
        sta  $0126                      ; D98F
        lda  #$00                       ; D992
        sta  $0127                      ; D994
        lda  #$E1                       ; D997
        sta  $0128                      ; D999
        lda  #$F5                       ; D99C
        sta  $0129                      ; D99E
        lda  #$05                       ; D9A1
        sta  $012A                      ; D9A3
loc_D9A6:
        jsr  sub_CC35                   ; D9A6
        lda  $0123                      ; D9A9
        clc                             ; D9AC
        adc  #$10                       ; D9AD
        tay                             ; D9AF
        lda  $03FA,y                    ; D9B0
        ldx  $03BE                      ; D9B3
        sta  $037E,x                    ; D9B6
        lda  $043A,y                    ; D9B9
        sta  $039E,x                    ; D9BC
        lda  $0123                      ; D9BF
        beq  loc_D9CF                   ; D9C2
        lda  #$FF                       ; D9C4
        sta  $03C0                      ; D9C6
        inc  $03BE                      ; D9C9
        jmp  loc_D9D7                   ; D9CC
loc_D9CF:
        lda  $03C0                      ; D9CF
        beq  loc_D9D7                   ; D9D2
        inc  $03BE                      ; D9D4
loc_D9D7:
        lda  $012B                      ; D9D7
        pha                             ; D9DA
        lda  $012C                      ; D9DB
        pha                             ; D9DE
        lda  $012D                      ; D9DF
        pha                             ; D9E2
        lda  $012E                      ; D9E3
        pha                             ; D9E6
        lda  $0127                      ; D9E7
        sta  $0123                      ; D9EA
        lda  $0128                      ; D9ED
        sta  $0124                      ; D9F0
        lda  $0129                      ; D9F3
        sta  $0125                      ; D9F6
        lda  $012A                      ; D9F9
        sta  $0126                      ; D9FC
        lda  #$0A                       ; D9FF
        sta  $0127                      ; DA01
        lda  #$00                       ; DA04
        sta  $0128                      ; DA06
        sta  $0129                      ; DA09
        sta  $012A                      ; DA0C
        jsr  sub_CC35                   ; DA0F
        lda  $0123                      ; DA12
        sta  $0127                      ; DA15
        lda  $0124                      ; DA18
        sta  $0128                      ; DA1B
        lda  $0125                      ; DA1E
        sta  $0129                      ; DA21
        lda  $0126                      ; DA24
        sta  $012A                      ; DA27
        pla                             ; DA2A
        sta  $0126                      ; DA2B
        pla                             ; DA2E
        sta  $0125                      ; DA2F
        pla                             ; DA32
        sta  $0124                      ; DA33
        pla                             ; DA36
        sta  $0123                      ; DA37
        lda  $0127                      ; DA3A
        bne  loc_DA51                   ; DA3D
        lda  $0128                      ; DA3F
        bne  loc_DA51                   ; DA42
        lda  $0129                      ; DA44
        bne  loc_DA51                   ; DA47
        lda  $012A                      ; DA49
        bne  loc_DA51                   ; DA4C
        jmp  loc_DA54                   ; DA4E
loc_DA51:
        jmp  loc_D9A6                   ; DA51
loc_DA54:
        rts                             ; DA54
count_list4_entries:
        lda  list4_ptr_lo               ; DA55
        sta  state_tbl_ptr              ; DA58
        lda  list4_ptr_hi               ; DA5A
        sta  $B1                        ; DA5D
        ldy  #$00                       ; DA5F
        sty  list4_count_lo             ; DA61
loc_DA64:
        ldy  #$00                       ; DA64
        lda  (state_tbl_ptr),y          ; DA66
        cmp  #$FF                       ; DA68
        bne  loc_DA77                   ; DA6A
        iny                             ; DA6C
        lda  (state_tbl_ptr),y          ; DA6D
        dey                             ; DA6F
        cmp  #$FF                       ; DA70
        bne  loc_DA77                   ; DA72
        jmp  loc_DA98                   ; DA74
loc_DA77:
        lda  state_tbl_ptr              ; DA77
        clc                             ; DA79
        adc  #$04                       ; DA7A
        sta  state_tbl_ptr              ; DA7C
        lda  $B1                        ; DA7E
        adc  #$00                       ; DA80
        sta  $B1                        ; DA82
        lda  list4_count_lo             ; DA84
        clc                             ; DA87
        adc  #$01                       ; DA88
        sta  list4_count_lo             ; DA8A
        lda  list4_count_hi             ; DA8D
        adc  #$00                       ; DA90
        sta  list4_count_hi             ; DA92
        jmp  loc_DA64                   ; DA95
loc_DA98:
        rts                             ; DA98
count_list2_entries:
        lda  $0369                      ; DA99
        sta  state_tbl_ptr              ; DA9C
        lda  $036A                      ; DA9E
        sta  $B1                        ; DAA1
        ldy  #$00                       ; DAA3
        sty  $0374                      ; DAA5
loc_DAA8:
        lda  (state_tbl_ptr),y          ; DAA8
        cmp  #$FF                       ; DAAA
        bne  loc_DAB9                   ; DAAC
        iny                             ; DAAE
        lda  (state_tbl_ptr),y          ; DAAF
        dey                             ; DAB1
        cmp  #$FF                       ; DAB2
        bne  loc_DAB9                   ; DAB4
        jmp  loc_DAC1                   ; DAB6
loc_DAB9:
        ; static (not seen in traces)
        iny                             ; DAB9
        iny                             ; DABA
        inc  $0374                      ; DABB
        jmp  loc_DAA8                   ; DABE
loc_DAC1:
        rts                             ; DAC1
pick_random_unused_entry:
        ; static (not seen in traces)
        jsr  jt_prng_step               ; DAC2
        lda  list4_count_hi             ; DAC5
        bne  loc_DAD2                   ; DAC8
        lda  prng_state                 ; DACA
        cmp  list4_count_lo             ; DACD
        bcs  pick_random_unused_entry   ; DAD0
loc_DAD2:
        ldx  #$00                       ; DAD2
loc_DAD4:
        lda  $03C5,x                    ; DAD4
        cmp  #$FF                       ; DAD7
        beq  loc_DAE4                   ; DAD9
        cmp  prng_state                 ; DADB
        beq  pick_random_unused_entry   ; DADE
        inx                             ; DAE0
        jmp  loc_DAD4                   ; DAE1
loc_DAE4:
        lda  prng_state                 ; DAE4
        sta  $03C5,x                    ; DAE7
        lda  prng_state                 ; DAEA
        rts                             ; DAED
sub_DAEE:
        ldx  $03BE                      ; DAEE
        lda  $0408                      ; DAF1
        sta  $037E,x                    ; DAF4
        lda  $0448                      ; DAF7
        sta  $039E,x                    ; DAFA
        rts                             ; DAFD
build_ascii_name_row:
        ; static (not seen in traces)
        inc  $03BE                      ; DAFE
        lda  list4_ptr_lo               ; DB01
        sta  state_tbl_ptr              ; DB04
        lda  list4_ptr_hi               ; DB06
        sta  $B1                        ; DB09
        lda  $0379                      ; DB0B
        sec                             ; DB0E
        sbc  #$01                       ; DB0F
        sta  $0135                      ; DB11
        lda  $037A                      ; DB14
        sbc  #$00                       ; DB17
        sta  $0136                      ; DB19
        lda  $037B                      ; DB1C
        sbc  #$00                       ; DB1F
        sta  $0137                      ; DB21
        lda  $037C                      ; DB24
        sbc  #$00                       ; DB27
        sta  $0138                      ; DB29
        lda  $0136                      ; DB2C
        cmp  $036C                      ; DB2F
        bcc  loc_DB54                   ; DB32
        beq  loc_DB38                   ; DB34
        bcs  loc_DB40                   ; DB36
loc_DB38:
        lda  $0135                      ; DB38
        cmp  $036B                      ; DB3B
        bcc  loc_DB54                   ; DB3E
loc_DB40:
        jsr  pick_random_unused_entry   ; DB40
        ldx  $03C2                      ; DB43
        sta  $03C5,x                    ; DB46
        lda  #$00                       ; DB49
        sta  $0139,x                    ; DB4B
        sta  $03F9                      ; DB4E
        jmp  loc_DB66                   ; DB51
loc_DB54:
        ldx  $03C2                      ; DB54
        lda  $0136                      ; DB57
        sta  $0139,x                    ; DB5A
        sta  $03F9                      ; DB5D
        lda  $0135                      ; DB60
        sta  $03C5,x                    ; DB63
loc_DB66:
        lda  $03C5,x                    ; DB66
        sta  $03F8                      ; DB69
        asl  $03F8                      ; DB6C
        rol  $03F9                      ; DB6F
        asl  $03F8                      ; DB72
        rol  $03F9                      ; DB75
        lda  state_tbl_ptr              ; DB78
        clc                             ; DB7A
        adc  $03F8                      ; DB7B
        sta  state_tbl_ptr              ; DB7E
        lda  $B1                        ; DB80
        adc  $03F9                      ; DB82
        sta  $B1                        ; DB85
        ldy  #$00                       ; DB87
        lda  (state_tbl_ptr),y          ; DB89
        sta  handler_ptr                ; DB8B
        iny                             ; DB8D
        lda  (state_tbl_ptr),y          ; DB8E
        sta  $B3                        ; DB90
        ldy  #$00                       ; DB92
        ldx  $03BE                      ; DB94
loc_DB97:
        cpy  #$16                       ; DB97
        bcs  loc_DBBF                   ; DB99
        lda  (handler_ptr),y            ; DB9B
        cmp  #$FF                       ; DB9D
        beq  loc_DBBF                   ; DB9F
        sec                             ; DBA1
        sbc  #$20                       ; DBA2
        sty  $037D                      ; DBA4
        tay                             ; DBA7
        lda  $03FA,y                    ; DBA8
        sta  $037E,x                    ; DBAB
        lda  $043A,y                    ; DBAE
        sta  $039E,x                    ; DBB1
        ldy  $037D                      ; DBB4
        iny                             ; DBB7
        inx                             ; DBB8
        inc  $03BE                      ; DBB9
        jmp  loc_DB97                   ; DBBC
loc_DBBF:
        rts                             ; DBBF
        .byte $60,$60 ; DBC0
step0_exit_launch:
        ; static (not seen in traces)
        jsr  sub_DBD6                   ; DBC2
        jsr  launch_ptr_from_ascii_entry; DBC5
        jsr  launch_selected_game       ; DBC8
        rts                             ; DBCB
step1_exit_launch:
        jsr  sub_DBD6                   ; DBCC
        jsr  launch_ptr_skip_to_stub    ; DBCF
        jsr  launch_selected_game       ; DBD2
        rts                             ; DBD5
sub_DBD6:
        lda  #$00                       ; DBD6
        sta  PPU_CTRL                   ; DBD8
        sta  PPU_MASK                   ; DBDB
        sta  ppu_ctrl_shadow            ; DBDE
        sta  ppu_mask_shadow            ; DBE0
        sta  APU_STATUS                 ; DBE2
        sta  JOY1                       ; DBE5
        sta  APU_4000                   ; DBE8
        sta  APU_4001                   ; DBEB
        sta  APU_4002                   ; DBEE
        sta  APU_4003                   ; DBF1
        sta  APU_4004                   ; DBF4
        sta  APU_4005                   ; DBF7
        sta  APU_4006                   ; DBFA
        sta  APU_4007                   ; DBFD
        sta  APU_4008                   ; DC00
        sta  APU_4009                   ; DC03
        sta  APU_400A                   ; DC06
        sta  APU_400B                   ; DC09
        sta  APU_400C                   ; DC0C
        sta  APU_400D                   ; DC0F
        sta  APU_400E                   ; DC12
        sta  APU_400F                   ; DC15
        ldy  #$20                       ; DC18
        sty  PPU_ADDR                   ; DC1A
        lda  #$00                       ; DC1D
        sta  PPU_ADDR                   ; DC1F
        ldx  #$00                       ; DC22
loc_DC24:
        sta  PPU_DATA                   ; DC24
        inx                             ; DC27
        bne  loc_DC24                   ; DC28
        iny                             ; DC2A
        cpy  #$40                       ; DC2B
        bne  loc_DC24                   ; DC2D
        ldx  #$3F                       ; DC2F
        stx  PPU_ADDR                   ; DC31
        ldx  #$00                       ; DC34
        stx  PPU_ADDR                   ; DC36
        lda  #$0F                       ; DC39
loc_DC3B:
        sta  PPU_DATA                   ; DC3B
        inx                             ; DC3E
        cpx  #$20                       ; DC3F
        bne  loc_DC3B                   ; DC41
        lda  #$00                       ; DC43
        sta  PPU_CTRL                   ; DC45
        sta  APU_STATUS                 ; DC48
        lda  #$00                       ; DC4B
        tax                             ; DC4D
loc_DC4E:
        sta  $0200,x                    ; DC4E
        sta  $0400,x                    ; DC51
        sta  $0500,x                    ; DC54
        sta  $0600,x                    ; DC57
        sta  $0700,x                    ; DC5A
        inx                             ; DC5D
        bne  loc_DC4E                   ; DC5E
        lda  #$00                       ; DC60
        sta  OAM_ADDR                   ; DC62
        sta  REG_4034                   ; DC65
        lda  #$02                       ; DC68
        sta  OAM_DMA                    ; DC6A
        lda  #$00                       ; DC6D
        sta  OB_CHR_2012                ; DC6F
        clc                             ; DC72
        adc  #$01                       ; DC73
        sta  OB_CHR_2013                ; DC75
        adc  #$01                       ; DC78
        sta  OB_CHR_2014                ; DC7A
        adc  #$01                       ; DC7D
        sta  OB_CHR_2015                ; DC7F
        lda  #$04                       ; DC82
        sta  OB_CHR_2016                ; DC84
        clc                             ; DC87
        adc  #$02                       ; DC88
        sta  OB_CHR_2017                ; DC8A
        rts                             ; DC8D
launch_ptr_from_ascii_entry:
        lda  #$3A                       ; DC8E
        sta  prg8000_shadow             ; DC90
        sta  OB_PRG_8000                ; DC92
        lda  list_header_sel            ; DC95
        asl  a                          ; DC98
        tay                             ; DC99
        lda  dat_8110,y                 ; DC9A
        sta  state_tbl_ptr              ; DC9D
        lda  dat_8111,y                 ; DC9F
        sta  $B1                        ; DCA2
        ldx  cn_row                     ; DCA4
        lda  $03C5,x                    ; DCA7
        sta  $03F8                      ; DCAA
        lda  $0139,x                    ; DCAD
        sta  $03F9                      ; DCB0
        asl  $03F8                      ; DCB3
        rol  $03F9                      ; DCB6
        asl  $03F8                      ; DCB9
        rol  $03F9                      ; DCBC
        lda  state_tbl_ptr              ; DCBF
        clc                             ; DCC1
        adc  $03F8                      ; DCC2
        sta  state_tbl_ptr              ; DCC5
        lda  $B1                        ; DCC7
        adc  $03F9                      ; DCC9
        sta  $B1                        ; DCCC
        ldy  #$02                       ; DCCE
        lda  (state_tbl_ptr),y          ; DCD0
        sta  $03F8                      ; DCD2
        iny                             ; DCD5
        lda  (state_tbl_ptr),y          ; DCD6
        sta  $03F9                      ; DCD8
        asl  $03F8                      ; DCDB
        rol  $03F9                      ; DCDE
        lda  $03F8                      ; DCE1
        clc                             ; DCE4
        adc  #$C3                       ; DCE5
        sta  handler_ptr                ; DCE7
        lda  #$86                       ; DCE9
        adc  $03F9                      ; DCEB
        sta  $B3                        ; DCEE
        rts                             ; DCF0
launch_ptr_skip_to_stub:
        jmp  loc_DDBA                   ; DCF1
        .byte $08,$8D,$07,$41,$AD,$F7,$03,$0A,$A8,$B9,$10,$81,$85,$B6,$B9,$11 ; DCF4
        .byte $81,$85,$B7,$A9,$00,$8D,$1B,$01,$AD,$75,$03,$8D,$11,$01,$A9,$00 ; DD04
        .byte $8D,$12,$01,$AD,$61,$03,$8D,$15,$01,$A9,$00,$8D,$16,$01,$20,$A1 ; DD14
        .byte $CA,$AD,$0D,$01,$18,$6D,$C3,$03,$48,$AD,$0E,$01,$69,$00,$8D,$1B ; DD24
        .byte $01,$68,$0A,$2E,$1B,$01,$0A,$2E,$1B,$01,$18,$65,$B6,$85,$B0,$AD ; DD34
        .byte $1B,$01,$65,$B7,$85,$B1,$A0,$02,$B1,$B0,$8D,$1B,$01,$C8,$B1,$B0 ; DD44
        .byte $8D,$1C,$01,$0E,$1B,$01,$2E,$1C,$01,$AD,$1B,$01,$69,$C3,$85,$B2 ; DD54
        .byte $AD,$1C,$01,$69,$86,$85,$B3,$60 ; DD64
launch_selected_game:
        ; static (not seen in traces)
        lda  #$38                       ; DD6C
        sta  prg8000_shadow             ; DD6E
        sta  OB_PRG_8000                ; DD70
        ldy  #$00                       ; DD73
        lda  (handler_ptr),y            ; DD75
        sta  $B6                        ; DD77
        iny                             ; DD79
        lda  (handler_ptr),y            ; DD7A
        sta  $B7                        ; DD7C
        ldy  #$00                       ; DD7E
loc_DD80:
        lda  ($B6),y                    ; DD80
        sta  $0400,y                    ; DD82
        iny                             ; DD85
        cpy  #$08                       ; DD86
        bcc  loc_DD80                   ; DD88
        lda  ($B6),y                    ; DD8A
        sta  handler_ptr                ; DD8C
        iny                             ; DD8E
        lda  ($B6),y                    ; DD8F
        sta  $B3                        ; DD91
        iny                             ; DD93
        lda  ($B6),y                    ; DD94
        pha                             ; DD96
        iny                             ; DD97
        lda  ($B6),y                    ; DD98
        pha                             ; DD9A
        iny                             ; DD9B
        lda  ($B6),y                    ; DD9C
        ldy  #$00                       ; DD9E
        sta  (handler_ptr),y            ; DDA0
        sty  ppu_ctrl_shadow            ; DDA2
        lda  #$00                       ; DDA4
        tax                             ; DDA6
loc_DDA7:
        sta  $0300,x                    ; DDA7
        inx                             ; DDAA
        bne  loc_DDA7                   ; DDAB
        ldy  #$00                       ; DDAD
loc_DDAF:
        lda  dat_launch_0100_init,y     ; DDAF
        sta  $0100,y                    ; DDB2
        iny                             ; DDB5
        cpy  #$10                       ; DDB6
        bcc  loc_DDAF                   ; DDB8
loc_DDBA:
        ldy  #$00                       ; DDBA
loc_DDBC:
        lda  ram_stub_launch_0408,y     ; DDBC
        sta  $0408,y                    ; DDBF
        iny                             ; DDC2
        cpy  #$DA                       ; DDC3
        bcc  loc_DDBC                   ; DDC5
        bit  chr_regs_reset_code        ; DDC7
        lda  #$00                       ; DDCA
        sta  OB_VIDEO_2010              ; DDCC
        sta  REG_4103                   ; DDCF
        jmp  $0408                      ; DDD2
chr_regs_reset_code:
        lda  #$00                       ; DDD5
        sta  OB_CHR_2016                ; DDD7
        lda  #$02                       ; DDDA
        sta  OB_CHR_2017                ; DDDC
        lda  #$04                       ; DDDF
        sta  OB_CHR_2012                ; DDE1
        lda  #$05                       ; DDE4
        sta  OB_CHR_2013                ; DDE6
        lda  #$06                       ; DDE9
        sta  OB_CHR_2014                ; DDEB
        lda  #$07                       ; DDEE
        sta  OB_CHR_2015                ; DDF0
        lda  #$00                       ; DDF3
        sta  MMC3_BANK_SELECT           ; DDF5
        lda  #$00                       ; DDF8
        sta  MMC3_BANK_DATA             ; DDFA
        lda  #$01                       ; DDFD
        sta  MMC3_BANK_SELECT           ; DDFF
        lda  #$02                       ; DE02
        sta  MMC3_BANK_DATA             ; DE04
        lda  #$02                       ; DE07
        sta  MMC3_BANK_SELECT           ; DE09
        lda  #$04                       ; DE0C
        sta  MMC3_BANK_DATA             ; DE0E
        lda  #$03                       ; DE11
        sta  MMC3_BANK_SELECT           ; DE13
        lda  #$05                       ; DE16
        sta  MMC3_BANK_DATA             ; DE18
        lda  #$04                       ; DE1B
        sta  MMC3_BANK_SELECT           ; DE1D
        lda  #$06                       ; DE20
        sta  MMC3_BANK_DATA             ; DE22
        lda  #$05                       ; DE25
        sta  MMC3_BANK_SELECT           ; DE27
        lda  #$07                       ; DE2A
        sta  MMC3_BANK_DATA             ; DE2C
        rts                             ; DE2F
        .byte $EA,$EA,$14,$1C,$04,$0C ; DE30
dat_launch_0100_init:
        .byte $00,$02,$00,$01,$80,$00,$40,$00,$20,$00,$10,$00,$08,$00,$04,$00 ; DE36
        .byte $00,$02,$00,$01,$80,$00,$00,$00,$40,$00,$20,$00,$10,$00,$00,$00 ; DE46
        .byte $64,$74,$9C,$9E,$3A,$1A ; DE56
; ---- RAM stub: copied to $0408 (218 bytes) by launch_selected_game; only the first part runs: it maps the English block and jumps to $AAB1 there
ram_stub_launch_0408:
        ; static (not seen in traces)
        lda  #$04                       ; DE5C
        sta  OB_PRG_MODE_410B           ; DE5E
        ldx  #$3C                       ; DE61
        stx  OB_PRG_8000                ; DE63
        inx                             ; DE66
        stx  OB_PRG_A000                ; DE67
        inx                             ; DE6A
        stx  OB_PRG_C000                ; DE6B
        inx                             ; DE6E
        stx  OB_PRG_E000                ; DE6F
        jmp  $AAB1                      ; DE72 ; -> English bank $3D: launch_from_chinese_menu ($AAB1, file 0x7AAB1)
        .byte $18,$AD,$75,$03,$C9,$20,$90,$04,$A9,$01,$85,$19,$A9,$04,$8D,$0B ; DE75
        .byte $41,$A9,$36,$8D,$09,$41,$A9,$37,$8D,$0A,$41,$4C,$2C,$E8,$07,$04 ; DE85
        .byte $C9,$20,$90,$06,$38,$E9,$20,$C8,$D0,$F6,$8D,$07,$04,$4E,$05,$04 ; DE95
        .byte $6E,$04,$04,$AD,$05,$04,$0A,$0A,$0A,$0A,$8D,$12,$01,$AD,$00,$04 ; DEA5
        .byte $C9,$05,$B0,$18,$AE,$04,$04,$8E,$07,$41,$E8,$8E,$08,$41,$E8,$8E ; DEB5
        .byte $09,$41,$E8,$8E,$0A,$41,$E0,$00,$D0,$12,$F0,$10,$AE,$04,$04,$8E ; DEC5
        .byte $07,$41,$8E,$09,$41,$E8,$8E,$08,$41,$8E,$0A,$41,$A0,$00,$AD,$07 ; DED5
        .byte $04,$C9,$02,$90,$06,$38,$E9,$02,$C8,$D0,$F6,$8D,$07,$04,$98,$0D ; DEE5
        .byte $12,$01,$8D,$00,$41,$A0,$00,$AD,$07,$04,$D0,$07,$AD,$06,$04,$C9 ; DEF5
        .byte $40,$90,$14,$AD,$06,$04,$38,$E9,$40,$8D,$06,$04,$AD,$07,$04,$E9 ; DF05
        .byte $00,$8D,$07,$04,$C8,$D0,$E0,$98,$0A,$0A,$0A,$0A,$8D,$18,$20,$0E ; DF15
        .byte $06,$04,$0E,$06,$04,$AD,$06,$04,$0D,$11,$01,$8D,$1A,$20,$6C,$FC ; DF25
        .byte $FF,$60 ; DF35
sub_DF37:
        ; static (not seen in traces)
        lda  #$04                       ; DF37
        sta  sound_id                   ; DF39
        jsr  sound_play                 ; DF3B
        rts                             ; DF3E
sub_DF3F:
        tya                             ; DF3F
        pha                             ; DF40
        txa                             ; DF41
        pha                             ; DF42
        lda  $015D                      ; DF43
        sta  $0152                      ; DF46
        iny                             ; DF49
        lda  $015E                      ; DF4A
        sta  $0153                      ; DF4D
        lda  $015A                      ; DF50
        asl  a                          ; DF53
        sta  $0154                      ; DF54
        lsr  a                          ; DF57
        lsr  a                          ; DF58
        lsr  a                          ; DF59
        lsr  a                          ; DF5A
        clc                             ; DF5B
        adc  $0134                      ; DF5C
        sta  $0155                      ; DF5F
        lda  $0154                      ; DF62
        asl  a                          ; DF65
        asl  a                          ; DF66
        asl  a                          ; DF67
        asl  a                          ; DF68
        clc                             ; DF69
        adc  $015B                      ; DF6A
        sta  $0156                      ; DF6D
        clc                             ; DF70
        lda  #$00                       ; DF71
        sta  $0157                      ; DF73
        lda  #$00                       ; DF76
        sta  $0158                      ; DF78
        lda  #$90                       ; DF7B
        sta  nmi_hook_ptr               ; DF7D
        lda  #$DF                       ; DF7F
        sta  $25                        ; DF81
        lda  #$01                       ; DF83
        sta  nmi_hook_mode              ; DF85
loc_DF87:
        lda  nmi_hook_mode              ; DF87
        bne  loc_DF87                   ; DF89
        pla                             ; DF8B
        tax                             ; DF8C
        pla                             ; DF8D
        tay                             ; DF8E
        rts                             ; DF8F
        tya                             ; DF90
        pha                             ; DF91
        txa                             ; DF92
        pha                             ; DF93
        ldy  $0158                      ; DF94
        ldx  $0157                      ; DF97
        lda  #$00                       ; DF9A
        sta  $0159                      ; DF9C
        clc                             ; DF9F
        lda  $0156                      ; DFA0
        adc  $0158                      ; DFA3
        sta  $0154                      ; DFA6
        lda  $0155                      ; DFA9
        adc  #$00                       ; DFAC
        sta  PPU_ADDR                   ; DFAE
        lda  $0154                      ; DFB1
        sta  PPU_ADDR                   ; DFB4
loc_DFB7:
        clc                             ; DFB7
        lda  ($AE),y                    ; DFB8
        adc  $015C                      ; DFBA
        sta  PPU_DATA                   ; DFBD
        iny                             ; DFC0
        inc  $0159                      ; DFC1
        lda  $0159                      ; DFC4
        cmp  #$20                       ; DFC7
        .byte $F0,$3A                   ; DFC9  beq loc_E005 (bank $1F: a branch into the next segment, written as bytes for ca65)
        cpy  $0152                      ; DFCB
        bne  loc_DFB7                   ; DFCE
        inx                             ; DFD0
        cpx  $0153                      ; DFD1
        .byte $F0,$64                   ; DFD4  beq loc_E03A (bank $1F: a branch into the next segment, written as bytes for ca65)
        clc                             ; DFD6
        lda  $0156                      ; DFD7
        adc  #$20                       ; DFDA
        sta  $0156                      ; DFDC
        lda  $0155                      ; DFDF
        adc  #$00                       ; DFE2
        sta  $0155                      ; DFE4
        sta  PPU_ADDR                   ; DFE7
        lda  $0156                      ; DFEA
        sta  PPU_ADDR                   ; DFED
        clc                             ; DFF0
        lda  $AE                        ; DFF1
        adc  $0152                      ; DFF3
        adc  #$0A                       ; DFF6
        sta  $AE                        ; DFF8
        lda  $AF                        ; DFFA
        adc  #$00                       ; DFFC
        sta  $AF                        ; DFFE
