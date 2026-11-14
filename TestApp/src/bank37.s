; Sup 400-in-1 language select + test app, 8 KiB PRG bank $37 (file 0x6E000), mapped at CPU $E000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK37"

langsel_entry:
        sei                             ; E000
        cld                             ; E001
        lda  PPU_STATUS                 ; E002
        ldx  #$FF                       ; E005
        txs                             ; E007
        lda  #$00                       ; E008
        sta  PPU_CTRL                   ; E00A
        tay                             ; E00D
loc_E00E:
        sta  $0100,y                    ; E00E
        iny                             ; E011
        bne  loc_E00E                   ; E012
        jsr  langsel_init_e387          ; E014
        jsr  sound_init                 ; E017
        jsr  langsel_install_nmi_06A0   ; E01A
        lda  #$10                       ; E01D
        sta  OB_CHR_2018                ; E01F
        lda  #$9E                       ; E022
        sta  OB_CHR_201A                ; E024
        lda  #$00                       ; E027
        sta  $C0                        ; E029
        ldx  #$00                       ; E02B
        jsr  langsel_draw_screen        ; E02D
        jsr  langsel_wait_vblank        ; E030
langsel_loop:
        jsr  langsel_wait_frame_read_pad; E033
        lda  langsel_pad_new            ; E036
        and  #$0C                       ; E038
        beq  loc_E045                   ; E03A
        lda  langsel_cursor             ; E03C
        eor  #$01                       ; E03E
        sta  langsel_cursor             ; E040
        jsr  langsel_move_cursor        ; E042
loc_E045:
        lda  langsel_pad_new            ; E045
        and  #$10                       ; E047
        beq  langsel_loop               ; E049
        lda  langsel_cursor             ; E04B
        bne  loc_E068                   ; E04D
        lda  #$00                       ; E04F
        sta  PPU_CTRL                   ; E051
        sta  PPU_MASK                   ; E054
        ldx  #$60                       ; E057
loc_E059:
        lda  ram_stub_start_chinese,x   ; E059
        sta  $0400,x                    ; E05C
        dex                             ; E05F
        bpl  loc_E059                   ; E060
        bit  dat_EAA0                   ; E062
        jmp  $0400                      ; E065
loc_E068:
        jmp  langsel_start_english      ; E068
        .byte $A9,$01,$8D,$0B,$41,$A9,$1E,$8D,$09,$41,$A9,$1F,$8D,$0A,$41,$A9 ; E06B
        .byte $00,$8D,$18,$20,$A9,$00,$8D,$1A,$20,$6C,$FC,$FF,$EA ; E07B
langsel_start_english:
        lda  #$00                       ; E088
        sta  PPU_CTRL                   ; E08A
        sta  PPU_MASK                   ; E08D
        ldx  #$20                       ; E090
loc_E092:
        lda  ram_stub_start_english,x   ; E092
        sta  $0400,x                    ; E095
        dex                             ; E098
        bpl  loc_E092                   ; E099
        jmp  $0400                      ; E09B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$49 ; E09E
        .byte $E0 ; E0AE
sub_E0AF:
        stx  PPU_ADDR                   ; E0AF
        ldx  #$00                       ; E0B2
        stx  PPU_ADDR                   ; E0B4
        ldx  #$20                       ; E0B7
loc_E0B9:
        ldy  #$20                       ; E0B9
loc_E0BB:
        sta  PPU_DATA                   ; E0BB
        dey                             ; E0BE
        bne  loc_E0BB                   ; E0BF
        dex                             ; E0C1
        bne  loc_E0B9                   ; E0C2
        rts                             ; E0C4
langsel_move_cursor:
        jsr  sub_E6C0                   ; E0C5
        lda  #$C7                       ; E0C8
        sta  $0201                      ; E0CA
        lda  #$D7                       ; E0CD
        sta  $0205                      ; E0CF
        lda  #$00                       ; E0D2
        sta  $0202                      ; E0D4
        sta  $0206                      ; E0D7
        jsr  sub_E6D8                   ; E0DA
        rts                             ; E0DD
        .byte $EA,$EA,$20,$41,$E1,$A9,$00,$85,$08,$A9,$E1,$85,$09,$A0,$00,$A9 ; E0DE
        .byte $10,$A2,$10,$20,$FD,$E1,$A9,$0F,$8D,$15,$40,$60,$FF,$FF,$FF,$FF ; E0EE
        .byte $FF,$60,$0E,$11,$02,$02,$0F,$20,$15,$30,$05,$20,$30,$20,$0F,$0F ; E0FE
        .byte $15,$20,$60,$FF,$FF,$FF,$FF ; E10E
langsel_nmi:
        pha                             ; E115
        txa                             ; E116
        pha                             ; E117
        tya                             ; E118
        pha                             ; E119
        inc  $1E                        ; E11A
        lda  #$00                       ; E11C
        jsr  langsel_nmi_sub            ; E11E
        lda  #$00                       ; E121
        sta  OAM_ADDR                   ; E123
        lda  #$02                       ; E126
        sta  OAM_DMA                    ; E128
        inc  $24                        ; E12B
        bit  loc_F000                   ; E12D
        jsr  sound_tick                 ; E130
        pla                             ; E133
        tay                             ; E134
        pla                             ; E135
        tax                             ; E136
        pla                             ; E137
        rti                             ; E138
        .byte $EA,$EA,$68,$A8,$68,$AA,$68,$40,$A9,$00,$8D,$00,$20,$8D,$01,$20 ; E139
        .byte $AD,$02,$20,$30,$FB,$AD,$02,$20,$10,$FB,$60 ; E149
langsel_wait_vblank:
        lda  #$00                       ; E154
        sta  PPU_SCROLL                 ; E156
        sta  PPU_SCROLL                 ; E159
        nop                             ; E15C
        nop                             ; E15D
        lda  #$98                       ; E15E
        sta  PPU_CTRL                   ; E160
        lda  #$1E                       ; E163
        jsr  langsel_eef0_regs          ; E165
        rts                             ; E168
sub_E169:
        lda  #$00                       ; E169
        clc                             ; E16B
        lda  #$20                       ; E16C
        sta  PPU_ADDR                   ; E16E
        lda  #$00                       ; E171
        sta  PPU_ADDR                   ; E173
        tay                             ; E176
        tax                             ; E177
loc_E178:
        lda  ($08),y                    ; E178
        beq  loc_E1AA                   ; E17A
        cmp  #$80                       ; E17C
        bcc  loc_E196                   ; E17E
        lda  #$7F                       ; E180
        and  ($08),y                    ; E182
        tax                             ; E184
        jsr  sub_E1B3                   ; E185
        lda  ($08),y                    ; E188
loc_E18A:
        sta  PPU_DATA                   ; E18A
        dex                             ; E18D
        bne  loc_E18A                   ; E18E
        jsr  sub_E1B3                   ; E190
        jmp  loc_E1A7                   ; E193
loc_E196:
        lda  ($08),y                    ; E196
        tax                             ; E198
loc_E199:
        jsr  sub_E1B3                   ; E199
        lda  ($08),y                    ; E19C
        sta  PPU_DATA                   ; E19E
        dex                             ; E1A1
        bne  loc_E199                   ; E1A2
        jsr  sub_E1B3                   ; E1A4
loc_E1A7:
        jmp  loc_E178                   ; E1A7
loc_E1AA:
        lda  #$00                       ; E1AA
        sta  PPU_ADDR                   ; E1AC
        sta  PPU_ADDR                   ; E1AF
        rts                             ; E1B2
sub_E1B3:
        iny                             ; E1B3
        bne  loc_E1B8                   ; E1B4
        inc  $09                        ; E1B6
loc_E1B8:
        rts                             ; E1B8
langsel_draw_screen:
        ldy  #$00                       ; E1B9
        sty  PPU_CTRL                   ; E1BB
        sty  PPU_MASK                   ; E1BE
        txa                             ; E1C1
        asl  a                          ; E1C2
        tax                             ; E1C3
        pha                             ; E1C4
        lda  dat_E6B0,x                 ; E1C5
        sta  $08                        ; E1C8
        lda  dat_E6B1,x                 ; E1CA
        sta  $09                        ; E1CD
loc_E1CF:
        lda  PPU_STATUS                 ; E1CF
        bpl  loc_E1CF                   ; E1D2
loc_E1D4:
        lda  PPU_STATUS                 ; E1D4
        bmi  loc_E1D4                   ; E1D7
        nop                             ; E1D9
        lda  #$00                       ; E1DA
        ldy  #$02                       ; E1DC
        ldx  #$20                       ; E1DE
        jsr  sub_E620                   ; E1E0
        ldy  #$00                       ; E1E3
        lda  ($08),y                    ; E1E5
        pha                             ; E1E7
        iny                             ; E1E8
        lda  ($08),y                    ; E1E9
        sta  $09                        ; E1EB
        pla                             ; E1ED
        sta  $08                        ; E1EE
        pla                             ; E1F0
        jsr  sub_E169                   ; E1F1
        rts                             ; E1F4
        .byte $00,$20,$30,$40,$50,$FF,$FF,$FF ; E1F5
sub_E1FD:
        pha                             ; E1FD
        lda  #$3F                       ; E1FE
        sta  PPU_ADDR                   ; E200
        pla                             ; E203
        sta  PPU_ADDR                   ; E204
loc_E207:
        lda  ($08),y                    ; E207
        sta  PPU_DATA                   ; E209
        iny                             ; E20C
        dex                             ; E20D
        bne  loc_E207                   ; E20E
        rts                             ; E210
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E211
        .byte $00,$97,$00,$04,$01,$02,$03,$04,$9C,$00,$04,$05,$06,$07,$08,$8F ; E221
        .byte $00,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$84,$0B,$02,$11,$12,$92 ; E231
        .byte $00,$08,$13,$0B,$14,$15,$16,$17,$18,$19,$82,$0B,$04,$1A,$1B,$1C ; E241
        .byte $1D,$92,$00,$07,$13,$1E,$1F,$20,$21,$22,$23,$82,$0B,$05,$24,$25 ; E251
        .byte $26,$27,$28,$92,$00,$04,$13,$29,$2A,$2B,$82,$2C,$08,$2D,$2E,$0B ; E261
        .byte $2F,$30,$31,$32,$33,$92,$00,$0E,$34,$35,$36,$37,$38,$39,$00,$3A ; E271
        .byte $3B,$3C,$3D,$3E,$3F,$1D,$92,$00,$0A,$40,$41,$42,$43,$44,$0B,$45 ; E281
        .byte $46,$47,$48,$83,$2C,$01,$49,$92,$00,$09,$13,$0B,$4A,$4B,$4C,$4D ; E291
        .byte $4E,$4F,$00,$83,$50,$02,$51,$1D,$92,$00,$05,$13,$52,$53,$54,$55 ; E2A1
        .byte $82,$52,$07,$56,$00,$57,$58,$52,$59,$1D,$92,$00,$01,$13,$82,$5A ; E2B1
        .byte $02,$5B,$5C,$82,$5A,$01,$5D,$84,$00,$02,$06,$1D,$92,$00,$05,$13 ; E2C1
        .byte $5E,$5F,$60,$61,$82,$5F,$01,$62,$84,$00,$02,$06,$1D,$92,$00,$05 ; E2D1
        .byte $13,$63,$2C,$64,$65,$82,$2C,$01,$66,$84,$00,$02,$67,$1D,$92,$00 ; E2E1
        .byte $0E,$68,$69,$6A,$6B,$6C,$69,$6D,$6E,$00,$6F,$70,$71,$72,$1D,$92 ; E2F1
        .byte $00,$0A,$73,$74,$75,$76,$77,$78,$79,$76,$7A,$7B,$82,$76,$02,$7C ; E301
        .byte $7D,$C6,$00,$02,$7E,$7F,$83,$00,$08,$80,$81,$82,$83,$84,$85,$86 ; E311
        .byte $87,$82,$78,$13,$88,$89,$8A,$80,$8B,$8C,$8D,$84,$85,$8E,$8F,$90 ; E321
        .byte $91,$92,$93,$78,$94,$95,$96,$83,$00,$1B,$97,$98,$99,$9A,$9B,$9C ; E331
        .byte $9D,$9E,$9F,$A0,$00,$91,$A1,$97,$A2,$A3,$00,$9B,$A4,$9D,$0B,$A5 ; E341
        .byte $A6,$9B,$9C,$A7,$A8,$85,$00,$1B,$91,$A1,$A9,$AA,$99,$9A,$9B,$9C ; E351
        .byte $AB,$AC,$AD ; E361
langsel_nmi_sub:
        ldx  #$01                       ; E364
        stx  JOY1                       ; E366
        dex                             ; E369
        stx  JOY1                       ; E36A
        ldx  #$08                       ; E36D
loc_E36F:
        lda  JOY1                       ; E36F
        lsr  a                          ; E372
        rol  $23                        ; E373
        dex                             ; E375
        bne  loc_E36F                   ; E376
        lda  $23                        ; E378
        tay                             ; E37A
        eor  $22                        ; E37B
        and  $23                        ; E37D
        sta  $23                        ; E37F
        sty  $22                        ; E381
        rts                             ; E383
        .byte $E6,$22,$60 ; E384
