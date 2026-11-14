; Sup 400-in-1 English menu, 8 KiB PRG bank $3D (file 0x7A000), mapped at CPU $A000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK3D"

relaunch_saved_game:
        jsr  read_pad_0327_thunk        ; A000
        lda  pad_state                  ; A003
        bne  relaunch_saved_game        ; A006
        lda  #$00                       ; A008
        sta  PPU_CTRL                   ; A00A
        sta  PPU_MASK                   ; A00D
        sta  APU_STATUS                 ; A010
        ldy  #$20                       ; A013
        sty  PPU_ADDR                   ; A015
        lda  #$00                       ; A018
        sta  PPU_ADDR                   ; A01A
        ldx  #$00                       ; A01D
loc_A01F:
        sta  PPU_DATA                   ; A01F
        inx                             ; A022
        bne  loc_A01F                   ; A023
        iny                             ; A025
        cpy  #$40                       ; A026
        bne  loc_A01F                   ; A028
        ldx  #$3F                       ; A02A
        stx  PPU_ADDR                   ; A02C
        ldx  #$00                       ; A02F
        stx  PPU_ADDR                   ; A031
        lda  #$0E                       ; A034
loc_A036:
        sta  PPU_DATA                   ; A036
        inx                             ; A039
        cpx  #$20                       ; A03A
        bne  loc_A036                   ; A03C
        lda  #$00                       ; A03E
        sta  PPU_ADDR                   ; A040
        sta  PPU_ADDR                   ; A043
        lda  #$00                       ; A046
        sta  PPU_ADDR                   ; A048
        sta  PPU_ADDR                   ; A04B
        ldx  #$20                       ; A04E
        ldy  #$00                       ; A050
        lda  #$00                       ; A052
loc_A054:
        sta  PPU_DATA                   ; A054
        iny                             ; A057
        bne  loc_A054                   ; A058
        dex                             ; A05A
        bne  loc_A054                   ; A05B
        lda  #$00                       ; A05D
        tax                             ; A05F
loc_A060:
        sta  $00,x                      ; A060
        sta  $0100,x                    ; A062
        sta  $0200,x                    ; A065
        sta  $0300,x                    ; A068
        sta  $0400,x                    ; A06B
        sta  $0500,x                    ; A06E
        sta  $0700,x                    ; A071
        inx                             ; A074
        bne  loc_A060                   ; A075
        lda  cursor_row                 ; A077
        asl  a                          ; A07A
        tax                             ; A07B
        lda  $064D,x                    ; A07C
        sta  $010C                      ; A07F
        lda  $064E,x                    ; A082
        sta  $010D                      ; A085
        asl  $010C                      ; A088
        rol  $010D                      ; A08B
        asl  $010C                      ; A08E
        rol  $010D                      ; A091
        lda  #$00                       ; A094
        asl  a                          ; A096
        tax                             ; A097
        lda  tbl_list_order_ptrs,x      ; A098
        sta  $CD                        ; A09B
        lda  dat_CE31,x                 ; A09D
        sta  $CE                        ; A0A0
        lda  $CD                        ; A0A2
        clc                             ; A0A4
        adc  $010C                      ; A0A5
        sta  $CB                        ; A0A8
        lda  $CE                        ; A0AA
        adc  $010D                      ; A0AC
        sta  $CC                        ; A0AF
        ldy  #$00                       ; A0B1
        lda  ($CB),y                    ; A0B3
        jsr  store_069F_06E0            ; A0B5
        iny                             ; A0B8
        lda  ($CB),y                    ; A0B9
        sta  game_number_hi             ; A0BB
loc_A0BE:
        asl  game_number_lo             ; A0BE
        rol  game_number_hi             ; A0C1
        lda  #$F1                       ; A0C4
        clc                             ; A0C6
        adc  game_number_lo             ; A0C7
        sta  $C5                        ; A0CA
        lda  #$E7                       ; A0CC
        adc  game_number_hi             ; A0CE
        sta  $C6                        ; A0D1
        ldy  #$00                       ; A0D3
        lda  ($C5),y                    ; A0D5
        sta  $C3                        ; A0D7
        iny                             ; A0D9
        lda  ($C5),y                    ; A0DA
        sta  $C4                        ; A0DC
        ldy  #$00                       ; A0DE
        lda  ($C3),y                    ; A0E0
        sta  $0100                      ; A0E2
        iny                             ; A0E5
        lda  ($C3),y                    ; A0E6
        sta  $0101                      ; A0E8
        iny                             ; A0EB
        lda  ($C3),y                    ; A0EC
        sta  $0102                      ; A0EE
        iny                             ; A0F1
        lda  ($C3),y                    ; A0F2
        sta  $0103                      ; A0F4
        iny                             ; A0F7
        lda  ($C3),y                    ; A0F8
        sta  $0104                      ; A0FA
        iny                             ; A0FD
        lda  ($C3),y                    ; A0FE
        sta  $0105                      ; A100
        iny                             ; A103
        lda  ($C3),y                    ; A104
        sta  $0106                      ; A106
        iny                             ; A109
        lda  ($C3),y                    ; A10A
        sta  $0107                      ; A10C
        iny                             ; A10F
        lda  ($C3),y                    ; A110
        sta  $0108                      ; A112
        iny                             ; A115
        lda  ($C3),y                    ; A116
        sta  $0109                      ; A118
        iny                             ; A11B
        lda  ($C3),y                    ; A11C
        sta  $010A                      ; A11E
        iny                             ; A121
        lda  ($C3),y                    ; A122
        sta  $010B                      ; A124
        jsr  relaunch_prepare           ; A127
        lda  $0108                      ; A12A
        sta  MMC3_MIRRORING             ; A12D
        lda  #$40                       ; A130
        sta  $01E0                      ; A132
        jmp  relaunch_continue          ; A135
        .byte $44,$A1,$9D,$00,$02,$E8,$D0,$F7,$4C,$00,$02,$60,$AD,$14,$01,$8D ; A138
        .byte $00,$60,$AD,$15,$01,$8D,$01,$60,$AD,$16,$01,$8D,$02,$60,$AD,$17 ; A148
        .byte $01,$8D,$03,$60,$A9,$00,$8D,$11,$01,$A9,$06,$8D,$00,$80,$AD,$1C ; A158
        .byte $01,$18,$6D,$11,$01,$8D,$01,$80,$AD,$11,$01,$0A,$0A,$0A,$AA,$A0 ; A168
        .byte $00,$8C,$00,$80,$8E,$01,$80,$E8,$E8,$C8,$8C,$00,$80,$8E,$01,$80 ; A178
        .byte $E8,$E8,$C8,$8C,$00,$80,$8E,$01,$80,$E8,$C8,$8C,$00,$80,$8E,$01 ; A188
        .byte $80,$E8,$C8,$8C,$00,$80,$8E,$01,$80,$E8,$C8,$8C,$00,$80,$8E,$01 ; A198
        .byte $80,$A9,$00,$8D,$06,$20,$8D,$06,$20,$85,$C3,$A9,$80,$85,$C4,$A2 ; A1A8
        .byte $20,$A0,$00,$B1,$C3,$8D,$07,$20,$C8,$D0,$F8,$E6,$C4,$CA,$D0,$F3 ; A1B8
        .byte $EE,$11,$01,$AD,$11,$01,$CD,$1D,$01,$90,$8E,$A9,$00,$8D,$06,$20 ; A1C8
        .byte $8D,$06,$20,$78,$D8,$A9,$C0,$8D,$17,$40,$A2,$08,$2C,$02,$20,$10 ; A1D8
        .byte $FB,$2C,$02,$20,$30,$FB,$CA,$10,$F3,$9A,$A2,$06,$A0,$0C,$8E,$00 ; A1E8
        .byte $80,$8C,$01,$80,$E8,$C8,$8E,$00,$80,$8C,$01,$80,$AD,$18,$01,$8D ; A1F8
        .byte $00,$60,$AD,$19,$01,$8D,$01,$60,$AD,$1A,$01,$8D,$02,$60,$AD,$1B ; A208
        .byte $01,$8D,$03,$60,$4C,$00,$01,$60 ; A218
relaunch_prepare:
        lda  $0103                      ; A220
        cmp  #$02                       ; A223
        beq  loc_A259                   ; A225
        cmp  #$11                       ; A227
        beq  loc_A25F                   ; A229
        cmp  #$12                       ; A22B
        beq  loc_A265                   ; A22D
        cmp  #$82                       ; A22F
        beq  loc_A265                   ; A231
        cmp  #$44                       ; A233
        beq  loc_A26B                   ; A235
        cmp  #$54                       ; A237
        beq  loc_A271                   ; A239
        cmp  #$64                       ; A23B
        beq  loc_A277                   ; A23D
        cmp  #$73                       ; A23F
        beq  loc_A27D                   ; A241
        cmp  #$92                       ; A243
        beq  loc_A265                   ; A245
        cmp  #$94                       ; A247
        beq  loc_A26B                   ; A249
        cmp  #$99                       ; A24B
        beq  loc_A265                   ; A24D
        cmp  #$A9                       ; A24F
        beq  loc_A265                   ; A251
        jsr  sub_A2A4                   ; A253
        jmp  loc_A283                   ; A256
loc_A259:
        ; static (not seen in traces)
        jsr  sub_A2EC                   ; A259
        jmp  loc_A283                   ; A25C
loc_A25F:
        jsr  sub_A2C8                   ; A25F
        jmp  loc_A283                   ; A262
loc_A265:
        jsr  sub_A310                   ; A265
        jmp  loc_A283                   ; A268
loc_A26B:
        jsr  sub_A344                   ; A26B
        jmp  loc_A283                   ; A26E
loc_A271:
        jsr  sub_A368                   ; A271
        jmp  loc_A283                   ; A274
loc_A277:
        jsr  sub_A38C                   ; A277
        jmp  loc_A283                   ; A27A
loc_A27D:
        jsr  sub_A3B0                   ; A27D
        jmp  loc_A283                   ; A280
loc_A283:
        jsr  sub_A3D4                   ; A283
        jsr  sub_A421                   ; A286
        rts                             ; A289
sfx_beep:
        lda  #$FF                       ; A28A
        sta  APU_4004                   ; A28C
        lda  #$AA                       ; A28F
        sta  APU_4005                   ; A291
        lda  #$78                       ; A294
        sta  APU_4006                   ; A296
        lda  #$00                       ; A299
        sta  APU_4007                   ; A29B
        lda  #$0F                       ; A29E
        sta  APU_STATUS                 ; A2A0
        rts                             ; A2A3
sub_A2A4:
        lda  #$20                       ; A2A4
        sta  $011D                      ; A2A6
        lda  #$00                       ; A2A9
        sta  $0114                      ; A2AB
        lda  #$80                       ; A2AE
        sta  $0115                      ; A2B0
        lda  #$00                       ; A2B3
        sta  $0117                      ; A2B5
        lda  #$00                       ; A2B8
        sta  $0118                      ; A2BA
        lda  #$80                       ; A2BD
        sta  $0119                      ; A2BF
        lda  #$80                       ; A2C2
        sta  $011B                      ; A2C4
        rts                             ; A2C7
