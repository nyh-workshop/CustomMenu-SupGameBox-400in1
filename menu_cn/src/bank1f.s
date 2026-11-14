; Sup 400-in-1 Chinese menu, 8 KiB PRG bank $1F (file 0x3E000), mapped at CPU $E000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK1F"

        ldy  #$00                       ; E000
        jmp  loc_DFB7                   ; E002
loc_E005:
        cpy  $0152                      ; E005
        bne  loc_E031                   ; E008
        ; static (not seen in traces)
        inx                             ; E00A
        cpx  $0153                      ; E00B
        beq  loc_E03A                   ; E00E
        clc                             ; E010
        lda  $0156                      ; E011
        adc  #$20                       ; E014
        sta  $0156                      ; E016
        lda  $0155                      ; E019
        adc  #$00                       ; E01C
        sta  $0155                      ; E01E
        clc                             ; E021
        lda  $AE                        ; E022
        adc  $0152                      ; E024
        sta  $AE                        ; E027
        lda  $AF                        ; E029
        adc  #$00                       ; E02B
        sta  $AF                        ; E02D
        ldy  #$00                       ; E02F
loc_E031:
        sty  $0158                      ; E031
        stx  $0157                      ; E034
        jmp  loc_E046                   ; E037
loc_E03A:
        lda  #$00                       ; E03A
        sta  nmi_hook_mode              ; E03C
        lda  #$04                       ; E03E
        sta  nmi_hook_ptr               ; E040
        lda  #$E1                       ; E042
        sta  $25                        ; E044
loc_E046:
        pla                             ; E046
        tax                             ; E047
        pla                             ; E048
        tay                             ; E049
        rts                             ; E04A
        tya                             ; E04B
        pha                             ; E04C
        txa                             ; E04D
        pha                             ; E04E
        ldy  $0158                      ; E04F
        ldx  $0157                      ; E052
        lda  #$00                       ; E055
        sta  $0159                      ; E057
        clc                             ; E05A
        lda  $0156                      ; E05B
        adc  $0158                      ; E05E
        sta  $0154                      ; E061
        lda  $0155                      ; E064
        adc  #$00                       ; E067
        sta  PPU_ADDR                   ; E069
        lda  $0154                      ; E06C
        sta  PPU_ADDR                   ; E06F
loc_E072:
        clc                             ; E072
        lda  ($AE),y                    ; E073
        adc  $015C                      ; E075
        sta  PPU_DATA                   ; E078
        iny                             ; E07B
        inc  $0159                      ; E07C
        lda  $0159                      ; E07F
        cmp  #$20                       ; E082
        beq  loc_E0BE                   ; E084
        cpy  $0152                      ; E086
        bne  loc_E072                   ; E089
        inx                             ; E08B
        cpx  $0153                      ; E08C
        beq  loc_E0F3                   ; E08F
        clc                             ; E091
        lda  $0156                      ; E092
        adc  #$20                       ; E095
        sta  $0156                      ; E097
        lda  $0155                      ; E09A
        adc  #$00                       ; E09D
        sta  $0155                      ; E09F
        sta  PPU_ADDR                   ; E0A2
        lda  $0156                      ; E0A5
        sta  PPU_ADDR                   ; E0A8
        clc                             ; E0AB
        lda  $AE                        ; E0AC
        adc  $0152                      ; E0AE
        sta  $AE                        ; E0B1
        lda  $AF                        ; E0B3
        adc  #$00                       ; E0B5
        sta  $AF                        ; E0B7
        ldy  #$00                       ; E0B9
        jmp  loc_E072                   ; E0BB
loc_E0BE:
        cpy  $0152                      ; E0BE
        bne  loc_E0EA                   ; E0C1
        ; static (not seen in traces)
        inx                             ; E0C3
        cpx  $0153                      ; E0C4
        beq  loc_E0F3                   ; E0C7
        clc                             ; E0C9
        lda  $0156                      ; E0CA
        adc  #$20                       ; E0CD
        sta  $0156                      ; E0CF
        lda  $0155                      ; E0D2
        adc  #$00                       ; E0D5
        sta  $0155                      ; E0D7
        clc                             ; E0DA
        lda  $AE                        ; E0DB
        adc  $0152                      ; E0DD
        sta  $AE                        ; E0E0
        lda  $AF                        ; E0E2
        adc  #$00                       ; E0E4
        sta  $AF                        ; E0E6
        ldy  #$00                       ; E0E8
loc_E0EA:
        sty  $0158                      ; E0EA
        stx  $0157                      ; E0ED
        jmp  loc_E0FF                   ; E0F0
loc_E0F3:
        lda  #$00                       ; E0F3
        sta  nmi_hook_mode              ; E0F5
        lda  #$04                       ; E0F7
        sta  nmi_hook_ptr               ; E0F9
        lda  #$E1                       ; E0FB
        sta  $25                        ; E0FD
loc_E0FF:
        pla                             ; E0FF
        tax                             ; E100
        pla                             ; E101
        tay                             ; E102
        rts                             ; E103
        .byte $60 ; E104
sub_E105:
        ; static (not seen in traces)
        tya                             ; E105
        pha                             ; E106
        txa                             ; E107
        pha                             ; E108
        ldy  #$00                       ; E109
        lda  ($AE),y                    ; E10B
        sta  $015B                      ; E10D
        iny                             ; E110
        lda  ($AE),y                    ; E111
        sta  $015A                      ; E113
        iny                             ; E116
        lda  ($AE),y                    ; E117
        sta  $015D                      ; E119
        iny                             ; E11C
        lda  ($AE),y                    ; E11D
        sta  $015E                      ; E11F
        iny                             ; E122
        lda  ($AE),y                    ; E123
        sta  $015C                      ; E125
        clc                             ; E128
        lda  $AE                        ; E129
        adc  #$05                       ; E12B
        sta  $AE                        ; E12D
        lda  $AF                        ; E12F
        adc  #$00                       ; E131
        sta  $AF                        ; E133
        jsr  sub_DF3F                   ; E135
        pla                             ; E138
        tax                             ; E139
        pla                             ; E13A
        tay                             ; E13B
        rts                             ; E13C
sub_E13D:
        tya                             ; E13D
        pha                             ; E13E
        txa                             ; E13F
        pha                             ; E140
        ldy  #$00                       ; E141
        lda  ($AE),y                    ; E143
        sta  $015B                      ; E145
        iny                             ; E148
        lda  ($AE),y                    ; E149
        sta  $015A                      ; E14B
        iny                             ; E14E
        lda  ($AE),y                    ; E14F
        sta  $015D                      ; E151
        iny                             ; E154
        lda  ($AE),y                    ; E155
        sta  $015E                      ; E157
        iny                             ; E15A
        lda  ($AE),y                    ; E15B
        sta  $015C                      ; E15D
        inc  $015A                      ; E160
        clc                             ; E163
        lda  $AE                        ; E164
        adc  #$05                       ; E166
        sta  $AE                        ; E168
        lda  $AF                        ; E16A
        adc  #$00                       ; E16C
        sta  $AF                        ; E16E
        jsr  sub_DF3F                   ; E170
        pla                             ; E173
        tax                             ; E174
        pla                             ; E175
        tay                             ; E176
        rts                             ; E177
sub_E178:
        rts                             ; E178
        .byte $60,$A9,$B8,$85,$AE,$A9,$E1,$85,$AF,$A9,$08,$8D,$52,$01,$8D,$53 ; E179
        .byte $01,$A9,$21,$8D,$55,$01,$A9,$02,$8D,$56,$01,$A9,$00,$8D,$57,$01 ; E189
        .byte $8D,$58,$01,$8D,$5C,$01,$A9,$4B,$85,$24,$A9,$E0,$85,$25,$A9,$01 ; E199
        .byte $85,$1C,$A5,$1C,$D0,$FC,$60,$60,$60,$EA,$EA,$14,$1C,$04,$0C,$00 ; E1A9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E1B9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E1C9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E1D9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E1E9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E1F9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E209
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E219
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E229
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E239
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E249
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E259
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E269
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E279
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E289
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E299
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2A9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2B9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2C9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2D9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2E9
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E2F9
        .byte $00,$00,$00,$64,$74,$9C,$9E,$3A,$1A ; E309
sub_E312:
        lda  #$00                       ; E312
        sta  $AE                        ; E314
        lda  #$BA                       ; E316
        sta  $AF                        ; E318
        lda  #$13                       ; E31A
        sta  $0152                      ; E31C
        lda  #$14                       ; E31F
        sta  $0153                      ; E321
        lda  #$20                       ; E324
        sta  $0155                      ; E326
        lda  #$A8                       ; E329
        sta  $0156                      ; E32B
        lda  #$00                       ; E32E
        sta  $0157                      ; E330
        sta  $0158                      ; E333
        sta  $015C                      ; E336
        lda  #$4B                       ; E339
        sta  nmi_hook_ptr               ; E33B
        lda  #$E0                       ; E33D
        sta  $25                        ; E33F
        lda  #$01                       ; E341
        sta  nmi_hook_mode              ; E343
loc_E345:
        lda  nmi_hook_mode              ; E345
        bne  loc_E345                   ; E347
        rts                             ; E349
sound_tick:
        jsr  sfx_tick                   ; E34A
        jsr  music_tick                 ; E34D
        rts                             ; E350
sound_play:
        ; static (not seen in traces)
        tya                             ; E351
        pha                             ; E352
        txa                             ; E353
        pha                             ; E354
        lda  sound_id                   ; E355
        asl  a                          ; E357
        tax                             ; E358
        lda  tbl_sfx_ptrs,x             ; E359
        sta  $EA                        ; E35C
        lda  tbl_sfx_ptrs_hi,x          ; E35E
        sta  $EB                        ; E361
        ldy  #$00                       ; E363
        lda  ($EA),y                    ; E365
        sta  $D8                        ; E367
        ora  $E4                        ; E369
        sta  $E4                        ; E36B
        lda  $D8                        ; E36D
        beq  loc_E371                   ; E36F
loc_E371:
        jsr  sfx_start_channel          ; E371
        pla                             ; E374
        tax                             ; E375
        pla                             ; E376
        tay                             ; E377
        rts                             ; E378
sound_init:
        tya                             ; E379
        pha                             ; E37A
        txa                             ; E37B
        pha                             ; E37C
        ldy  #$00                       ; E37D
        sty  APU_STATUS                 ; E37F
        sty  $0358                      ; E382
        sty  a:$0080                    ; E385
loc_E388:
        lda  #$FF                       ; E388
        sta  $0300,y                    ; E38A
        tya                             ; E38D
        clc                             ; E38E
        adc  #$15                       ; E38F
        tay                             ; E391
        cmp  #$54                       ; E392
        bcc  loc_E388                   ; E394
        jsr  snd_credit_checksum        ; E396
        jsr  music_start_song           ; E399
        pla                             ; E39C
        tax                             ; E39D
        pla                             ; E39E
        tay                             ; E39F
        rts                             ; E3A0
music_start_song:
        lda  a:$0081                    ; E3A1
        asl  a                          ; E3A4
        tay                             ; E3A5
        lda  tbl_song_records,y         ; E3A6
        sta  $D6                        ; E3A9
        lda  tbl_song_records_hi,y      ; E3AB
        sta  $D7                        ; E3AE
        lda  a:$0081                    ; E3B0
        asl  a                          ; E3B3
        tay                             ; E3B4
        lda  tbl_song_ntracks,y         ; E3B5
        sta  $D2                        ; E3B8
        lda  tbl_song_first_track,y     ; E3BA
        tay                             ; E3BD
        lda  $D2                        ; E3BE
        beq  music_start_track          ; E3C0
        cmp  #$02                       ; E3C2
        beq  loc_E3CB                   ; E3C4
        bcc  loc_E3CE                   ; E3C6
        jsr  music_start_track          ; E3C8
loc_E3CB:
        jsr  music_start_track          ; E3CB