langsel_init_e387:
        jsr  sub_E418                   ; E387
        ldx  #$20                       ; E38A
        lda  #$00                       ; E38C
        jsr  sub_E0AF                   ; E38E
        lda  #$00                       ; E391
        jsr  sub_E9E0                   ; E393
        jsr  langsel_move_cursor        ; E396
        rts                             ; E399
        .byte $CD,$CE,$CC,$CF,$CB,$82,$CC,$01,$D0,$82,$CC,$0C,$D1,$D2,$D3,$D4 ; E39A
        .byte $CE,$CC,$00,$EC,$0F,$01,$1B,$20,$0F,$05,$16,$27,$0F,$08,$1A,$28 ; E3AA
        .byte $0F,$13,$20,$30,$0F,$02,$25,$25,$0F,$15,$29,$09,$0F,$02,$20,$31 ; E3BA
        .byte $0F,$00,$30,$01,$99,$D0,$00,$E8,$C8,$C0,$06,$D0,$F4,$60,$A5,$1C ; E3CA
        .byte $85,$56,$A5,$1D,$85,$57,$A5,$1F,$85,$60,$60,$FF,$FF,$FF,$FF,$FF ; E3DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF ; E3EA
sub_E3F1:
        lda  #$F8                       ; E3F1
        ldy  #$00                       ; E3F3
loc_E3F5:
        sta  $0200,y                    ; E3F5
        iny                             ; E3F8
        bne  loc_E3F5                   ; E3F9
        rts                             ; E3FB
sub_E3FC:
        lda  #$00                       ; E3FC
        tay                             ; E3FE
loc_E3FF:
        sta  a:$0000,y                  ; E3FF
        sta  $0300,y                    ; E402
        sta  $0400,y                    ; E405
        sta  $0500,y                    ; E408
        sta  $0600,y                    ; E40B
        sta  $0700,y                    ; E40E
        iny                             ; E411
        bne  loc_E3FF                   ; E412
        rts                             ; E414
        .byte $FF,$FF,$FF ; E415
sub_E418:
        jsr  sub_E3FC                   ; E418
        jsr  sub_E3F1                   ; E41B
        jsr  langsel_click_sfx          ; E41E
        jsr  sub_EBE0                   ; E421
        rts                             ; E424
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$96,$98,$40,$42 ; E425
        .byte $0F,$A0,$86,$01,$10,$27,$00,$E8,$03,$00,$64,$00,$00,$0A,$00,$00 ; E435
        .byte $FF,$FF,$FF,$85,$12,$E4,$10,$F0,$10,$86,$10,$8A,$C9,$0D,$90,$06 ; E445
        .byte $38,$E9,$0E,$4C,$51,$E4,$4C,$9B,$E0,$4C,$A6,$E0,$A9,$01,$85,$13 ; E455
        .byte $4C,$A6,$E4,$A9,$01,$85,$13,$4C,$CB,$E4,$A9,$02,$85,$13,$4C,$24 ; E465
        .byte $E5,$A9,$02,$85,$13,$A5,$18,$D0,$14,$A5,$19,$D0,$10,$A5,$17,$D0 ; E475
        .byte $0C,$A5,$D2,$85,$18,$A5,$D1,$85,$19,$A5,$D0,$85,$17,$A5,$18,$38 ; E485
        .byte $E9,$01,$85,$18,$A5,$19,$E9,$00,$85,$19,$A5,$17,$E9,$00,$85,$17 ; E495
        .byte $60,$E6,$18,$D0,$06,$E6,$19,$D0,$02,$E6,$17,$A2,$00,$A5,$17,$C5 ; E4A5
        .byte $D0,$90,$12,$A5,$19,$C5,$D1,$90,$0C,$A5,$18,$C5,$D2,$90,$06,$86 ; E4B5
        .byte $18,$86,$19,$86,$17,$60,$18,$A5,$18,$69,$08,$85,$18,$A5,$19,$69 ; E4C5
        .byte $00,$85,$19,$A5,$17,$69,$00,$85,$17,$A5,$17,$C5,$D0,$90,$35,$D0 ; E4D5
        .byte $0E,$A5,$19,$C5,$D1,$90,$2D,$D0,$06,$A5,$18,$C5,$D2,$90,$25,$38 ; E4E5
        .byte $A5,$18,$E5,$D2,$85,$18,$A5,$18,$C5,$D4,$90,$0C,$A9,$00,$85,$18 ; E4F5
        .byte $85,$19,$85,$17,$F0,$0E,$EA,$EA,$A5,$D3,$85,$18,$A5,$D1,$85,$19 ; E505
        .byte $A5,$D0,$85,$17,$A9,$00,$85,$24,$A5,$24,$C9,$08,$D0,$FA,$60,$38 ; E515
        .byte $A5,$18,$E9,$08,$85,$18,$A5,$19,$E9,$00,$85,$19,$EA,$EA,$A5,$17 ; E525
        .byte $E9,$00,$85,$17,$B0,$25,$18,$A5,$18,$65,$D2,$85,$18,$A5,$19,$65 ; E535
        .byte $D1,$85,$19,$A5,$17,$65,$D0,$85,$17,$A5,$18,$C5,$D4,$90,$0C,$A5 ; E545
        .byte $D3,$85,$18,$A5,$D1,$85,$19,$A5,$D0,$85,$17,$A9,$00,$85,$24,$A5 ; E555
        .byte $24,$C9,$08,$D0,$FA,$60,$FF,$FF,$FF,$FF,$FF,$A5,$13,$F0,$53,$C9 ; E565
        .byte $01,$D0,$16,$18,$A5,$14,$69,$08,$85,$14,$A5,$15,$69,$00,$85,$15 ; E575
        .byte $A5,$16,$69,$00,$85,$16,$4C,$B1,$E5,$38,$A5,$14,$E9,$08,$85,$14 ; E585
        .byte $A5,$15,$E9,$00,$85,$15,$A5,$16,$E9,$00,$85,$16,$B0,$2C,$A5,$D0 ; E595
        .byte $85,$16,$A5,$D1,$85,$15,$A5,$D3,$85,$14,$D0,$1E,$A5,$16,$C5,$D0 ; E5A5
        .byte $90,$18,$D0,$0E,$A5,$15,$C5,$D1,$90,$10,$D0,$06,$A5,$14,$C5,$D2 ; E5B5
        .byte $90,$08,$A9,$00,$85,$14,$85,$15,$85,$16,$60,$A9,$00,$85,$C0,$A2 ; E5C5
        .byte $00,$20,$B9,$E1,$EA,$20,$54,$E1,$A9,$00,$85,$24,$A5,$24,$C9,$06 ; E5D5
        .byte $D0,$FA,$A5,$22,$A0,$00,$84,$22,$A8,$29,$10,$D0,$03,$4C,$DD,$E5 ; E5E5
        .byte $60,$FF,$FF,$FF,$FF,$A9,$21,$8D,$06,$20,$20,$00,$EE,$A0,$00,$A6 ; E5F5
        .byte $D5,$BD,$F5,$E1,$85,$00,$A9,$C6,$85,$01,$B1,$00,$C9,$FF,$F0,$06 ; E605
        .byte $8D,$07,$20,$C8,$D0,$F4,$60,$FF,$FF,$FF,$FF ; E615
sub_E620:
        lda  $C0                        ; E620
        bne  loc_E628                   ; E622
        jsr  sub_E1FD                   ; E624
        rts                             ; E627
loc_E628:
        ; static (not seen in traces)
        jsr  sub_EB00                   ; E628
        rts                             ; E62B
        .byte $FF ; E62C
langsel_wait_frame_read_pad:
        lda  #$00                       ; E62D
        sta  $24                        ; E62F
loc_E631:
        lda  $24                        ; E631
        cmp  #$0C                       ; E633
        bne  loc_E631                   ; E635
        lda  $22                        ; E637
        ldy  #$00                       ; E639
        sty  $22                        ; E63B
        tay                             ; E63D
        and  #$1C                       ; E63E
        bne  loc_E645                   ; E640
        jmp  langsel_wait_frame_read_pad; E642
loc_E645:
        sty  langsel_pad_new            ; E645
        rts                             ; E647
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$02,$03,$09,$F0,$13,$18,$F0 ; E648
        .byte $02,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$A5,$56,$38,$F9,$30,$E4,$48,$A5 ; E658
        .byte $57,$F9,$31,$E4,$EA,$EA,$48,$A5,$60,$F9,$32,$E4,$90,$0D,$85,$60 ; E668
        .byte $68,$85,$57,$68,$85,$56,$F6,$58,$4C,$60,$E6,$68,$68,$60,$98,$48 ; E678
        .byte $8A,$48,$A0,$00,$A2,$00,$A9,$01,$95,$58,$20,$60,$E6,$C8,$C8,$C8 ; E688
        .byte $E8,$E0,$07,$D0,$F1,$A5,$56,$18,$69,$01,$95,$58,$68,$AA,$68,$A8 ; E698
        .byte $60,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6A8
dat_E6B0:
        .byte $AC ; E6B0
dat_E6B1:
        .byte $E3,$B8,$E6,$FF,$FF,$FF,$FF,$00,$EC,$FF,$FF,$FF,$FF,$FF,$FF ; E6B1
sub_E6C0:
        lda  langsel_cursor             ; E6C0
        tax                             ; E6C2
        lda  dat_E6CD,x                 ; E6C3
        sta  $0200                      ; E6C6
        sta  $0204                      ; E6C9
        rts                             ; E6CC
dat_E6CD:
        .byte $34,$44,$FF,$A9,$63,$8D,$00,$41,$A9,$00,$8D ; E6CD
sub_E6D8:
        lda  #$40                       ; E6D8
        sta  $0203                      ; E6DA
        lda  #$48                       ; E6DD
        sta  $0207                      ; E6DF
        rts                             ; E6E2
        .byte $FF ; E6E3