sub_A2C8:
        ; static (not seen in traces)
        lda  #$10                       ; A2C8
        sta  $011D                      ; A2CA
        lda  #$C0                       ; A2CD
        sta  $0114                      ; A2CF
        lda  #$80                       ; A2D2
        sta  $0115                      ; A2D4
        lda  #$00                       ; A2D7
        sta  $0117                      ; A2D9
        lda  #$80                       ; A2DC
        sta  $0118                      ; A2DE
        lda  #$80                       ; A2E1
        sta  $0119                      ; A2E3
        lda  #$80                       ; A2E6
        sta  $011B                      ; A2E8
        rts                             ; A2EB
sub_A2EC:
        lda  #$20                       ; A2EC
        sta  $011D                      ; A2EE
        lda  #$40                       ; A2F1
        sta  $0114                      ; A2F3
        lda  #$80                       ; A2F6
        sta  $0115                      ; A2F8
        lda  #$00                       ; A2FB
        sta  $0117                      ; A2FD
        lda  #$40                       ; A300
        sta  $0118                      ; A302
        lda  #$80                       ; A305
        sta  $0119                      ; A307
        lda  #$80                       ; A30A
        sta  $011B                      ; A30C
        rts                             ; A30F
sub_A310:
        lda  #$10                       ; A310
        sta  $011D                      ; A312
        lda  #$C0                       ; A315
        sta  $0114                      ; A317
        lda  #$80                       ; A31A
        sta  $0115                      ; A31C
        lda  #$00                       ; A31F
        sta  $0117                      ; A321
        lda  #$C0                       ; A324
        sta  $0118                      ; A326
        lda  #$80                       ; A329
        sta  $0119                      ; A32B
        lda  #$80                       ; A32E
        sta  $011B                      ; A330
        lda  $0104                      ; A333
        and  #$F8                       ; A336
        sta  $0104                      ; A338
        lda  $0106                      ; A33B
        and  #$F0                       ; A33E
        sta  $0106                      ; A340
        rts                             ; A343
sub_A344:
        lda  #$04                       ; A344
        sta  $011D                      ; A346
        lda  #$C0                       ; A349
        sta  $0114                      ; A34B
        lda  #$80                       ; A34E
        sta  $0115                      ; A350
        lda  #$00                       ; A353
        sta  $0117                      ; A355
        lda  #$C0                       ; A358
        sta  $0118                      ; A35A
        lda  #$82                       ; A35D
        sta  $0119                      ; A35F
        lda  #$10                       ; A362
        sta  $011B                      ; A364
        rts                             ; A367
sub_A368:
        lda  #$02                       ; A368
        sta  $011D                      ; A36A
        lda  #$C0                       ; A36D
        sta  $0114                      ; A36F
        lda  #$80                       ; A372
        sta  $0115                      ; A374
        lda  #$00                       ; A377
        sta  $0117                      ; A379
        lda  #$C0                       ; A37C
        sta  $0118                      ; A37E
        lda  #$82                       ; A381
        sta  $0119                      ; A383
        lda  #$10                       ; A386
        sta  $011B                      ; A388
        rts                             ; A38B
sub_A38C:
        lda  #$01                       ; A38C
        sta  $011D                      ; A38E
        lda  #$C0                       ; A391
        sta  $0114                      ; A393
        lda  #$80                       ; A396
        sta  $0115                      ; A398
        lda  #$00                       ; A39B
        sta  $0117                      ; A39D
        lda  #$C0                       ; A3A0
        sta  $0118                      ; A3A2
        lda  #$82                       ; A3A5
        sta  $0119                      ; A3A7
        lda  #$90                       ; A3AA
        sta  $011B                      ; A3AC
        rts                             ; A3AF
sub_A3B0:
        lda  #$01                       ; A3B0
        sta  $011D                      ; A3B2
        lda  #$C0                       ; A3B5
        sta  $0114                      ; A3B7
        lda  #$80                       ; A3BA
        sta  $0115                      ; A3BC
        lda  #$00                       ; A3BF
        sta  $0117                      ; A3C1
        lda  #$C0                       ; A3C4
        sta  $0118                      ; A3C6
        lda  #$80                       ; A3C9
        sta  $0119                      ; A3CB
        lda  #$90                       ; A3CE
        sta  $011B                      ; A3D0
        rts                             ; A3D3
sub_A3D4:
        lda  $0106                      ; A3D4
        and  #$0F                       ; A3D7
        sta  $011C                      ; A3D9
        lda  $0106                      ; A3DC
        lsr  a                          ; A3DF
        lsr  a                          ; A3E0
        lsr  a                          ; A3E1
        lsr  a                          ; A3E2
        and  #$07                       ; A3E3
        ora  $0114                      ; A3E5
        sta  $0114                      ; A3E8
        lda  $0106                      ; A3EB
        lsr  a                          ; A3EE
        lsr  a                          ; A3EF
        lsr  a                          ; A3F0
        and  #$10                       ; A3F1
        ora  $0115                      ; A3F3
        sta  $0115                      ; A3F6
        lda  $0107                      ; A3F9
        asl  a                          ; A3FC
        asl  a                          ; A3FD
        and  #$04                       ; A3FE
        ora  $0115                      ; A400
        sta  $0115                      ; A403
        lda  $0107                      ; A406
        asl  a                          ; A409
        asl  a                          ; A40A
        and  #$08                       ; A40B
        ora  $0115                      ; A40D
        sta  $0115                      ; A410
        lda  $0107                      ; A413
        asl  a                          ; A416
        asl  a                          ; A417
        and  #$30                       ; A418
        ora  $0114                      ; A41A
        sta  $0114                      ; A41D
        rts                             ; A420
sub_A421:
        lda  $0104                      ; A421
        lsr  a                          ; A424
        lsr  a                          ; A425
        lsr  a                          ; A426
        and  #$07                       ; A427
        ora  $0118                      ; A429
        sta  $0118                      ; A42C
        lda  $0104                      ; A42F
        lsr  a                          ; A432
        lsr  a                          ; A433
        and  #$10                       ; A434
        ora  $0119                      ; A436
        sta  $0119                      ; A439
        lda  $0104                      ; A43C
        lsr  a                          ; A43F
        lsr  a                          ; A440
        lsr  a                          ; A441
        lsr  a                          ; A442
        lsr  a                          ; A443
        and  #$04                       ; A444
        ora  $0119                      ; A446
        sta  $0119                      ; A449
        lda  $0105                      ; A44C
        asl  a                          ; A44F
        asl  a                          ; A450
        asl  a                          ; A451
        and  #$08                       ; A452
        ora  $0119                      ; A454
        sta  $0119                      ; A457
        lda  $0105                      ; A45A
        asl  a                          ; A45D
        asl  a                          ; A45E
        asl  a                          ; A45F
        and  #$30                       ; A460
        ora  $0118                      ; A462
        sta  $0118                      ; A465
        lda  $0104                      ; A468
        asl  a                          ; A46B
        and  #$0E                       ; A46C
        ora  $011B                      ; A46E
        sta  $011B                      ; A471
        rts                             ; A474
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A475
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A485
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A495
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4A5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4B5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4C5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4D5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4E5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A4F5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A505
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A515
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A525
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A535
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A545
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A555
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A565
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A575
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A585
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A595
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5A5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5B5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5C5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5D5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5E5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A5F5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A605
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A615
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A625
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A635
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A645
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A655
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A665
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A675
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A685
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A695
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6A5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6B5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6C5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6D5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6E5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6F5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A705
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A715
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A725
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A735
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A745
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A755
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A765
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A775
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A785
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A795
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7A5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7B5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7C5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7D5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7E5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A7F5
store_069F_06E0:
        sta  game_number_lo             ; A800
        sta  $06E0                      ; A803
        rts                             ; A806
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A807
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A817
        .byte $00,$00,$00,$00,$00 ; A827
launch_game:
        cld                             ; A82C
        jsr  ppu_off_wait_vblank        ; A82D
        ldx  #$FF                       ; A830
loc_A832:
        inx                             ; A832
        lda  ram_stub_game_launch,x     ; A833
        sta  $0400,x                    ; A836
        cpx  #$60                       ; A839
        bne  loc_A832                   ; A83B
        jsr  sub_A940                   ; A83D
        jsr  prelaunch_mirroring_save_ptrs; A840
        lda  #$00                       ; A843
        sta  APU_STATUS                 ; A845
        jsr  sub_ACA0                   ; A848
        jmp  $0400                      ; A84B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$B0,$05,$A9,$8D,$8D,$02,$04,$20,$75,$AB ; A84E
        .byte $A9,$00,$8D,$15,$40,$20,$A0,$AC,$4C,$00,$04,$FF,$FF,$FF,$FF,$FF ; A85E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A86E
        .byte $FF,$FF ; A87E
ppu_off_wait_vblank:
        lda  #$00                       ; A880
        sta  PPU_CTRL                   ; A882
        sta  PPU_MASK                   ; A885
loc_A888:
        lda  PPU_STATUS                 ; A888
        bmi  loc_A888                   ; A88B
loc_A88D:
        lda  PPU_STATUS                 ; A88D
        bpl  loc_A88D                   ; A890
        jsr  init_reg_pointer_table     ; A892
        rts                             ; A895
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A896
init_reg_pointer_table:
        ldx  #$00                       ; A8A0
loc_A8A2:
        lda  tbl_reg_pointers,x         ; A8A2
        sta  regptr_410B,x              ; A8A5
        inx                             ; A8A7
        cpx  #$0F                       ; A8A8
        bne  loc_A8A2                   ; A8AA
        rts                             ; A8AC
        .byte $20,$00,$03,$60 ; A8AD
tbl_reg_pointers:
        .byte $0B,$41,$1A,$20,$00,$41,$18,$20,$3F,$20,$30,$00,$00,$00,$00,$FF ; A8B1
relaunch_continue:
        lda  $0618                      ; A8C1
        beq  loc_A8D1                   ; A8C4
        ; static (not seen in traces)
        tax                             ; A8C6
loc_A8C7:
        lda  $18                        ; A8C7
        clc                             ; A8C9
        adc  #$0A                       ; A8CA
        sta  $18                        ; A8CC
        dex                             ; A8CE
        bne  loc_A8C7                   ; A8CF
loc_A8D1:
        lda  cursor_row                 ; A8D1
        clc                             ; A8D4
        adc  $18                        ; A8D5
        sta  $18                        ; A8D7
        lda  $0618                      ; A8D9
        cmp  #$19                       ; A8DC
        bcc  loc_A8EB                   ; A8DE
        ; static (not seen in traces)
        lda  #$01                       ; A8E0
        sta  $19                        ; A8E2
        lda  $0618                      ; A8E4
        cmp  #$19                       ; A8E7
        beq  loc_A8EE                   ; A8E9
loc_A8EB:
        jmp  launch_game                ; A8EB
loc_A8EE:
        ; static (not seen in traces)
        lda  $18                        ; A8EE
        cmp  #$04                       ; A8F0
        bcc  loc_A8F8                   ; A8F2
        lda  #$00                       ; A8F4
        sta  $19                        ; A8F6
loc_A8F8:
        jmp  launch_game                ; A8F8
        .byte $FF,$FF,$FF,$FF,$FF ; A8FB
sub_A900:
        ldx  #$00                       ; A900
        stx  $02                        ; A902
        jsr  sub_A91B                   ; A904
        lda  $28                        ; A907
        nop                             ; A909
        nop                             ; A90A
        asl  a                          ; A90B
        asl  a                          ; A90C
        asl  a                          ; A90D
        tay                             ; A90E