loc_E3CE:
        jsr  music_start_track          ; E3CE
music_start_track:
        sty  $CE                        ; E3D1
        sty  $D3                        ; E3D3
        stx  $D4                        ; E3D5
        lda  #$00                       ; E3D7
        asl  $CE                        ; E3D9
        rol  a                          ; E3DB
        asl  $CE                        ; E3DC
        rol  a                          ; E3DE
        pha                             ; E3DF
        lda  $D6                        ; E3E0
        clc                             ; E3E2
        adc  $CE                        ; E3E3
        sta  $CE                        ; E3E5
        pla                             ; E3E7
        adc  $D7                        ; E3E8
        sta  $CF                        ; E3EA
        ldy  #$00                       ; E3EC
        lda  ($CE),y                    ; E3EE
        tax                             ; E3F0
        lda  $0300,x                    ; E3F1
        cmp  #$FF                       ; E3F4
        beq  loc_E407                   ; E3F6
        ; static (not seen in traces)
        lda  $0301,x                    ; E3F8
        and  #$03                       ; E3FB
        tay                             ; E3FD
        lda  tbl_chan_clear_mask,y      ; E3FE
        and  $0358                      ; E401
        sta  $0358                      ; E404
loc_E407:
        ldy  #$01                       ; E407
        lda  ($CE),y                    ; E409
        sta  $0301,x                    ; E40B
        iny                             ; E40E
        lda  ($CE),y                    ; E40F
        sta  $0302,x                    ; E411
        iny                             ; E414
        lda  ($CE),y                    ; E415
        sta  $0303,x                    ; E417
        lda  #$00                       ; E41A
        sta  $0300,x                    ; E41C
        ldx  $D4                        ; E41F
        ldy  $D3                        ; E421
        iny                             ; E423
        rts                             ; E424
snd_credit_checksum:
        lda  #$00                       ; E425
        ldy  #$00                       ; E427
loc_E429:
        clc                             ; E429
        adc  snd_credit_gb2312,y        ; E42A
        iny                             ; E42D
        cpy  #$0E                       ; E42E
        bne  loc_E429                   ; E430
        cmp  #$25                       ; E432
        beq  loc_E439                   ; E434
        ; static (not seen in traces)
        jmp  loc_E87C                   ; E436
loc_E439:
        rts                             ; E439
sfx_start_channel:
        ; static (not seen in traces)
        iny                             ; E43A
        lda  ($EA),y                    ; E43B
        sta  $D8                        ; E43D
        ora  $D9                        ; E43F
        sta  $D9                        ; E441
        lda  $D8                        ; E443
        ora  $0358                      ; E445
        ora  a:$0080                    ; E448
        sta  a:$0080                    ; E44B
        sta  APU_STATUS                 ; E44E
        lda  $D8                        ; E451
        cmp  #$01                       ; E453
        beq  loc_E464                   ; E455
        cmp  #$02                       ; E457
        beq  loc_E469                   ; E459
        cmp  #$04                       ; E45B
        beq  loc_E46E                   ; E45D
        ldx  #$03                       ; E45F
        jmp  loc_E470                   ; E461
loc_E464:
        ldx  #$00                       ; E464
        jmp  loc_E470                   ; E466
loc_E469:
        ldx  #$01                       ; E469
        jmp  loc_E470                   ; E46B
loc_E46E:
        ldx  #$02                       ; E46E
loc_E470:
        iny                             ; E470
        lda  ($EA),y                    ; E471
        sta  $E5,x                      ; E473
        iny                             ; E475
        lda  ($EA),y                    ; E476
        sta  $F0,x                      ; E478
        iny                             ; E47A
        lda  ($EA),y                    ; E47B
        sta  $EC,x                      ; E47D
        lda  #$00                       ; E47F
        sta  $F4,x                      ; E481
        sta  $E0,x                      ; E483
        txa                             ; E485
        asl  a                          ; E486
        asl  a                          ; E487
        tax                             ; E488
        iny                             ; E489
        lda  ($EA),y                    ; E48A
        sta  APU_4000,x                 ; E48C
        iny                             ; E48F
        lda  ($EA),y                    ; E490
        sta  APU_4001,x                 ; E492
        iny                             ; E495
        lda  ($EA),y                    ; E496
        sta  APU_4002,x                 ; E498
        iny                             ; E49B
        lda  ($EA),y                    ; E49C
        sta  APU_4003,x                 ; E49E
        iny                             ; E4A1
        tya                             ; E4A2
        clc                             ; E4A3
        adc  $EA                        ; E4A4
        sta  $EA                        ; E4A6
        lda  $EB                        ; E4A8
        adc  #$00                       ; E4AA
        sta  $EB                        ; E4AC
        txa                             ; E4AE
        lsr  a                          ; E4AF
        tax                             ; E4B0
        lda  $EA                        ; E4B1
        sta  $F8,x                      ; E4B3
        lda  $EB                        ; E4B5
        sta  $F9,x                      ; E4B7
        rts                             ; E4B9
sfx_tick:
        lda  $E4                        ; E4BA
        and  #$01                       ; E4BC
        beq  loc_E4C3                   ; E4BE
        ; static (not seen in traces)
        jsr  sfx_tick_channels          ; E4C0
loc_E4C3:
        rts                             ; E4C3
sfx_tick_channels:
        ; static (not seen in traces)
        jsr  sfx_tick_pulse1            ; E4C4
        jsr  sfx_tick_pulse2            ; E4C7
        jsr  sfx_tick_triangle          ; E4CA
        jsr  sfx_tick_noise             ; E4CD
        rts                             ; E4D0
sfx_tick_pulse1:
        lda  $D9                        ; E4D1
        and  #$01                       ; E4D3
        beq  loc_E542                   ; E4D5
        inc  $F4                        ; E4D7
        lda  $F4                        ; E4D9
        cmp  $F0                        ; E4DB
        bcc  loc_E542                   ; E4DD
        lda  #$00                       ; E4DF
        sta  $F4                        ; E4E1
        lda  $E0                        ; E4E3
        cmp  $EC                        ; E4E5
        bcs  loc_E52E                   ; E4E7
        ldy  #$00                       ; E4E9
        lda  $E5                        ; E4EB
        and  #$01                       ; E4ED
        beq  loc_E4F7                   ; E4EF
        lda  ($F8),y                    ; E4F1
        sta  APU_4000                   ; E4F3
        iny                             ; E4F6
loc_E4F7:
        lda  $E5                        ; E4F7
        and  #$02                       ; E4F9
        beq  loc_E503                   ; E4FB
        lda  ($F8),y                    ; E4FD
        sta  APU_4001                   ; E4FF
        iny                             ; E502
loc_E503:
        lda  $E5                        ; E503
        and  #$04                       ; E505
        beq  loc_E50F                   ; E507
        lda  ($F8),y                    ; E509
        sta  APU_4002                   ; E50B
        iny                             ; E50E
loc_E50F:
        lda  $E5                        ; E50F
        and  #$08                       ; E511
        beq  loc_E51B                   ; E513
        lda  ($F8),y                    ; E515
        sta  APU_4003                   ; E517
        iny                             ; E51A
loc_E51B:
        tya                             ; E51B
        clc                             ; E51C
        adc  $E0                        ; E51D
        sta  $E0                        ; E51F
        tya                             ; E521
        clc                             ; E522
        adc  $F8                        ; E523
        sta  $F8                        ; E525
        lda  $F9                        ; E527
        adc  #$00                       ; E529
        sta  $F9                        ; E52B
        rts                             ; E52D
loc_E52E:
        lda  $D9                        ; E52E
        and  #$FE                       ; E530
        sta  $D9                        ; E532
        lda  a:$0080                    ; E534
        and  #$FE                       ; E537
        sta  a:$0080                    ; E539
        ora  $0358                      ; E53C
        sta  APU_STATUS                 ; E53F
loc_E542:
        rts                             ; E542
sfx_tick_pulse2:
        lda  $D9                        ; E543
        and  #$02                       ; E545
        beq  loc_E5B4                   ; E547
        inc  $F5                        ; E549
        lda  $F5                        ; E54B
        cmp  $F1                        ; E54D
        bcc  loc_E5B4                   ; E54F
        lda  #$00                       ; E551
        sta  $F5                        ; E553
        lda  $E1                        ; E555
        cmp  $ED                        ; E557
        bcs  loc_E5A0                   ; E559
        ldy  #$00                       ; E55B
        lda  $E6                        ; E55D
        and  #$01                       ; E55F
        beq  loc_E569                   ; E561
        lda  ($FA),y                    ; E563
        sta  APU_4004                   ; E565
        iny                             ; E568
loc_E569:
        lda  $E6                        ; E569
        and  #$02                       ; E56B
        beq  loc_E575                   ; E56D
        lda  ($FA),y                    ; E56F
        sta  APU_4005                   ; E571
        iny                             ; E574
loc_E575:
        lda  $E6                        ; E575
        and  #$04                       ; E577
        beq  loc_E581                   ; E579
        lda  ($FA),y                    ; E57B
        sta  APU_4006                   ; E57D
        iny                             ; E580
loc_E581:
        lda  $E6                        ; E581
        and  #$08                       ; E583
        beq  loc_E58D                   ; E585
        lda  ($FA),y                    ; E587
        sta  APU_4007                   ; E589
        iny                             ; E58C
loc_E58D:
        tya                             ; E58D
        clc                             ; E58E
        adc  $E1                        ; E58F
        sta  $E1                        ; E591
        tya                             ; E593
        clc                             ; E594
        adc  $FA                        ; E595
        sta  $FA                        ; E597
        lda  $FB                        ; E599
        adc  #$00                       ; E59B
        sta  $FB                        ; E59D
        rts                             ; E59F
loc_E5A0:
        lda  $D9                        ; E5A0
        and  #$FD                       ; E5A2
        sta  $D9                        ; E5A4
        lda  a:$0080                    ; E5A6
        and  #$FD                       ; E5A9
        sta  a:$0080                    ; E5AB
        ora  $0358                      ; E5AE
        sta  APU_STATUS                 ; E5B1
loc_E5B4:
        rts                             ; E5B4
sfx_tick_triangle:
        lda  $D9                        ; E5B5
        and  #$04                       ; E5B7
        beq  loc_E626                   ; E5B9
        inc  $F6                        ; E5BB
        lda  $F6                        ; E5BD
        cmp  $F2                        ; E5BF
        bcc  loc_E626                   ; E5C1
        lda  #$00                       ; E5C3
        sta  $F6                        ; E5C5
        lda  $E2                        ; E5C7
        cmp  $EE                        ; E5C9
        bcs  loc_E612                   ; E5CB
        ldy  #$00                       ; E5CD
        lda  $E7                        ; E5CF
        and  #$01                       ; E5D1
        beq  loc_E5DB                   ; E5D3
        lda  ($FC),y                    ; E5D5
        sta  APU_4008                   ; E5D7
        iny                             ; E5DA
loc_E5DB:
        lda  $E7                        ; E5DB
        and  #$02                       ; E5DD
        beq  loc_E5E7                   ; E5DF
        lda  ($FC),y                    ; E5E1
        sta  APU_4009                   ; E5E3
        iny                             ; E5E6
loc_E5E7:
        lda  $E7                        ; E5E7
        and  #$04                       ; E5E9
        beq  loc_E5F3                   ; E5EB
        lda  ($FC),y                    ; E5ED
        sta  APU_400A                   ; E5EF
        iny                             ; E5F2
loc_E5F3:
        lda  $E7                        ; E5F3
        and  #$08                       ; E5F5
        beq  loc_E5FF                   ; E5F7
        lda  ($FC),y                    ; E5F9
        sta  APU_400B                   ; E5FB
        iny                             ; E5FE