; ---- RAM stub: copied to $0400 (33 bytes) when $C1=1: start the English menu
ram_stub_start_english:
        ; static (not seen in traces)
        lda  #$04                       ; E6E4
        sta  OB_PRG_MODE_410B           ; E6E6
        ldx  #$3C                       ; E6E9
        stx  OB_PRG_8000                ; E6EB
        inx                             ; E6EE
        stx  OB_PRG_A000                ; E6EF
        inx                             ; E6F2
        stx  OB_PRG_C000                ; E6F3
        inx                             ; E6F6
        stx  OB_PRG_E000                ; E6F7
        jmp  $FB7D                      ; E6FA ; -> English block english_menu_entry ($FB7D, file 0x7FB7D)
        .byte $FF,$FF,$FF,$FF,$00,$97,$00,$04,$01,$02,$03,$04,$9C,$00,$04,$05 ; E6FD
        .byte $06,$07,$08,$8F,$00,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$84,$0B ; E70D
        .byte $02,$11,$12,$92,$00,$08,$13,$0B,$14,$15,$16,$17,$18,$19,$82,$0B ; E71D
        .byte $04,$1A,$1B,$1C,$1D,$92,$00,$07,$13,$1E,$1F,$20,$21,$22,$23,$82 ; E72D
        .byte $0B,$05,$24,$25,$26,$27,$28,$92,$00,$04,$13,$29,$2A,$2B,$82,$2C ; E73D
        .byte $08,$2D,$2E,$0B,$2F,$30,$31,$32,$33,$92,$00,$0E,$34,$35,$36,$37 ; E74D
        .byte $38,$39,$00,$3A,$3B,$3C,$3D,$3E,$3F,$1D,$92,$00,$0A,$40,$41,$42 ; E75D
        .byte $43,$44,$0B,$45,$46,$47,$48,$83,$2C,$01,$49,$92,$00,$09,$13,$0B ; E76D
        .byte $4A,$4B,$4C,$4D,$4E,$4F,$00,$83,$50,$02,$51,$1D,$92,$00,$05,$13 ; E77D
        .byte $52,$53,$54,$55,$82,$52,$07,$56,$00,$57,$58,$52,$59,$1D,$92,$00 ; E78D
        .byte $01,$13,$82,$5A,$02,$5B,$5C,$82,$5A,$01,$5D,$84,$00,$02,$06,$1D ; E79D
        .byte $92,$00,$05,$13,$5E,$5F,$60,$61,$82,$5F,$01,$62,$84,$00,$02,$06 ; E7AD
        .byte $1D,$92,$00,$05,$13,$63,$2C,$64,$65,$82,$2C,$01,$66,$84,$00,$02 ; E7BD
        .byte $67,$1D,$92,$00,$0E,$68,$69,$6A,$6B,$6C,$69,$6D,$6E,$00,$6F,$70 ; E7CD
        .byte $71,$72,$1D,$92,$00,$0A,$73,$74,$75,$76,$77,$78,$79,$76,$7A,$7B ; E7DD
        .byte $82,$76,$02,$7C,$7D,$C6,$00,$02,$7E,$7F,$83,$00,$08,$80,$81,$82 ; E7ED
        .byte $83,$84,$85,$86,$87,$82,$78,$13,$88,$89,$8A,$80,$8B,$8C,$8D,$84 ; E7FD
        .byte $85,$8E,$8F,$90,$91,$92,$93,$78,$94,$95,$96,$83,$00,$1B,$97,$98 ; E80D
        .byte $99,$9A,$9B,$9C,$9D,$9E,$9F,$A0,$00,$91,$A1,$97,$A2,$A3,$00,$9B ; E81D
        .byte $A4,$9D,$0B,$A5,$A6,$9B,$9C,$A7,$A8,$85,$00,$1B,$91,$A1,$A9,$AA ; E82D
        .byte $99,$9A,$9B,$9C,$AB,$AC,$AD,$A6,$00,$91,$AE,$AF,$00,$99,$B0,$B1 ; E83D
        .byte $B2,$B3,$B4,$99,$9A,$B5,$B6,$84,$00,$1C,$AD,$B7,$50,$B8,$B9,$BA ; E84D
        .byte $BB,$BC,$BD,$BE,$B6,$BF,$C0,$C1,$A6,$C2,$C3,$C4,$BA,$C5,$C6,$B0 ; E85D
        .byte $C7,$8B,$C8,$C9,$CA,$98,$84,$00,$01,$CB,$82,$CC,$05,$CD,$CE,$CC ; E86D
        .byte $CF,$CB,$82,$CC,$01,$D0,$82,$CC,$0C,$D1,$D2,$D3,$D4,$CE,$CC,$D5 ; E87D
        .byte $D6,$D7,$D8,$D0,$CE,$82,$CC,$01,$D9,$FF,$00,$C4,$00,$00,$AD,$34 ; E88D
        .byte $04,$8D,$11,$50,$AD,$31,$04,$8D,$12,$50,$A9,$C0,$8D,$17,$40,$6C ; E89D
        .byte $FC,$FF,$FF,$48,$A6,$D5,$BD,$BC,$E8,$85,$50,$68,$18,$65,$50,$60 ; E8AD
        .byte $0E,$0E,$17,$17,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E8BD
        .byte $FF,$FF,$FF,$A6,$D5,$BD,$D7,$E8,$85,$09,$60,$43,$43,$43,$43,$FF ; E8CD
        .byte $A6,$D5,$BD,$E8,$E8,$8D,$03,$02,$8D,$07,$02,$60,$08,$08,$FF,$FF ; E8DD
        .byte $FF,$FF,$FF,$48,$A9,$06,$8D,$00,$80,$68,$0A,$8D,$01,$80,$48,$A9 ; E8ED
        .byte $07,$8D,$00,$80,$68,$09,$01,$8D,$01,$80,$60,$FF,$FF,$FF,$FF,$FF ; E8FD
        .byte $FF,$FF,$FF,$8D,$07,$20,$60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E90D
        .byte $FF,$FF,$FF,$FF,$EA,$4C,$40,$E9,$68,$29,$0F,$EA,$4C,$30,$E9,$EA ; E91D
        .byte $EA,$EA,$EA,$48,$A9,$00,$8D,$00,$A0,$68,$EA,$4C,$50,$E9,$FF,$FF ; E92D
        .byte $FF,$FF,$FF,$48,$A9,$01,$8D,$00,$A0,$68,$EA,$4C,$50,$E9,$FF,$FF ; E93D
        .byte $FF,$FF,$FF,$60,$32,$60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E94D
        .byte $FF,$FF,$FF,$00,$01,$2C,$28,$04,$01,$00,$00,$00,$00,$4C,$40,$03 ; E95D
        .byte $02,$00,$00,$00,$00,$58,$50,$07,$03,$00,$00,$00,$00,$80,$70,$0F ; E96D
        .byte $04,$00,$00,$A2,$06,$8E,$00,$80,$AD,$D3,$04,$8D,$01,$80,$A2,$07 ; E97D
        .byte $8E,$00,$80,$AD,$D4,$04,$8D,$01,$80,$60,$FF,$FF,$FF,$FF,$FF,$FF ; E98D
        .byte $FF,$FF,$FF,$48,$4A,$4A,$4A,$4A,$20,$80,$E9,$68,$48,$29,$80,$F0 ; E99D
        .byte $07,$68,$29,$1F,$EA,$4C,$D0,$E9,$68,$29,$1F,$EA,$4C,$C0,$E9,$EA ; E9AD
        .byte $EA,$EA,$EA,$48,$A9,$00,$8D,$00,$A0,$68,$EA,$4C,$E0,$E9,$FF,$FF ; E9BD
        .byte $FF,$FF,$FF,$48,$A9,$01,$8D,$00,$A0,$68,$EA,$4C,$E0,$E9,$FF,$FF ; E9CD
        .byte $FF,$FF,$FF ; E9DD
sub_E9E0:
        nop                             ; E9E0
        asl  a                          ; E9E1
        asl  a                          ; E9E2
        asl  a                          ; E9E3
        ldx  #$00                       ; E9E4
loc_E9E6:
        stx  MMC3_BANK_SELECT           ; E9E6
        sta  MMC3_BANK_DATA             ; E9E9
        clc                             ; E9EC
        adc  #$02                       ; E9ED
        inx                             ; E9EF
        cpx  #$02                       ; E9F0
        bne  loc_E9E6                   ; E9F2
        clc                             ; E9F4
        ldx  #$02                       ; E9F5
loc_E9F7:
        stx  MMC3_BANK_SELECT           ; E9F7
        sta  MMC3_BANK_DATA             ; E9FA
        adc  #$01                       ; E9FD
        inx                             ; E9FF
        cpx  #$06                       ; EA00
        bne  loc_E9F7                   ; EA02
        rts                             ; EA04
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$A2,$08,$8E,$00,$80 ; EA05
        .byte $AD,$D5,$04,$8D,$01,$80,$60,$A2,$09,$8E,$00,$80,$AD,$D6,$04,$8D ; EA15
        .byte $01,$80,$60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AD,$D0,$04,$8D,$0B ; EA25
        .byte $41,$A2,$00,$BD,$D3,$04,$09,$40,$9D,$07,$41,$E8,$E0,$04,$D0,$F3 ; EA35
        .byte $6C,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$20,$A0,$EF,$A9,$00 ; EA45
        .byte $0A,$0A,$0A,$AA,$A0,$00,$BD,$60,$E9,$99,$D0,$00,$E8,$C8,$C0,$06 ; EA55
        .byte $D0,$F4,$60,$A5,$1C,$85,$56,$A5,$1D,$85,$57,$A5,$1F,$85,$60,$60 ; EA65
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EA75
langsel_click_sfx:
        lda  #$0F                       ; EA80
        sta  APU_STATUS                 ; EA82
        lda  #$8F                       ; EA85
        sta  APU_4000                   ; EA87
        lda  #$AA                       ; EA8A
        sta  APU_4001                   ; EA8C
        sta  APU_4002                   ; EA8F
        lda  #$80                       ; EA92
        sta  APU_4003                   ; EA94
        rts                             ; EA97
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EA98
dat_EAA0:
        .byte $A2,$00,$BD,$00,$CE,$9D,$80,$04,$E8,$E0,$0F,$D0,$F5,$20,$80,$04 ; EAA0
        .byte $20,$A0,$EE,$60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EAB0
langsel_install_nmi_06A0:
        lda  #$4C                       ; EAC0
        sta  nmi_jmp_06A0               ; EAC2
        lda  #$15                       ; EAC5
        sta  nmi_jmp_06A1               ; EAC7
        lda  #$E1                       ; EACA
        sta  nmi_jmp_06A2               ; EACC
        rts                             ; EACF
        .byte $FF,$FF,$FF,$80,$09,$01,$8D,$01,$80,$60,$FF,$FF,$FF,$FF,$FF,$FF ; EAD0
        .byte $A2,$07,$BD,$00,$01,$95,$D8,$CA,$10,$F8,$20,$C0,$E6,$60,$FF,$FF ; EAE0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EAF0
sub_EB00:
        ; static (not seen in traces)
        jsr  sub_EB10                   ; EB00
        jsr  sub_EB55                   ; EB03
        rts                             ; EB06
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EB07
sub_EB10:
        ; static (not seen in traces)
        lda  #$D0                       ; EB10
        sta  $39                        ; EB12
        lda  #$00                       ; EB14
        sta  $38                        ; EB16
        lda  #$3F                       ; EB18
        sta  $3B                        ; EB1A
        lda  #$00                       ; EB1C
        sta  $3A                        ; EB1E
        jsr  sub_EB2B                   ; EB20
        lda  #$3F                       ; EB23
        sta  $3B                        ; EB25
        lda  #$80                       ; EB27
        sta  $3A                        ; EB29
sub_EB2B:
        ldx  #$04                       ; EB2B
loc_EB2D:
        ldy  #$00                       ; EB2D
        lda  $3B                        ; EB2F
        sta  PPU_ADDR                   ; EB31
        lda  $3A                        ; EB34
        sta  PPU_ADDR                   ; EB36
loc_EB39:
        lda  ($38),y                    ; EB39
        sta  PPU_DATA                   ; EB3B
        iny                             ; EB3E
        cpy  #$10                       ; EB3F
        bcc  loc_EB39                   ; EB41
        clc                             ; EB43
        lda  #$10                       ; EB44
        adc  $38                        ; EB46
        sta  $38                        ; EB48
        clc                             ; EB4A
        lda  #$20                       ; EB4B
        adc  $3A                        ; EB4D
        sta  $3A                        ; EB4F
        dex                             ; EB51
        bne  loc_EB2D                   ; EB52
        rts                             ; EB54
sub_EB55:
        lda  #$D0                       ; EB55
        sta  $39                        ; EB57
        lda  #$80                       ; EB59
        sta  $38                        ; EB5B
        lda  #$3F                       ; EB5D
        sta  $3B                        ; EB5F
        lda  #$10                       ; EB61
        sta  $3A                        ; EB63
        jsr  sub_EB2B                   ; EB65
        lda  #$3F                       ; EB68
        sta  $3B                        ; EB6A
        lda  #$90                       ; EB6C
        sta  $3A                        ; EB6E
        jsr  sub_EB2B                   ; EB70
        rts                             ; EB73
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$48,$8A,$48,$98 ; EB74
        .byte $48,$A9,$00,$8D,$00,$E0,$A9,$EE,$8D,$1A,$20,$A9,$60,$8D,$00,$C0 ; EB84
        .byte $8D,$01,$C0,$68,$A8,$68,$AA,$68,$40,$FF,$FF,$FF,$A9,$A0,$8D,$00 ; EB94
        .byte $C0,$8D,$01,$C0,$8D,$01,$E0,$60,$FF,$FF,$FF,$FF,$20,$80,$EA,$20 ; EBA4
        .byte $18,$E4,$60,$00,$0C,$60,$AA,$D0,$07,$AD,$01,$0C,$C9,$55,$F0,$01 ; EBB4
        .byte $60,$AD,$02,$0C,$85,$C1,$4C,$4B,$E0,$FF,$FF,$FF,$A5,$C1,$C5,$C2 ; EBC4
        .byte $F0,$07,$A5,$C1,$85,$C2,$20,$C5,$E0,$60,$FF,$FF ; EBD4