loc_A90F:
        lda  ($02),y                    ; A90F
        sta  launch_p0,x                ; A911
        iny                             ; A914
        inx                             ; A915
        cpx  #$08                       ; A916
        bne  loc_A90F                   ; A918
        rts                             ; A91A
sub_A91B:
        lda  $19                        ; A91B
        bne  loc_A925                   ; A91D
        lda  #$B0                       ; A91F
        sta  $03                        ; A921
        bne  loc_A929                   ; A923
loc_A925:
        ; static (not seen in traces)
        lda  #$B8                       ; A925
        sta  $03                        ; A927
loc_A929:
        lda  $28                        ; A929
        nop                             ; A92B
        nop                             ; A92C
        and  #$E0                       ; A92D
        lsr  a                          ; A92F
        lsr  a                          ; A930
        lsr  a                          ; A931
        lsr  a                          ; A932
        lsr  a                          ; A933
        ora  $03                        ; A934
        sta  $03                        ; A936
        rts                             ; A938
        .byte $FF,$00,$00,$00,$00,$00,$00 ; A939
sub_A940:
        lda  $19                        ; A940
        beq  loc_A955                   ; A942
        ; static (not seen in traces)
        lda  $18                        ; A944
        cmp  #$39                       ; A946
        bcc  loc_A955                   ; A948
        lda  #$00                       ; A94A
        sta  $19                        ; A94C
        sec                             ; A94E
        lda  $18                        ; A94F
        sbc  #$39                       ; A951
        sta  $18                        ; A953
loc_A955:
        jsr  sub_AE00                   ; A955
        jsr  sub_A900                   ; A958
        jsr  sub_A960                   ; A95B
        rts                             ; A95E
        .byte $00 ; A95F
sub_A960:
        lda  $18                        ; A960
        cmp  #$0C                       ; A962
        bne  loc_A979                   ; A964
        ; static (not seen in traces)
        lda  $28                        ; A966
        cmp  #$38                       ; A968
        bne  loc_A979                   ; A96A
        ldx  #$00                       ; A96C
loc_A96E:
        lda  dat_A980,x                 ; A96E
        sta  launch_p0,x                ; A971
        inx                             ; A974
        cpx  #$08                       ; A975
        bne  loc_A96E                   ; A977
loc_A979:
        rts                             ; A979
        .byte $00,$00,$00,$00,$00,$00 ; A97A
dat_A980:
        .byte $01,$00,$06,$1E,$60,$00,$02,$36,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A980
        .byte $A5,$19,$D0,$06,$A5,$18,$C9,$04,$F0,$01,$60,$A9,$80,$8D,$34,$04 ; A990
        .byte $A9,$01,$8D,$32,$04,$A9,$1C,$8D,$33,$04,$A9,$02,$8D,$36,$04,$A9 ; A9A0
        .byte $10,$8D,$35,$04,$60,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte $A2,$00,$86,$02,$20,$DB,$A9,$A5,$18,$EA,$EA,$0A,$0A,$0A,$A8,$B1 ; A9C0
        .byte $02,$9D,$30,$04,$C8,$E8,$E0,$08,$D0,$F5,$60,$A5,$19,$D0,$06,$A9 ; A9D0
set_chr_banks_mmc3:
        nop                             ; A9E0
        asl  a                          ; A9E1
        asl  a                          ; A9E2
        asl  a                          ; A9E3
        ldx  #$00                       ; A9E4
loc_A9E6:
        stx  MMC3_BANK_SELECT           ; A9E6
        sta  MMC3_BANK_DATA             ; A9E9
        clc                             ; A9EC
        adc  #$02                       ; A9ED
        inx                             ; A9EF
        cpx  #$02                       ; A9F0
        bne  loc_A9E6                   ; A9F2
        clc                             ; A9F4
        ldx  #$02                       ; A9F5
loc_A9F7:
        stx  MMC3_BANK_SELECT           ; A9F7
        sta  MMC3_BANK_DATA             ; A9FA
        adc  #$01                       ; A9FD
        inx                             ; A9FF
        cpx  #$06                       ; AA00
        bne  loc_A9F7                   ; AA02
        rts                             ; AA04
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AA05
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AA15
sub_AA20:
        pha                             ; AA20
        tya                             ; AA21
        pha                             ; AA22
        txa                             ; AA23
        pha                             ; AA24
        ldx  #$08                       ; AA25
loc_AA27:
        lda  #$00                       ; AA27
        sta  $062B,x                    ; AA29
        dex                             ; AA2C
        bpl  loc_AA27                   ; AA2D
        pla                             ; AA2F
        tax                             ; AA30
        pla                             ; AA31
        tay                             ; AA32
        pla                             ; AA33
        jsr  print_string_struct        ; AA34
        rts                             ; AA37
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; AA38
read_pad_edge:
        ldx  #$01                       ; AA40
        stx  JOY1                       ; AA42
        dex                             ; AA45
        stx  JOY1                       ; AA46
        ldx  #$08                       ; AA49
loc_AA4B:
        lda  JOY1                       ; AA4B
        lsr  a                          ; AA4E
        rol  pad_new_aa40               ; AA4F
        dex                             ; AA51
        bne  loc_AA4B                   ; AA52
        lda  pad_new_aa40               ; AA54
        tay                             ; AA56
        eor  pad_held_aa40              ; AA57
        and  pad_new_aa40               ; AA59
        sta  pad_new_aa40               ; AA5B
        sty  pad_held_aa40              ; AA5D
        rts                             ; AA5F
check_AB_support_app:
        jsr  read_pad_edge              ; AA60
        lda  pad_held_aa40              ; AA63
        cmp  #$C0                       ; AA65
        beq  loc_AA6A                   ; AA67
        rts                             ; AA69
loc_AA6A:
        ldx  #$30                       ; AA6A
loc_AA6C:
        lda  ram_stub_support_app,x     ; AA6C
        sta  $0400,x                    ; AA6F
        dex                             ; AA72
        bpl  loc_AA6C                   ; AA73
        jmp  $0400                      ; AA75
; ---- RAM stub: copied to $0400 (49 bytes) by check_AB_support_app
ram_stub_support_app:
        ; static (not seen in traces)
        lda  #$00                       ; AA78
        sta  OB_PRG_OUTER_4100          ; AA7A
        lda  #$04                       ; AA7D
        sta  OB_PRG_MODE_410B           ; AA7F
        lda  #$36                       ; AA82
        sta  OB_PRG_C000                ; AA84
        lda  #$37                       ; AA87
        sta  OB_PRG_E000                ; AA89
        lda  #$10                       ; AA8C
        sta  OB_CHR_2018                ; AA8E
        lda  #$A6                       ; AA91
        sta  OB_CHR_201A                ; AA93
        lda  #$1F                       ; AA96
        sta  REG_413F                   ; AA98
        lda  #$0B                       ; AA9B
        sta  REG_4138                   ; AA9D
        lda  #$0F                       ; AAA0
        sta  REG_4139                   ; AAA2
        jmp  (vec_reset)                ; AAA5
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAA8
launch_from_chinese_menu:
        ; static (not seen in traces)
        lda  cn_page                    ; AAB1
        beq  loc_AAC1                   ; AAB4
        tax                             ; AAB6
loc_AAB7:
        lda  $18                        ; AAB7
        clc                             ; AAB9
        adc  #$0A                       ; AABA
        sta  $18                        ; AABC
        dex                             ; AABE
        bne  loc_AAB7                   ; AABF
loc_AAC1:
        lda  cn_row                     ; AAC1
        clc                             ; AAC4
        adc  $18                        ; AAC5
        sta  $18                        ; AAC7
        lda  cn_page                    ; AAC9
        cmp  #$19                       ; AACC
        bcc  loc_AADB                   ; AACE
        lda  #$01                       ; AAD0
        sta  $19                        ; AAD2
        lda  cn_page                    ; AAD4
        cmp  #$19                       ; AAD7
        beq  loc_AADE                   ; AAD9
loc_AADB:
        jmp  launch_game                ; AADB
loc_AADE:
        lda  $18                        ; AADE
        cmp  #$04                       ; AAE0
        bcc  loc_AAE8                   ; AAE2
        lda  #$00                       ; AAE4
        sta  $19                        ; AAE6
loc_AAE8:
        jmp  launch_game                ; AAE8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAEB
        .byte $00,$00,$00,$00,$00 ; AAFB
; ---- RAM stub: copied to $0400 (96 bytes) by launch_game
ram_stub_game_launch:
        ; static (not seen in traces)
        ldy  #$00                       ; AB00
        lda  launch_410B                ; AB02
        sta  (regptr_410B),y            ; AB05
        and  #$0F                       ; AB07
        cmp  #$04                       ; AB09
        bne  loc_AB1F                   ; AB0B
        ldx  #$00                       ; AB0D
        lda  launch_prg_bank            ; AB0F
loc_AB12:
        sta  OB_PRG_8000,x              ; AB12
        clc                             ; AB15
        adc  #$01                       ; AB16
        inx                             ; AB18
        cpx  #$04                       ; AB19
        bne  loc_AB12                   ; AB1B
        beq  loc_AB31                   ; AB1D
loc_AB1F:
        lda  launch_prg_bank            ; AB1F
        sta  OB_PRG_8000                ; AB22
        sta  OB_PRG_C000                ; AB25
        clc                             ; AB28
        adc  #$01                       ; AB29
        sta  OB_PRG_A000                ; AB2B
        sta  OB_PRG_E000                ; AB2E
loc_AB31:
        lda  launch_2018                ; AB31
        and  #$F0                       ; AB34
        sta  (regptr_2018),y            ; AB36
        lda  launch_p0                  ; AB38
        beq  loc_AB41                   ; AB3B
        lda  #$80                       ; AB3D
        bne  loc_AB43                   ; AB3F
loc_AB41:
        lda  #$00                       ; AB41
loc_AB43:
        sta  REG_4118                   ; AB43
        lda  launch_p0                  ; AB46
        nop                             ; AB49
        nop                             ; AB4A
        asl  a                          ; AB4B
        asl  a                          ; AB4C
        asl  a                          ; AB4D
        ora  launch_outer_lo            ; AB4E
        sta  (regptr_4100),y            ; AB51
        lda  launch_201A                ; AB53
        sta  (regptr_201A),y            ; AB56
        jmp  (vec_reset)                ; AB58
        .byte $FF,$FF,$6C,$FC,$FF,$E9,$A9,$00,$8D,$15,$40,$A2,$00,$A9,$00,$9D ; AB5B
        .byte $00,$40,$E8,$E0,$20,$D0,$F8,$EA,$EA,$EA ; AB6B
prelaunch_mirroring_save_ptrs:
        lda  launch_410B                ; AB75
        and  #$80                       ; AB78
        bne  loc_AB83                   ; AB7A
        lda  #$00                       ; AB7C
        sta  MMC3_MIRRORING             ; AB7E
        beq  loc_AB88                   ; AB81
loc_AB83:
        ; static (not seen in traces)
        lda  #$01                       ; AB83
        sta  MMC3_MIRRORING             ; AB85
loc_AB88:
        lda  launch_410B                ; AB88
        and  #$7F                       ; AB8B
        sta  launch_410B                ; AB8D
        ldx  #$07                       ; AB90