loc_E5FF:
        tya                             ; E5FF
        clc                             ; E600
        adc  $E2                        ; E601
        sta  $E2                        ; E603
        tya                             ; E605
        clc                             ; E606
        adc  $FC                        ; E607
        sta  $FC                        ; E609
        lda  $FD                        ; E60B
        adc  #$00                       ; E60D
        sta  $FD                        ; E60F
        rts                             ; E611
loc_E612:
        lda  $D9                        ; E612
        and  #$FB                       ; E614
        sta  $D9                        ; E616
        lda  a:$0080                    ; E618
        and  #$FB                       ; E61B
        sta  a:$0080                    ; E61D
        ora  $0358                      ; E620
        sta  APU_STATUS                 ; E623
loc_E626:
        rts                             ; E626
sfx_tick_noise:
        lda  $D9                        ; E627
        and  #$08                       ; E629
        beq  loc_E698                   ; E62B
        inc  $F7                        ; E62D
        lda  $F7                        ; E62F
        cmp  $F3                        ; E631
        bcc  loc_E698                   ; E633
        lda  #$00                       ; E635
        sta  $F7                        ; E637
        lda  $E3                        ; E639
        cmp  $EF                        ; E63B
        bcs  loc_E684                   ; E63D
        ldy  #$00                       ; E63F
        lda  $E8                        ; E641
        and  #$01                       ; E643
        beq  loc_E64D                   ; E645
        lda  ($FE),y                    ; E647
        sta  APU_400C                   ; E649
        iny                             ; E64C
loc_E64D:
        lda  $E8                        ; E64D
        and  #$02                       ; E64F
        beq  loc_E659                   ; E651
        lda  ($FE),y                    ; E653
        sta  APU_400D                   ; E655
        iny                             ; E658
loc_E659:
        lda  $E8                        ; E659
        and  #$04                       ; E65B
        beq  loc_E665                   ; E65D
        lda  ($FE),y                    ; E65F
        sta  APU_400E                   ; E661
        iny                             ; E664
loc_E665:
        lda  $E8                        ; E665
        and  #$08                       ; E667
        beq  loc_E671                   ; E669
        lda  ($FE),y                    ; E66B
        sta  APU_400F                   ; E66D
        iny                             ; E670
loc_E671:
        tya                             ; E671
        clc                             ; E672
        adc  $E3                        ; E673
        sta  $E3                        ; E675
        tya                             ; E677
        clc                             ; E678
        adc  $FE                        ; E679
        sta  $FE                        ; E67B
        lda  $FF                        ; E67D
        adc  #$00                       ; E67F
        sta  $FF                        ; E681
        rts                             ; E683
loc_E684:
        lda  $D9                        ; E684
        and  #$F7                       ; E686
        sta  $D9                        ; E688
        lda  a:$0080                    ; E68A
        and  #$F7                       ; E68D
        sta  a:$0080                    ; E68F
        ora  $0358                      ; E692
        sta  APU_STATUS                 ; E695
loc_E698:
        rts                             ; E698
music_tick:
        lda  #$00                       ; E699
        sta  $0354                      ; E69B
        inc  $035B                      ; E69E
loc_E6A1:
        tax                             ; E6A1
        lda  $0301,x                    ; E6A2
        and  #$03                       ; E6A5
        sta  $0355                      ; E6A7
        tay                             ; E6AA
        asl  a                          ; E6AB
        asl  a                          ; E6AC
        sta  $0357                      ; E6AD
        lda  tbl_chan_type,y            ; E6B0
        sta  $0356                      ; E6B3
        lda  $0300,x                    ; E6B6
        beq  music_read_header          ; E6B9
        cmp  #$FF                       ; E6BB
        beq  loc_E719                   ; E6BD
        jsr  music_vibrato              ; E6BF
        jsr  music_envelope             ; E6C2
        inc  $030D,x                    ; E6C5
        lda  $030D,x                    ; E6C8
        cmp  $030C,x                    ; E6CB
        bcc  loc_E6D6                   ; E6CE
        lda  $030C,x                    ; E6D0
        sta  $030D,x                    ; E6D3
loc_E6D6:
        lda  $0305,x                    ; E6D6
        sec                             ; E6D9
        sbc  #$10                       ; E6DA
        sta  $0305,x                    ; E6DC
        bpl  loc_E6FE                   ; E6DF
        lda  $0304,x                    ; E6E1
        clc                             ; E6E4
        adc  $0305,x                    ; E6E5
        clc                             ; E6E8
        adc  #$01                       ; E6E9
        sta  $0305,x                    ; E6EB
        jsr  music_volume_slide         ; E6EE
        lda  $0314,x                    ; E6F1
        beq  loc_E6F9                   ; E6F4
        ; static (not seen in traces)
        dec  $0314,x                    ; E6F6
loc_E6F9:
        dec  $0307,x                    ; E6F9
        beq  loc_E704                   ; E6FC
loc_E6FE:
        jsr  music_write_volume_chk     ; E6FE
        jmp  loc_E70D                   ; E701
loc_E704:
        lda  $0313,x                    ; E704
        sta  $0314,x                    ; E707
        jsr  music_read_commands        ; E70A
loc_E70D:
        ldy  $0355                      ; E70D
        lda  tbl_chan_bit,y             ; E710
        ora  $0354                      ; E713
        sta  $0354                      ; E716
loc_E719:
        txa                             ; E719
        clc                             ; E71A
        adc  #$15                       ; E71B
        cmp  #$54                       ; E71D
        bne  loc_E6A1                   ; E71F
        rts                             ; E721
music_read_header:
        lda  $0302,x                    ; E722
        sta  $D0                        ; E725
        lda  $0303,x                    ; E727
        sta  $D1                        ; E72A
        ldy  #$00                       ; E72C
        lda  ($D0),y                    ; E72E
        pha                             ; E730
        asl  a                          ; E731
        sta  $0304,x                    ; E732
        pla                             ; E735
        rol  a                          ; E736
        asl  $0304,x                    ; E737
        rol  a                          ; E73A
        asl  $0304,x                    ; E73B
        rol  a                          ; E73E
        asl  $0304,x                    ; E73F
        rol  a                          ; E742
        clc                             ; E743
        adc  #$0F                       ; E744
        sta  $0304,x                    ; E746
        sta  $0305,x                    ; E749
        iny                             ; E74C
        jsr  music_read_duty            ; E74D
        iny                             ; E750
        lda  ($D0),y                    ; E751
        ora  $0359                      ; E753
        sta  $0306,x                    ; E756
        iny                             ; E759
        lda  ($D0),y                    ; E75A
        sta  $0308,x                    ; E75C
        lda  #$00                       ; E75F
        sta  $0309,x                    ; E761
        sta  $030A,x                    ; E764
        sta  $030B,x                    ; E767
        sta  $030E,x                    ; E76A
        lda  #$02                       ; E76D
        sta  $0300,x                    ; E76F
        bne  loc_E704                   ; E772
music_read_commands:
        ldy  #$00                       ; E774
        sty  $D1                        ; E776
        lda  $0300,x                    ; E778
        asl  a                          ; E77B
        rol  $D1                        ; E77C
        adc  $0302,x                    ; E77E
        sta  $D0                        ; E781
        lda  $0303,x                    ; E783
        adc  $D1                        ; E786
        sta  $D1                        ; E788
loc_E78A:
        lda  ($D0),y                    ; E78A
        inc  $0300,x                    ; E78C
        iny                             ; E78F
        cmp  #$F0                       ; E790
        bcs  loc_E7AE                   ; E792
        cmp  #$E0                       ; E794
        bcs  loc_E7C6                   ; E796
        cmp  #$D0                       ; E798
        bcs  loc_E7D0                   ; E79A
        cmp  #$C0                       ; E79C
        bcs  loc_E7E6                   ; E79E
        cmp  #$B0                       ; E7A0
        bcs  loc_E806                   ; E7A2
        cmp  #$A0                       ; E7A4
        bcc  loc_E7AB                   ; E7A6
        jmp  loc_E834                   ; E7A8
loc_E7AB:
        jmp  music_cmd_note             ; E7AB
loc_E7AE:
        ; static (not seen in traces)
        cmp  #$FD                       ; E7AE
        bne  loc_E7BC                   ; E7B0
        lda  $0300,x                    ; E7B2
        sta  $0312,x                    ; E7B5
loc_E7B8:
        iny                             ; E7B8
        jmp  loc_E78A                   ; E7B9
loc_E7BC:
        cmp  #$FF                       ; E7BC
        bne  loc_E7B8                   ; E7BE
        sta  $0300,x                    ; E7C0
        jmp  music_cmd_rest             ; E7C3
loc_E7C6:
        and  #$0F                       ; E7C6
        eor  #$FF                       ; E7C8
        clc                             ; E7CA
        adc  #$01                       ; E7CB
        jmp  loc_E7D2                   ; E7CD
loc_E7D0:
        and  #$0F                       ; E7D0
loc_E7D2:
        bit  $0356                      ; E7D2
        bmi  loc_E7E2                   ; E7D5
        sta  $030E,x                    ; E7D7
        lda  ($D0),y                    ; E7DA
        sta  $030F,x                    ; E7DC
        sta  $0310,x                    ; E7DF
loc_E7E2:
        iny                             ; E7E2
        jmp  loc_E78A                   ; E7E3
loc_E7E6:
        and  #$0F                       ; E7E6
        sta  $0359                      ; E7E8
        bit  $0356                      ; E7EB
        bmi  loc_E802                   ; E7EE
        lda  $0306,x                    ; E7F0
        and  #$10                       ; E7F3
        beq  loc_E802                   ; E7F5
        lda  ($D0),y                    ; E7F7
        sta  $030C,x                    ; E7F9
        lda  $0359                      ; E7FC
        sta  $030B,x                    ; E7FF
loc_E802:
        iny                             ; E802
        jmp  loc_E78A                   ; E803
loc_E806:
        ; static (not seen in traces)
        and  #$0F                       ; E806
        beq  loc_E827                   ; E808
        pha                             ; E80A
        lda  ($D0),y                    ; E80B
        bne  loc_E81C                   ; E80D
        pla                             ; E80F
        dec  $0309,x                    ; E810
        beq  loc_E831                   ; E813
        bpl  loc_E827                   ; E815
        sta  $0309,x                    ; E817
        bmi  loc_E827                   ; E81A
loc_E81C:
        pla                             ; E81C
        dec  $030A,x                    ; E81D
        beq  loc_E831                   ; E820
        bpl  loc_E827                   ; E822
        sta  $030A,x                    ; E824
loc_E827:
        lda  ($D0),y                    ; E827
        bne  loc_E82E                   ; E829
        lda  $0312,x                    ; E82B
loc_E82E:
        sta  $0300,x                    ; E82E
loc_E831:
        jmp  music_read_commands        ; E831
loc_E834:
        bne  loc_E845                   ; E834
        ; static (not seen in traces)
        bit  $0356                      ; E836
        bmi  loc_E84E                   ; E839
        lda  $0306,x                    ; E83B
        and  #$C0                       ; E83E
        ora  ($D0),y                    ; E840
        jmp  loc_E863                   ; E842
loc_E845:
        cmp  #$A1                       ; E845
        bne  loc_E852                   ; E847
        lda  ($D0),y                    ; E849
        sta  $0308,x                    ; E84B
loc_E84E:
        iny                             ; E84E
        jmp  loc_E78A                   ; E84F
loc_E852:
        cmp  #$A2                       ; E852
        bne  loc_E86A                   ; E854
        jsr  music_read_duty            ; E856
        bcs  loc_E863                   ; E859
        lda  $0306,x                    ; E85B
        and  #$1F                       ; E85E
        ora  $0359                      ; E860
loc_E863:
        sta  $0306,x                    ; E863
        iny                             ; E866
        jmp  loc_E78A                   ; E867