sub_EBE0:
        lda  #$4C                       ; EBE0
        sta  $A8                        ; EBE2
        lda  #$15                       ; EBE4
        sta  $A9                        ; EBE6
        lda  #$E1                       ; EBE8
        sta  $AA                        ; EBEA
        lda  #$01                       ; EBEC
        sta  $C2                        ; EBEE
        rts                             ; EBF0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EBF1
        .byte $00,$CB,$00,$0E,$C5,$00,$C8,$C9,$CA,$CB,$00,$A7,$A8,$A9,$AA,$AB ; EC01
        .byte $AC,$AB,$92,$00,$0E,$D5,$00,$D8,$D9,$DA,$DB,$00,$B2,$B3,$B4,$B5 ; EC11
        .byte $B6,$B7,$B6,$92,$00,$0E,$C6,$00,$CC,$CD,$CA,$CB,$00,$AB,$AA,$AD ; EC21
        .byte $AE,$A9,$AC,$AF,$92,$00,$0E,$D6,$00,$DC,$DD,$DA,$DB,$00,$B6,$B5 ; EC31
        .byte $B8,$B9,$B4,$B7,$BA,$CD,$00,$16,$E0,$E1,$E2,$E3,$00,$AC,$AB,$AE ; EC41
        .byte $AB,$A7,$C4,$00,$E4,$E5,$E6,$E7,$00,$AC,$C4,$A5,$A6,$C4,$8A,$00 ; EC51
        .byte $16,$F0,$F1,$F2,$F3,$00,$B7,$B6,$B9,$B6,$B2,$D4,$00,$F4,$F5,$F6 ; EC61
        .byte $F7,$00,$B7,$D4,$B0,$B1,$D4,$86,$00,$09,$01,$02,$01,$04,$01,$03 ; EC71
        .byte $00,$04,$01,$85,$00,$05,$02,$04,$01,$06,$07,$88,$00,$03,$04,$01 ; EC81
        .byte $04,$84,$01,$05,$03,$02,$04,$01,$04,$86,$00,$02,$05,$03,$82,$00 ; EC91
        .byte $03,$08,$09,$0A,$87,$00,$02,$02,$04,$85,$00,$83,$01,$0A,$0B,$0C ; ECA1
        .byte $0F,$00,$03,$00,$02,$01,$04,$01,$82,$00,$04,$10,$11,$14,$15,$82 ; ECB1
        .byte $00,$06,$03,$00,$04,$01,$04,$01,$84,$00,$84,$01,$02,$0D,$0E,$82 ; ECC1
        .byte $00,$04,$01,$04,$01,$03,$84,$00,$04,$12,$13,$16,$17,$82,$00,$04 ; ECD1
        .byte $01,$04,$02,$04,$89,$00,$09,$02,$18,$19,$1C,$1D,$03,$00,$02,$01 ; ECE1
        .byte $88,$00,$04,$02,$01,$04,$01,$8A,$00,$0A,$05,$03,$1A,$1B,$1E,$1F ; ECF1
        .byte $01,$04,$01,$03,$88,$00,$02,$01,$03,$88,$00,$03,$03,$00,$02,$83 ; ED01
        .byte $01,$06,$03,$00,$02,$01,$04,$01,$85,$00,$06,$02,$00,$01,$04,$01 ; ED11
        .byte $03,$84,$00,$01,$21,$84,$00,$04,$01,$04,$01,$03,$83,$01,$03,$04 ; ED21
        .byte $01,$03,$86,$00,$02,$05,$03,$82,$01,$08,$02,$04,$01,$04,$00,$20 ; ED31
        .byte $22,$23,$84,$00,$08,$04,$01,$02,$01,$04,$01,$04,$01,$87,$00,$83 ; ED41
        .byte $01,$04,$03,$00,$04,$01,$83,$00,$03,$24,$27,$28,$84,$00,$04,$02 ; ED51
        .byte $04,$01,$03,$8A,$00,$85,$01,$01,$04,$84,$00,$04,$25,$26,$29,$2A ; ED61
        .byte $84,$00,$04,$2B,$2C,$2F,$30,$87,$00,$01,$35,$84,$00,$02,$39,$3A ; ED71
        .byte $8E,$00,$06,$2D,$2E,$31,$32,$33,$34,$87,$00,$04,$36,$37,$38,$3B ; ED81
        .byte $8F,$00,$07,$3C,$3D,$3F,$40,$43,$44,$47,$82,$00,$02,$01,$03,$82 ; ED91
        .byte $00,$04,$49,$4B,$4C,$4F,$85,$00,$02,$04,$01,$85,$00,$02,$01,$03 ; EDA1
        .byte $82,$00,$07,$3E,$41,$42,$45,$46,$48,$00,$83,$01,$07,$04,$00,$4A ; EDB1
        .byte $4D,$4E,$50,$35,$84,$00,$02,$02,$04,$84,$00,$83,$01,$01,$04,$82 ; EDC1
        .byte $00,$06,$51,$52,$54,$55,$58,$59,$85,$00,$04,$5C,$5E,$5F,$60,$89 ; EDD1
        .byte $00,$04,$02,$01,$02,$01,$85,$00,$05,$53,$56,$57,$5A,$5B,$84,$00 ; EDE1
        .byte $02,$5D,$35,$8C,$00,$04,$01,$03,$01,$03,$8B,$00,$86,$F0,$82,$00 ; EDF1
        .byte $86,$FF,$82,$00,$82,$0F,$04,$4F,$8F,$2F,$0F,$82,$00,$05,$54,$11 ; EE01
        .byte $00,$08,$02,$85,$00,$04,$40,$81,$20,$FF,$82,$00,$05,$04,$11,$00 ; EE11
        .byte $08,$02,$88,$00,$02,$0D,$00,$00,$6F,$70,$72,$82,$16,$05,$74,$4E ; EE21
        .byte $40,$78,$54,$8B,$00,$82,$03,$07,$02,$03,$02,$04,$00,$6B,$6C,$83 ; EE31
        .byte $00,$08,$71,$73,$25,$16,$75,$76,$77,$79,$87,$00,$02,$7A,$7B,$82 ; EE41
        .byte $00,$07,$03,$02,$04,$03,$02,$01,$02,$86,$00,$0D,$7E,$80,$81,$83 ; EE51
        .byte $84,$87,$79,$89,$00,$01,$02,$01,$02,$82,$00,$02,$7C,$7D,$82,$00 ; EE61
        .byte $07,$02,$01,$02,$01,$03,$02,$04,$86,$00,$06,$7F,$82,$25,$85,$86 ; EE71
        .byte $88,$83,$00,$04,$02,$04,$02,$04,$97,$00,$01,$55,$88,$00,$04,$AA ; EE81
        .byte $00,$F0,$30,$86,$00,$02,$0F,$03,$86,$00,$02,$80,$20,$8C,$00,$00 ; EE91
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EEA1
; ---- RAM stub: copied to $0400 (97 bytes) when $C1=0: start the Chinese menu
ram_stub_start_chinese:
        ; static (not seen in traces)
        lda  #$01                       ; EEB0
        sta  OB_PRG_MODE_410B           ; EEB2
        ldx  #$1C                       ; EEB5
        stx  OB_PRG_8000                ; EEB7
        inx                             ; EEBA
        stx  OB_PRG_A000                ; EEBB
        inx                             ; EEBE
        stx  OB_PRG_C000                ; EEBF
        inx                             ; EEC2
        stx  OB_PRG_E000                ; EEC3
        lda  #$00                       ; EEC6
        sta  OB_CHR_2018                ; EEC8
        sta  OB_CHR_201A                ; EECB
        jmp  ($FFFC)                    ; EECE ; -> reset vector of the Chinese block after the switch ($F9EE)
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EED1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EEE1
langsel_eef0_regs:
        lda  #$1E                       ; EEF0
        sta  PPU_MASK                   ; EEF2
        ldy  #$06                       ; EEF5
loc_EEF7:
        lda  $1E                        ; EEF7
loc_EEF9:
        cmp  $1E                        ; EEF9
        beq  loc_EEF9                   ; EEFB
        dey                             ; EEFD
        bne  loc_EEF7                   ; EEFE
        nop                             ; EF00
        nop                             ; EF01
        nop                             ; EF02
        nop                             ; EF03
        lda  #$1F                       ; EF04
        sta  REG_413F                   ; EF06
        lda  #$0B                       ; EF09
        sta  REG_4138                   ; EF0B
        lda  #$0F                       ; EF0E
        sta  REG_4139                   ; EF10
        rts                             ; EF13
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$4C,$55,$EF,$4C ; EF14
        .byte $26,$EF ; EF24
sound_tick:
        jsr  sfx_tick                   ; EF26
        jsr  music_tick                 ; EF29
        rts                             ; EF2C
sound_play:
        ; static (not seen in traces)
        tya                             ; EF2D
        pha                             ; EF2E
        txa                             ; EF2F
        pha                             ; EF30
        lda  $DB                        ; EF31
        asl  a                          ; EF33
        tax                             ; EF34
        lda  tbl_sfx_ptrs,x             ; EF35
        sta  $EA                        ; EF38
        lda  tbl_sfx_ptrs_hi,x          ; EF3A
        sta  $EB                        ; EF3D
        ldy  #$00                       ; EF3F
        lda  ($EA),y                    ; EF41
        sta  $D8                        ; EF43
        ora  $E4                        ; EF45
        sta  $E4                        ; EF47
        lda  $D8                        ; EF49
        beq  loc_EF4D                   ; EF4B
loc_EF4D:
        jsr  sfx_start_channel          ; EF4D
        pla                             ; EF50
        tax                             ; EF51
        pla                             ; EF52
        tay                             ; EF53
        rts                             ; EF54
sound_init:
        tya                             ; EF55
        pha                             ; EF56
        txa                             ; EF57
        pha                             ; EF58
        ldy  #$00                       ; EF59
        sty  APU_STATUS                 ; EF5B
        sty  $0458                      ; EF5E
        sty  $045C                      ; EF61
loc_EF64:
        lda  #$FF                       ; EF64
        sta  $0400,y                    ; EF66
        tya                             ; EF69
        clc                             ; EF6A
        adc  #$15                       ; EF6B
        tay                             ; EF6D
        cmp  #$54                       ; EF6E
        bcc  loc_EF64                   ; EF70
        jsr  snd_credit_checksum        ; EF72
        jsr  music_start_song           ; EF75
        pla                             ; EF78
        tax                             ; EF79
        pla                             ; EF7A
        tay                             ; EF7B
        rts                             ; EF7C
music_start_song:
        lda  $045D                      ; EF7D
        asl  a                          ; EF80
        tay                             ; EF81
        lda  tbl_song_records,y         ; EF82
        sta  $D6                        ; EF85
        lda  tbl_song_records_hi,y      ; EF87
        sta  $D7                        ; EF8A
        lda  $045D                      ; EF8C
        asl  a                          ; EF8F
        tay                             ; EF90
        lda  tbl_song_ntracks,y         ; EF91
        sta  $D2                        ; EF94
        lda  tbl_song_first_track,y     ; EF96
        tay                             ; EF99
        lda  $D2                        ; EF9A
        beq  music_start_track          ; EF9C
        cmp  #$02                       ; EF9E
        beq  loc_EFA7                   ; EFA0
        bcc  loc_EFAA                   ; EFA2
        jsr  music_start_track          ; EFA4
loc_EFA7:
        jsr  music_start_track          ; EFA7
loc_EFAA:
        jsr  music_start_track          ; EFAA
music_start_track:
        sty  $CE                        ; EFAD
        sty  $D3                        ; EFAF
        stx  $D4                        ; EFB1
        lda  #$00                       ; EFB3
        asl  $CE                        ; EFB5
        rol  a                          ; EFB7
        asl  $CE                        ; EFB8
        rol  a                          ; EFBA
        pha                             ; EFBB
        lda  $D6                        ; EFBC
        clc                             ; EFBE
        adc  $CE                        ; EFBF
        sta  $CE                        ; EFC1
        pla                             ; EFC3
        adc  $D7                        ; EFC4
        sta  $CF                        ; EFC6
        ldy  #$00                       ; EFC8
        lda  ($CE),y                    ; EFCA
        tax                             ; EFCC
        lda  $0400,x                    ; EFCD
        cmp  #$FF                       ; EFD0
        beq  loc_EFE3                   ; EFD2
        ; static (not seen in traces)
        lda  $0401,x                    ; EFD4
        and  #$03                       ; EFD7
        tay                             ; EFD9
        lda  tbl_chan_clear_mask,y      ; EFDA
        and  $0458                      ; EFDD
        sta  $0458                      ; EFE0
loc_EFE3:
        ldy  #$01                       ; EFE3
        lda  ($CE),y                    ; EFE5
        sta  $0401,x                    ; EFE7
        iny                             ; EFEA
        lda  ($CE),y                    ; EFEB
        sta  $0402,x                    ; EFED
        iny                             ; EFF0
        lda  ($CE),y                    ; EFF1
        sta  $0403,x                    ; EFF3
        lda  #$00                       ; EFF6
        sta  $0400,x                    ; EFF8
        ldx  $D4                        ; EFFB
        ldy  $D3                        ; EFFD
        iny                             ; EFFF
loc_F000:
        rts                             ; F000
snd_credit_checksum:
        lda  #$00                       ; F001
        ldy  #$00                       ; F003
loc_F005:
        clc                             ; F005
        adc  snd_credit_gb2312,y        ; F006
        iny                             ; F009
        cpy  #$0E                       ; F00A
        bne  loc_F005                   ; F00C
        cmp  #$25                       ; F00E
        beq  loc_F015                   ; F010
        ; static (not seen in traces)
        jmp  loc_F458                   ; F012
loc_F015:
        rts                             ; F015
sfx_start_channel:
        ; static (not seen in traces)
        iny                             ; F016
        lda  ($EA),y                    ; F017
        sta  $D8                        ; F019
        ora  $D9                        ; F01B
        sta  $D9                        ; F01D
        lda  $D8                        ; F01F
        ora  $0458                      ; F021
        ora  $045C                      ; F024
        sta  $045C                      ; F027
        sta  APU_STATUS                 ; F02A
        lda  $D8                        ; F02D
        cmp  #$01                       ; F02F
        beq  loc_F040                   ; F031
        cmp  #$02                       ; F033
        beq  loc_F045                   ; F035
        cmp  #$04                       ; F037
        beq  loc_F04A                   ; F039
        ldx  #$03                       ; F03B
        jmp  loc_F04C                   ; F03D
loc_F040:
        ldx  #$00                       ; F040
        jmp  loc_F04C                   ; F042
loc_F045:
        ldx  #$01                       ; F045
        jmp  loc_F04C                   ; F047
loc_F04A:
        ldx  #$02                       ; F04A
loc_F04C:
        iny                             ; F04C
        lda  ($EA),y                    ; F04D
        sta  $E5,x                      ; F04F
        iny                             ; F051
        lda  ($EA),y                    ; F052
        sta  $F0,x                      ; F054
        iny                             ; F056
        lda  ($EA),y                    ; F057
        sta  $EC,x                      ; F059
        lda  #$00                       ; F05B
        sta  $F4,x                      ; F05D
        sta  $E0,x                      ; F05F
        txa                             ; F061
        asl  a                          ; F062
        asl  a                          ; F063
        tax                             ; F064
        iny                             ; F065
        lda  ($EA),y                    ; F066
        sta  APU_4000,x                 ; F068
        iny                             ; F06B
        lda  ($EA),y                    ; F06C
        sta  APU_4001,x                 ; F06E
        iny                             ; F071
        lda  ($EA),y                    ; F072
        sta  APU_4002,x                 ; F074
        iny                             ; F077
        lda  ($EA),y                    ; F078
        sta  APU_4003,x                 ; F07A
        iny                             ; F07D
        tya                             ; F07E
        clc                             ; F07F
        adc  $EA                        ; F080
        sta  $EA                        ; F082
        lda  $EB                        ; F084
        adc  #$00                       ; F086
        sta  $EB                        ; F088
        txa                             ; F08A
        lsr  a                          ; F08B
        tax                             ; F08C
        lda  $EA                        ; F08D
        sta  $F8,x                      ; F08F
        lda  $EB                        ; F091
        sta  $F9,x                      ; F093
        rts                             ; F095