loc_AB92:
        lda  regptr_410B,x              ; AB92
        sta  $0100,x                    ; AB94
        dex                             ; AB97
        bpl  loc_AB92                   ; AB98
        rts                             ; AB9A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AB9B
        .byte $FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABAB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABBB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABCB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABDB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABEB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABFB
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC0B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC1B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC2B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC3B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC4B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC5B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC6B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC7B
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC8B
        .byte $00,$00,$00,$00,$00 ; AC9B
sub_ACA0:
        ldx  #$07                       ; ACA0
loc_ACA2:
        lda  $0100,x                    ; ACA2
        sta  regptr_410B,x              ; ACA5
        dex                             ; ACA7
        bpl  loc_ACA2                   ; ACA8
        nop                             ; ACAA
        nop                             ; ACAB
        nop                             ; ACAC
        ldx  #$00                       ; ACAD
        lda  #$00                       ; ACAF
loc_ACB1:
        sta  APU_4000,x                 ; ACB1
        inx                             ; ACB4
        cpx  #$10                       ; ACB5
        bne  loc_ACB1                   ; ACB7
        lda  #$00                       ; ACB9
        jsr  set_chr_banks_mmc3         ; ACBB
        rts                             ; ACBE
        .byte $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACBF
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACCF
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACDF
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACEF
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACFF
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD0F
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD1F
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD2F
        .byte $00 ; AD3F
run_ram_stub_outer_88:
        .byte $A9,$00,$8D,$00,$20,$8D,$01,$20,$A2,$30,$BD,$60,$AD,$9D,$00,$04 ; AD40
        .byte $CA,$10,$F7,$4C,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD50
; ---- RAM stub: copied to $0400 (49 bytes) by run_ram_stub_outer_88
ram_stub_outer_88:
        ; static (not seen in traces)
        lda  #$04                       ; AD60
        sta  OB_PRG_MODE_410B           ; AD62
        lda  #$88                       ; AD65
        sta  OB_PRG_OUTER_4100          ; AD67
        ldx  #$38                       ; AD6A
        stx  OB_PRG_8000                ; AD6C
        inx                             ; AD6F
        stx  OB_PRG_A000                ; AD70
        inx                             ; AD73
        stx  OB_PRG_C000                ; AD74
        inx                             ; AD77
        stx  OB_PRG_E000                ; AD78
        lda  #$10                       ; AD7B
        sta  OB_CHR_2018                ; AD7D
        lda  #$C6                       ; AD80
        sta  OB_CHR_201A                ; AD82
        jmp  (vec_reset)                ; AD85
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD88
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD98
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADA8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADC8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD8
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADE8
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; ADF8
sub_AE00:
        lda  $19                        ; AE00
        bne  loc_AE0E                   ; AE02
        lda  #$7B                       ; AE04
        sta  $00                        ; AE06
        lda  #$CE                       ; AE08
        sta  $01                        ; AE0A
        bne  loc_AE16                   ; AE0C
loc_AE0E:
        ; static (not seen in traces)
        lda  #$7B                       ; AE0E
        sta  $00                        ; AE10
        lda  #$D2                       ; AE12
        sta  $01                        ; AE14
loc_AE16:
        ldx  $18                        ; AE16
        beq  loc_AE2A                   ; AE18
loc_AE1A:
        lda  $00                        ; AE1A
        clc                             ; AE1C
        adc  #$04                       ; AE1D
        sta  $00                        ; AE1F
        lda  $01                        ; AE21
        adc  #$00                       ; AE23
        sta  $01                        ; AE25
        dex                             ; AE27
        bne  loc_AE1A                   ; AE28