loc_E86A:
        ; static (not seen in traces)
        cmp  #$A3                       ; E86A
        bne  loc_E88B                   ; E86C
        lda  ($D0),y                    ; E86E
        bmi  loc_E88F                   ; E870
        pha                             ; E872
        and  #$0F                       ; E873
        asl  a                          ; E875
        sta  $0313,x                    ; E876
        sta  $0314,x                    ; E879
loc_E87C:
        pla                             ; E87C
        and  #$70                       ; E87D
        ora  $0355                      ; E87F
        ora  #$80                       ; E882
        sta  $0301,x                    ; E884
        iny                             ; E887
        jmp  loc_E78A                   ; E888
loc_E88B:
        cmp  #$A4                       ; E88B
        bne  loc_E89B                   ; E88D
loc_E88F:
        lda  $0301,x                    ; E88F
        and  #$03                       ; E892
        sta  $0301,x                    ; E894
        iny                             ; E897
        jmp  loc_E78A                   ; E898
loc_E89B:
        cmp  #$AD                       ; E89B
        bne  loc_E8C5                   ; E89D
        lda  ($D0),y                    ; E89F
        pha                             ; E8A1
        lda  #$00                       ; E8A2
        sta  $D1                        ; E8A4
        lda  $0300,x                    ; E8A6
        asl  a                          ; E8A9
        rol  $D1                        ; E8AA
        adc  $0302,x                    ; E8AC
        sta  $0302,x                    ; E8AF
        lda  $0303,x                    ; E8B2
        adc  $D1                        ; E8B5
        sta  $0303,x                    ; E8B7
        lda  #$00                       ; E8BA
        sta  $0300,x                    ; E8BC
        pla                             ; E8BF
        bne  loc_E8D2                   ; E8C0
        jmp  music_read_header          ; E8C2
loc_E8C5:
        cmp  #$AE                       ; E8C5
        bne  loc_E8D6                   ; E8C7
        asl  $0304,x                    ; E8C9
        lda  ($D0),y                    ; E8CC
        asl  a                          ; E8CE
        ror  $0304,x                    ; E8CF
loc_E8D2:
        iny                             ; E8D2
        jmp  loc_E78A                   ; E8D3
loc_E8D6:
        cmp  #$AF                       ; E8D6
        bne  loc_E8F8                   ; E8D8
        lda  ($D0),y                    ; E8DA
        pha                             ; E8DC
        asl  a                          ; E8DD
        sta  $0304,x                    ; E8DE
        pla                             ; E8E1
        rol  a                          ; E8E2
        asl  $0304,x                    ; E8E3
        rol  a                          ; E8E6
        asl  $0304,x                    ; E8E7
        rol  a                          ; E8EA
        asl  $0304,x                    ; E8EB
        rol  a                          ; E8EE
        clc                             ; E8EF
        adc  #$0F                       ; E8F0
        sta  $0305,x                    ; E8F2
        sta  $0304,x                    ; E8F5
loc_E8F8:
        iny                             ; E8F8
        jmp  loc_E78A                   ; E8F9
music_cmd_note:
        sta  $0359                      ; E8FC
        lda  ($D0),y                    ; E8FF
        sta  $0307,x                    ; E901
        lda  $0359                      ; E904
        bit  $0356                      ; E907
        bvs  loc_E975                   ; E90A
        pha                             ; E90C
        and  #$0F                       ; E90D
        cmp  #$0C                       ; E90F
        bcs  loc_E983                   ; E911
        asl  a                          ; E913
        tay                             ; E914
        lda  tbl_note_period_lo,y       ; E915
        sta  $0359                      ; E918
        lda  tbl_note_period_hi,y       ; E91B
        sta  $035A                      ; E91E
        pla                             ; E921
        lsr  a                          ; E922
        lsr  a                          ; E923
        lsr  a                          ; E924
        lsr  a                          ; E925
        beq  loc_E932                   ; E926
        tay                             ; E928
loc_E929:
        lsr  $035A                      ; E929
        ror  $0359                      ; E92C
        dey                             ; E92F
        bne  loc_E929                   ; E930
loc_E932:
        lda  #$00                       ; E932
        sta  $030D,x                    ; E934
        jsr  music_skip_if_sfx_owns     ; E937
        lda  tbl_chan_bit,y             ; E93A
        ora  $0358                      ; E93D
        sta  $0358                      ; E940
        jsr  apu_enable_channels        ; E943
        lda  $035A                      ; E946
        pha                             ; E949
        lda  $0359                      ; E94A
        pha                             ; E94D
        jsr  music_write_volume         ; E94E
        lda  $0308,x                    ; E951
        jsr  apu_write_r1               ; E954
        pla                             ; E957
        jsr  apu_write_r2               ; E958
        cmp  #$02                       ; E95B
        bcc  loc_E967                   ; E95D
        cmp  #$FE                       ; E95F
        bcc  loc_E969                   ; E961
        ; static (not seen in traces)
        lda  #$FD                       ; E963
        bne  loc_E969                   ; E965
loc_E967:
        lda  #$02                       ; E967
loc_E969:
        sta  $0311,x                    ; E969
        pla                             ; E96C
        and  #$07                       ; E96D
        ora  #$08                       ; E96F
        jsr  apu_write_r3               ; E971
        rts                             ; E974
loc_E975:
        cmp  #$10                       ; E975
        bcs  music_cmd_rest             ; E977
        sta  $0359                      ; E979
        lda  #$00                       ; E97C
        sta  $035A                      ; E97E
        beq  loc_E932                   ; E981
loc_E983:
        pla                             ; E983
music_cmd_rest:
        jsr  music_skip_if_sfx_owns     ; E984
        lda  tbl_chan_clear_mask,y      ; E987
        and  $0358                      ; E98A
        sta  $0358                      ; E98D
        jsr  apu_enable_channels        ; E990
        rts                             ; E993
music_skip_if_sfx_owns:
        ldy  $0355                      ; E994
        lda  tbl_chan_bit,y             ; E997
        bit  $0354                      ; E99A
        beq  loc_E9A1                   ; E99D
        ; static (not seen in traces)
        pla                             ; E99F
        pla                             ; E9A0
loc_E9A1:
        rts                             ; E9A1
music_read_duty:
        bit  $0356                      ; E9A2
        bmi  loc_E9B3                   ; E9A5
        lda  ($D0),y                    ; E9A7
        ror  a                          ; E9A9
        ror  a                          ; E9AA
        ror  a                          ; E9AB
        and  #$C0                       ; E9AC
        sta  $0359                      ; E9AE
        clc                             ; E9B1
        rts                             ; E9B2
loc_E9B3:
        lda  ($D0),y                    ; E9B3
        and  #$7F                       ; E9B5
        sta  $0359                      ; E9B7
        sec                             ; E9BA
        rts                             ; E9BB
music_write_volume_chk:
        jsr  music_skip_if_sfx_owns     ; E9BC
music_write_volume:
        cpy  #$02                       ; E9BF
        beq  loc_E9D8                   ; E9C1
        lda  $030B,x                    ; E9C3
        bne  loc_E9EE                   ; E9C6
        lda  $0306,x                    ; E9C8
        and  #$10                       ; E9CB
        asl  a                          ; E9CD
        ora  $0306,x                    ; E9CE
        ldy  $0357                      ; E9D1
        jsr  apu_write_r0               ; E9D4
        rts                             ; E9D7
loc_E9D8:
        lda  $0306,x                    ; E9D8
        ldy  $0357                      ; E9DB
        jsr  apu_write_tri_linear       ; E9DE
loc_E9E1:
        rts                             ; E9E1
music_envelope:
        jsr  music_skip_if_sfx_owns     ; E9E2
        cpy  #$02                       ; E9E5
        beq  loc_E9E1                   ; E9E7
        lda  $030B,x                    ; E9E9
        beq  loc_E9E1                   ; E9EC
loc_E9EE:
        asl  a                          ; E9EE
        asl  a                          ; E9EF
        asl  a                          ; E9F0
        asl  a                          ; E9F1
        pha                             ; E9F2
        lda  #$00                       ; E9F3
        sta  $0359                      ; E9F5
        lda  $030D,x                    ; E9F8
        ldy  #$03                       ; E9FB
loc_E9FD:
        asl  a                          ; E9FD
        cmp  $030C,x                    ; E9FE
        bcc  loc_EA06                   ; EA01
        sbc  $030C,x                    ; EA03
loc_EA06:
        rol  $0359                      ; EA06
        dey                             ; EA09
        bpl  loc_E9FD                   ; EA0A
        pla                             ; EA0C
        ora  $0359                      ; EA0D
        tay                             ; EA10
        lda  $0306,x                    ; EA11
        and  #$0F                       ; EA14
        ora  tbl_envelope,y             ; EA16
        tay                             ; EA19
        lda  $0306,x                    ; EA1A
        and  #$C0                       ; EA1D
        ora  tbl_volume_scale,y         ; EA1F
        ldy  $0357                      ; EA22
        jsr  apu_write_r0               ; EA25
        rts                             ; EA28
music_volume_slide:
        bit  $0356                      ; EA29
        bmi  loc_EA5C                   ; EA2C
        lda  $030E,x                    ; EA2E
        beq  loc_EA5C                   ; EA31
        ; static (not seen in traces)
        dec  $0310,x                    ; EA33
        bne  loc_EA5C                   ; EA36
        lda  $030F,x                    ; EA38
        sta  $0310,x                    ; EA3B
        lda  $0306,x                    ; EA3E
        and  #$1F                       ; EA41
        sta  $0359                      ; EA43
        and  #$10                       ; EA46
        beq  loc_EA5C                   ; EA48
        lda  $030E,x                    ; EA4A
        bmi  loc_EA5D                   ; EA4D
        dec  $030E,x                    ; EA4F
        lda  $0359                      ; EA52
        cmp  #$1F                       ; EA55
        beq  loc_EA5C                   ; EA57
        inc  $0306,x                    ; EA59
loc_EA5C:
        rts                             ; EA5C
loc_EA5D:
        ; static (not seen in traces)
        inc  $030E,x                    ; EA5D
        lda  $0359                      ; EA60
        cmp  #$10                       ; EA63
        beq  loc_EA5C                   ; EA65
        dec  $0306,x                    ; EA67
        rts                             ; EA6A
music_vibrato:
        jsr  music_skip_if_sfx_owns     ; EA6B
        bit  $0356                      ; EA6E
        bvs  loc_EA98                   ; EA71
        lda  $0314,x                    ; EA73
        bne  loc_EA98                   ; EA76
        lda  $0301,x                    ; EA78
        bpl  loc_EA98                   ; EA7B
        ; static (not seen in traces)
        and  #$70                       ; EA7D
        sta  $0359                      ; EA7F
        lda  $035B                      ; EA82
        and  #$0F                       ; EA85
        ora  $0359                      ; EA87
        tay                             ; EA8A
        lda  tbl_vibrato,y              ; EA8B
        clc                             ; EA8E
        adc  $0311,x                    ; EA8F
        ldy  $0357                      ; EA92
        jsr  apu_write_r2               ; EA95
loc_EA98:
        rts                             ; EA98
apu_write_r0:
        sta  $D8                        ; EA99
        jsr  apu_check_sfx_channel      ; EA9B
        lda  $DA                        ; EA9E
        bne  loc_EAA7                   ; EAA0
        lda  $D8                        ; EAA2
        sta  APU_4000,y                 ; EAA4
loc_EAA7:
        rts                             ; EAA7
apu_write_r1:
        sta  $D8                        ; EAA8
        jsr  apu_check_sfx_channel      ; EAAA
        lda  $DA                        ; EAAD
        bne  loc_EAB6                   ; EAAF
        lda  $D8                        ; EAB1
        sta  APU_4001,y                 ; EAB3
loc_EAB6:
        rts                             ; EAB6
apu_write_r2:
        sta  $D8                        ; EAB7
        jsr  apu_check_sfx_channel      ; EAB9
        lda  $DA                        ; EABC
        bne  loc_EAC5                   ; EABE
        lda  $D8                        ; EAC0
        sta  APU_4002,y                 ; EAC2