sfx_tick:
        lda  $E4                        ; F096
        and  #$01                       ; F098
        beq  loc_F09F                   ; F09A
        ; static (not seen in traces)
        jsr  sfx_tick_channels          ; F09C
loc_F09F:
        rts                             ; F09F
sfx_tick_channels:
        ; static (not seen in traces)
        jsr  sfx_tick_pulse1            ; F0A0
        jsr  sfx_tick_pulse2            ; F0A3
        jsr  sfx_tick_triangle          ; F0A6
        jsr  sfx_tick_noise             ; F0A9
        rts                             ; F0AC
sfx_tick_pulse1:
        lda  $D9                        ; F0AD
        and  #$01                       ; F0AF
        beq  loc_F11E                   ; F0B1
        inc  $F4                        ; F0B3
        lda  $F4                        ; F0B5
        cmp  $F0                        ; F0B7
        bcc  loc_F11E                   ; F0B9
        lda  #$00                       ; F0BB
        sta  $F4                        ; F0BD
        lda  $E0                        ; F0BF
        cmp  $EC                        ; F0C1
        bcs  loc_F10A                   ; F0C3
        ldy  #$00                       ; F0C5
        lda  $E5                        ; F0C7
        and  #$01                       ; F0C9
        beq  loc_F0D3                   ; F0CB
        lda  ($F8),y                    ; F0CD
        sta  APU_4000                   ; F0CF
        iny                             ; F0D2
loc_F0D3:
        lda  $E5                        ; F0D3
        and  #$02                       ; F0D5
        beq  loc_F0DF                   ; F0D7
        lda  ($F8),y                    ; F0D9
        sta  APU_4001                   ; F0DB
        iny                             ; F0DE
loc_F0DF:
        lda  $E5                        ; F0DF
        and  #$04                       ; F0E1
        beq  loc_F0EB                   ; F0E3
        lda  ($F8),y                    ; F0E5
        sta  APU_4002                   ; F0E7
        iny                             ; F0EA
loc_F0EB:
        lda  $E5                        ; F0EB
        and  #$08                       ; F0ED
        beq  loc_F0F7                   ; F0EF
        lda  ($F8),y                    ; F0F1
        sta  APU_4003                   ; F0F3
        iny                             ; F0F6
loc_F0F7:
        tya                             ; F0F7
        clc                             ; F0F8
        adc  $E0                        ; F0F9
        sta  $E0                        ; F0FB
        tya                             ; F0FD
        clc                             ; F0FE
        adc  $F8                        ; F0FF
        sta  $F8                        ; F101
        lda  $F9                        ; F103
        adc  #$00                       ; F105
        sta  $F9                        ; F107
        rts                             ; F109
loc_F10A:
        lda  $D9                        ; F10A
        and  #$FE                       ; F10C
        sta  $D9                        ; F10E
        lda  $045C                      ; F110
        and  #$FE                       ; F113
        sta  $045C                      ; F115
        ora  $0458                      ; F118
        sta  APU_STATUS                 ; F11B
loc_F11E:
        rts                             ; F11E
sfx_tick_pulse2:
        lda  $D9                        ; F11F
        and  #$02                       ; F121
        beq  loc_F190                   ; F123
        inc  langsel_pad_new            ; F125
        lda  langsel_pad_new            ; F127
        cmp  $F1                        ; F129
        bcc  loc_F190                   ; F12B
        lda  #$00                       ; F12D
        sta  langsel_pad_new            ; F12F
        lda  $E1                        ; F131
        cmp  $ED                        ; F133
        bcs  loc_F17C                   ; F135
        ldy  #$00                       ; F137
        lda  $E6                        ; F139
        and  #$01                       ; F13B
        beq  loc_F145                   ; F13D
        lda  ($FA),y                    ; F13F
        sta  APU_4004                   ; F141
        iny                             ; F144
loc_F145:
        lda  $E6                        ; F145
        and  #$02                       ; F147
        beq  loc_F151                   ; F149
        lda  ($FA),y                    ; F14B
        sta  APU_4005                   ; F14D
        iny                             ; F150
loc_F151:
        lda  $E6                        ; F151
        and  #$04                       ; F153
        beq  loc_F15D                   ; F155
        lda  ($FA),y                    ; F157
        sta  APU_4006                   ; F159
        iny                             ; F15C
loc_F15D:
        lda  $E6                        ; F15D
        and  #$08                       ; F15F
        beq  loc_F169                   ; F161
        lda  ($FA),y                    ; F163
        sta  APU_4007                   ; F165
        iny                             ; F168
loc_F169:
        tya                             ; F169
        clc                             ; F16A
        adc  $E1                        ; F16B
        sta  $E1                        ; F16D
        tya                             ; F16F
        clc                             ; F170
        adc  $FA                        ; F171
        sta  $FA                        ; F173
        lda  $FB                        ; F175
        adc  #$00                       ; F177
        sta  $FB                        ; F179
        rts                             ; F17B
loc_F17C:
        lda  $D9                        ; F17C
        and  #$FD                       ; F17E
        sta  $D9                        ; F180
        lda  $045C                      ; F182
        and  #$FD                       ; F185
        sta  $045C                      ; F187
        ora  $0458                      ; F18A
        sta  APU_STATUS                 ; F18D
loc_F190:
        rts                             ; F190
sfx_tick_triangle:
        lda  $D9                        ; F191
        and  #$04                       ; F193
        beq  loc_F202                   ; F195
        inc  $F6                        ; F197
        lda  $F6                        ; F199
        cmp  $F2                        ; F19B
        bcc  loc_F202                   ; F19D
        lda  #$00                       ; F19F
        sta  $F6                        ; F1A1
        lda  $E2                        ; F1A3
        cmp  $EE                        ; F1A5
        bcs  loc_F1EE                   ; F1A7
        ldy  #$00                       ; F1A9
        lda  $E7                        ; F1AB
        and  #$01                       ; F1AD
        beq  loc_F1B7                   ; F1AF
        lda  ($FC),y                    ; F1B1
        sta  APU_4008                   ; F1B3
        iny                             ; F1B6
loc_F1B7:
        lda  $E7                        ; F1B7
        and  #$02                       ; F1B9
        beq  loc_F1C3                   ; F1BB
        lda  ($FC),y                    ; F1BD
        sta  APU_4009                   ; F1BF
        iny                             ; F1C2
loc_F1C3:
        lda  $E7                        ; F1C3
        and  #$04                       ; F1C5
        beq  loc_F1CF                   ; F1C7
        lda  ($FC),y                    ; F1C9
        sta  APU_400A                   ; F1CB
        iny                             ; F1CE
loc_F1CF:
        lda  $E7                        ; F1CF
        and  #$08                       ; F1D1
        beq  loc_F1DB                   ; F1D3
        lda  ($FC),y                    ; F1D5
        sta  APU_400B                   ; F1D7
        iny                             ; F1DA
loc_F1DB:
        tya                             ; F1DB
        clc                             ; F1DC
        adc  $E2                        ; F1DD
        sta  $E2                        ; F1DF
        tya                             ; F1E1
        clc                             ; F1E2
        adc  $FC                        ; F1E3
        sta  $FC                        ; F1E5
        lda  $FD                        ; F1E7
        adc  #$00                       ; F1E9
        sta  $FD                        ; F1EB
        rts                             ; F1ED
loc_F1EE:
        lda  $D9                        ; F1EE
        and  #$FB                       ; F1F0
        sta  $D9                        ; F1F2
        lda  $045C                      ; F1F4
        and  #$FB                       ; F1F7
        sta  $045C                      ; F1F9
        ora  $0458                      ; F1FC
        sta  APU_STATUS                 ; F1FF
loc_F202:
        rts                             ; F202
sfx_tick_noise:
        lda  $D9                        ; F203
        and  #$08                       ; F205
        beq  loc_F274                   ; F207
        inc  $F7                        ; F209
        lda  $F7                        ; F20B
        cmp  $F3                        ; F20D
        bcc  loc_F274                   ; F20F
        lda  #$00                       ; F211
        sta  $F7                        ; F213
        lda  $E3                        ; F215
        cmp  $EF                        ; F217
        bcs  loc_F260                   ; F219
        ldy  #$00                       ; F21B
        lda  $E8                        ; F21D
        and  #$01                       ; F21F
        beq  loc_F229                   ; F221
        lda  ($FE),y                    ; F223
        sta  APU_400C                   ; F225
        iny                             ; F228
loc_F229:
        lda  $E8                        ; F229
        and  #$02                       ; F22B
        beq  loc_F235                   ; F22D
        lda  ($FE),y                    ; F22F
        sta  APU_400D                   ; F231
        iny                             ; F234
loc_F235:
        lda  $E8                        ; F235
        and  #$04                       ; F237
        beq  loc_F241                   ; F239
        lda  ($FE),y                    ; F23B
        sta  APU_400E                   ; F23D
        iny                             ; F240
loc_F241:
        lda  $E8                        ; F241
        and  #$08                       ; F243
        beq  loc_F24D                   ; F245
        lda  ($FE),y                    ; F247
        sta  APU_400F                   ; F249
        iny                             ; F24C
loc_F24D:
        tya                             ; F24D
        clc                             ; F24E
        adc  $E3                        ; F24F
        sta  $E3                        ; F251
        tya                             ; F253
        clc                             ; F254
        adc  $FE                        ; F255
        sta  $FE                        ; F257
        lda  $FF                        ; F259
        adc  #$00                       ; F25B
        sta  $FF                        ; F25D
        rts                             ; F25F
loc_F260:
        lda  $D9                        ; F260
        and  #$F7                       ; F262
        sta  $D9                        ; F264
        lda  $045C                      ; F266
        and  #$F7                       ; F269
        sta  $045C                      ; F26B
        ora  $0458                      ; F26E
        sta  APU_STATUS                 ; F271
loc_F274:
        rts                             ; F274
music_tick:
        lda  #$00                       ; F275
        sta  $0454                      ; F277
        inc  $045B                      ; F27A
loc_F27D:
        tax                             ; F27D
        lda  $0401,x                    ; F27E
        and  #$03                       ; F281
        sta  $0455                      ; F283
        tay                             ; F286
        asl  a                          ; F287
        asl  a                          ; F288
        sta  $0457                      ; F289
        lda  tbl_chan_type,y            ; F28C
        sta  $0456                      ; F28F
        lda  $0400,x                    ; F292
        beq  music_read_header          ; F295
        cmp  #$FF                       ; F297
        beq  loc_F2F5                   ; F299
        jsr  music_vibrato              ; F29B
        jsr  music_envelope             ; F29E
        inc  $040D,x                    ; F2A1
        lda  $040D,x                    ; F2A4
        cmp  $040C,x                    ; F2A7
        bcc  loc_F2B2                   ; F2AA
        lda  $040C,x                    ; F2AC
        sta  $040D,x                    ; F2AF
loc_F2B2:
        lda  $0405,x                    ; F2B2
        sec                             ; F2B5
        sbc  #$10                       ; F2B6
        sta  $0405,x                    ; F2B8
        bpl  loc_F2DA                   ; F2BB
        lda  $0404,x                    ; F2BD
        clc                             ; F2C0
        adc  $0405,x                    ; F2C1
        clc                             ; F2C4
        adc  #$01                       ; F2C5
        sta  $0405,x                    ; F2C7
        jsr  music_volume_slide         ; F2CA
        lda  $0414,x                    ; F2CD
        beq  loc_F2D5                   ; F2D0
        ; static (not seen in traces)
        dec  $0414,x                    ; F2D2
loc_F2D5:
        dec  $0407,x                    ; F2D5
        beq  loc_F2E0                   ; F2D8
loc_F2DA:
        jsr  music_write_volume_chk     ; F2DA
        jmp  loc_F2E9                   ; F2DD
loc_F2E0:
        lda  $0413,x                    ; F2E0
        sta  $0414,x                    ; F2E3
        jsr  music_read_commands        ; F2E6
loc_F2E9:
        ldy  $0455                      ; F2E9
        lda  tbl_chan_bit,y             ; F2EC
        ora  $0454                      ; F2EF
        sta  $0454                      ; F2F2
loc_F2F5:
        txa                             ; F2F5
        clc                             ; F2F6
        adc  #$15                       ; F2F7
        cmp  #$54                       ; F2F9
        bne  loc_F27D                   ; F2FB
        rts                             ; F2FD
music_read_header:
        lda  $0402,x                    ; F2FE
        sta  $D0                        ; F301
        lda  $0403,x                    ; F303
        sta  $D1                        ; F306
        ldy  #$00                       ; F308
        lda  ($D0),y                    ; F30A
        pha                             ; F30C
        asl  a                          ; F30D
        sta  $0404,x                    ; F30E
        pla                             ; F311
        rol  a                          ; F312
        asl  $0404,x                    ; F313
        rol  a                          ; F316
        asl  $0404,x                    ; F317
        rol  a                          ; F31A
        asl  $0404,x                    ; F31B
        rol  a                          ; F31E
        clc                             ; F31F
        adc  #$0F                       ; F320
        sta  $0404,x                    ; F322
        sta  $0405,x                    ; F325
        iny                             ; F328
        jsr  music_read_duty            ; F329
        iny                             ; F32C
        lda  ($D0),y                    ; F32D
        ora  $0459                      ; F32F
        sta  $0406,x                    ; F332
        iny                             ; F335
        lda  ($D0),y                    ; F336
        sta  $0408,x                    ; F338
        lda  #$00                       ; F33B
        sta  $0409,x                    ; F33D
        sta  $040A,x                    ; F340
        sta  $040B,x                    ; F343
        sta  $040E,x                    ; F346
        lda  #$02                       ; F349
        sta  $0400,x                    ; F34B
        bne  loc_F2E0                   ; F34E