loc_AE2A:
        ldy  #$02                       ; AE2A
        lda  ($00),y                    ; AE2C
        sta  $28                        ; AE2E
        rts                             ; AE30
        .byte $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE31
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE41
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE51
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE61
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE71
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE81
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE91
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEA1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEE1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEF1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF01
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF11
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF21
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF31
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF41
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF51
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF61
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF71
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF81
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF91
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFA1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFC1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFE1
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFF1
tbl_launch_params_b0:
        .byte $00,$00,$01,$1E,$55,$00,$02,$00 ; B000  launch_param 0
        .byte $00,$00,$01,$3E,$55,$10,$02,$01 ; B008  launch_param 1
        .byte $00,$00,$01,$5E,$55,$20,$02,$02 ; B010  launch_param 2
        .byte $00,$00,$01,$7E,$55,$30,$02,$03 ; B018  launch_param 3
        .byte $00,$00,$01,$9E,$55,$40,$02,$04 ; B020  launch_param 4
        .byte $00,$00,$01,$BE,$55,$50,$02,$05 ; B028  launch_param 5
        .byte $00,$00,$01,$DE,$55,$60,$02,$06 ; B030  launch_param 6
        .byte $00,$00,$01,$DE,$70,$10,$09,$36 ; B038  launch_param 7
        .byte $01,$00,$06,$0E,$60,$00,$02,$08 ; B040  launch_param 8
        .byte $00,$00,$01,$3E,$66,$10,$02,$0D ; B048  launch_param 9
        .byte $00,$00,$01,$5E,$66,$20,$02,$0E ; B050  launch_param 10
        .byte $00,$00,$01,$7E,$66,$30,$02,$0F ; B058  launch_param 11
        .byte $00,$00,$01,$9E,$66,$40,$02,$10 ; B060  launch_param 12
        .byte $00,$00,$01,$BE,$66,$50,$02,$11 ; B068  launch_param 13
        .byte $00,$00,$01,$DE,$66,$60,$02,$12 ; B070  launch_param 14
        .byte $00,$00,$01,$FE,$66,$70,$02,$13 ; B078  launch_param 15
        .byte $00,$00,$01,$1E,$77,$00,$02,$14 ; B080  launch_param 16
        .byte $00,$00,$01,$3E,$77,$10,$02,$15 ; B088  launch_param 17
        .byte $00,$00,$01,$5E,$77,$20,$02,$16 ; B090  launch_param 18
        .byte $00,$00,$01,$7E,$77,$30,$02,$17 ; B098  launch_param 19
        .byte $00,$00,$01,$9E,$77,$40,$02,$18 ; B0A0  launch_param 20
        .byte $00,$00,$01,$BE,$77,$50,$02,$19 ; B0A8  launch_param 21
        .byte $00,$00,$96,$38,$00,$10,$04,$1A ; B0B0  launch_param 22
        .byte $00,$00,$06,$40,$15,$70,$05,$1B ; B0B8  launch_param 23
        .byte $00,$00,$0E,$42,$15,$70,$05,$1C ; B0C0  launch_param 24
        .byte $00,$00,$16,$44,$15,$70,$85,$1F ; B0C8  launch_param 25
        .byte $00,$00,$1E,$46,$15,$70,$05,$20 ; B0D0  launch_param 26
        .byte $00,$00,$26,$48,$15,$70,$05,$21 ; B0D8  launch_param 27
        .byte $00,$00,$2E,$4A,$15,$70,$85,$22 ; B0E0  launch_param 28
        .byte $00,$00,$36,$4C,$15,$70,$85,$23 ; B0E8  launch_param 29
        .byte $00,$00,$3E,$4E,$15,$70,$05,$24 ; B0F0  launch_param 30
        .byte $00,$00,$46,$50,$15,$70,$05,$25 ; B0F8  launch_param 31
        .byte $00,$00,$4E,$52,$15,$70,$05,$26 ; B100  launch_param 32
        .byte $00,$00,$56,$54,$15,$70,$05,$27 ; B108  launch_param 33
        .byte $00,$00,$5E,$56,$15,$70,$85,$28 ; B110  launch_param 34
        .byte $00,$00,$66,$58,$15,$70,$05,$29 ; B118  launch_param 35
        .byte $00,$00,$6E,$5A,$15,$70,$05,$2A ; B120  launch_param 36
        .byte $00,$00,$76,$5C,$15,$70,$05,$2B ; B128  launch_param 37
        .byte $00,$00,$7E,$5E,$15,$70,$85,$2C ; B130  launch_param 38
        .byte $00,$00,$86,$60,$15,$70,$85,$2D ; B138  launch_param 39
        .byte $00,$00,$8E,$62,$15,$70,$05,$2E ; B140  launch_param 40
        .byte $00,$00,$96,$64,$15,$70,$85,$2F ; B148  launch_param 41
        .byte $00,$00,$9E,$66,$15,$70,$85,$30 ; B150  launch_param 42
        .byte $00,$00,$A6,$68,$15,$70,$05,$31 ; B158  launch_param 43
        .byte $00,$00,$AE,$6A,$15,$70,$05,$32 ; B160  launch_param 44
        .byte $00,$00,$B6,$6C,$15,$70,$05,$33 ; B168  launch_param 45
        .byte $00,$00,$BE,$6E,$15,$70,$05,$34 ; B170  launch_param 46
        .byte $00,$00,$C6,$70,$15,$70,$05,$35 ; B178  launch_param 47
        .byte $00,$00,$CE,$72,$15,$70,$05,$36 ; B180  launch_param 48
        .byte $00,$00,$D6,$74,$15,$70,$05,$37 ; B188  launch_param 49
        .byte $00,$00,$DE,$76,$15,$70,$05,$38 ; B190  launch_param 50
        .byte $00,$00,$E6,$78,$15,$70,$85,$39 ; B198  launch_param 51
        .byte $00,$00,$EE,$7A,$15,$70,$05,$3A ; B1A0  launch_param 52
        .byte $00,$00,$F6,$7C,$15,$70,$85,$3B ; B1A8  launch_param 53
        .byte $00,$00,$FE,$7E,$15,$70,$85,$3C ; B1B0  launch_param 54
        .byte $00,$00,$06,$80,$10,$20,$05,$3D ; B1B8  launch_param 55
        .byte $00,$00,$0E,$82,$10,$20,$05,$3E ; B1C0  launch_param 56
        .byte $00,$00,$16,$84,$10,$20,$05,$3F ; B1C8  launch_param 57
        .byte $00,$00,$1E,$86,$10,$20,$05,$40 ; B1D0  launch_param 58
        .byte $00,$00,$26,$88,$10,$20,$85,$41 ; B1D8  launch_param 59
        .byte $00,$00,$2E,$8A,$10,$20,$05,$42 ; B1E0  launch_param 60
        .byte $00,$00,$36,$8C,$10,$20,$05,$43 ; B1E8  launch_param 61
        .byte $00,$00,$3E,$8E,$10,$20,$05,$44 ; B1F0  launch_param 62
        .byte $00,$00,$46,$90,$10,$20,$05,$45 ; B1F8  launch_param 63
        .byte $00,$00,$4E,$92,$10,$20,$05,$46 ; B200  launch_param 64
        .byte $00,$00,$56,$94,$10,$20,$05,$47 ; B208  launch_param 65
        .byte $00,$00,$5E,$96,$10,$20,$05,$48 ; B210  launch_param 66
        .byte $00,$00,$66,$98,$10,$20,$05,$49 ; B218  launch_param 67
        .byte $00,$00,$6E,$9A,$10,$20,$05,$4A ; B220  launch_param 68
        .byte $00,$00,$76,$9C,$10,$20,$05,$0B ; B228  launch_param 69
        .byte $00,$00,$7E,$9E,$10,$20,$05,$4B ; B230  launch_param 70
        .byte $00,$00,$86,$A0,$10,$20,$05,$4C ; B238  launch_param 71
        .byte $00,$00,$8E,$A2,$10,$20,$05,$4D ; B240  launch_param 72
        .byte $00,$00,$96,$A4,$10,$20,$05,$4E ; B248  launch_param 73
        .byte $00,$00,$9E,$A6,$10,$20,$05,$4F ; B250  launch_param 74
        .byte $00,$00,$A6,$A8,$10,$20,$05,$50 ; B258  launch_param 75
        .byte $00,$00,$AE,$AA,$10,$20,$05,$51 ; B260  launch_param 76
        .byte $00,$00,$B6,$AC,$10,$20,$85,$52 ; B268  launch_param 77
        .byte $00,$00,$BE,$AE,$10,$20,$05,$53 ; B270  launch_param 78
        .byte $00,$00,$C6,$B0,$10,$20,$85,$54 ; B278  launch_param 79
        .byte $00,$00,$CE,$B2,$10,$20,$85,$55 ; B280  launch_param 80
        .byte $00,$00,$D6,$B4,$10,$20,$05,$56 ; B288  launch_param 81
        .byte $00,$00,$DE,$B6,$10,$20,$05,$57 ; B290  launch_param 82
        .byte $00,$00,$E6,$B8,$10,$20,$85,$58 ; B298  launch_param 83
        .byte $00,$00,$EE,$BA,$10,$20,$05,$59 ; B2A0  launch_param 84
        .byte $00,$00,$F6,$BC,$10,$20,$05,$5A ; B2A8  launch_param 85
        .byte $00,$00,$FE,$BE,$10,$20,$05,$5B ; B2B0  launch_param 86
        .byte $00,$00,$06,$C0,$10,$30,$05,$5C ; B2B8  launch_param 87
        .byte $00,$00,$0E,$C2,$10,$30,$05,$5D ; B2C0  launch_param 88
        .byte $00,$00,$16,$C4,$10,$30,$85,$5E ; B2C8  launch_param 89
        .byte $00,$00,$1E,$C6,$10,$30,$05,$5F ; B2D0  launch_param 90
        .byte $00,$00,$26,$C8,$10,$30,$85,$60 ; B2D8  launch_param 91
        .byte $00,$00,$2E,$CA,$10,$30,$05,$61 ; B2E0  launch_param 92
        .byte $00,$00,$06,$40,$20,$50,$84,$62 ; B2E8  launch_param 93
        .byte $00,$00,$0E,$44,$20,$50,$04,$63 ; B2F0  launch_param 94
        .byte $00,$00,$16,$48,$20,$50,$04,$64 ; B2F8  launch_param 95
        .byte $00,$00,$1E,$4C,$20,$50,$84,$65 ; B300  launch_param 96
        .byte $00,$00,$26,$50,$20,$50,$04,$66 ; B308  launch_param 97
        .byte $00,$00,$2E,$54,$20,$50,$04,$67 ; B310  launch_param 98
        .byte $00,$00,$36,$58,$20,$50,$04,$68 ; B318  launch_param 99
        .byte $00,$00,$3E,$5C,$20,$50,$84,$69 ; B320  launch_param 100
        .byte $00,$00,$46,$60,$20,$50,$04,$6A ; B328  launch_param 101
        .byte $00,$00,$4E,$64,$20,$50,$04,$6B ; B330  launch_param 102
        .byte $00,$00,$56,$68,$20,$50,$84,$6C ; B338  launch_param 103
        .byte $00,$00,$5E,$6C,$20,$50,$04,$6D ; B340  launch_param 104
        .byte $00,$00,$66,$70,$20,$50,$04,$6E ; B348  launch_param 105
        .byte $00,$00,$6E,$74,$20,$50,$04,$7F ; B350  launch_param 106
        .byte $00,$00,$76,$78,$20,$50,$04,$70 ; B358  launch_param 107
        .byte $00,$00,$7E,$7C,$20,$50,$04,$71 ; B360  launch_param 108
        .byte $00,$00,$86,$80,$20,$50,$84,$72 ; B368  launch_param 109
        .byte $00,$00,$8E,$84,$20,$50,$84,$73 ; B370  launch_param 110
        .byte $00,$00,$96,$88,$20,$50,$84,$74 ; B378  launch_param 111
        .byte $00,$00,$9E,$8C,$20,$50,$04,$75 ; B380  launch_param 112
        .byte $00,$00,$A6,$90,$20,$50,$04,$76 ; B388  launch_param 113
        .byte $00,$00,$AE,$94,$20,$50,$04,$77 ; B390  launch_param 114
        .byte $00,$00,$B6,$98,$20,$50,$04,$78 ; B398  launch_param 115
        .byte $00,$00,$BE,$9C,$20,$50,$04,$79 ; B3A0  launch_param 116
        .byte $00,$00,$36,$CC,$10,$30,$05,$7A ; B3A8  launch_param 117
        .byte $00,$00,$C6,$A0,$20,$50,$04,$7B ; B3B0  launch_param 118
        .byte $00,$00,$CE,$A4,$20,$50,$84,$7C ; B3B8  launch_param 119
        .byte $00,$00,$D6,$A8,$20,$50,$04,$7D ; B3C0  launch_param 120
        .byte $00,$00,$DE,$AC,$20,$50,$04,$7E ; B3C8  launch_param 121
        .byte $00,$00,$E6,$B0,$20,$50,$04,$7F ; B3D0  launch_param 122
        .byte $00,$00,$EE,$B4,$20,$50,$04,$80 ; B3D8  launch_param 123
        .byte $00,$00,$F6,$B8,$20,$50,$04,$81 ; B3E0  launch_param 124
        .byte $00,$00,$FE,$BC,$20,$50,$04,$82 ; B3E8  launch_param 125
        .byte $00,$00,$06,$C0,$20,$60,$84,$83 ; B3F0  launch_param 126
        .byte $00,$00,$0E,$C4,$20,$60,$04,$84 ; B3F8  launch_param 127
        .byte $00,$00,$16,$C8,$20,$60,$04,$85 ; B400  launch_param 128
        .byte $00,$00,$1E,$CC,$20,$60,$04,$86 ; B408  launch_param 129
        .byte $00,$00,$26,$D0,$20,$60,$04,$87 ; B410  launch_param 130
        .byte $00,$00,$2E,$D4,$20,$60,$04,$88 ; B418  launch_param 131
        .byte $00,$00,$36,$D8,$20,$60,$04,$89 ; B420  launch_param 132
        .byte $00,$00,$3E,$DC,$20,$60,$04,$8A ; B428  launch_param 133
        .byte $00,$00,$46,$E0,$20,$60,$04,$8B ; B430  launch_param 134
        .byte $00,$00,$4E,$E4,$20,$60,$04,$8C ; B438  launch_param 135
        .byte $00,$00,$56,$E8,$20,$60,$04,$8D ; B440  launch_param 136
        .byte $00,$00,$5E,$EC,$20,$60,$84,$8E ; B448  launch_param 137
        .byte $00,$00,$66,$F0,$20,$60,$04,$06 ; B450  launch_param 138
        .byte $00,$00,$6E,$F4,$20,$60,$04,$8F ; B458  launch_param 139
        .byte $00,$00,$76,$F8,$20,$60,$84,$90 ; B460  launch_param 140
        .byte $00,$00,$7E,$FC,$20,$60,$04,$91 ; B468  launch_param 141
        .byte $00,$00,$86,$00,$30,$60,$04,$92 ; B470  launch_param 142
        .byte $00,$00,$8E,$04,$30,$60,$04,$93 ; B478  launch_param 143
        .byte $00,$00,$96,$08,$30,$60,$84,$94 ; B480  launch_param 144
        .byte $00,$00,$9E,$0C,$30,$60,$84,$95 ; B488  launch_param 145
        .byte $00,$00,$A6,$10,$30,$60,$04,$96 ; B490  launch_param 146
        .byte $00,$00,$AE,$14,$30,$60,$04,$97 ; B498  launch_param 147
        .byte $00,$00,$05,$80,$44,$00,$04,$98 ; B4A0  launch_param 148
        .byte $00,$00,$15,$84,$44,$00,$04,$99 ; B4A8  launch_param 149
        .byte $00,$00,$25,$88,$44,$00,$84,$1D ; B4B0  launch_param 150
        .byte $00,$00,$B6,$78,$40,$60,$84,$9B ; B4B8  launch_param 151
        .byte $00,$00,$35,$8C,$44,$00,$04,$9C ; B4C0  launch_param 152
        .byte $00,$00,$44,$90,$44,$00,$04,$0A ; B4C8  launch_param 153
        .byte $00,$00,$64,$94,$44,$00,$04,$9D ; B4D0  launch_param 154
        .byte $00,$00,$84,$98,$44,$00,$04,$9A ; B4D8  launch_param 155
        .byte $00,$00,$A4,$9C,$44,$00,$04,$9E ; B4E0  launch_param 156
        .byte $00,$00,$C4,$A0,$44,$00,$04,$0C ; B4E8  launch_param 157
        .byte $00,$00,$E4,$A4,$44,$00,$04,$1E ; B4F0  launch_param 158
        .byte $00,$00,$04,$A8,$44,$10,$04,$9F ; B4F8  launch_param 159
        .byte $00,$00,$24,$AC,$44,$10,$04,$A0 ; B500  launch_param 160
        .byte $00,$00,$44,$B0,$44,$10,$04,$A1 ; B508  launch_param 161
        .byte $00,$00,$64,$B4,$44,$10,$04,$A2 ; B510  launch_param 162
        .byte $00,$00,$84,$B8,$44,$10,$04,$A3 ; B518  launch_param 163
        .byte $00,$00,$A4,$BC,$44,$10,$84,$A4 ; B520  launch_param 164
        .byte $00,$00,$C4,$C0,$44,$10,$04,$A5 ; B528  launch_param 165
        .byte $00,$00,$E4,$C4,$44,$10,$04,$A6 ; B530  launch_param 166
        .byte $00,$00,$04,$C8,$44,$20,$04,$A7 ; B538  launch_param 167
        .byte $00,$00,$24,$CC,$44,$20,$04,$A8 ; B540  launch_param 168
        .byte $00,$00,$44,$D0,$44,$20,$04,$A9 ; B548  launch_param 169
        .byte $00,$00,$64,$D4,$44,$20,$84,$AA ; B550  launch_param 170
        .byte $00,$00,$84,$D8,$44,$20,$84,$AB ; B558  launch_param 171
        .byte $00,$00,$A4,$DC,$44,$20,$84,$AC ; B560  launch_param 172
        .byte $00,$00,$C4,$E0,$44,$20,$84,$AD ; B568  launch_param 173
        .byte $00,$00,$E4,$E4,$44,$20,$04,$AE ; B570  launch_param 174
        .byte $00,$00,$04,$E8,$44,$30,$84,$AF ; B578  launch_param 175
        .byte $00,$00,$24,$EC,$44,$30,$04,$B0 ; B580  launch_param 176
        .byte $00,$00,$44,$F0,$44,$30,$04,$B1 ; B588  launch_param 177
        .byte $00,$00,$64,$F4,$44,$30,$04,$B2 ; B590  launch_param 178
        .byte $00,$00,$84,$F8,$44,$30,$04,$B3 ; B598  launch_param 179
        .byte $00,$00,$A4,$FC,$44,$30,$84,$B4 ; B5A0  launch_param 180
        .byte $00,$00,$02,$7C,$41,$10,$04,$B5 ; B5A8  launch_param 181
        .byte $00,$00,$3E,$CE,$10,$30,$05,$B6 ; B5B0  launch_param 182
        .byte $00,$00,$46,$D0,$10,$30,$05,$B7 ; B5B8  launch_param 183
        .byte $00,$00,$4E,$D2,$10,$30,$05,$B8 ; B5C0  launch_param 184
        .byte $00,$00,$56,$D4,$10,$30,$05,$B9 ; B5C8  launch_param 185
        .byte $00,$00,$5E,$D6,$10,$30,$05,$BA ; B5D0  launch_param 186
        .byte $00,$00,$66,$D8,$10,$30,$05,$BB ; B5D8  launch_param 187
        .byte $00,$00,$6E,$DA,$10,$30,$05,$BC ; B5E0  launch_param 188
        .byte $00,$00,$76,$DC,$10,$30,$05,$BD ; B5E8  launch_param 189
        .byte $00,$00,$7E,$DE,$10,$30,$05,$BE ; B5F0  launch_param 190
        .byte $00,$00,$86,$E0,$10,$30,$05,$BF ; B5F8  launch_param 191
        .byte $00,$00,$8E,$E2,$10,$30,$05,$C0 ; B600  launch_param 192
        .byte $00,$00,$96,$E4,$10,$30,$05,$C1 ; B608  launch_param 193
        .byte $00,$00,$9E,$E6,$10,$30,$85,$C2 ; B610  launch_param 194
        .byte $00,$00,$A6,$E8,$10,$30,$05,$C3 ; B618  launch_param 195
        .byte $00,$00,$AE,$EA,$10,$30,$05,$C4 ; B620  launch_param 196
        .byte $00,$00,$B6,$EC,$10,$30,$05,$C5 ; B628  launch_param 197
        .byte $00,$00,$BE,$EE,$10,$30,$05,$C6 ; B630  launch_param 198
        .byte $00,$00,$C6,$F0,$10,$30,$05,$C7 ; B638  launch_param 199
        .byte $00,$00,$CE,$F2,$10,$30,$05,$C8 ; B640  launch_param 200
        .byte $00,$00,$D6,$F4,$10,$30,$05,$C9 ; B648  launch_param 201
        .byte $00,$00,$DE,$F6,$10,$30,$05,$CA ; B650  launch_param 202
        .byte $00,$00,$E6,$F8,$10,$30,$05,$CB ; B658  launch_param 203
        .byte $00,$00,$EE,$FA,$10,$30,$05,$CC ; B660  launch_param 204
        .byte $00,$00,$F6,$FC,$10,$30,$05,$CD ; B668  launch_param 205
        .byte $00,$00,$FE,$FE,$10,$30,$05,$CE ; B670  launch_param 206
        .byte $00,$00,$06,$00,$20,$40,$05,$CF ; B678  launch_param 207
        .byte $00,$00,$0E,$02,$20,$40,$05,$D0 ; B680  launch_param 208
        .byte $00,$00,$16,$04,$20,$40,$05,$D1 ; B688  launch_param 209
        .byte $00,$00,$1E,$06,$20,$40,$05,$D2 ; B690  launch_param 210
        .byte $00,$00,$26,$08,$20,$40,$05,$D3 ; B698  launch_param 211
        .byte $00,$00,$2E,$0A,$20,$40,$05,$D4 ; B6A0  launch_param 212
        .byte $00,$00,$36,$0C,$20,$40,$05,$D5 ; B6A8  launch_param 213
        .byte $00,$00,$3E,$0E,$20,$40,$05,$D6 ; B6B0  launch_param 214
        .byte $00,$00,$46,$10,$20,$40,$05,$D7 ; B6B8  launch_param 215
        .byte $00,$00,$4E,$12,$20,$40,$05,$D8 ; B6C0  launch_param 216
        .byte $00,$00,$56,$14,$20,$40,$05,$D9 ; B6C8  launch_param 217
        .byte $00,$00,$5E,$16,$20,$40,$05,$DA ; B6D0  launch_param 218
        .byte $00,$00,$66,$18,$20,$40,$05,$DB ; B6D8  launch_param 219
        .byte $00,$00,$6E,$1A,$20,$40,$05,$DC ; B6E0  launch_param 220
        .byte $00,$00,$76,$1C,$20,$40,$05,$DD ; B6E8  launch_param 221
        .byte $00,$00,$7E,$1E,$20,$40,$05,$DE ; B6F0  launch_param 222
        .byte $00,$00,$86,$20,$20,$40,$05,$DF ; B6F8  launch_param 223
        .byte $00,$00,$8E,$22,$20,$40,$05,$E0 ; B700  launch_param 224
        .byte $00,$00,$96,$24,$20,$40,$05,$E1 ; B708  launch_param 225
        .byte $00,$00,$9E,$26,$20,$40,$05,$E2 ; B710  launch_param 226
        .byte $00,$00,$A6,$28,$20,$40,$05,$E3 ; B718  launch_param 227
        .byte $00,$00,$AE,$2A,$20,$40,$05,$E4 ; B720  launch_param 228
        .byte $00,$00,$B6,$2C,$20,$40,$05,$E5 ; B728  launch_param 229
        .byte $00,$00,$BE,$2E,$20,$40,$05,$E6 ; B730  launch_param 230
        .byte $00,$00,$C6,$30,$20,$40,$05,$E7 ; B738  launch_param 231
        .byte $00,$00,$CE,$32,$20,$40,$05,$E8 ; B740  launch_param 232
        .byte $00,$00,$BE,$18,$30,$60,$04,$E9 ; B748  launch_param 233
        .byte $00,$00,$C6,$1C,$30,$60,$04,$EA ; B750  launch_param 234
        .byte $00,$00,$CE,$20,$30,$60,$04,$EB ; B758  launch_param 235
        .byte $00,$00,$D6,$24,$30,$60,$04,$EC ; B760  launch_param 236
        .byte $00,$00,$DE,$28,$30,$60,$04,$ED ; B768  launch_param 237
        .byte $00,$00,$E6,$2C,$30,$60,$04,$EE ; B770  launch_param 238
        .byte $00,$00,$EE,$30,$30,$60,$04,$EF ; B778  launch_param 239
        .byte $00,$00,$F6,$34,$30,$60,$04,$F0 ; B780  launch_param 240
        .byte $00,$00,$FE,$38,$30,$60,$04,$F1 ; B788  launch_param 241
        .byte $00,$00,$06,$3C,$30,$70,$04,$F2 ; B790  launch_param 242
        .byte $00,$00,$0E,$40,$30,$70,$04,$F3 ; B798  launch_param 243
        .byte $00,$00,$16,$44,$30,$70,$04,$F4 ; B7A0  launch_param 244
        .byte $00,$00,$1E,$48,$30,$70,$04,$F5 ; B7A8  launch_param 245
        .byte $00,$00,$26,$4C,$30,$70,$04,$F6 ; B7B0  launch_param 246
        .byte $00,$00,$2E,$50,$30,$70,$04,$F7 ; B7B8  launch_param 247
        .byte $00,$00,$36,$54,$30,$70,$04,$F8 ; B7C0  launch_param 248
        .byte $00,$00,$3E,$58,$30,$70,$04,$F9 ; B7C8  launch_param 249
        .byte $00,$00,$46,$5C,$30,$70,$04,$FA ; B7D0  launch_param 250
        .byte $00,$00,$4E,$60,$30,$70,$04,$FB ; B7D8  launch_param 251
        .byte $00,$00,$56,$64,$30,$70,$04,$FC ; B7E0  launch_param 252
        .byte $00,$00,$5E,$68,$30,$70,$04,$FD ; B7E8  launch_param 253
        .byte $00,$00,$66,$6C,$30,$70,$04,$FE ; B7F0  launch_param 254
        .byte $00,$00,$6E,$70,$30,$70,$04,$FF ; B7F8  launch_param 255