loc_EAC5:
        rts                             ; EAC5
apu_write_r3:
        sta  $D8                        ; EAC6
        jsr  apu_check_sfx_channel      ; EAC8
        lda  $DA                        ; EACB
        bne  loc_EAD4                   ; EACD
        lda  $D8                        ; EACF
        sta  APU_4003,y                 ; EAD1
loc_EAD4:
        rts                             ; EAD4
apu_enable_channels:
        ora  a:$0080                    ; EAD5
        sta  a:$0080                    ; EAD8
        sta  APU_STATUS                 ; EADB
        rts                             ; EADE
apu_write_tri_linear:
        sta  $D8                        ; EADF
        lda  $D9                        ; EAE1
        and  #$04                       ; EAE3
        bne  loc_EAEC                   ; EAE5
        lda  $D8                        ; EAE7
        sta  APU_4008                   ; EAE9
loc_EAEC:
        rts                             ; EAEC
apu_check_sfx_channel:
        lda  #$00                       ; EAED
        sta  $DA                        ; EAEF
        lda  $D9                        ; EAF1
        and  #$01                       ; EAF3
        beq  loc_EAFE                   ; EAF5
        ; static (not seen in traces)
        cpy  #$00                       ; EAF7
        bne  loc_EAFE                   ; EAF9
        jmp  loc_EB22                   ; EAFB
loc_EAFE:
        lda  $D9                        ; EAFE
        and  #$02                       ; EB00
        beq  loc_EB0B                   ; EB02
        ; static (not seen in traces)
        cpy  #$04                       ; EB04
        bne  loc_EB0B                   ; EB06
        jmp  loc_EB22                   ; EB08
loc_EB0B:
        lda  $D9                        ; EB0B
        and  #$04                       ; EB0D
        beq  loc_EB18                   ; EB0F
        ; static (not seen in traces)
        cpy  #$08                       ; EB11
        bne  loc_EB18                   ; EB13
        jmp  loc_EB22                   ; EB15
loc_EB18:
        lda  $D9                        ; EB18
        and  #$08                       ; EB1A
        beq  loc_EB26                   ; EB1C
        ; static (not seen in traces)
        cpy  #$0C                       ; EB1E
        bne  loc_EB26                   ; EB20
loc_EB22:
        lda  #$FF                       ; EB22
        sta  $DA                        ; EB24
loc_EB26:
        rts                             ; EB26
snd_credit_gb2312:
        .byte $D2,$F4,$D0,$A7,$D6,$C6,$D7,$F7,$A3,$BA,$CD,$F5,$B3,$AC ; EB27
tbl_note_period_lo:
        .byte $AE ; EB35
tbl_note_period_hi:
        .byte $06,$4E,$06,$F4,$05,$9E,$05,$4D,$05,$01,$05,$B9,$04,$75,$04,$35 ; EB36
        .byte $04,$F9,$03,$C0,$03,$8A,$03 ; EB46
tbl_chan_bit:
        .byte $01,$02,$04,$08 ; EB4D
tbl_chan_clear_mask:
        .byte $0E,$0D,$0B,$07 ; EB51
tbl_chan_type:
        .byte $00,$01,$82,$43 ; EB55
tbl_vibrato:
        .byte $00,$00,$01,$01,$00,$00,$FF,$FF,$00,$00,$01,$01,$00,$00,$FF,$FF ; EB59
        .byte $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00,$FF,$FF,$FF,$FF ; EB69
        .byte $00,$01,$02,$01,$00,$FF,$FE,$FF,$00,$01,$02,$01,$00,$FF,$FE,$FF ; EB79
        .byte $00,$00,$01,$01,$02,$02,$01,$01,$00,$00,$FF,$FF,$FE,$FE,$FF,$FF ; EB89
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; EB99
        .byte $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE ; EBA9
        .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; EBB9
tbl_envelope:
        .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; EBC9
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80,$70,$60,$50,$40,$30,$20,$10,$00 ; EBD9
        .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0 ; EBE9
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0 ; EBF9
        .byte $80,$90,$A0,$B0,$C0,$D0,$E0,$F0,$F0,$E0,$D0,$C0,$B0,$A0,$90,$80 ; EC09
        .byte $F0,$D0,$B0,$90,$70,$50,$30,$10,$E0,$C0,$A0,$80,$60,$40,$20,$00 ; EC19
        .byte $F0,$E0,$D0,$C0,$C0,$D0,$E0,$D0,$C0,$A0,$80,$60,$40,$20,$10,$00 ; EC29
        .byte $F0,$D0,$B0,$90,$A0,$B0,$90,$70,$60,$50,$40,$30,$20,$10,$10,$00 ; EC39
        .byte $40,$40,$40,$40,$40,$40,$40,$60,$60,$70,$80,$A0,$C0,$F0,$B0,$80 ; EC49
        .byte $F0,$F0,$A0,$80,$F0,$F0,$A0,$80,$70,$70,$60,$60,$50,$50,$40,$20 ; EC59
tbl_volume_scale:
        .byte $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30 ; EC69
        .byte $30,$30,$30,$30,$30,$30,$30,$30,$31,$31,$31,$31,$31,$31,$31,$31 ; EC79
        .byte $30,$30,$30,$30,$31,$31,$31,$31,$31,$31,$31,$31,$32,$32,$32,$32 ; EC89
        .byte $30,$30,$30,$31,$31,$31,$31,$31,$32,$32,$32,$32,$32,$33,$33,$33 ; EC99
        .byte $30,$30,$31,$31,$31,$31,$32,$32,$32,$32,$33,$33,$33,$33,$34,$34 ; ECA9
        .byte $30,$30,$31,$31,$31,$32,$32,$32,$33,$33,$33,$34,$34,$34,$35,$35 ; ECB9
        .byte $30,$30,$31,$31,$32,$32,$32,$33,$33,$34,$34,$34,$35,$35,$36,$36 ; ECC9
        .byte $30,$30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$36,$37,$37 ; ECD9
        .byte $30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$36,$37,$37,$38 ; ECE9
        .byte $30,$31,$31,$32,$32,$33,$34,$34,$35,$35,$36,$37,$37,$38,$38,$39 ; ECF9
        .byte $30,$31,$31,$32,$33,$33,$34,$35,$35,$36,$37,$37,$38,$39,$39,$3A ; ED09
        .byte $30,$31,$31,$32,$33,$34,$34,$35,$36,$37,$37,$38,$39,$3A,$3A,$3B ; ED19
        .byte $30,$31,$32,$32,$33,$34,$35,$36,$36,$37,$38,$39,$3A,$3A,$3B,$3C ; ED29
        .byte $30,$31,$32,$33,$33,$34,$35,$36,$37,$38,$39,$3A,$3A,$3B,$3C,$3D ; ED39
        .byte $30,$31,$32,$33,$34,$35,$36,$37,$37,$38,$39,$3A,$3B,$3C,$3D,$3E ; ED49
        .byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F ; ED59
tbl_sfx_ptrs:
        .byte $BF ; ED69
tbl_sfx_ptrs_hi:
        .byte $ED,$C8,$ED,$DD,$ED,$DD,$ED,$E6,$ED,$EF,$ED,$EF,$ED,$04,$EE,$0D ; ED6A
        .byte $EE,$0D,$EE,$70,$EE,$70,$EE,$70,$EE,$A1,$EE,$AB,$EE,$AB,$EE,$CB ; ED7A
        .byte $EE,$E4,$EE,$E4,$EE,$FF,$EE,$FF,$EE,$11,$EF,$46,$EF,$68,$EF,$82 ; ED8A
        .byte $EF,$82,$EF,$82,$EF,$82,$EF,$93,$EF,$93,$EF,$93,$EF,$93,$EF,$93 ; ED9A
        .byte $EF,$93,$EF,$93,$EF,$93,$EF,$93,$EF,$93,$EF,$93,$EF,$93,$EF,$A2 ; EDAA
        .byte $EF,$A2,$EF,$B9,$EF,$01,$02,$0F,$32,$00,$FF,$AA,$57,$05,$01,$02 ; EDBA
        .byte $0F,$03,$0C,$0F,$7F,$D4,$08,$0F,$7F,$1C,$09,$0F,$7F,$52,$09,$0F ; EDCA
        .byte $7F,$AB,$09,$01,$02,$0F,$C8,$00,$3F,$CB,$CF,$02,$01,$02,$0F,$1E ; EDDA
        .byte $00,$3F,$AA,$C8,$00,$01,$02,$0F,$03,$0C,$0F,$7F,$AB,$09,$0F,$7F ; EDEA
        .byte $52,$09,$0F,$7F,$1C,$09,$0F,$7F,$D4,$08,$01,$08,$0F,$3C,$00,$0F ; EDFA
        .byte $00,$0E,$C0,$01,$02,$0D,$01,$5A,$75,$30,$B0,$08,$76,$B8,$08,$77 ; EE0A
        .byte $C0,$08,$78,$C8,$08,$79,$D0,$08,$7A,$D8,$08,$7B,$E0,$08,$7C,$E8 ; EE1A
        .byte $08,$7D,$F0,$08,$7D,$F8,$08,$7C,$00,$09,$7C,$08,$09,$7B,$10,$09 ; EE2A
        .byte $7B,$18,$09,$7A,$20,$09,$7A,$28,$09,$79,$30,$09,$79,$38,$09,$78 ; EE3A
        .byte $40,$09,$78,$48,$09,$77,$50,$09,$77,$58,$09,$76,$60,$09,$76,$68 ; EE4A
        .byte $09,$75,$70,$09,$75,$78,$09,$74,$80,$09,$74,$88,$09,$73,$90,$09 ; EE5A
        .byte $73,$98,$09,$00,$00,$00,$01,$04,$04,$01,$28,$8F,$19,$A0,$A0,$97 ; EE6A
        .byte $A0,$97,$23,$35,$47,$25,$38,$4B,$28,$3B,$50,$2A,$3F,$54,$2C,$43 ; EE7A
        .byte $59,$2F,$47,$5F,$32,$4B,$64,$35,$50,$6A,$71,$77,$7F,$86,$8E,$97 ; EE8A
        .byte $A0,$A9,$B3,$BE,$C9,$D5,$00,$01,$02,$01,$01,$01,$BF,$08,$61,$08 ; EE9A
        .byte $00,$01,$02,$04,$01,$17,$00,$81,$35,$08,$32,$2F,$2C,$2A,$28,$25 ; EEAA
        .byte $23,$21,$1F,$1E,$1C,$1A,$1E,$1F,$21,$23,$25,$28,$2A,$2C,$2F,$32 ; EEBA
        .byte $35,$01,$02,$04,$03,$10,$9F,$7F,$D4,$08,$9F,$D4,$E1,$9F,$E1,$EE ; EECA
        .byte $9F,$EE,$FD,$9F,$FD,$0C,$EE,$0C,$1C,$00,$01,$02,$03,$03,$12,$BA ; EEDA
        .byte $84,$55,$08,$B9,$83,$B6,$83,$B4,$83,$B3,$83,$B2,$83,$B1,$83,$B1 ; EEEA
        .byte $83,$B1,$83,$B1,$83,$01,$02,$04,$03,$09,$CA,$00,$D6,$C0,$AA,$78 ; EEFA
        .byte $D6,$AA,$78,$D6,$AA,$78,$00,$01,$02,$05,$05,$2C,$7E,$08,$8E,$00 ; EF0A
        .byte $BD,$78,$BD,$8E,$B7,$59,$B7,$3F,$B7,$2A,$B9,$1C,$BD,$15,$B5,$0E ; EF1A
        .byte $B5,$78,$B7,$AE,$BD,$59,$B7,$3F,$B9,$2A,$B9,$1C,$BA,$15,$B6,$0E ; EF2A
        .byte $B5,$78,$B5,$8E,$B4,$59,$B3,$3F,$B2,$38,$00,$00,$01,$02,$04,$01 ; EF3A
        .byte $19,$CA,$00,$6B,$C0,$87,$7F,$78,$71,$6B,$65,$5F,$5A,$87,$7F,$78 ; EF4A
        .byte $71,$6B,$65,$5F,$5A,$87,$7F,$78,$71,$6B,$65,$5F,$5A,$00,$01,$02 ; EF5A
        .byte $04,$01,$11,$8F,$00,$8E,$08,$86,$7F,$78,$71,$6A,$64,$5F,$86,$7F ; EF6A
        .byte $78,$71,$6A,$64,$5F,$59,$54,$50,$01,$02,$0F,$05,$08,$9F,$00,$2A ; EF7A
        .byte $29,$3F,$08,$C4,$C1,$00,$00,$00,$00,$01,$02,$0C,$03,$42,$44,$00 ; EF8A
        .byte $47,$C0,$4C,$C0,$AA,$C0,$AC,$C1,$01,$02,$05,$08,$0E,$9F,$7F,$7C ; EF9A
        .byte $09,$9F,$93,$9F,$7C,$9F,$93,$9F,$7C,$9F,$93,$9F,$7C,$00,$00 ; EFAA