music_read_commands:
        ldy  #$00                       ; F350
        sty  $D1                        ; F352
        lda  $0400,x                    ; F354
        asl  a                          ; F357
        rol  $D1                        ; F358
        adc  $0402,x                    ; F35A
        sta  $D0                        ; F35D
        lda  $0403,x                    ; F35F
        adc  $D1                        ; F362
        sta  $D1                        ; F364
loc_F366:
        lda  ($D0),y                    ; F366
        inc  $0400,x                    ; F368
        iny                             ; F36B
        cmp  #$F0                       ; F36C
        bcs  loc_F38A                   ; F36E
        cmp  #$E0                       ; F370
        bcs  loc_F3A2                   ; F372
        cmp  #$D0                       ; F374
        bcs  loc_F3AC                   ; F376
        cmp  #$C0                       ; F378
        bcs  loc_F3C2                   ; F37A
        cmp  #$B0                       ; F37C
        bcs  loc_F3E2                   ; F37E
        cmp  #$A0                       ; F380
        bcc  loc_F387                   ; F382
        jmp  loc_F410                   ; F384
loc_F387:
        jmp  music_cmd_note             ; F387
loc_F38A:
        ; static (not seen in traces)
        cmp  #$FD                       ; F38A
        bne  loc_F398                   ; F38C
        lda  $0400,x                    ; F38E
        sta  $0412,x                    ; F391
loc_F394:
        iny                             ; F394
        jmp  loc_F366                   ; F395
loc_F398:
        cmp  #$FF                       ; F398
        bne  loc_F394                   ; F39A
        sta  $0400,x                    ; F39C
        jmp  music_cmd_rest             ; F39F
loc_F3A2:
        and  #$0F                       ; F3A2
        eor  #$FF                       ; F3A4
        clc                             ; F3A6
        adc  #$01                       ; F3A7
        jmp  loc_F3AE                   ; F3A9
loc_F3AC:
        and  #$0F                       ; F3AC
loc_F3AE:
        bit  $0456                      ; F3AE
        bmi  loc_F3BE                   ; F3B1
        sta  $040E,x                    ; F3B3
        lda  ($D0),y                    ; F3B6
        sta  $040F,x                    ; F3B8
        sta  $0410,x                    ; F3BB
loc_F3BE:
        iny                             ; F3BE
        jmp  loc_F366                   ; F3BF
loc_F3C2:
        and  #$0F                       ; F3C2
        sta  $0459                      ; F3C4
        bit  $0456                      ; F3C7
        bmi  loc_F3DE                   ; F3CA
        lda  $0406,x                    ; F3CC
        and  #$10                       ; F3CF
        beq  loc_F3DE                   ; F3D1
        lda  ($D0),y                    ; F3D3
        sta  $040C,x                    ; F3D5
        lda  $0459                      ; F3D8
        sta  $040B,x                    ; F3DB
loc_F3DE:
        iny                             ; F3DE
        jmp  loc_F366                   ; F3DF
loc_F3E2:
        ; static (not seen in traces)
        and  #$0F                       ; F3E2
        beq  loc_F403                   ; F3E4
        pha                             ; F3E6
        lda  ($D0),y                    ; F3E7
        bne  loc_F3F8                   ; F3E9
        pla                             ; F3EB
        dec  $0409,x                    ; F3EC
        beq  loc_F40D                   ; F3EF
        bpl  loc_F403                   ; F3F1
        sta  $0409,x                    ; F3F3
        bmi  loc_F403                   ; F3F6
loc_F3F8:
        pla                             ; F3F8
        dec  $040A,x                    ; F3F9
        beq  loc_F40D                   ; F3FC
        bpl  loc_F403                   ; F3FE
        sta  $040A,x                    ; F400
loc_F403:
        lda  ($D0),y                    ; F403
        bne  loc_F40A                   ; F405
        lda  $0412,x                    ; F407
loc_F40A:
        sta  $0400,x                    ; F40A
loc_F40D:
        jmp  music_read_commands        ; F40D
loc_F410:
        bne  loc_F421                   ; F410
        ; static (not seen in traces)
        bit  $0456                      ; F412
        bmi  loc_F42A                   ; F415
        lda  $0406,x                    ; F417
        and  #$C0                       ; F41A
        ora  ($D0),y                    ; F41C
        jmp  loc_F43F                   ; F41E
loc_F421:
        cmp  #$A1                       ; F421
        bne  loc_F42E                   ; F423
        lda  ($D0),y                    ; F425
        sta  $0408,x                    ; F427
loc_F42A:
        iny                             ; F42A
        jmp  loc_F366                   ; F42B
loc_F42E:
        cmp  #$A2                       ; F42E
        bne  loc_F446                   ; F430
        jsr  music_read_duty            ; F432
        bcs  loc_F43F                   ; F435
        ; static (not seen in traces)
        lda  $0406,x                    ; F437
        and  #$1F                       ; F43A
        ora  $0459                      ; F43C
loc_F43F:
        sta  $0406,x                    ; F43F
        iny                             ; F442
        jmp  loc_F366                   ; F443
loc_F446:
        ; static (not seen in traces)
        cmp  #$A3                       ; F446
        bne  loc_F467                   ; F448
        lda  ($D0),y                    ; F44A
        bmi  loc_F46B                   ; F44C
        pha                             ; F44E
        and  #$0F                       ; F44F
        asl  a                          ; F451
        sta  $0413,x                    ; F452
        sta  $0414,x                    ; F455
loc_F458:
        pla                             ; F458
        and  #$70                       ; F459
        ora  $0455                      ; F45B
        ora  #$80                       ; F45E
        sta  $0401,x                    ; F460
        iny                             ; F463
        jmp  loc_F366                   ; F464
loc_F467:
        cmp  #$A4                       ; F467
        bne  loc_F477                   ; F469
loc_F46B:
        lda  $0401,x                    ; F46B
        and  #$03                       ; F46E
        sta  $0401,x                    ; F470
        iny                             ; F473
        jmp  loc_F366                   ; F474
loc_F477:
        cmp  #$AD                       ; F477
        bne  loc_F4A1                   ; F479
        lda  ($D0),y                    ; F47B
        pha                             ; F47D
        lda  #$00                       ; F47E
        sta  $D1                        ; F480
        lda  $0400,x                    ; F482
        asl  a                          ; F485
        rol  $D1                        ; F486
        adc  $0402,x                    ; F488
        sta  $0402,x                    ; F48B
        lda  $0403,x                    ; F48E
        adc  $D1                        ; F491
        sta  $0403,x                    ; F493
        lda  #$00                       ; F496
        sta  $0400,x                    ; F498
        pla                             ; F49B
        bne  loc_F4AE                   ; F49C
        jmp  music_read_header          ; F49E
loc_F4A1:
        cmp  #$AE                       ; F4A1
        bne  loc_F4B2                   ; F4A3
        asl  $0404,x                    ; F4A5
        lda  ($D0),y                    ; F4A8
        asl  a                          ; F4AA
        ror  $0404,x                    ; F4AB
loc_F4AE:
        iny                             ; F4AE
        jmp  loc_F366                   ; F4AF
loc_F4B2:
        cmp  #$AF                       ; F4B2
        bne  loc_F4D4                   ; F4B4
        lda  ($D0),y                    ; F4B6
        pha                             ; F4B8
        asl  a                          ; F4B9
        sta  $0404,x                    ; F4BA
        pla                             ; F4BD
        rol  a                          ; F4BE
        asl  $0404,x                    ; F4BF
        rol  a                          ; F4C2
        asl  $0404,x                    ; F4C3
        rol  a                          ; F4C6
        asl  $0404,x                    ; F4C7
        rol  a                          ; F4CA
        clc                             ; F4CB
        adc  #$0F                       ; F4CC
        sta  $0405,x                    ; F4CE
        sta  $0404,x                    ; F4D1
loc_F4D4:
        iny                             ; F4D4
        jmp  loc_F366                   ; F4D5
music_cmd_note:
        sta  $0459                      ; F4D8
        lda  ($D0),y                    ; F4DB
        sta  $0407,x                    ; F4DD
        lda  $0459                      ; F4E0
        bit  $0456                      ; F4E3
        bvs  loc_F551                   ; F4E6
        pha                             ; F4E8
        and  #$0F                       ; F4E9
        cmp  #$0C                       ; F4EB
        bcs  loc_F55F                   ; F4ED
        asl  a                          ; F4EF
        tay                             ; F4F0
        lda  tbl_note_period_lo,y       ; F4F1
        sta  $0459                      ; F4F4
        lda  tbl_note_period_hi,y       ; F4F7
        sta  $045A                      ; F4FA
        pla                             ; F4FD
        lsr  a                          ; F4FE
        lsr  a                          ; F4FF
        lsr  a                          ; F500
        lsr  a                          ; F501
        beq  loc_F50E                   ; F502
        tay                             ; F504
loc_F505:
        lsr  $045A                      ; F505
        ror  $0459                      ; F508
        dey                             ; F50B
        bne  loc_F505                   ; F50C
loc_F50E:
        lda  #$00                       ; F50E
        sta  $040D,x                    ; F510
        jsr  music_skip_if_sfx_owns     ; F513
        lda  tbl_chan_bit,y             ; F516
        ora  $0458                      ; F519
        sta  $0458                      ; F51C
        jsr  apu_enable_channels        ; F51F
        lda  $045A                      ; F522
        pha                             ; F525
        lda  $0459                      ; F526
        pha                             ; F529
        jsr  music_write_volume         ; F52A
        lda  $0408,x                    ; F52D
        jsr  apu_write_r1               ; F530
        pla                             ; F533
        jsr  apu_write_r2               ; F534
        cmp  #$02                       ; F537
        bcc  loc_F543                   ; F539
        cmp  #$FE                       ; F53B
        bcc  loc_F545                   ; F53D
        ; static (not seen in traces)
        lda  #$FD                       ; F53F
        bne  loc_F545                   ; F541
loc_F543:
        lda  #$02                       ; F543
loc_F545:
        sta  $0411,x                    ; F545
        pla                             ; F548
        and  #$07                       ; F549
        ora  #$08                       ; F54B
        jsr  apu_write_r3               ; F54D
        rts                             ; F550
loc_F551:
        cmp  #$10                       ; F551
        bcs  music_cmd_rest             ; F553
        sta  $0459                      ; F555
        lda  #$00                       ; F558
        sta  $045A                      ; F55A
        beq  loc_F50E                   ; F55D
loc_F55F:
        ; static (not seen in traces)
        pla                             ; F55F
music_cmd_rest:
        jsr  music_skip_if_sfx_owns     ; F560
        lda  tbl_chan_clear_mask,y      ; F563
        and  $0458                      ; F566
        sta  $0458                      ; F569
        jsr  apu_enable_channels        ; F56C
        rts                             ; F56F
music_skip_if_sfx_owns:
        ldy  $0455                      ; F570
        lda  tbl_chan_bit,y             ; F573
        bit  $0454                      ; F576
        beq  loc_F57D                   ; F579
        ; static (not seen in traces)
        pla                             ; F57B
        pla                             ; F57C
loc_F57D:
        rts                             ; F57D
music_read_duty:
        bit  $0456                      ; F57E
        bmi  loc_F58F                   ; F581
        lda  ($D0),y                    ; F583
        ror  a                          ; F585
        ror  a                          ; F586
        ror  a                          ; F587
        and  #$C0                       ; F588
        sta  $0459                      ; F58A
        clc                             ; F58D
        rts                             ; F58E
loc_F58F:
        lda  ($D0),y                    ; F58F
        and  #$7F                       ; F591
        sta  $0459                      ; F593
        sec                             ; F596
        rts                             ; F597
music_write_volume_chk:
        jsr  music_skip_if_sfx_owns     ; F598
music_write_volume:
        cpy  #$02                       ; F59B
        beq  loc_F5B4                   ; F59D
        lda  $040B,x                    ; F59F
        bne  loc_F5CA                   ; F5A2
        lda  $0406,x                    ; F5A4
        and  #$10                       ; F5A7
        asl  a                          ; F5A9
        ora  $0406,x                    ; F5AA
        ldy  $0457                      ; F5AD
        jsr  apu_write_r0               ; F5B0
        rts                             ; F5B3
loc_F5B4:
        lda  $0406,x                    ; F5B4
        ldy  $0457                      ; F5B7
        jsr  apu_write_tri_linear       ; F5BA
loc_F5BD:
        rts                             ; F5BD
music_envelope:
        jsr  music_skip_if_sfx_owns     ; F5BE
        cpy  #$02                       ; F5C1
        beq  loc_F5BD                   ; F5C3
        lda  $040B,x                    ; F5C5
        beq  loc_F5BD                   ; F5C8
loc_F5CA:
        asl  a                          ; F5CA
        asl  a                          ; F5CB
        asl  a                          ; F5CC
        asl  a                          ; F5CD
        pha                             ; F5CE
        lda  #$00                       ; F5CF
        sta  $0459                      ; F5D1
        lda  $040D,x                    ; F5D4
        ldy  #$03                       ; F5D7
loc_F5D9:
        asl  a                          ; F5D9
        cmp  $040C,x                    ; F5DA
        bcc  loc_F5E2                   ; F5DD
        sbc  $040C,x                    ; F5DF