tbl_launch_params_b8:
        .byte $00,$00,$76,$74,$30,$70,$04,$00 ; B800  launch_param 256
        .byte $00,$00,$7E,$78,$30,$70,$04,$01 ; B808  launch_param 257
        .byte $00,$00,$86,$7C,$30,$70,$04,$02 ; B810  launch_param 258
        .byte $00,$00,$8E,$80,$30,$70,$04,$03 ; B818  launch_param 259
        .byte $00,$00,$96,$84,$30,$70,$04,$04 ; B820  launch_param 260
        .byte $00,$00,$9E,$88,$30,$70,$04,$05 ; B828  launch_param 261
        .byte $00,$00,$A6,$8C,$30,$70,$04,$06 ; B830  launch_param 262
        .byte $00,$00,$AE,$90,$30,$70,$04,$07 ; B838  launch_param 263
        .byte $00,$00,$B6,$94,$30,$70,$04,$08 ; B840  launch_param 264
        .byte $00,$00,$BE,$98,$30,$70,$04,$09 ; B848  launch_param 265
        .byte $00,$00,$C6,$9C,$30,$70,$04,$0A ; B850  launch_param 266
        .byte $00,$00,$CE,$A0,$30,$70,$04,$0B ; B858  launch_param 267
        .byte $00,$00,$D6,$A4,$30,$70,$04,$0C ; B860  launch_param 268
        .byte $00,$00,$DE,$A8,$30,$70,$04,$0D ; B868  launch_param 269
        .byte $00,$00,$E6,$AC,$30,$70,$04,$0E ; B870  launch_param 270
        .byte $00,$00,$EE,$B0,$30,$70,$04,$0F ; B878  launch_param 271
        .byte $00,$00,$F6,$B4,$30,$70,$04,$10 ; B880  launch_param 272
        .byte $00,$00,$FE,$B8,$30,$70,$04,$11 ; B888  launch_param 273
        .byte $00,$00,$06,$BC,$31,$00,$04,$12 ; B890  launch_param 274
        .byte $00,$00,$0E,$C0,$31,$00,$04,$13 ; B898  launch_param 275
        .byte $00,$00,$16,$C4,$31,$00,$04,$14 ; B8A0  launch_param 276
        .byte $00,$00,$1E,$C8,$31,$00,$04,$15 ; B8A8  launch_param 277
        .byte $00,$00,$26,$CC,$31,$00,$04,$16 ; B8B0  launch_param 278
        .byte $00,$00,$2E,$D0,$31,$00,$04,$17 ; B8B8  launch_param 279
        .byte $00,$00,$36,$D4,$31,$00,$04,$18 ; B8C0  launch_param 280
        .byte $00,$00,$3E,$D8,$31,$00,$04,$19 ; B8C8  launch_param 281
        .byte $00,$00,$46,$DC,$31,$00,$04,$1A ; B8D0  launch_param 282
        .byte $00,$00,$4E,$E0,$31,$00,$04,$1B ; B8D8  launch_param 283
        .byte $00,$00,$56,$E4,$31,$00,$04,$1C ; B8E0  launch_param 284
        .byte $00,$00,$5E,$E8,$31,$00,$04,$1D ; B8E8  launch_param 285
        .byte $00,$00,$66,$EC,$31,$00,$04,$1E ; B8F0  launch_param 286
        .byte $00,$00,$6E,$F0,$31,$00,$04,$1F ; B8F8  launch_param 287
        .byte $00,$00,$76,$F4,$31,$00,$84,$20 ; B900  launch_param 288
        .byte $00,$00,$7E,$F8,$31,$00,$04,$21 ; B908  launch_param 289
        .byte $00,$00,$86,$FC,$31,$00,$04,$22 ; B910  launch_param 290
        .byte $00,$00,$8E,$30,$11,$00,$04,$23 ; B918  launch_param 291
        .byte $00,$00,$96,$34,$11,$00,$04,$24 ; B920  launch_param 292
        .byte $00,$00,$9E,$38,$11,$00,$04,$25 ; B928  launch_param 293
        .byte $00,$00,$A6,$3C,$11,$00,$04,$26 ; B930  launch_param 294
        .byte $00,$00,$AE,$28,$11,$00,$04,$27 ; B938  launch_param 295
        .byte $00,$00,$B6,$2C,$11,$00,$04,$28 ; B940  launch_param 296
        .byte $00,$00,$BE,$E0,$71,$00,$04,$29 ; B948  launch_param 297
        .byte $00,$00,$C6,$E4,$71,$00,$04,$2A ; B950  launch_param 298
        .byte $00,$00,$CE,$E8,$71,$00,$04,$2B ; B958  launch_param 299
        .byte $00,$00,$D6,$34,$20,$40,$05,$2C ; B960  launch_param 300
        .byte $00,$00,$D6,$EC,$71,$00,$04,$2D ; B968  launch_param 301
        .byte $00,$00,$DE,$F0,$71,$00,$04,$2E ; B970  launch_param 302
        .byte $00,$00,$E6,$F4,$71,$00,$04,$2F ; B978  launch_param 303
        .byte $00,$00,$DE,$36,$20,$40,$05,$30 ; B980  launch_param 304
        .byte $00,$00,$EE,$F8,$71,$00,$04,$31 ; B988  launch_param 305
        .byte $00,$00,$E6,$38,$20,$40,$05,$32 ; B990  launch_param 306
        .byte $00,$00,$EE,$3A,$20,$40,$05,$33 ; B998  launch_param 307
        .byte $00,$00,$F6,$3C,$20,$40,$05,$34 ; B9A0  launch_param 308
        .byte $00,$00,$F6,$FC,$71,$00,$04,$35 ; B9A8  launch_param 309
        .byte $00,$00,$FE,$3E,$20,$40,$05,$36 ; B9B0  launch_param 310
        .byte $00,$00,$FE,$16,$01,$00,$05,$37 ; B9B8  launch_param 311
        .byte $00,$00,$6E,$70,$30,$70,$04,$38 ; B9C0  launch_param 312
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9C8  launch_param 313
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9D0  launch_param 314
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9D8  launch_param 315
        .byte $00,$00,$56,$B0,$54,$20,$04,$3C ; B9E0  launch_param 316
        .byte $00,$00,$5E,$B4,$54,$20,$04,$3D ; B9E8  launch_param 317
        .byte $00,$00,$66,$B8,$54,$20,$04,$3E ; B9F0  launch_param 318
        .byte $00,$00,$6E,$BC,$54,$20,$04,$3F ; B9F8  launch_param 319
        .byte $00,$00,$76,$C0,$54,$20,$04,$40 ; BA00  launch_param 320
        .byte $00,$00,$7E,$C4,$54,$20,$04,$41 ; BA08  launch_param 321
        .byte $00,$00,$86,$C8,$54,$20,$04,$42 ; BA10  launch_param 322
        .byte $00,$00,$8E,$CC,$54,$20,$04,$43 ; BA18  launch_param 323
        .byte $00,$00,$96,$D0,$54,$20,$04,$44 ; BA20  launch_param 324
        .byte $00,$00,$9E,$D4,$54,$20,$04,$45 ; BA28  launch_param 325
        .byte $00,$00,$A6,$D8,$54,$20,$04,$46 ; BA30  launch_param 326
        .byte $00,$00,$AE,$DC,$54,$20,$04,$47 ; BA38  launch_param 327
        .byte $00,$00,$B6,$E0,$54,$20,$04,$48 ; BA40  launch_param 328
        .byte $00,$00,$BE,$E4,$54,$20,$04,$49 ; BA48  launch_param 329
        .byte $00,$00,$C6,$E8,$54,$20,$04,$4A ; BA50  launch_param 330
        .byte $00,$00,$CE,$EC,$54,$20,$04,$4B ; BA58  launch_param 331
        .byte $00,$00,$D6,$F0,$54,$20,$04,$4C ; BA60  launch_param 332
        .byte $00,$00,$DE,$F4,$54,$20,$04,$4D ; BA68  launch_param 333
        .byte $00,$00,$E6,$F8,$54,$20,$04,$4E ; BA70  launch_param 334
        .byte $00,$00,$EE,$FC,$54,$20,$04,$4F ; BA78  launch_param 335
        .byte $00,$00,$F6,$00,$64,$20,$04,$50 ; BA80  launch_param 336
        .byte $00,$00,$FE,$04,$64,$20,$04,$51 ; BA88  launch_param 337
        .byte $00,$00,$06,$08,$64,$30,$04,$52 ; BA90  launch_param 338
        .byte $00,$00,$0E,$0C,$64,$30,$04,$53 ; BA98  launch_param 339
        .byte $00,$00,$16,$10,$64,$30,$04,$54 ; BAA0  launch_param 340
        .byte $00,$00,$1E,$14,$64,$30,$04,$55 ; BAA8  launch_param 341
        .byte $00,$00,$26,$18,$64,$30,$04,$56 ; BAB0  launch_param 342
        .byte $00,$00,$2E,$1C,$64,$30,$04,$57 ; BAB8  launch_param 343
        .byte $00,$00,$36,$20,$64,$30,$04,$58 ; BAC0  launch_param 344
        .byte $00,$00,$3E,$24,$64,$30,$04,$59 ; BAC8  launch_param 345
        .byte $00,$00,$46,$28,$64,$30,$04,$5A ; BAD0  launch_param 346
        .byte $00,$00,$4E,$2C,$64,$30,$04,$5B ; BAD8  launch_param 347
        .byte $00,$00,$56,$30,$64,$30,$04,$5C ; BAE0  launch_param 348
        .byte $00,$00,$5E,$34,$64,$30,$04,$5D ; BAE8  launch_param 349
        .byte $00,$00,$66,$38,$64,$30,$04,$5E ; BAF0  launch_param 350
        .byte $00,$00,$6E,$3C,$64,$30,$C4,$5F ; BAF8  launch_param 351
        .byte $00,$00,$76,$40,$64,$30,$04,$60 ; BB00  launch_param 352
        .byte $00,$00,$7E,$44,$64,$30,$04,$61 ; BB08  launch_param 353
        .byte $00,$00,$86,$48,$64,$30,$04,$62 ; BB10  launch_param 354
        .byte $00,$00,$8E,$4C,$64,$30,$04,$63 ; BB18  launch_param 355
        .byte $00,$00,$96,$50,$64,$30,$04,$64 ; BB20  launch_param 356
        .byte $00,$00,$9E,$54,$64,$30,$84,$65 ; BB28  launch_param 357
        .byte $00,$00,$A6,$58,$64,$30,$05,$66 ; BB30  launch_param 358
        .byte $00,$00,$AE,$5A,$64,$30,$85,$67 ; BB38  launch_param 359
        .byte $00,$00,$B6,$5C,$64,$30,$05,$68 ; BB40  launch_param 360
        .byte $00,$00,$BE,$5E,$64,$30,$05,$69 ; BB48  launch_param 361
        .byte $00,$00,$C6,$60,$64,$30,$05,$6A ; BB50  launch_param 362
        .byte $00,$00,$CE,$62,$64,$30,$05,$6B ; BB58  launch_param 363
        .byte $00,$00,$D6,$64,$64,$30,$05,$6C ; BB60  launch_param 364
        .byte $00,$00,$DE,$66,$64,$30,$05,$6D ; BB68  launch_param 365
        .byte $00,$00,$E6,$68,$64,$30,$85,$6E ; BB70  launch_param 366
        .byte $00,$00,$EE,$6A,$64,$30,$05,$6F ; BB78  launch_param 367
        .byte $00,$00,$F6,$6C,$64,$30,$85,$70 ; BB80  launch_param 368
        .byte $00,$00,$FE,$6E,$64,$30,$85,$71 ; BB88  launch_param 369
        .byte $00,$00,$06,$70,$64,$40,$85,$72 ; BB90  launch_param 370
        .byte $00,$00,$0E,$72,$64,$40,$05,$73 ; BB98  launch_param 371
        .byte $00,$00,$16,$74,$64,$40,$05,$74 ; BBA0  launch_param 372
        .byte $00,$00,$1E,$76,$64,$40,$05,$75 ; BBA8  launch_param 373
        .byte $00,$00,$26,$78,$64,$40,$85,$76 ; BBB0  launch_param 374
        .byte $00,$00,$2E,$7A,$64,$40,$85,$77 ; BBB8  launch_param 375
        .byte $00,$00,$36,$7C,$64,$40,$05,$78 ; BBC0  launch_param 376
        .byte $00,$00,$3E,$7E,$64,$40,$05,$79 ; BBC8  launch_param 377
        .byte $00,$00,$46,$80,$64,$40,$85,$7A ; BBD0  launch_param 378
        .byte $00,$00,$4E,$82,$64,$40,$85,$7B ; BBD8  launch_param 379
        .byte $00,$00,$56,$84,$64,$40,$05,$7C ; BBE0  launch_param 380
        .byte $00,$00,$5E,$86,$64,$40,$85,$7D ; BBE8  launch_param 381
        .byte $00,$00,$66,$88,$64,$40,$05,$7E ; BBF0  launch_param 382
        .byte $00,$00,$6E,$8A,$64,$40,$05,$7F ; BBF8  launch_param 383
        .byte $00,$00,$76,$8C,$64,$40,$05,$80 ; BC00  launch_param 384
        .byte $00,$00,$7E,$8E,$64,$40,$05,$81 ; BC08  launch_param 385
        .byte $00,$00,$86,$90,$64,$40,$85,$82 ; BC10  launch_param 386
        .byte $00,$00,$8E,$92,$64,$40,$85,$83 ; BC18  launch_param 387
        .byte $00,$00,$96,$94,$64,$40,$05,$84 ; BC20  launch_param 388
        .byte $00,$00,$9E,$96,$64,$40,$05,$85 ; BC28  launch_param 389
        .byte $00,$00,$A6,$98,$64,$40,$05,$86 ; BC30  launch_param 390
        .byte $00,$00,$AE,$9A,$64,$40,$85,$87 ; BC38  launch_param 391
        .byte $00,$00,$B6,$9C,$64,$40,$05,$88 ; BC40  launch_param 392
        .byte $00,$00,$BE,$9E,$64,$40,$05,$89 ; BC48  launch_param 393
        .byte $00,$00,$C6,$A0,$64,$40,$85,$8A ; BC50  launch_param 394
        .byte $00,$00,$CE,$A2,$64,$40,$05,$8B ; BC58  launch_param 395
        .byte $00,$00,$D6,$A4,$64,$40,$05,$8C ; BC60  launch_param 396
        .byte $00,$00,$DE,$A6,$64,$40,$85,$8D ; BC68  launch_param 397
        .byte $00,$00,$E6,$A8,$64,$40,$05,$8E ; BC70  launch_param 398
        .byte $00,$00,$EE,$AA,$64,$40,$05,$8F ; BC78  launch_param 399
        .byte $00,$00,$F6,$AC,$64,$40,$05,$90 ; BC80  launch_param 400
        .byte $00,$00,$FE,$AE,$64,$40,$05,$91 ; BC88  launch_param 401
        .byte $00,$00,$06,$B0,$64,$50,$05,$92 ; BC90  launch_param 402
        .byte $00,$00,$0E,$B2,$64,$50,$85,$93 ; BC98  launch_param 403
        .byte $00,$00,$16,$B4,$64,$50,$05,$94 ; BCA0  launch_param 404
        .byte $00,$00,$1E,$B6,$64,$50,$05,$95 ; BCA8  launch_param 405
        .byte $00,$00,$26,$B8,$64,$50,$05,$96 ; BCB0  launch_param 406
        .byte $00,$00,$2E,$BA,$64,$50,$05,$97 ; BCB8  launch_param 407
        .byte $00,$00,$36,$BC,$64,$50,$85,$98 ; BCC0  launch_param 408
        .byte $00,$00,$3E,$BE,$64,$50,$05,$99 ; BCC8  launch_param 409
        .byte $00,$00,$46,$C0,$64,$50,$05,$9A ; BCD0  launch_param 410
        .byte $FF,$07,$4E,$C2,$64,$50,$05,$01 ; BCD8  launch_param 411
        .byte $00,$00,$56,$C4,$64,$50,$05,$9C ; BCE0  launch_param 412
        .byte $FF,$07,$5E,$C6,$64,$50,$85,$00 ; BCE8  launch_param 413
        .byte $00,$00,$66,$C8,$64,$50,$05,$9E ; BCF0  launch_param 414
        .byte $00,$00,$6E,$CA,$64,$50,$05,$9F ; BCF8  launch_param 415
        .byte $00,$00,$76,$CC,$64,$50,$05,$A0 ; BD00  launch_param 416
        .byte $00,$00,$7E,$CE,$64,$50,$05,$A1 ; BD08  launch_param 417
        .byte $00,$00,$86,$D0,$64,$50,$05,$A2 ; BD10  launch_param 418
        .byte $00,$00,$8E,$D2,$64,$50,$05,$A3 ; BD18  launch_param 419
        .byte $00,$00,$96,$D4,$64,$50,$05,$A4 ; BD20  launch_param 420
        .byte $00,$00,$9E,$D6,$64,$50,$05,$A5 ; BD28  launch_param 421
        .byte $00,$00,$A6,$D8,$64,$50,$05,$A6 ; BD30  launch_param 422
        .byte $00,$00,$AE,$DA,$64,$50,$05,$A7 ; BD38  launch_param 423
        .byte $00,$00,$B6,$DC,$64,$50,$05,$A8 ; BD40  launch_param 424
        .byte $00,$00,$BE,$DE,$64,$50,$85,$A9 ; BD48  launch_param 425
        .byte $00,$00,$C6,$E0,$64,$50,$05,$AA ; BD50  launch_param 426
        .byte $00,$00,$CE,$E2,$64,$50,$85,$AB ; BD58  launch_param 427
        .byte $00,$00,$D6,$E4,$64,$50,$05,$AC ; BD60  launch_param 428
        .byte $00,$00,$DE,$E6,$64,$50,$05,$AD ; BD68  launch_param 429
        .byte $01,$00,$06,$AE,$30,$00,$02,$AE ; BD70  launch_param 430
        .byte $01,$00,$06,$BE,$30,$00,$02,$AF ; BD78  launch_param 431
        .byte $01,$00,$06,$CE,$30,$00,$02,$B0 ; BD80  launch_param 432
        .byte $01,$00,$06,$DE,$30,$00,$02,$B1 ; BD88  launch_param 433
        .byte $01,$00,$06,$EE,$30,$00,$02,$B2 ; BD90  launch_param 434
        .byte $01,$00,$06,$FE,$30,$00,$82,$B3 ; BD98  launch_param 435
        .byte $01,$00,$06,$FE,$60,$00,$02,$B4 ; BDA0  launch_param 436
        .byte $01,$00,$06,$0E,$70,$00,$02,$B5 ; BDA8  launch_param 437
        .byte $01,$00,$06,$1E,$70,$00,$02,$B6 ; BDB0  launch_param 438
        .byte $01,$00,$06,$2E,$70,$00,$02,$B7 ; BDB8  launch_param 439
        .byte $01,$00,$06,$3E,$70,$00,$02,$B8 ; BDC0  launch_param 440
        .byte $01,$00,$06,$4E,$70,$00,$02,$B9 ; BDC8  launch_param 441
        .byte $01,$00,$06,$5E,$70,$00,$02,$BA ; BDD0  launch_param 442
        .byte $01,$00,$06,$6E,$70,$00,$02,$BB ; BDD8  launch_param 443
        .byte $01,$00,$06,$7E,$70,$00,$02,$BC ; BDE0  launch_param 444
        .byte $01,$00,$06,$8E,$70,$00,$02,$BD ; BDE8  launch_param 445
        .byte $01,$00,$06,$9E,$70,$00,$02,$BE ; BDF0  launch_param 446
        .byte $01,$00,$06,$AE,$70,$00,$02,$BF ; BDF8  launch_param 447
        .byte $01,$00,$06,$BE,$70,$00,$02,$C0 ; BE00  launch_param 448
        .byte $01,$00,$06,$CE,$70,$00,$02,$C1 ; BE08  launch_param 449
        .byte $01,$00,$06,$DE,$70,$00,$02,$C2 ; BE10  launch_param 450
        .byte $01,$00,$06,$EE,$70,$00,$82,$C3 ; BE18  launch_param 451
        .byte $01,$00,$06,$FE,$70,$00,$02,$C4 ; BE20  launch_param 452
        .byte $01,$00,$06,$0E,$00,$02,$02,$C5 ; BE28  launch_param 453
        .byte $01,$00,$06,$1E,$00,$02,$02,$C6 ; BE30  launch_param 454
        .byte $01,$00,$06,$2E,$00,$02,$02,$C7 ; BE38  launch_param 455
        .byte $01,$00,$06,$3E,$00,$02,$02,$C8 ; BE40  launch_param 456
        .byte $48,$00,$06,$4E,$00,$02,$02,$01 ; BE48  launch_param 457
        .byte $01,$00,$06,$5E,$00,$02,$02,$CA ; BE50  launch_param 458
        .byte $01,$00,$06,$6E,$00,$02,$02,$CB ; BE58  launch_param 459
        .byte $01,$00,$06,$7E,$00,$02,$02,$CC ; BE60  launch_param 460
        .byte $01,$00,$06,$8E,$00,$02,$02,$CD ; BE68  launch_param 461
        .byte $01,$00,$06,$9E,$00,$02,$02,$CE ; BE70  launch_param 462
        .byte $01,$00,$06,$AE,$00,$02,$02,$CF ; BE78  launch_param 463
        .byte $01,$00,$06,$BE,$00,$02,$02,$D0 ; BE80  launch_param 464
        .byte $01,$00,$06,$CE,$00,$02,$02,$D1 ; BE88  launch_param 465
        .byte $01,$00,$06,$DE,$00,$02,$02,$D2 ; BE90  launch_param 466
        .byte $01,$00,$06,$EE,$00,$02,$02,$D3 ; BE98  launch_param 467
        .byte $01,$00,$06,$FE,$00,$02,$02,$D4 ; BEA0  launch_param 468
        .byte $01,$00,$06,$2E,$00,$01,$02,$D5 ; BEA8  launch_param 469
        .byte $20,$01,$A4,$54,$20,$60,$04,$01 ; BEB0  launch_param 470
        .byte $20,$01,$A4,$54,$20,$60,$04,$02 ; BEB8  launch_param 471
        .byte $20,$01,$A4,$54,$20,$60,$04,$03 ; BEC0  launch_param 472
        .byte $20,$01,$A4,$54,$20,$60,$04,$04 ; BEC8  launch_param 473
        .byte $20,$01,$A4,$54,$20,$60,$04,$05 ; BED0  launch_param 474
        .byte $20,$01,$A4,$54,$20,$60,$04,$06 ; BED8  launch_param 475
        .byte $20,$01,$A4,$54,$20,$60,$04,$07 ; BEE0  launch_param 476
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$0C ; BEE8  launch_param 477
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$0E ; BEF0  launch_param 478
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$0F ; BEF8  launch_param 479
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$10 ; BF00  launch_param 480
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$11 ; BF08  launch_param 481
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$12 ; BF10  launch_param 482
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$13 ; BF18  launch_param 483
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$14 ; BF20  launch_param 484
        .byte $10,$FD,$2E,$1C,$54,$10,$04,$15 ; BF28  launch_param 485
        .byte $71,$07,$24,$44,$20,$60,$04,$01 ; BF30  launch_param 486
        .byte $71,$07,$24,$44,$20,$60,$04,$02 ; BF38  launch_param 487
        .byte $71,$07,$24,$44,$20,$60,$04,$03 ; BF40  launch_param 488
        .byte $71,$07,$24,$44,$20,$60,$04,$04 ; BF48  launch_param 489
        .byte $71,$07,$24,$44,$20,$60,$04,$01 ; BF50  launch_param 490
        .byte $71,$07,$24,$44,$20,$60,$04,$02 ; BF58  launch_param 491
        .byte $71,$07,$24,$44,$20,$60,$04,$03 ; BF60  launch_param 492
        .byte $71,$07,$24,$44,$20,$60,$04,$04 ; BF68  launch_param 493
        .byte $71,$07,$24,$44,$20,$60,$04,$03 ; BF70  launch_param 494
        .byte $71,$07,$24,$44,$20,$60,$04,$04 ; BF78  launch_param 495
        .byte $B0,$01,$5E,$C6,$64,$50,$85,$01 ; BF80  launch_param 496
        .byte $B0,$01,$5E,$C6,$64,$50,$85,$02 ; BF88  launch_param 497
        .byte $B0,$01,$5E,$C6,$64,$50,$85,$03 ; BF90  launch_param 498
        .byte $48,$00,$06,$4E,$00,$02,$02,$02 ; BF98  launch_param 499
        .byte $48,$00,$06,$4E,$00,$02,$02,$03 ; BFA0  launch_param 500
        .byte $48,$00,$06,$4E,$00,$02,$02,$04 ; BFA8  launch_param 501
        .byte $48,$00,$06,$4E,$00,$02,$02,$05 ; BFB0  launch_param 502
        .byte $48,$00,$06,$4E,$00,$02,$02,$06 ; BFB8  launch_param 503
        .byte $20,$01,$E4,$5C,$20,$60,$04,$01 ; BFC0  launch_param 504
        .byte $20,$01,$E4,$5C,$20,$60,$04,$02 ; BFC8  launch_param 505
        .byte $20,$01,$E4,$5C,$20,$60,$04,$03 ; BFD0  launch_param 506
        .byte $20,$01,$E4,$5C,$20,$60,$04,$04 ; BFD8  launch_param 507
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFE0  launch_param 508
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFE8  launch_param 509
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFF0  launch_param 510
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFF8  launch_param 511