tbl_song_ntracks:
        .byte $03 ; EFB9
tbl_song_first_track:
        .byte $00,$03,$00,$03,$00 ; EFBA
tbl_song_records:
        .byte $C5 ; EFBF
tbl_song_records_hi:
        .byte $EF,$D5,$EF,$D5,$EF ; EFC0
song0_track_records:
        .byte $00,$00,$D5,$EF,$15,$01,$EA,$F0,$2A,$02,$5F,$F2,$3F,$03,$74,$F3 ; EFC5
song0_pulse1:
        .byte $71,$03,$1F,$00,$A2,$3A,$C1,$2A,$1B,$08,$1F,$04,$1B,$04,$1F,$04 ; EFD5
        .byte $1A,$04,$1F,$04,$1A,$04,$2B,$08,$26,$08,$2B,$04,$32,$04,$2B,$08 ; EFE5
        .byte $31,$04,$32,$04,$27,$08,$22,$08,$27,$04,$2B,$04,$32,$08,$31,$04 ; EFF5
        .byte $2B,$04,$29,$08,$24,$08,$29,$04,$31,$04,$34,$08,$32,$04,$31,$04 ; F005
        .byte $2B,$08,$26,$08,$2B,$04,$32,$04,$2B,$08,$31,$04,$32,$04,$2B,$08 ; F015
        .byte $26,$08,$2B,$04,$32,$04,$2B,$08,$31,$04,$32,$04,$27,$08,$22,$08 ; F025
        .byte $27,$04,$2B,$04,$32,$08,$31,$04,$2B,$04,$29,$08,$24,$08,$29,$04 ; F035
        .byte $31,$04,$34,$08,$32,$04,$31,$04,$2B,$08,$26,$08,$2B,$04,$32,$04 ; F045
        .byte $2B,$08,$31,$04,$32,$04,$1B,$08,$16,$08,$1B,$04,$22,$04,$1B,$08 ; F055
        .byte $21,$04,$22,$04,$17,$08,$12,$08,$17,$04,$1B,$04,$22,$08,$21,$04 ; F065
        .byte $1B,$04,$19,$08,$14,$08,$19,$04,$21,$04,$24,$08,$22,$04,$21,$04 ; F075
        .byte $1B,$08,$16,$08,$1B,$04,$22,$04,$1B,$08,$21,$04,$22,$04,$1B,$08 ; F085
        .byte $16,$08,$1B,$04,$22,$04,$1B,$08,$21,$04,$22,$04,$17,$08,$12,$08 ; F095
        .byte $17,$04,$1B,$04,$22,$08,$21,$04,$1B,$04,$19,$08,$14,$08,$19,$04 ; F0A5
        .byte $21,$04,$24,$08,$22,$04,$21,$04,$26,$08,$21,$08,$26,$04,$2A,$04 ; F0B5
        .byte $31,$08,$34,$04,$2A,$04,$2B,$08,$1F,$04,$2B,$04,$1F,$04,$2A,$04 ; F0C5
        .byte $1F,$04,$2A,$04,$1B,$08,$1F,$04,$1B,$04,$1F,$04,$1A,$04,$1F,$04 ; F0D5
        .byte $1A,$04,$B0,$02,$FF ; F0E5
song0_pulse2:
        .byte $71,$03,$00,$00,$A1,$2A,$C1,$2A,$2B,$08,$1F,$04,$2B,$04,$1F,$04 ; F0EA
        .byte $26,$04,$1F,$04,$26,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04 ; F0FA
        .byte $36,$04,$32,$04,$3B,$04,$36,$04,$32,$04,$27,$04,$22,$04,$27,$04 ; F10A
        .byte $2B,$04,$27,$04,$32,$04,$2B,$04,$37,$04,$36,$04,$32,$04,$29,$04 ; F11A
        .byte $24,$04,$29,$04,$31,$04,$29,$04,$34,$04,$31,$04,$39,$04,$37,$04 ; F12A
        .byte $36,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04,$36,$04,$32,$04 ; F13A
        .byte $3B,$04,$36,$04,$32,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04 ; F14A
        .byte $36,$04,$32,$04,$3B,$04,$36,$04,$32,$04,$27,$04,$22,$04,$27,$04 ; F15A
        .byte $2B,$04,$27,$04,$32,$04,$2B,$04,$37,$04,$36,$04,$32,$04,$29,$04 ; F16A
        .byte $24,$04,$29,$04,$31,$04,$29,$04,$34,$04,$31,$04,$39,$04,$37,$04 ; F17A
        .byte $36,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04,$36,$04,$32,$04 ; F18A
        .byte $3B,$04,$36,$04,$32,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04 ; F19A
        .byte $36,$04,$32,$04,$3B,$04,$36,$04,$32,$04,$27,$04,$22,$04,$27,$04 ; F1AA
        .byte $2B,$04,$27,$04,$32,$04,$2B,$04,$37,$04,$36,$04,$32,$04,$29,$04 ; F1BA
        .byte $24,$04,$29,$04,$31,$04,$29,$04,$34,$04,$31,$04,$39,$04,$37,$04 ; F1CA
        .byte $36,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04,$36,$04,$32,$04 ; F1DA
        .byte $3B,$04,$36,$04,$32,$04,$2B,$04,$26,$04,$2B,$04,$32,$04,$2B,$04 ; F1EA
        .byte $36,$04,$32,$04,$3B,$04,$36,$04,$32,$04,$27,$04,$22,$04,$27,$04 ; F1FA
        .byte $2B,$04,$27,$04,$32,$04,$2B,$04,$37,$04,$36,$04,$32,$04,$29,$04 ; F20A
        .byte $24,$04,$29,$04,$31,$04,$29,$04,$34,$04,$31,$04,$39,$04,$37,$04 ; F21A
        .byte $36,$04,$31,$04,$26,$04,$2A,$04,$31,$04,$34,$04,$36,$04,$3A,$04 ; F22A
        .byte $41,$04,$3B,$04,$3A,$04,$2B,$08,$1F,$04,$2B,$04,$1F,$04,$26,$04 ; F23A
        .byte $1F,$04,$26,$04,$36,$08,$1F,$04,$36,$04,$1F,$04,$34,$04,$1F,$04 ; F24A
        .byte $34,$04,$B0,$02,$FF ; F25A
song0_triangle:
        .byte $71,$03,$1F,$00,$A2,$3A,$C2,$2A,$1B,$08,$1F,$04,$1B,$04,$1F,$04 ; F25F
        .byte $1A,$04,$1F,$04,$1A,$04,$2B,$08,$26,$08,$2B,$04,$32,$04,$2B,$08 ; F26F
        .byte $31,$04,$32,$04,$27,$08,$22,$08,$27,$04,$2B,$04,$32,$08,$31,$04 ; F27F
        .byte $2B,$04,$29,$08,$24,$08,$29,$04,$31,$04,$34,$08,$32,$04,$31,$04 ; F28F
        .byte $2B,$08,$26,$08,$2B,$04,$32,$04,$2B,$08,$31,$04,$32,$04,$2B,$08 ; F29F
        .byte $26,$08,$2B,$04,$32,$04,$2B,$08,$31,$04,$32,$04,$27,$08,$22,$08 ; F2AF
        .byte $27,$04,$2B,$04,$32,$08,$31,$04,$2B,$04,$29,$08,$24,$08,$29,$04 ; F2BF
        .byte $31,$04,$34,$08,$32,$04,$31,$04,$2B,$08,$26,$08,$2B,$04,$32,$04 ; F2CF
        .byte $2B,$08,$31,$04,$32,$04,$1B,$08,$16,$08,$1B,$04,$22,$04,$1B,$08 ; F2DF
        .byte $21,$04,$22,$04,$17,$08,$12,$08,$17,$04,$1B,$04,$22,$08,$21,$04 ; F2EF
        .byte $1B,$04,$19,$08,$14,$08,$19,$04,$21,$04,$24,$08,$22,$04,$21,$04 ; F2FF
        .byte $1B,$08,$16,$08,$1B,$04,$22,$04,$1B,$08,$21,$04,$22,$04,$1B,$08 ; F30F
        .byte $16,$08,$1B,$04,$22,$04,$1B,$08,$21,$04,$22,$04,$17,$08,$12,$08 ; F31F
        .byte $17,$04,$1B,$04,$22,$08,$21,$04,$1B,$04,$19,$08,$14,$08,$19,$04 ; F32F
        .byte $21,$04,$24,$08,$22,$04,$21,$04,$26,$08,$21,$08,$26,$04,$2A,$04 ; F33F
        .byte $31,$08,$34,$04,$2A,$04,$2B,$08,$1F,$04,$2B,$04,$1F,$04,$2A,$04 ; F34F
        .byte $1F,$04,$2A,$04,$1B,$08,$1F,$04,$1B,$04,$1F,$04,$1A,$04,$1F,$04 ; F35F
        .byte $1A,$04,$B0,$02,$FF ; F36F