loc_F5E2:
        rol  $0459                      ; F5E2
        dey                             ; F5E5
        bpl  loc_F5D9                   ; F5E6
        pla                             ; F5E8
        ora  $0459                      ; F5E9
        tay                             ; F5EC
        lda  $0406,x                    ; F5ED
        and  #$0F                       ; F5F0
        ora  tbl_envelope,y             ; F5F2
        tay                             ; F5F5
        lda  $0406,x                    ; F5F6
        and  #$C0                       ; F5F9
        ora  tbl_volume_scale,y         ; F5FB
        ldy  $0457                      ; F5FE
        jsr  apu_write_r0               ; F601
        rts                             ; F604
music_volume_slide:
        bit  $0456                      ; F605
        bmi  loc_F638                   ; F608
        lda  $040E,x                    ; F60A
        beq  loc_F638                   ; F60D
        ; static (not seen in traces)
        dec  $0410,x                    ; F60F
        bne  loc_F638                   ; F612
        lda  $040F,x                    ; F614
        sta  $0410,x                    ; F617
        lda  $0406,x                    ; F61A
        and  #$1F                       ; F61D
        sta  $0459                      ; F61F
        and  #$10                       ; F622
        beq  loc_F638                   ; F624
        lda  $040E,x                    ; F626
        bmi  loc_F639                   ; F629
        dec  $040E,x                    ; F62B
        lda  $0459                      ; F62E
        cmp  #$1F                       ; F631
        beq  loc_F638                   ; F633
        inc  $0406,x                    ; F635
loc_F638:
        rts                             ; F638
loc_F639:
        ; static (not seen in traces)
        inc  $040E,x                    ; F639
        lda  $0459                      ; F63C
        cmp  #$10                       ; F63F
        beq  loc_F638                   ; F641
        dec  $0406,x                    ; F643
        rts                             ; F646
music_vibrato:
        jsr  music_skip_if_sfx_owns     ; F647
        bit  $0456                      ; F64A
        bvs  loc_F674                   ; F64D
        lda  $0414,x                    ; F64F
        bne  loc_F674                   ; F652
        lda  $0401,x                    ; F654
        bpl  loc_F674                   ; F657
        ; static (not seen in traces)
        and  #$70                       ; F659
        sta  $0459                      ; F65B
        lda  $045B                      ; F65E
        and  #$0F                       ; F661
        ora  $0459                      ; F663
        tay                             ; F666
        lda  tbl_vibrato,y              ; F667
        clc                             ; F66A
        adc  $0411,x                    ; F66B
        ldy  $0457                      ; F66E
        jsr  apu_write_r2               ; F671
loc_F674:
        rts                             ; F674
apu_write_r0:
        sta  $D8                        ; F675
        jsr  apu_check_sfx_channel      ; F677
        lda  $DA                        ; F67A
        bne  loc_F683                   ; F67C
        lda  $D8                        ; F67E
        sta  APU_4000,y                 ; F680
loc_F683:
        rts                             ; F683
apu_write_r1:
        sta  $D8                        ; F684
        jsr  apu_check_sfx_channel      ; F686
        lda  $DA                        ; F689
        bne  loc_F692                   ; F68B
        lda  $D8                        ; F68D
        sta  APU_4001,y                 ; F68F
loc_F692:
        rts                             ; F692
apu_write_r2:
        sta  $D8                        ; F693
        jsr  apu_check_sfx_channel      ; F695
        lda  $DA                        ; F698
        bne  loc_F6A1                   ; F69A
        lda  $D8                        ; F69C
        sta  APU_4002,y                 ; F69E
loc_F6A1:
        rts                             ; F6A1
apu_write_r3:
        sta  $D8                        ; F6A2
        jsr  apu_check_sfx_channel      ; F6A4
        lda  $DA                        ; F6A7
        bne  loc_F6B0                   ; F6A9
        lda  $D8                        ; F6AB
        sta  APU_4003,y                 ; F6AD
loc_F6B0:
        rts                             ; F6B0
apu_enable_channels:
        ora  $045C                      ; F6B1
        sta  $045C                      ; F6B4
        sta  APU_STATUS                 ; F6B7
        rts                             ; F6BA
apu_write_tri_linear:
        sta  $D8                        ; F6BB
        lda  $D9                        ; F6BD
        and  #$04                       ; F6BF
        bne  loc_F6C8                   ; F6C1
        lda  $D8                        ; F6C3
        sta  APU_4008                   ; F6C5
loc_F6C8:
        rts                             ; F6C8
apu_check_sfx_channel:
        lda  #$00                       ; F6C9
        sta  $DA                        ; F6CB
        lda  $D9                        ; F6CD
        and  #$01                       ; F6CF
        beq  loc_F6DA                   ; F6D1
        ; static (not seen in traces)
        cpy  #$00                       ; F6D3
        bne  loc_F6DA                   ; F6D5
        jmp  loc_F6FE                   ; F6D7
loc_F6DA:
        lda  $D9                        ; F6DA
        and  #$02                       ; F6DC
        beq  loc_F6E7                   ; F6DE
        ; static (not seen in traces)
        cpy  #$04                       ; F6E0
        bne  loc_F6E7                   ; F6E2
        jmp  loc_F6FE                   ; F6E4
loc_F6E7:
        lda  $D9                        ; F6E7
        and  #$04                       ; F6E9
        beq  loc_F6F4                   ; F6EB
        ; static (not seen in traces)
        cpy  #$08                       ; F6ED
        bne  loc_F6F4                   ; F6EF
        jmp  loc_F6FE                   ; F6F1
loc_F6F4:
        lda  $D9                        ; F6F4
        and  #$08                       ; F6F6
        beq  loc_F702                   ; F6F8
        ; static (not seen in traces)
        cpy  #$0C                       ; F6FA
        bne  loc_F702                   ; F6FC
loc_F6FE:
        lda  #$FF                       ; F6FE
        sta  $DA                        ; F700
loc_F702:
        rts                             ; F702
snd_credit_gb2312:
        .byte $D2,$F4,$D0,$A7,$D6,$C6,$D7,$F7,$A3,$BA,$CD,$F5,$B3,$AC ; F703
tbl_note_period_lo:
        .byte $AE ; F711
tbl_note_period_hi:
        .byte $06,$4E,$06,$F4,$05,$9E,$05,$4D,$05,$01,$05,$B9,$04,$75,$04,$35 ; F712
        .byte $04,$F9,$03,$C0,$03,$8A,$03 ; F722
tbl_chan_bit:
        .byte $01,$02,$04,$08 ; F729
tbl_chan_clear_mask:
        .byte $0E,$0D,$0B,$07 ; F72D
tbl_chan_type:
        .byte $00,$01,$82,$43 ; F731
tbl_vibrato:
        .byte $00,$00,$01,$01,$00,$00,$FF,$FF,$00,$00,$01,$01,$00,$00,$FF,$FF ; F735
        .byte $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00,$FF,$FF,$FF,$FF ; F745
        .byte $00,$01,$02,$01,$00,$FF,$FE,$FF,$00,$01,$02,$01,$00,$FF,$FE,$FF ; F755
        .byte $00,$00,$01,$01,$02,$02,$01,$01,$00,$00,$FF,$FF,$FE,$FE,$FF,$FF ; F765
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F775
        .byte $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE ; F785
        .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; F795
tbl_envelope:
        .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; F7A5
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80,$70,$60,$50,$40,$30,$20,$10,$00 ; F7B5
        .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0 ; F7C5
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0 ; F7D5
        .byte $80,$90,$A0,$B0,$C0,$D0,$E0,$F0,$F0,$E0,$D0,$C0,$B0,$A0,$90,$80 ; F7E5
        .byte $F0,$D0,$B0,$90,$70,$50,$30,$10,$E0,$C0,$A0,$80,$60,$40,$20,$00 ; F7F5
        .byte $F0,$E0,$D0,$C0,$C0,$D0,$E0,$D0,$C0,$A0,$80,$60,$40,$20,$10,$00 ; F805
        .byte $F0,$D0,$B0,$90,$A0,$B0,$90,$70,$60,$50,$40,$30,$20,$10,$10,$00 ; F815
        .byte $40,$40,$40,$40,$40,$40,$40,$60,$60,$70,$80,$A0,$C0,$F0,$B0,$80 ; F825
        .byte $F0,$F0,$A0,$80,$F0,$F0,$A0,$80,$70,$70,$60,$60,$50,$50,$40,$20 ; F835
tbl_volume_scale:
        .byte $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30 ; F845
        .byte $30,$30,$30,$30,$30,$30,$30,$30,$31,$31,$31,$31,$31,$31,$31,$31 ; F855
        .byte $30,$30,$30,$30,$31,$31,$31,$31,$31,$31,$31,$31,$32,$32,$32,$32 ; F865
        .byte $30,$30,$30,$31,$31,$31,$31,$31,$32,$32,$32,$32,$32,$33,$33,$33 ; F875
        .byte $30,$30,$31,$31,$31,$31,$32,$32,$32,$32,$33,$33,$33,$33,$34,$34 ; F885
        .byte $30,$30,$31,$31,$31,$32,$32,$32,$33,$33,$33,$34,$34,$34,$35,$35 ; F895
        .byte $30,$30,$31,$31,$32,$32,$32,$33,$33,$34,$34,$34,$35,$35,$36,$36 ; F8A5
        .byte $30,$30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$36,$37,$37 ; F8B5
        .byte $30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$36,$37,$37,$38 ; F8C5
        .byte $30,$31,$31,$32,$32,$33,$34,$34,$35,$35,$36,$37,$37,$38,$38,$39 ; F8D5
        .byte $30,$31,$31,$32,$33,$33,$34,$35,$35,$36,$37,$37,$38,$39,$39,$3A ; F8E5
        .byte $30,$31,$31,$32,$33,$34,$34,$35,$36,$37,$37,$38,$39,$3A,$3A,$3B ; F8F5
        .byte $30,$31,$32,$32,$33,$34,$35,$36,$36,$37,$38,$39,$3A,$3A,$3B,$3C ; F905
        .byte $30,$31,$32,$33,$33,$34,$35,$36,$37,$38,$39,$3A,$3A,$3B,$3C,$3D ; F915
        .byte $30,$31,$32,$33,$34,$35,$36,$37,$37,$38,$39,$3A,$3B,$3C,$3D,$3E ; F925
        .byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F ; F935
tbl_sfx_ptrs:
        .byte $9B ; F945