song0_noise:
        .byte $71,$02,$00,$00,$C1,$10,$08,$08,$1F,$04,$08,$04,$1F,$04,$08,$04 ; F374
        .byte $1F,$04,$08,$04,$08,$08,$08,$04,$08,$04,$08,$04,$08,$04,$1F,$04 ; F384
        .byte $08,$04,$08,$04,$08,$04,$1F,$08,$08,$04,$08,$04,$1F,$04,$08,$04 ; F394
        .byte $1F,$04,$08,$04,$08,$04,$08,$04,$1F,$08,$08,$04,$08,$04,$1F,$04 ; F3A4
        .byte $08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$08,$08,$08,$04,$08,$04 ; F3B4
        .byte $1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$08,$08,$08,$04 ; F3C4
        .byte $08,$04,$08,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$1F,$08 ; F3D4
        .byte $08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04 ; F3E4
        .byte $1F,$08,$08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04 ; F3F4
        .byte $08,$04,$08,$08,$08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04 ; F404
        .byte $08,$04,$08,$04,$08,$08,$08,$04,$08,$04,$08,$04,$08,$04,$1F,$04 ; F414
        .byte $08,$04,$08,$04,$08,$04,$1F,$08,$08,$04,$08,$04,$1F,$04,$08,$04 ; F424
        .byte $1F,$04,$08,$04,$08,$04,$08,$04,$1F,$08,$08,$04,$08,$04,$1F,$04 ; F434
        .byte $08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$08,$08,$08,$04,$08,$04 ; F444
        .byte $1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$08,$08,$08,$04 ; F454
        .byte $08,$04,$08,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04,$1F,$08 ; F464
        .byte $08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04,$08,$04 ; F474
        .byte $1F,$08,$08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04,$08,$04 ; F484
        .byte $08,$04,$08,$08,$08,$04,$08,$04,$1F,$04,$08,$04,$1F,$04,$08,$04 ; F494
        .byte $08,$04,$08,$04,$1F,$10,$1F,$10,$1F,$10,$1F,$10,$B0,$02,$FF,$A2 ; F4A4
        .byte $00,$BD,$CF,$F4,$85,$E0,$BD,$D0,$F4,$85,$E1,$A0,$00,$B1,$E0,$99 ; F4B4
        .byte $10,$01,$C8,$C0,$80,$90,$F6,$4C,$10,$01,$60,$D1,$F4,$A9,$06,$8D ; F4C4
        .byte $00,$80,$A9,$00,$8D,$01,$80,$A9,$00,$8D,$09,$01,$A9,$20,$8D,$08 ; F4D4
        .byte $01,$A9,$00,$85,$E0,$A9,$80,$85,$E1,$A9,$00,$A8,$B1,$E0,$8D,$03 ; F4E4
        .byte $01,$C8,$B1,$E0,$8D,$02,$01,$C8,$AD,$03,$01,$8D,$30,$42,$AD,$02 ; F4F4
        .byte $01,$8D,$31,$42,$A9,$D4,$8D,$33,$42,$C0,$00,$D0,$DF,$A5,$E1,$AA ; F504
        .byte $E8,$8A,$85,$E1,$CE,$08,$01,$D0,$D0,$EE,$09,$01,$AE,$09,$01,$E0 ; F514
        .byte $13,$F0,$1D,$A9,$06,$8D,$00,$80,$AD,$09,$01,$8D,$01,$80,$E0,$12 ; F524
        .byte $F0,$07,$A9,$20,$8D,$08,$01,$D0,$A8,$A9,$18,$8D,$08,$01,$D0,$A1 ; F534
        .byte $60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F544
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F554
        .byte $FF,$FF,$FF,$FF,$FF ; F564
sub_F569:
        asl  a                          ; F569
        asl  a                          ; F56A
        clc                             ; F56B
        lda  #$20                       ; F56C
        sta  PPU_ADDR                   ; F56E
        lda  #$00                       ; F571
        sta  PPU_ADDR                   ; F573
        tay                             ; F576
        tax                             ; F577
loc_F578:
        lda  ($88),y                    ; F578
        beq  loc_F5AA                   ; F57A
        cmp  #$80                       ; F57C
        bcc  loc_F596                   ; F57E
        lda  #$7F                       ; F580
        and  ($88),y                    ; F582
        tax                             ; F584
        jsr  sub_F5B3                   ; F585
        lda  ($88),y                    ; F588
loc_F58A:
        sta  PPU_DATA                   ; F58A
        dex                             ; F58D
        bne  loc_F58A                   ; F58E
        jsr  sub_F5B3                   ; F590
        jmp  loc_F5A7                   ; F593
loc_F596:
        lda  ($88),y                    ; F596
        tax                             ; F598
loc_F599:
        jsr  sub_F5B3                   ; F599
        lda  ($88),y                    ; F59C
        sta  PPU_DATA                   ; F59E
        dex                             ; F5A1
        bne  loc_F599                   ; F5A2
        jsr  sub_F5B3                   ; F5A4
loc_F5A7:
        jmp  loc_F578                   ; F5A7
loc_F5AA:
        lda  #$00                       ; F5AA
        sta  PPU_ADDR                   ; F5AC
        sta  PPU_ADDR                   ; F5AF
        rts                             ; F5B2
sub_F5B3:
        iny                             ; F5B3
        bne  loc_F5B8                   ; F5B4
        inc  $89                        ; F5B6
loc_F5B8:
        rts                             ; F5B8
sub_F5B9:
        ldy  #$00                       ; F5B9
        sty  PPU_CTRL                   ; F5BB
        sty  PPU_MASK                   ; F5BE
        ldx  #$00                       ; F5C1
        txa                             ; F5C3
        pha                             ; F5C4
        lda  dat_F646,x                 ; F5C5
        sta  $88                        ; F5C8
        lda  dat_F647,x                 ; F5CA
        sta  $89                        ; F5CD
loc_F5CF:
        lda  PPU_STATUS                 ; F5CF
        bpl  loc_F5CF                   ; F5D2
loc_F5D4:
        lda  PPU_STATUS                 ; F5D4
        bmi  loc_F5D4                   ; F5D7
        nop                             ; F5D9
        lda  #$00                       ; F5DA
        ldy  #$02                       ; F5DC
        ldx  #$20                       ; F5DE
        jsr  sub_F5FD                   ; F5E0
        ldy  #$00                       ; F5E3
        lda  ($88),y                    ; F5E5
        pha                             ; F5E7
        iny                             ; F5E8
        lda  ($88),y                    ; F5E9
        sta  $89                        ; F5EB
        pla                             ; F5ED
        sta  $88                        ; F5EE
        pla                             ; F5F0
        jsr  sub_F569                   ; F5F1
        rts                             ; F5F4
        .byte $00,$20,$30,$40,$50,$FF,$FF,$FF ; F5F5
sub_F5FD:
        pha                             ; F5FD
        lda  #$3F                       ; F5FE
        sta  PPU_ADDR                   ; F600
        pla                             ; F603
        sta  PPU_ADDR                   ; F604
loc_F607:
        lda  ($88),y                    ; F607
        sta  PPU_DATA                   ; F609
        iny                             ; F60C
        dex                             ; F60D
        bne  loc_F607                   ; F60E
        rts                             ; F610
        .byte $FF,$FF,$FF,$FF,$FF,$00,$B8,$0F,$01,$1B,$20,$0F,$05,$16,$27,$0F ; F611
        .byte $20,$16,$2C,$0F,$13,$20,$30,$0F,$0F,$17,$27,$0D,$02,$20,$12,$0D ; F621
        .byte $21,$1A,$16,$0D,$02,$20,$12,$FF ; F631
sub_F639:
        jsr  sub_F5B9                   ; F639
        jsr  sub_CA1A                   ; F63C
        rts                             ; F63F
        .byte $FF,$FF,$FF,$FF,$FF,$FF ; F640
dat_F646:
        .byte $16 ; F646
dat_F647:
        .byte $F6,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F647
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F657
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F667
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F677
set_page_bg_chr:
        ldx  cn_page                    ; F680
        lda  tbl_page_bg_chr,x          ; F683
        sta  bg_chr_base                ; F686
        jsr  sub_F700                   ; F688
        rts                             ; F68B
        .byte $74,$03,$F0,$06,$8D,$74,$03,$20,$00,$F7,$60,$FF,$FF,$FF,$FF,$FF ; F68C
        .byte $FF,$FF,$FF,$FF ; F69C
tbl_page_bg_chr:
        .byte $00 ; F6A0  page_bg_chr 0
        .byte $04 ; F6A1  page_bg_chr 1
        .byte $08 ; F6A2  page_bg_chr 2
        .byte $0C ; F6A3  page_bg_chr 3
        .byte $10 ; F6A4  page_bg_chr 4
        .byte $14 ; F6A5  page_bg_chr 5
        .byte $18 ; F6A6  page_bg_chr 6
        .byte $1C ; F6A7  page_bg_chr 7
        .byte $20 ; F6A8  page_bg_chr 8
        .byte $24 ; F6A9  page_bg_chr 9
        .byte $28 ; F6AA  page_bg_chr 10
        .byte $2C ; F6AB  page_bg_chr 11
        .byte $30 ; F6AC  page_bg_chr 12
        .byte $34 ; F6AD  page_bg_chr 13
        .byte $38 ; F6AE  page_bg_chr 14
        .byte $3C ; F6AF  page_bg_chr 15
        .byte $40 ; F6B0  page_bg_chr 16
        .byte $44 ; F6B1  page_bg_chr 17
        .byte $48 ; F6B2  page_bg_chr 18
        .byte $4C ; F6B3  page_bg_chr 19
        .byte $50 ; F6B4  page_bg_chr 20
        .byte $54 ; F6B5  page_bg_chr 21
        .byte $58 ; F6B6  page_bg_chr 22
        .byte $5C ; F6B7  page_bg_chr 23
        .byte $60 ; F6B8  page_bg_chr 24
        .byte $64 ; F6B9  page_bg_chr 25
        .byte $68 ; F6BA  page_bg_chr 26
        .byte $6C ; F6BB  page_bg_chr 27
        .byte $70 ; F6BC  page_bg_chr 28
        .byte $74 ; F6BD  page_bg_chr 29
        .byte $78 ; F6BE  page_bg_chr 30
        .byte $7C ; F6BF  page_bg_chr 31
        .byte $80 ; F6C0  page_bg_chr 32
        .byte $84 ; F6C1  page_bg_chr 33
        .byte $88 ; F6C2  page_bg_chr 34
        .byte $8C ; F6C3  page_bg_chr 35
        .byte $90 ; F6C4  page_bg_chr 36
        .byte $94 ; F6C5  page_bg_chr 37
        .byte $98 ; F6C6  page_bg_chr 38
        .byte $9C ; F6C7  page_bg_chr 39
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F6C8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F6D8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F6E8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F6F8
sub_F700:
        lda  #$00                       ; F700
        sta  $70                        ; F702
        lda  #$80                       ; F704
        sta  $71                        ; F706
        ldx  cn_page                    ; F708
        beq  loc_F71D                   ; F70B
loc_F70D:
        ; static (not seen in traces)
        lda  $70                        ; F70D
        clc                             ; F70F
        adc  #$28                       ; F710
        sta  $70                        ; F712
        lda  $71                        ; F714
        adc  #$00                       ; F716
        sta  $71                        ; F718
        dex                             ; F71A
        bne  loc_F70D                   ; F71B
loc_F71D:
        lda  $70                        ; F71D
        sta  state_tbl_ptr              ; F71F
        lda  $71                        ; F721
        sta  $B1                        ; F723
        rts                             ; F725
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F726
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F736
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F746
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F756
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F766
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F776
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F786
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F796
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7A6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7B6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7C6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7D6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7E6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F7F6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F806
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F816
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F826
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F836
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F846
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F856
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F866
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F876
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F886
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F896
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F8A6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F8B6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F8C6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F8D6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; F8E6
        .byte $FF,$FF,$FF,$FF,$EA,$00,$00,$00,$EB,$00,$20,$00,$EC,$00,$0C,$00 ; F8F6
        .byte $ED,$00,$C4,$00,$E8,$00,$40,$00,$E9,$00,$38,$00,$F1,$00,$01,$00 ; F906
        .byte $F2,$00,$10,$00,$27,$00,$A3,$00,$40,$00,$00,$00,$41,$00,$00,$00 ; F916
        .byte $42,$00,$01,$00,$43,$00,$12,$00,$44,$00,$10,$00,$45,$00,$26,$00 ; F926
        .byte $46,$00,$08,$00,$47,$00,$53,$00,$48,$00,$02,$00,$49,$00,$15,$00 ; F936
        .byte $4A,$00,$19,$00,$4B,$00,$19,$00,$4C,$00,$16,$00,$50,$00,$19,$00 ; F946
        .byte $51,$00,$2F,$00,$52,$00,$2D,$00,$53,$00,$3E,$00,$54,$00,$3F,$00 ; F956
        .byte $55,$00,$3F,$00,$56,$00,$2C,$00,$57,$00,$77,$00,$58,$00,$09,$00 ; F966
        .byte $59,$00,$06,$00,$5A,$00,$06,$00,$5B,$00,$0A,$00,$5C,$00,$1D,$00 ; F976
        .byte $5D,$00,$CC,$00,$1B,$00,$1B,$00,$1A,$00,$01,$00,$24,$00,$2F,$00 ; F986
        .byte $25,$00,$57,$00,$23,$00,$97,$00,$18,$00,$36,$00,$19,$00,$01,$00 ; F996
        .byte $01,$00,$00,$00,$1F,$05,$88,$00,$1F,$05,$80,$00,$1F,$05,$90,$00 ; F9A6
        .byte $1F,$05,$D0,$00,$17,$00,$05,$00,$36,$00,$00,$00,$28,$28,$38,$00 ; F9B6
        .byte $28,$00,$3C,$00,$02,$00,$00,$00,$03,$00,$00,$00,$04,$00,$00,$00 ; F9C6
        .byte $05,$00,$EF,$00,$06,$00,$00,$00,$07,$00,$00,$00,$08,$00,$01,$00 ; F9D6
        .byte $09,$00,$3F,$00,$FF,$FF,$FF,$FF ; F9E6
reset:
        lda  #$00                       ; F9EE
        sta  PPU_CTRL                   ; F9F0
        sta  PPU_MASK                   ; F9F3
        lda  #$C0                       ; F9F6
        sta  JOY2_FRAME                 ; F9F8
        sei                             ; F9FB
        cld                             ; F9FC
        ldx  #$02                       ; F9FD
loc_F9FF:
        bit  PPU_STATUS                 ; F9FF
        bpl  loc_F9FF                   ; FA02
loc_FA04:
        bit  PPU_STATUS                 ; FA04
        bmi  loc_FA04                   ; FA07
        dex                             ; FA09
        bpl  loc_F9FF                   ; FA0A
        lda  #$00                       ; FA0C
        tax                             ; FA0E
loc_FA0F:
        sta  $0100,x                    ; FA0F
        inx                             ; FA12
        bne  loc_FA0F                   ; FA13
        ldx  #$FF                       ; FA15
        txs                             ; FA17
        nop                             ; FA18
        nop                             ; FA19
        nop                             ; FA1A
        nop                             ; FA1B
        nop                             ; FA1C
        ldx  #$FF                       ; FA1D
        txs                             ; FA1F
        lda  #$00                       ; FA20
        sta  PPU_CTRL                   ; FA22
        sta  PPU_MASK                   ; FA25
        jsr  hw_init                    ; FA28
        jsr  init_ppu_shadows           ; FA2B
        jsr  read_4119_flag             ; FA2E
        jsr  clear_oam_and_sprite_slots ; FA31
        lda  #$00                       ; FA34
        sta  a:$0081                    ; FA36
        jsr  sound_init                 ; FA39
        lda  #$00                       ; FA3C
        sta  a:menu_state               ; FA3E
        lda  #$01                       ; FA41
        sta  a:menu_step                ; FA43
        lda  #$20                       ; FA46
        sta  $0134                      ; FA48
main_loop:
        jsr  state_dispatch_main        ; FA4B
        ; static (not seen in traces)
        jmp  main_loop                  ; FA4E
nmi_handler:
        php                             ; FA51
        pha                             ; FA52
        tya                             ; FA53
        pha                             ; FA54
        txa                             ; FA55
        pha                             ; FA56
        jsr  nmi_call_hook_24           ; FA57
        lda  #$00                       ; FA5A
        sta  OAM_ADDR                   ; FA5C
        sta  REG_4034                   ; FA5F
        lda  #$02                       ; FA62
        sta  OAM_DMA                    ; FA64
        lda  PPU_STATUS                 ; FA67
        ldx  bg_chr_base                ; FA6A
        stx  OB_CHR_2012                ; FA6C
        inx                             ; FA6F
        stx  OB_CHR_2013                ; FA70
        inx                             ; FA73
        stx  OB_CHR_2014                ; FA74
        inx                             ; FA77
        stx  OB_CHR_2015                ; FA78
        nop                             ; FA7B
        nop                             ; FA7C
        nop                             ; FA7D
        nop                             ; FA7E
        nop                             ; FA7F
        lda  a:spr_chr_base             ; FA80
        sta  OB_CHR_2016                ; FA83
        clc                             ; FA86
        adc  #$02                       ; FA87
        sta  OB_CHR_2017                ; FA89
        ldx  #$00                       ; FA8C
        stx  $07                        ; FA8E
        lda  a:$003D,x                  ; FA90
        beq  loc_FA9E                   ; FA93
        ; static (not seen in traces)
        sta  REG_4101                   ; FA95
        sta  REG_4102                   ; FA98
        sta  REG_4104                   ; FA9B
loc_FA9E:
        lda  $05                        ; FA9E
        and  #$40                       ; FAA0
        beq  loc_FAA7                   ; FAA2
        ; static (not seen in traces)
        jmp  loc_FAAD                   ; FAA4
loc_FAA7:
        lda  $05                        ; FAA7
        and  #$80                       ; FAA9
        beq  loc_FAAD                   ; FAAB
loc_FAAD:
        lda  PPU_STATUS                 ; FAAD
        lda  ppu_ctrl_shadow            ; FAB0
        sta  PPU_CTRL                   ; FAB2
        lda  ppu_mask_shadow            ; FAB5
        sta  PPU_MASK                   ; FAB7
        lda  video_2010_shadow          ; FABA
        sta  OB_VIDEO_2010              ; FABC
        lda  scroll_x_shadow            ; FABF
        sta  PPU_SCROLL                 ; FAC1
        lda  scroll_y_shadow            ; FAC4
        sta  PPU_SCROLL                 ; FAC6
        cli                             ; FAC9
        inc  frame_counter              ; FACA
        jsr  read_pad                   ; FACC
        jsr  prng_step                  ; FACF
        lda  #$3C                       ; FAD2
        sta  OB_PRG_8000                ; FAD4
        jsr  sound_tick                 ; FAD7
        lda  frame_done                 ; FADA
        beq  loc_FAE2                   ; FADC
        lda  #$00                       ; FADE
        sta  frame_done                 ; FAE0
loc_FAE2:
        lda  prg8000_shadow             ; FAE2
        sta  OB_PRG_8000                ; FAE4
        pla                             ; FAE7
        tax                             ; FAE8
        pla                             ; FAE9
        tay                             ; FAEA
        pla                             ; FAEB
        plp                             ; FAEC
        rti                             ; FAED
        .byte $AD,$02,$20,$A2,$00,$A5,$93,$8D,$06,$20,$A5,$92,$8D,$06,$20,$A9 ; FAEE
        .byte $0B,$8D,$34,$40,$A5,$91,$8D,$14,$40,$A9,$2B,$8D,$34,$40,$A5,$91 ; FAFE
        .byte $8D,$14,$40,$A9,$4B,$8D,$34,$40,$A5,$91,$8D,$14,$40,$A9,$6B,$8D ; FB0E
        .byte $34,$40,$A5,$91,$8D,$14,$40,$A9,$8B,$8D,$34,$40,$A5,$91,$8D,$14 ; FB1E
        .byte $40,$A9,$AB,$8D,$34,$40,$A5,$91,$8D,$14,$40,$A9,$CB,$8D,$34,$40 ; FB2E
        .byte $A5,$91,$8D,$14,$40,$A9,$EB,$8D,$34,$40,$A5,$91,$8D,$14,$40,$E6 ; FB3E
        .byte $93,$E6,$91,$E8,$E0,$02,$90,$9D,$A5,$91,$C9,$08,$D0,$15,$C6,$93 ; FB4E
        .byte $A5,$05,$29,$7F,$85,$05,$20,$FE,$C9,$AD,$3C,$00,$C9,$01,$D0,$03 ; FB5E
        .byte $EE,$3C,$00,$60,$A9,$00,$85,$11,$A5,$91,$C9,$08,$D0,$04,$A9,$20 ; FB6E
        .byte $85,$11,$A5,$93,$C9,$24,$90,$05,$A9,$27,$4C,$8D,$FB,$A9,$23,$8D ; FB7E
        .byte $06,$20,$A9,$C0,$05,$11,$8D,$06,$20,$A9,$CB,$05,$11,$8D,$34,$40 ; FB8E
        .byte $A9,$07,$8D,$14,$40,$60,$AD,$02,$20,$A9,$3F,$8D,$06,$20,$A9,$00 ; FB9E
        .byte $8D,$06,$20,$AD,$00,$04,$8D,$07,$20,$A9,$01,$8D,$34,$40,$A9,$04 ; FBAE
        .byte $8D,$14,$40,$A5,$05,$29,$BF,$85,$05,$60 ; FBBE
irq_handler:
        ; static (not seen in traces)
        php                             ; FBC8
        pha                             ; FBC9
        tya                             ; FBCA
        pha                             ; FBCB
        txa                             ; FBCC
        pha                             ; FBCD
        sta  REG_4103                   ; FBCE
        inc  $07                        ; FBD1
        ldx  $07                        ; FBD3
        lda  a:$003D,x                  ; FBD5
        beq  loc_FBE3                   ; FBD8
        sta  REG_4101                   ; FBDA
        sta  REG_4102                   ; FBDD
        sta  REG_4104                   ; FBE0
loc_FBE3:
        ldy  #$08                       ; FBE3
loc_FBE5:
        dey                             ; FBE5
        bne  loc_FBE5                   ; FBE6
        nop                             ; FBE8
        nop                             ; FBE9
        nop                             ; FBEA
        lda  PPU_STATUS                 ; FBEB
        lda  $07                        ; FBEE
        asl  a                          ; FBF0
        asl  a                          ; FBF1
        clc                             ; FBF2
        adc  a:$0039                    ; FBF3
        sta  OB_CHR_2012                ; FBF6
        adc  #$01                       ; FBF9
        sta  OB_CHR_2013                ; FBFB
        adc  #$01                       ; FBFE
        sta  OB_CHR_2014                ; FC00
        adc  #$01                       ; FC03
        sta  OB_CHR_2015                ; FC05
        lda  scroll_x_shadow            ; FC08
        sta  PPU_SCROLL                 ; FC0A
        lda  scroll_y_shadow            ; FC0D
        sta  PPU_SCROLL                 ; FC0F
        pla                             ; FC12
        tax                             ; FC13
        pla                             ; FC14
        tay                             ; FC15
        pla                             ; FC16
        plp                             ; FC17
        rti                             ; FC18
nmi_call_hook_24:
        lda  nmi_hook_mode              ; FC19
        cmp  #$01                       ; FC1B
        beq  loc_FC23                   ; FC1D
        cmp  #$02                       ; FC1F
        bne  loc_FC26                   ; FC21
loc_FC23:
        jmp  (nmi_hook_ptr)             ; FC23
loc_FC26:
        rts                             ; FC26
state_dispatch_main:
        lda  a:menu_state               ; FC27
        asl  a                          ; FC2A
        tax                             ; FC2B
        lda  tbl_menu_states,x          ; FC2C
        sta  state_tbl_ptr              ; FC2F
        lda  tbl_menu_states+1,x        ; FC31
        sta  $B1                        ; FC34
        lda  a:menu_step                ; FC36
        asl  a                          ; FC39
        asl  a                          ; FC3A
        tay                             ; FC3B
        lda  (state_tbl_ptr),y          ; FC3C
        sta  handler_ptr                ; FC3E
        iny                             ; FC40
        lda  (state_tbl_ptr),y          ; FC41
        sta  $B3                        ; FC43
        jmp  (handler_ptr)              ; FC45
        .byte $60,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC48
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC58
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC68
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC78
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC88
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC98
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCA8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCB8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCC8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCD8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCE8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCF8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD08
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD18
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD28
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD38
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD48
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD58
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD68
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD78
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD88
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD98
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDA8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDB8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDC8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDD8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDE8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDF8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE08
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE18
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE28
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE38
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE48
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE58
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE68
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE78
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE88
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE98
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FEA8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FEB8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FEC8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FED8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FEE8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FEF8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF08
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF18
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF28
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF38
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF48
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF58
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF68
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF78
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF88
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF98
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFA8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFB8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFC8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFD8
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFE8
        .byte $FF,$FF ; FFF8
vec_nmi:
        .word nmi_handler ; FFFA
vec_reset:
        .byte $EE,$F9 ; FFFC
vec_irq:
        .byte $C8,$FB ; FFFE