tbl_sfx_ptrs_hi:
        .byte $F9,$A4,$F9,$B9,$F9,$C2,$F9,$CB,$F9,$D4,$F9,$DD,$F9,$F2,$F9,$FB ; F946
        .byte $F9,$14,$FA,$77,$FA,$9C,$FA,$B3,$FA,$E4,$FA,$EE,$FA,$F8,$FA,$18 ; F956
        .byte $FB,$31,$FB,$5A,$FB,$75,$FB,$87,$FB,$99,$FB,$CE,$FB,$F0,$FB,$0A ; F966
        .byte $FC,$13,$FC,$24,$FC,$39,$FC,$4A,$FC,$57,$FC,$60,$FC,$69,$FC,$72 ; F976
        .byte $FC,$7B,$FC,$84,$FC,$8D,$FC,$97,$FC,$A2,$FC,$AD,$FC,$73,$FD,$BE ; F986
        .byte $FD,$DD,$FD,$F4,$FD,$01,$02,$0F,$32,$00,$FF,$AA,$57,$05,$01,$02 ; F996
        .byte $0F,$03,$0C,$0F,$7F,$D4,$08,$0F,$7F,$1C,$09,$0F,$7F,$52,$09,$0F ; F9A6
        .byte $7F,$AB,$09,$01,$08,$0F,$32,$00,$1F,$AA,$EF,$80,$01,$02,$0F,$C8 ; F9B6
        .byte $00,$3F,$CB,$CF,$02,$01,$02,$0F,$1E,$00,$3F,$AA,$C8,$00,$01,$02 ; F9C6
        .byte $0F,$28,$00,$6F,$AB,$CF,$02,$01,$02,$0F,$03,$0C,$0F,$7F,$AB,$09 ; F9D6
        .byte $0F,$7F,$52,$09,$0F,$7F,$1C,$09,$0F,$7F,$D4,$08,$01,$08,$0F,$3C ; F9E6
        .byte $00,$0F,$00,$0E,$C0,$01,$04,$04,$03,$10,$FF,$00,$39,$C0,$3C,$40 ; F9F6
        .byte $43,$47,$4C,$50,$55,$5A,$5F,$65,$65,$6B,$6B,$00,$00,$00,$01,$02 ; FA06
        .byte $0D,$01,$5A,$75,$30,$B0,$08,$76,$B8,$08,$77,$C0,$08,$78,$C8,$08 ; FA16
        .byte $79,$D0,$08,$7A,$D8,$08,$7B,$E0,$08,$7C,$E8,$08,$7D,$F0,$08,$7D ; FA26
        .byte $F8,$08,$7C,$00,$09,$7C,$08,$09,$7B,$10,$09,$7B,$18,$09,$7A,$20 ; FA36
        .byte $09,$7A,$28,$09,$79,$30,$09,$79,$38,$09,$78,$40,$09,$78,$48,$09 ; FA46
        .byte $77,$50,$09,$77,$58,$09,$76,$60,$09,$76,$68,$09,$75,$70,$09,$75 ; FA56
        .byte $78,$09,$74,$80,$09,$74,$88,$09,$73,$90,$09,$73,$98,$09,$00,$00 ; FA66
        .byte $00,$01,$08,$0F,$03,$1C,$3F,$08,$0A,$08,$3D,$08,$03,$08,$3B,$08 ; FA76
        .byte $04,$08,$39,$08,$05,$08,$37,$08,$06,$08,$35,$08,$07,$08,$33,$08 ; FA86
        .byte $08,$08,$00,$00,$00,$00,$01,$08,$01,$06,$0E,$3C,$00,$0F,$08,$3F ; FA96
        .byte $3E,$3D,$3C,$3B,$3A,$39,$38,$37,$36,$35,$34,$30,$00,$01,$04,$04 ; FAA6
        .byte $01,$28,$8F,$19,$A0,$A0,$97,$A0,$97,$23,$35,$47,$25,$38,$4B,$28 ; FAB6
        .byte $3B,$50,$2A,$3F,$54,$2C,$43,$59,$2F,$47,$5F,$32,$4B,$64,$35,$50 ; FAC6
        .byte $6A,$71,$77,$7F,$86,$8E,$97,$A0,$A9,$B3,$BE,$C9,$D5,$00,$01,$02 ; FAD6
        .byte $01,$01,$01,$BF,$08,$61,$08,$00,$01,$02,$01,$1E,$01,$9F,$A5,$69 ; FAE6
        .byte $08,$8F,$01,$02,$04,$01,$17,$00,$81,$35,$08,$32,$2F,$2C,$2A,$28 ; FAF6
        .byte $25,$23,$21,$1F,$1E,$1C,$1A,$1E,$1F,$21,$23,$25,$28,$2A,$2C,$2F ; FB06
        .byte $32,$35,$01,$02,$04,$03,$10,$9F,$7F,$D4,$08,$9F,$D4,$E1,$9F,$E1 ; FB16
        .byte $EE,$9F,$EE,$FD,$9F,$FD,$0C,$EE,$0C,$1C,$00,$01,$08,$05,$01,$20 ; FB26
        .byte $3A,$78,$0F,$18,$3A,$01,$3A,$02,$3A,$03,$3A,$04,$3A,$05,$3A,$06 ; FB36
        .byte $3A,$07,$3A,$08,$3A,$09,$3A,$0A,$3A,$0B,$3A,$0C,$3A,$0D,$3A,$0E ; FB46
        .byte $3A,$0F,$00,$10,$01,$02,$03,$03,$12,$BA,$84,$55,$08,$B9,$83,$B6 ; FB56
        .byte $83,$B4,$83,$B3,$83,$B2,$83,$B1,$83,$B1,$83,$B1,$83,$B1,$83,$01 ; FB66
        .byte $02,$0D,$06,$09,$3B,$08,$00,$C5,$30,$00,$C5,$3B,$F8,$C3,$30,$F8 ; FB76
        .byte $C3,$01,$02,$04,$03,$09,$CA,$00,$D6,$C0,$AA,$78,$D6,$AA,$78,$D6 ; FB86
        .byte $AA,$78,$00,$01,$02,$05,$05,$2C,$7E,$08,$8E,$00,$BD,$78,$BD,$8E ; FB96
        .byte $B7,$59,$B7,$3F,$B7,$2A,$B9,$1C,$BD,$15,$B5,$0E,$B5,$78,$B7,$AE ; FBA6
        .byte $BD,$59,$B7,$3F,$B9,$2A,$B9,$1C,$BA,$15,$B6,$0E,$B5,$78,$B5,$8E ; FBB6
        .byte $B4,$59,$B3,$3F,$B2,$38,$00,$00,$01,$02,$04,$01,$19,$CA,$00,$6B ; FBC6
        .byte $C0,$87,$7F,$78,$71,$6B,$65,$5F,$5A,$87,$7F,$78,$71,$6B,$65,$5F ; FBD6
        .byte $5A,$87,$7F,$78,$71,$6B,$65,$5F,$5A,$00,$01,$02,$04,$01,$11,$8F ; FBE6
        .byte $00,$8E,$08,$86,$7F,$78,$71,$6A,$64,$5F,$86,$7F,$78,$71,$6A,$64 ; FBF6
        .byte $5F,$59,$54,$50,$01,$08,$01,$32,$00,$0C,$00,$0D,$40,$01,$02,$01 ; FC06
        .byte $01,$08,$4F,$00,$6A,$08,$4F,$4F,$4F,$4F,$4F,$4F,$4F,$00,$01,$02 ; FC16
        .byte $03,$01,$0C,$BF,$00,$D5,$00,$BF,$00,$BF,$00,$BF,$00,$BF,$00,$BF ; FC26
        .byte $00,$00,$00,$01,$02,$0F,$05,$08,$9F,$00,$2A,$29,$3F,$08,$C4,$C1 ; FC36
        .byte $00,$00,$00,$00,$01,$02,$0F,$0A,$04,$3F,$08,$00,$C4,$00,$00,$00 ; FC46
        .byte $00,$01,$04,$00,$00,$00,$1F,$00,$BF,$C0,$01,$04,$00,$00,$00,$1F ; FC56
        .byte $00,$97,$C0,$01,$04,$00,$00,$00,$0F,$00,$87,$C0,$01,$04,$00,$00 ; FC66
        .byte $00,$0F,$00,$6B,$C0,$01,$02,$00,$00,$00,$9B,$49,$70,$28,$01,$02 ; FC76
        .byte $00,$00,$00,$80,$11,$50,$18,$01,$02,$04,$03,$01,$9F,$7F,$BE,$08 ; FC86
        .byte $01,$01,$02,$01,$02,$02,$BF,$08,$25,$F8,$BC,$B0,$01,$02,$04,$02 ; FC96
        .byte $02,$9F,$7F,$8E,$08,$01,$01,$01,$02,$0D,$01,$BD,$9F,$7F,$8E,$08 ; FCA6
        .byte $B0,$AD,$FE,$BF,$92,$01,$3F,$F5,$03,$FE,$EF,$05,$7E,$F8,$02,$BD ; FCB6
        .byte $19,$02,$3D,$9B,$05,$BD,$A5,$02,$FD,$30,$04,$7C,$FB,$01,$BC,$BD ; FCC6
        .byte $03,$7C,$DE,$01,$FC,$30,$04,$BB,$56,$03,$3B,$FE,$04,$FB,$25,$03 ; FCD6
        .byte $7B,$73,$04,$BA,$EF,$05,$3A,$5B,$02,$BA,$56,$03,$FA,$AD,$06,$79 ; FCE6
        .byte $92,$01,$B9,$F5,$03,$79,$EF,$05,$F9,$F8,$02,$B9,$19,$02,$38,$9B ; FCF6
        .byte $05,$F8,$A5,$02,$78,$30,$04,$B7,$FB,$01,$37,$BD,$03,$B7,$DE,$01 ; FD06
        .byte $F6,$30,$04,$76,$56,$03,$B6,$FE,$04,$76,$25,$03,$F5,$73,$04,$B5 ; FD16
        .byte $EF,$05,$35,$5B,$02,$F4,$56,$03,$74,$AD,$06,$B4,$92,$01,$34,$F5 ; FD26
        .byte $03,$B3,$EF,$05,$F3,$F8,$02,$73,$19,$02,$B3,$9B,$05,$72,$A5,$02 ; FD36
        .byte $F2,$30,$04,$B2,$FB,$01,$32,$BD,$03,$F2,$DE,$01,$71,$30,$04,$B1 ; FD46
        .byte $56,$03,$31,$FE,$04,$B1,$25,$03,$F0,$73,$04,$70,$EF,$05,$B0,$5B ; FD56
        .byte $02,$70,$56,$03,$F0,$AD,$06,$B0,$92,$01,$30,$F5,$03,$01,$02,$0C ; FD66
        .byte $03,$42,$44,$00,$47,$C0,$4C,$C0,$50,$C0,$55,$C0,$5A,$C0,$5F,$C0 ; FD76
        .byte $65,$C0,$65,$C0,$6B,$C0,$71,$C0,$78,$C0,$7F,$C0,$87,$C0,$8F,$C0 ; FD86
        .byte $97,$C0,$A0,$C0,$AA,$C0,$B4,$C0,$BF,$C0,$CA,$C0,$D6,$C0,$E3,$C0 ; FD96
        .byte $F0,$C0,$FE,$C0,$0E,$C1,$1E,$C1,$2F,$C1,$41,$C1,$54,$C1,$68,$C1 ; FDA6
        .byte $7D,$C1,$94,$C1,$AC,$C1,$00,$C0,$01,$02,$0C,$05,$16,$FF,$00,$7D ; FDB6
        .byte $C1,$68,$C1,$54,$C1,$2F,$C1,$1E,$C1,$FE,$C0,$1E,$C1,$2F,$C1,$54 ; FDC6
        .byte $C1,$68,$C1,$7D,$C1,$00,$C0,$01,$02,$05,$08,$0E,$9F,$7F,$7C,$09 ; FDD6
        .byte $9F,$93,$9F,$7C,$9F,$93,$9F,$7C,$9F,$93,$9F,$7C,$00,$00,$01,$04 ; FDE6
        .byte $00,$32,$00,$01,$00,$81,$18 ; FDF6
tbl_song_ntracks:
        .byte $03 ; FDFD
tbl_song_first_track:
        .byte $00,$03,$00,$03,$00 ; FDFE
tbl_song_records:
        .byte $05 ; FE03
tbl_song_records_hi:
        .byte $FE ; FE04
song0_track_records:
        .byte $00,$00,$15,$FE,$15,$01,$78,$FE,$2A,$02,$D1,$FE,$3F,$03,$28,$FF ; FE05
song0_pulse1:
        .byte $71,$03,$12,$00,$A1,$3A,$C1,$2A,$35,$06,$38,$06,$31,$06,$35,$06 ; FE15
        .byte $36,$0C,$36,$06,$31,$06,$26,$06,$26,$06,$2A,$06,$2B,$06,$31,$03 ; FE25
        .byte $33,$03,$31,$03,$30,$03,$31,$06,$35,$03,$36,$03,$26,$06,$28,$06 ; FE35
        .byte $2A,$06,$2B,$06,$31,$03,$33,$03,$31,$03,$30,$03,$31,$0C,$35,$06 ; FE45
        .byte $38,$06,$31,$06,$35,$06,$36,$03,$35,$03,$36,$03,$38,$03,$3A,$06 ; FE55
        .byte $36,$06,$35,$06,$38,$06,$31,$06,$35,$06,$36,$06,$36,$06,$36,$0C ; FE65
        .byte $B0,$04,$FF ; FE75
song0_pulse2:
        .byte $71,$03,$14,$00,$A1,$2A,$C1,$2A,$31,$06,$35,$06,$28,$06,$31,$06 ; FE78
        .byte $26,$06,$2A,$06,$26,$0C,$2A,$06,$2A,$06,$31,$06,$33,$06,$26,$06 ; FE88
        .byte $26,$06,$26,$06,$31,$03,$31,$03,$31,$06,$2A,$06,$28,$06,$26,$06 ; FE98
        .byte $26,$06,$26,$06,$2A,$06,$31,$06,$25,$06,$31,$06,$2B,$06,$31,$06 ; FEA8
        .byte $26,$06,$26,$06,$2A,$06,$26,$06,$25,$06,$31,$06,$2B,$06,$31,$06 ; FEB8
        .byte $26,$06,$2A,$06,$26,$0C,$B0,$04,$FF ; FEC8
song0_triangle:
        .byte $71,$03,$16,$00,$A2,$3A,$C1,$2A,$28,$06,$31,$06,$35,$06,$31,$06 ; FED1
        .byte $26,$09,$26,$03,$26,$0C,$26,$09,$26,$03,$28,$09,$2A,$03,$26,$09 ; FEE1
        .byte $26,$03,$28,$09,$2A,$03,$26,$09,$26,$03,$28,$09,$2A,$03,$26,$09 ; FEF1
        .byte $26,$03,$28,$09,$2A,$03,$21,$09,$21,$03,$23,$09,$25,$03,$26,$09 ; FF01
        .byte $26,$03,$28,$09,$2A,$03,$21,$09,$21,$03,$23,$09,$25,$03,$26,$09 ; FF11
        .byte $26,$03,$26,$0C,$B0,$04,$FF ; FF21
song0_noise:
        .byte $71,$02,$00,$00,$C1,$10,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06 ; FF28
        .byte $08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06 ; FF38
        .byte $08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06 ; FF48
        .byte $08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06 ; FF58
        .byte $08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06,$08,$06,$0A,$06 ; FF68
        .byte $08,$06,$0A,$06,$08,$03,$08,$03,$B0,$04,$FF,$FF,$FF,$FF,$FF,$FF ; FF78
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00 ; FF88
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FF98
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FFA8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FFB8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FFC8
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; FFD8
testapp_reset:
        sei                             ; FFE0
        cld                             ; FFE1
        lda  #$00                       ; FFE2
        sta  PPU_CTRL                   ; FFE4
        sta  PPU_MASK                   ; FFE7
        sta  MMC3_MIRRORING             ; FFEA
        jmp  testapp_start              ; FFED
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FFF0
vec_nmi:
        .word $06A0 ; FFFA
vec_reset:
        .byte $E0,$FF ; FFFC
vec_irq:
        .byte $23,$A0 ; FFFE
