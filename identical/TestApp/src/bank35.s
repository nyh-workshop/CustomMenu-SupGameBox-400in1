; Sup 400-in-1 language select + test app, 8 KiB PRG bank $35 (file 0x6A000), mapped at CPU $A000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK35"

testapp_main:
        jsr  copy_a3c0_to_0700          ; A000
        lda  #$00                       ; A003
        jsr  wait_vblank_b030           ; A005
        sta  PPU_MASK                   ; A008
        lda  #$20                       ; A00B
        sta  $00                        ; A00D
loc_A00F:
        lda  $00                        ; A00F
        sta  PPU_ADDR                   ; A011
        lda  #$00                       ; A014
        sta  PPU_ADDR                   ; A016
        ldy  #$00                       ; A019
        lda  #$30                       ; A01B
loc_A01D:
        sta  PPU_DATA                   ; A01D
        dey                             ; A020
        bne  loc_A01D                   ; A021
irq_target_inside_main:
        inc  $00                        ; A023
        lda  #$2C                       ; A025
        cmp  $00                        ; A027
        bne  loc_A00F                   ; A029
        ldy  #$00                       ; A02B
        lda  #$20                       ; A02D
        sta  $00                        ; A02F
        lda  #$87                       ; A031
        sta  $01                        ; A033
        jsr  print_string               ; A035
        lda  #$E6                       ; A038
        sta  $01                        ; A03A
        jsr  print_string               ; A03C
        lda  #$21                       ; A03F
        sta  $00                        ; A041
        lda  #$4A                       ; A043
        sta  $01                        ; A045
        jsr  print_string               ; A047
        lda  #$22                       ; A04A
        sta  $00                        ; A04C
        lda  #$26                       ; A04E
        sta  $01                        ; A050
        jsr  print_string               ; A052
        lda  #$A6                       ; A055
        sta  $01                        ; A057
        jsr  print_string               ; A059
        lda  #$64                       ; A05C
        sta  $01                        ; A05E
        jsr  print_string               ; A060
        lda  #$23                       ; A063
        sta  $00                        ; A065
        lda  #$37                       ; A067
        sta  $01                        ; A069
        jsr  print_string               ; A06B
        lda  #$3F                       ; A06E
        sta  PPU_ADDR                   ; A070
        lda  #$00                       ; A073
        sta  PPU_ADDR                   ; A075
        ldy  #$20                       ; A078
loc_A07A:
        lda  tbl_test_palette,y         ; A07A
        sta  PPU_DATA                   ; A07D
        dey                             ; A080
        bne  loc_A07A                   ; A081
        lda  #$0A                       ; A083
        jsr  draw_attr_and_grid         ; A085
        lda  #$00                       ; A088
        sta  PPU_SCROLL                 ; A08A
        sta  PPU_SCROLL                 ; A08D
        lda  #$08                       ; A090
        sta  PPU_MASK                   ; A092
        lda  #$80                       ; A095
        sta  PPU_CTRL                   ; A097
        lda  #$3C                       ; A09A
        sta  $0F                        ; A09C
loc_A09E:
        jsr  read_both_pads             ; A09E
        ldx  #$00                       ; A0A1
loc_A0A3:
        lda  $04,x                      ; A0A3
        and  #$40                       ; A0A5
        eor  $0C,x                      ; A0A7
        beq  loc_A0C1                   ; A0A9
        nop                             ; A0AB
        jsr  count_press                ; A0AC
        jsr  low_nibble_minus_10        ; A0AF
        bne  loc_A0BB                   ; A0B2
        ; static (not seen in traces)
        lda  $10,x                      ; A0B4
        clc                             ; A0B6
        adc  #$06                       ; A0B7
        sta  $10,x                      ; A0B9
loc_A0BB:
        lda  $0C,x                      ; A0BB
        eor  #$40                       ; A0BD
        sta  $0C,x                      ; A0BF
loc_A0C1:
        inx                             ; A0C1
        cpx  #$02                       ; A0C2
        bne  loc_A0A3                   ; A0C4
        beq  loc_A09E                   ; A0C6
put_tile_2200:
        lda  #$22                       ; A0C8
        sta  PPU_ADDR                   ; A0CA
        lda  $12                        ; A0CD
        sta  PPU_ADDR                   ; A0CF
        lda  $13                        ; A0D2
        sta  PPU_DATA                   ; A0D4
        rts                             ; A0D7
sub_1A_minus_9:
        lda  $1A                        ; A0D8
        sec                             ; A0DA
        sbc  #$09                       ; A0DB
        sta  $1A                        ; A0DD
        rts                             ; A0DF
low_nibble_minus_10:
        and  #$0F                       ; A0E0
        sec                             ; A0E2
        sbc  #$0A                       ; A0E3
        rts                             ; A0E5
read_joy1_bit:
        lda  JOY1                       ; A0E6
        pha                             ; A0E9
        and  #$01                       ; A0EA
        ora  #$30                       ; A0EC
        sta  $0721                      ; A0EE
        pla                             ; A0F1
        rts                             ; A0F2
read_joy2_bit:
        lda  JOY2_FRAME                 ; A0F3
        pha                             ; A0F6
        and  #$01                       ; A0F7
        ora  #$32                       ; A0F9
        sta  $0725                      ; A0FB
        pla                             ; A0FE
        rts                             ; A0FF
print_string:
        lda  $00                        ; A100
        sta  PPU_ADDR                   ; A102
        lda  $01                        ; A105
        sta  PPU_ADDR                   ; A107
loc_A10A:
        lda  tbl_test_strings,y         ; A10A
        cmp  #$FF                       ; A10D
        beq  loc_A118                   ; A10F
        sta  PPU_DATA                   ; A111
        iny                             ; A114
        jmp  loc_A10A                   ; A115
loc_A118:
        iny                             ; A118
        rts                             ; A119
tbl_test_strings:
        .byte $30,$16,$0A,$12,$17,$30,$0D,$0E,$1F,$12,$0C,$0E,$30,$1D,$0E,$1C ; A11A
        .byte $1D,$FF,$30,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35 ; A12A
        .byte $35,$35,$35,$35,$35,$30,$30,$FF,$FF,$18,$FF,$18,$FF,$18,$30,$30 ; A13A
        .byte $30,$18,$30,$30,$30,$30,$1C,$30,$30,$30,$1C,$30,$30,$30,$30,$0B ; A14A
        .byte $30,$30,$30,$0A,$FF,$0A,$0A,$1B,$18,$17,$12,$21,$FF,$FF,$30,$27 ; A15A
        .byte $2F,$30,$25,$1A,$07,$28,$27,$12,$06,$24,$23,$14,$26,$0A,$1B,$0A ; A16A
        .byte $16,$24,$0E,$1B,$1B,$00 ; A17A
read_both_pads:
        lda  #$01                       ; A180
        sta  JOY1                       ; A182
        lda  #$00                       ; A185
        sta  JOY1                       ; A187
        ldy  #$08                       ; A18A
loc_A18C:
        asl  $03                        ; A18C
        jsr  read_joy1_bit              ; A18E
        and  #$03                       ; A191
        beq  loc_A197                   ; A193
        lda  #$01                       ; A195
loc_A197:
        sta  $02                        ; A197
        jsr  read_joy2_bit              ; A199
        and  #$01                       ; A19C
        ora  $02                        ; A19E
        ora  $03                        ; A1A0
        sta  $03                        ; A1A2
        dey                             ; A1A4
        bne  loc_A18C                   ; A1A5
        ldy  #$0A                       ; A1A7
        asl  $03                        ; A1A9
        bcc  loc_A1AF                   ; A1AB
        ldy  #$52                       ; A1AD
loc_A1AF:
        sty  $04                        ; A1AF
        ldy  #$0B                       ; A1B1
        asl  $03                        ; A1B3
        bcc  loc_A1B9                   ; A1B5
        ldy  #$53                       ; A1B7
loc_A1B9:
        sty  $05                        ; A1B9
        ldy  #$1C                       ; A1BB
        asl  $03                        ; A1BD
        bcc  loc_A1C3                   ; A1BF
        ; static (not seen in traces)
        ldy  #$51                       ; A1C1
loc_A1C3:
        sty  $06                        ; A1C3
        ldy  #$1C                       ; A1C5
        asl  $03                        ; A1C7
        bcc  loc_A1CD                   ; A1C9
        ; static (not seen in traces)
        ldy  #$51                       ; A1CB
loc_A1CD:
        sty  $07                        ; A1CD
        ldy  #$18                       ; A1CF
        asl  $03                        ; A1D1
        bcc  loc_A1D7                   ; A1D3
        ; static (not seen in traces)
        ldy  #$50                       ; A1D5
loc_A1D7:
        sty  $0B                        ; A1D7
        ldy  #$18                       ; A1D9
        asl  $03                        ; A1DB
        bcc  loc_A1E1                   ; A1DD
        ; static (not seen in traces)
        ldy  #$50                       ; A1DF
loc_A1E1:
        sty  $0A                        ; A1E1
        ldy  #$18                       ; A1E3
        asl  $03                        ; A1E5
        bcc  loc_A1EB                   ; A1E7
        ; static (not seen in traces)
        ldy  #$50                       ; A1E9
loc_A1EB:
        sty  $09                        ; A1EB
        ldy  #$18                       ; A1ED
        asl  $03                        ; A1EF
        bcc  loc_A1F5                   ; A1F1
        ; static (not seen in traces)
        ldy  #$50                       ; A1F3
loc_A1F5:
        sty  $08                        ; A1F5
        rts                             ; A1F7
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A1F8
testapp_nmi:
        php                             ; A200
        pha                             ; A201
        txa                             ; A202
        pha                             ; A203
        lda  #$00                       ; A204
        jsr  set_mask_oam_dma_07        ; A206
        lda  PPU_STATUS                 ; A209
        lda  #$26                       ; A20C
        sta  $12                        ; A20E
        lda  $0B                        ; A210
        sta  $13                        ; A212
        jsr  put_tile_2200              ; A214
        lda  #$A6                       ; A217
        sta  $12                        ; A219
        lda  $0A                        ; A21B
        sta  $13                        ; A21D
        jsr  put_tile_2200              ; A21F
        lda  #$64                       ; A222
        sta  $12                        ; A224
        lda  $09                        ; A226
        sta  $13                        ; A228
        jsr  put_tile_2200              ; A22A
        lda  #$68                       ; A22D
        sta  $12                        ; A22F
        lda  $08                        ; A231
        sta  $13                        ; A233
        jsr  put_tile_2200              ; A235
        lda  #$71                       ; A238
        sta  $12                        ; A23A
        lda  $07                        ; A23C
        sta  $13                        ; A23E
        jsr  put_tile_2200              ; A240
        lda  #$6D                       ; A243
        sta  $12                        ; A245
        lda  $06                        ; A247
        sta  $13                        ; A249
        jsr  put_tile_2200              ; A24B
        lda  #$76                       ; A24E
        sta  $12                        ; A250
        lda  $05                        ; A252
        sta  $13                        ; A254
        jsr  put_tile_2200              ; A256
        lda  #$7A                       ; A259
        sta  $12                        ; A25B
        lda  $04                        ; A25D
        sta  $13                        ; A25F
        jsr  put_tile_2200              ; A261
        dec  $0F                        ; A264
        bne  loc_A2A4                   ; A266
        nop                             ; A268
        jsr  show_press_rates           ; A269
        lda  #$5C                       ; A26C
        sta  $1A                        ; A26E
        ldx  #$00                       ; A270
loc_A272:
        lda  $10,x                      ; A272
        and  #$0F                       ; A274
        sta  $14,x                      ; A276
        lda  $10,x                      ; A278
        lsr  a                          ; A27A
        lsr  a                          ; A27B
        lsr  a                          ; A27C
        lsr  a                          ; A27D
        and  #$0F                       ; A27E
        sta  $16,x                      ; A280
        lda  #$00                       ; A282
        sta  $10,x                      ; A284
        lda  #$21                       ; A286
        sta  PPU_ADDR                   ; A288
        jsr  next_counter_addr          ; A28B
        sta  PPU_ADDR                   ; A28E
        lda  $16,x                      ; A291
        sta  PPU_DATA                   ; A293
        lda  $14,x                      ; A296
        sta  PPU_DATA                   ; A298
        inx                             ; A29B
        cpx  #$02                       ; A29C
        bne  loc_A272                   ; A29E
        lda  #$3C                       ; A2A0
        sta  $0F                        ; A2A2
loc_A2A4:
        tya                             ; A2A4
        pha                             ; A2A5
        jsr  show_sound_step            ; A2A6
        pla                             ; A2A9
        tay                             ; A2AA
        lda  #$00                       ; A2AB
        sta  PPU_SCROLL                 ; A2AD
        sta  PPU_SCROLL                 ; A2B0
        lda  #$18                       ; A2B3
        sta  PPU_MASK                   ; A2B5
        lda  #$0F                       ; A2B8
        sta  REG_4139                   ; A2BA
        pla                             ; A2BD
        tax                             ; A2BE
        pla                             ; A2BF
        plp                             ; A2C0
        rti                             ; A2C1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A2C2
testapp_start:
        sei                             ; A2D0
loc_A2D1:
        lda  PPU_STATUS                 ; A2D1
        bpl  loc_A2D1                   ; A2D4
        lda  #$00                       ; A2D6
        sta  PPU_CTRL                   ; A2D8
        sta  PPU_MASK                   ; A2DB
        lda  warm_marker                ; A2DE
        cmp  #$57                       ; A2E1
        bne  loc_A2E8                   ; A2E3
        ; static (not seen in traces)
        jmp  testapp_warm_reset_to_langsel; A2E5
loc_A2E8:
        lda  PPU_STATUS                 ; A2E8
        bpl  loc_A2E8                   ; A2EB
        ldy  #$00                       ; A2ED
        lda  #$00                       ; A2EF
        sta  PPU_ADDR                   ; A2F1
        sta  PPU_ADDR                   ; A2F4
loc_A2F7:
        lda  dat_B1FA,y                 ; A2F7
        nop                             ; A2FA
        nop                             ; A2FB
        nop                             ; A2FC
        iny                             ; A2FD
        bne  loc_A2F7                   ; A2FE
        jmp  test_wram_patterns         ; A300
loc_A303:
        ; static (not seen in traces)
        lda  #$3F                       ; A303
        sta  PPU_ADDR                   ; A305
        lda  #$10                       ; A308
        sta  PPU_ADDR                   ; A30A
        lda  #$0A                       ; A30D
        sta  PPU_DATA                   ; A30F
        lda  #$30                       ; A312
        sta  PPU_DATA                   ; A314
        lda  #$00                       ; A317
        sta  PPU_SCROLL                 ; A319
        sta  PPU_SCROLL                 ; A31C
        sta  PPU_ADDR                   ; A31F
        sta  PPU_ADDR                   ; A322
        nop                             ; A325
        ldy  #$00                       ; A326
        sty  OAM_ADDR                   ; A328
loc_A32B:
        lda  dat_B1C2,y                 ; A32B
        sta  OAM_DATA                   ; A32E
        iny                             ; A331
        cpy  #$1C                       ; A332
        bne  loc_A32B                   ; A334
        lda  #$00                       ; A336
loc_A338:
        sta  OAM_DATA                   ; A338
        iny                             ; A33B
        bne  loc_A338                   ; A33C
        lda  #$00                       ; A33E
        sta  PPU_CTRL                   ; A340
        lda  #$10                       ; A343
        sta  PPU_MASK                   ; A345
loc_A348:
        lda  #$0F                       ; A348
        sta  APU_STATUS                 ; A34A
        lda  #$FF                       ; A34D
        sta  APU_4000                   ; A34F
        lda  #$FF                       ; A352
        sta  APU_4001                   ; A354
        lda  #$40                       ; A357
        sta  APU_4002                   ; A359
        lda  #$01                       ; A35C
        sta  APU_4003                   ; A35E
        ldy  #$00                       ; A361
loc_A363:
        ldx  #$00                       ; A363
loc_A365:
        dex                             ; A365
        bne  loc_A365                   ; A366
loc_A368:
        dex                             ; A368
        bne  loc_A368                   ; A369
loc_A36B:
        dex                             ; A36B
        bne  loc_A36B                   ; A36C
loc_A36E:
        dex                             ; A36E
        bne  loc_A36E                   ; A36F
loc_A371:
        dex                             ; A371
        bne  loc_A371                   ; A372
loc_A374:
        dex                             ; A374
        bne  loc_A374                   ; A375
        iny                             ; A377
        bne  loc_A363                   ; A378
        jmp  loc_A348                   ; A37A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$78,$AD,$02,$20,$10,$FB,$A0,$00,$A9 ; A37D
        .byte $00,$8D,$00,$20,$8D,$06,$20,$EA,$8D,$06,$20,$B9,$00,$80,$8D,$07 ; A38D
        .byte $20,$C8,$D0,$F7,$B9,$00,$81,$8D,$07,$20,$C8,$D0,$F7,$B9,$00,$82 ; A39D
        .byte $8D,$07,$20,$C8,$D0,$F7,$B9,$00,$83,$8D,$07,$20,$C8,$D0,$F7,$4C ; A3AD
        .byte $29,$A3,$FF ; A3BD
dat_A3C0:
        .byte $6C,$00,$00,$10,$6C,$01,$00,$2C,$6C,$02,$00,$4C,$6C,$03,$00,$6C ; A3C0
        .byte $6C,$04,$00,$8C,$6C,$05,$00,$AC,$6C,$06,$00,$CC,$6C,$07,$00,$E8 ; A3D0
        .byte $94,$30,$00,$E8,$9C,$32,$00,$E8,$32,$36,$80,$38,$3C,$36,$00,$38 ; A3E0
        .byte $B8,$00,$03,$08,$B8,$01,$03,$10,$B8,$02,$03,$18,$B8,$03,$03,$20 ; A3F0
        .byte $B8,$04,$03,$28,$B8,$05,$03,$30,$B8,$06,$03,$38,$B8,$07,$03,$40 ; A400
        .byte $C0,$00,$42,$08,$C0,$01,$42,$10,$C0,$02,$42,$18,$C0,$03,$42,$20 ; A410
        .byte $C0,$04,$42,$28,$C0,$05,$42,$30,$C0,$06,$42,$38,$C0,$07,$42,$40 ; A420
        .byte $C8,$00,$81,$08,$C8,$01,$81,$10,$C8,$02,$81,$18,$C8,$03,$81,$20 ; A430
        .byte $C8,$04,$81,$28,$C8,$05,$81,$30,$C8,$06,$81,$38,$C8,$07,$81,$40 ; A440
        .byte $D0,$00,$C0,$08,$D0,$01,$C0,$10,$D0,$02,$C0,$18,$D0,$03,$C0,$20 ; A450
        .byte $D0,$04,$C0,$28,$D0,$05,$C0,$30,$D0,$06,$C0,$38,$D0,$07,$C0,$40 ; A460
dat_A470:
        .byte $4A,$DA,$00,$78,$4A,$ED,$00,$78,$48,$D0,$00,$D0,$40,$D1,$00,$D0 ; A470
        .byte $40,$D2,$00,$D8,$40,$D2,$40,$E0,$40,$D1,$40,$E8,$48,$D0,$40,$E8 ; A480
        .byte $50,$D0,$80,$D0,$58,$D1,$80,$D0,$58,$D2,$80,$D8,$50,$D0,$C0,$E8 ; A490
        .byte $58,$D1,$C0,$E8,$58,$D2,$C0,$E0,$34,$0A,$02,$28,$3C,$0B,$02,$28 ; A4A0
        .byte $48,$D3,$01,$D8,$48,$D3,$01,$E0,$50,$D3,$02,$D8,$50,$D3,$02,$E0 ; A4B0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A4C0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A4D0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A4E0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A4F0
tbl_test_palette:
        .byte $FF,$26,$30,$2D,$2C,$2B,$2A,$3A,$28,$27,$26,$2A,$24,$30,$16,$1A ; A4FF
        .byte $0A,$30,$27,$2F,$30,$25,$1A,$07,$28,$27,$01,$06,$21,$21,$04,$16 ; A50F
        .byte $0A ; A51F
show_press_rates:
        nop                             ; A520
        nop                             ; A521
        nop                             ; A522
        lda  $20                        ; A523
        clc                             ; A525
        adc  #$38                       ; A526
        sta  $072B                      ; A528
        lda  $21                        ; A52B
        clc                             ; A52D
        adc  #$38                       ; A52E
        sta  $072F                      ; A530
        lda  #$3C                       ; A533
        sta  $0F                        ; A535
        lda  #$00                       ; A537
        sta  $20                        ; A539
        sta  $21                        ; A53B
        rts                             ; A53D
        .byte $FF,$FF ; A53E
count_press:
        inc  $10,x                      ; A540
        inc  $20,x                      ; A542
        lda  $10,x                      ; A544
        rts                             ; A546
copy_a3c0_to_0700:
        ldy  #$00                       ; A547
loc_A549:
        lda  dat_A3C0,y                 ; A549
        sta  $0700,y                    ; A54C
        iny                             ; A54F
        cpy  #$00                       ; A550
        bne  loc_A549                   ; A552
        rts                             ; A554
set_mask_oam_dma_07:
        sta  PPU_MASK                   ; A555
        sta  OAM_ADDR                   ; A558
        lda  #$07                       ; A55B
        sta  OAM_DMA                    ; A55D
        nop                             ; A560
        lda  $24                        ; A561
        bne  loc_A566                   ; A563
        rts                             ; A565
loc_A566:
        lda  $07B3                      ; A566
        cmp  #$9C                       ; A569
        beq  loc_A587                   ; A56B
        nop                             ; A56D
        inc  $07B0                      ; A56E
        inc  $07B1                      ; A571
        inc  $07B3                      ; A574
        inc  $07B3                      ; A577
        inc  $07B4                      ; A57A
        inc  $07B5                      ; A57D
        dec  $07B7                      ; A580
        dec  $07B7                      ; A583
        rts                             ; A586
loc_A587:
        inc  $25                        ; A587
        inc  $25                        ; A589
        inc  $25                        ; A58B
        inc  $25                        ; A58D
        beq  loc_A592                   ; A58F
        rts                             ; A591
loc_A592:
        ; static (not seen in traces)
        tya                             ; A592
        pha                             ; A593
        ldy  #$00                       ; A594
loc_A596:
        lda  dat_A470,y                 ; A596
        sta  $07B0,y                    ; A599
        iny                             ; A59C
        cpy  #$08                       ; A59D
        bne  loc_A596                   ; A59F
        pla                             ; A5A1
        tay                             ; A5A2
        rts                             ; A5A3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5A4
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5B4
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5C4
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5D4
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5E4
next_counter_addr:
        lda  #$FF                       ; A5F0
        sta  $24                        ; A5F2
        jmp  sub_1A_minus_9             ; A5F4
        .byte $FF,$FF,$FF,$FF,$FF ; A5F7
tbl_ram_test_patterns:
        .byte $55,$AA,$FF,$00 ; A5FC
test_wram_patterns:
        ldy  #$00                       ; A600
        ldx  #$00                       ; A602
        lda  #$55                       ; A604
loc_A606:
        sta  $00,x                      ; A606
        lda  $00,x                      ; A608
        cmp  tbl_ram_test_patterns,y    ; A60A
        bne  loc_A66A                   ; A60D
        sta  $0100,x                    ; A60F
        lda  $0100,x                    ; A612
        cmp  tbl_ram_test_patterns,y    ; A615
        bne  loc_A66A                   ; A618
        sta  $0200,x                    ; A61A
        lda  $0200,x                    ; A61D
        cmp  tbl_ram_test_patterns,y    ; A620
        bne  loc_A66A                   ; A623
        sta  $0300,x                    ; A625
        lda  $0300,x                    ; A628
        cmp  tbl_ram_test_patterns,y    ; A62B
        bne  loc_A66A                   ; A62E
        sta  $0400,x                    ; A630
        lda  $0400,x                    ; A633
        cmp  tbl_ram_test_patterns,y    ; A636
        bne  loc_A66A                   ; A639
        sta  $0500,x                    ; A63B
        lda  $0500,x                    ; A63E
        cmp  tbl_ram_test_patterns,y    ; A641
        bne  loc_A66A                   ; A644
        sta  $0600,x                    ; A646
        lda  $0600,x                    ; A649
        cmp  tbl_ram_test_patterns,y    ; A64C
        bne  loc_A66A                   ; A64F
        sta  $0700,x                    ; A651
        lda  $0700,x                    ; A654
        cmp  tbl_ram_test_patterns,y    ; A657
        bne  loc_A66A                   ; A65A
        inx                             ; A65C
        bne  loc_A606                   ; A65D
        iny                             ; A65F
        cpy  #$04                       ; A660
        beq  test_wram_fill_verify      ; A662
        lda  tbl_ram_test_patterns,y    ; A664
        jmp  loc_A606                   ; A667
loc_A66A:
        ; static (not seen in traces)
        jmp  ram_test_failed            ; A66A
test_wram_fill_verify:
        ldy  #$00                       ; A66D
        ldx  #$00                       ; A66F
        lda  #$55                       ; A671
loc_A673:
        sta  $00,x                      ; A673
        sta  $0100,x                    ; A675
        sta  $0200,x                    ; A678
        sta  $0300,x                    ; A67B
        sta  $0400,x                    ; A67E
        sta  $0500,x                    ; A681
        sta  $0600,x                    ; A684
        sta  $0700,x                    ; A687
        inx                             ; A68A
        bne  loc_A673                   ; A68B
        lda  tbl_ram_test_patterns,y    ; A68D
loc_A690:
        cmp  $00,x                      ; A690
        bne  loc_A66A                   ; A692
        cmp  $0100,x                    ; A694
        bne  loc_A66A                   ; A697
        cmp  $0200,x                    ; A699
        bne  loc_A66A                   ; A69C
        cmp  $0300,x                    ; A69E
        bne  loc_A66A                   ; A6A1
        cmp  $0400,x                    ; A6A3
        bne  loc_A66A                   ; A6A6
        cmp  $0500,x                    ; A6A8
        bne  loc_A66A                   ; A6AB
        cmp  $0600,x                    ; A6AD
        bne  loc_A66A                   ; A6B0
        cmp  $0700,x                    ; A6B2
        bne  loc_A66A                   ; A6B5
        inx                             ; A6B7
        bne  loc_A690                   ; A6B8
        iny                             ; A6BA
        cpy  #$04                       ; A6BB
        beq  test_wram_copy_rom_c000    ; A6BD
        lda  tbl_ram_test_patterns,y    ; A6BF
        jmp  loc_A673                   ; A6C2
test_wram_copy_rom_c000:
        ldy  #$00                       ; A6C5
        ldx  #$00                       ; A6C7
loc_A6C9:
        lda  dat_C000,x                 ; A6C9
        sta  $00,x                      ; A6CC
        lda  dat_C100,x                 ; A6CE
        sta  $0100,x                    ; A6D1
        lda  dat_C200,x                 ; A6D4
        sta  $0200,x                    ; A6D7
        lda  dat_C300,x                 ; A6DA
        sta  $0300,x                    ; A6DD
        lda  dat_C400,x                 ; A6E0
        sta  $0400,x                    ; A6E3
        lda  dat_C500,x                 ; A6E6
        sta  $0500,x                    ; A6E9
        lda  dat_C600,x                 ; A6EC
        sta  $0600,x                    ; A6EF
        lda  dat_C700,x                 ; A6F2
        sta  $0700,x                    ; A6F5
        inx                             ; A6F8
        bne  loc_A6C9                   ; A6F9
loc_A6FB:
        lda  dat_C000,x                 ; A6FB
        cmp  $00,x                      ; A6FE
        bne  ram_test_failed            ; A700
        lda  dat_C100,x                 ; A702
        cmp  $0100,x                    ; A705
        bne  ram_test_failed            ; A708
        lda  dat_C200,x                 ; A70A
        cmp  $0200,x                    ; A70D
        bne  ram_test_failed            ; A710
        lda  dat_C300,x                 ; A712
        cmp  $0300,x                    ; A715
        bne  ram_test_failed            ; A718
        lda  dat_C400,x                 ; A71A
        cmp  $0400,x                    ; A71D
        bne  ram_test_failed            ; A720
        lda  dat_C500,x                 ; A722
        cmp  $0500,x                    ; A725
        bne  ram_test_failed            ; A728
        lda  dat_C600,x                 ; A72A
        cmp  $0600,x                    ; A72D
        bne  ram_test_failed            ; A730
        lda  dat_C700,x                 ; A732
        cmp  $0700,x                    ; A735
        bne  ram_test_failed            ; A738
        inx                             ; A73A
        bne  loc_A6FB                   ; A73B
        jmp  clear_wram                 ; A73D
ram_test_failed:
        ; static (not seen in traces)
        jmp  test_vram                  ; A740
clear_wram:
        ldx  #$08                       ; A743
        ldy  #$00                       ; A745
        sty  $00                        ; A747
        sty  $01                        ; A749
        ldy  #$02                       ; A74B
        lda  #$00                       ; A74D
loc_A74F:
        sta  ($00),y                    ; A74F
        iny                             ; A751
        bne  loc_A74F                   ; A752
        inc  $01                        ; A754
        dex                             ; A756
        bne  loc_A74F                   ; A757
        lda  #$55                       ; A759
        sta  $4E                        ; A75B
        lda  #$AA                       ; A75D
        sta  $4F                        ; A75F
test_vram:
        lda  #$20                       ; A761
        sta  PPU_ADDR                   ; A763
        lda  #$00                       ; A766
        sta  PPU_ADDR                   ; A768
        ldx  #$08                       ; A76B
        ldy  #$00                       ; A76D
        lda  #$FF                       ; A76F
loc_A771:
        sta  PPU_DATA                   ; A771
        iny                             ; A774
        bne  loc_A771                   ; A775
        dex                             ; A777
        bne  loc_A771                   ; A778
        lda  #$20                       ; A77A
        sta  PPU_ADDR                   ; A77C
        lda  #$00                       ; A77F
        sta  PPU_ADDR                   ; A781
        ldx  #$08                       ; A784
        ldy  #$00                       ; A786
        lda  PPU_DATA                   ; A788
loc_A78B:
        lda  PPU_DATA                   ; A78B
        cmp  #$FF                       ; A78E
        bne  loc_A7C7                   ; A790
        iny                             ; A792
        bne  loc_A78B                   ; A793
        dex                             ; A795
        bne  loc_A78B                   ; A796
        lda  #$20                       ; A798
        sta  PPU_ADDR                   ; A79A
        lda  #$00                       ; A79D
        sta  PPU_ADDR                   ; A79F
        ldx  #$08                       ; A7A2
        ldy  #$00                       ; A7A4
        lda  #$00                       ; A7A6
loc_A7A8:
        sta  PPU_DATA                   ; A7A8
        iny                             ; A7AB
        bne  loc_A7A8                   ; A7AC
        dex                             ; A7AE
        bne  loc_A7A8                   ; A7AF
        lda  #$20                       ; A7B1
        sta  PPU_ADDR                   ; A7B3
        lda  #$00                       ; A7B6
        sta  PPU_ADDR                   ; A7B8
        ldx  #$08                       ; A7BB
        ldy  #$00                       ; A7BD
        lda  PPU_DATA                   ; A7BF
loc_A7C2:
        lda  PPU_DATA                   ; A7C2
        cmp  #$00                       ; A7C5
loc_A7C7:
        bne  loc_A832                   ; A7C7
        iny                             ; A7C9
        bne  loc_A7C2                   ; A7CA
        dex                             ; A7CC
        bne  loc_A7C2                   ; A7CD
        lda  #$20                       ; A7CF
        sta  PPU_ADDR                   ; A7D1
        lda  #$00                       ; A7D4
        sta  PPU_ADDR                   ; A7D6
        ldy  #$00                       ; A7D9
loc_A7DB:
        lda  dat_C000,y                 ; A7DB
        sta  PPU_DATA                   ; A7DE
        lda  dat_C100,y                 ; A7E1
        sta  PPU_DATA                   ; A7E4
        lda  dat_C200,y                 ; A7E7
        sta  PPU_DATA                   ; A7EA
        lda  dat_C300,y                 ; A7ED
        sta  PPU_DATA                   ; A7F0
        iny                             ; A7F3
        bne  loc_A7DB                   ; A7F4
        lda  #$24                       ; A7F6
        sta  PPU_ADDR                   ; A7F8
        lda  #$00                       ; A7FB
        sta  PPU_ADDR                   ; A7FD
        ldy  #$00                       ; A800
loc_A802:
        lda  dat_C400,y                 ; A802
        sta  PPU_DATA                   ; A805
        lda  dat_C500,y                 ; A808
        sta  PPU_DATA                   ; A80B
        lda  dat_C600,y                 ; A80E
        sta  PPU_DATA                   ; A811
        lda  dat_C700,y                 ; A814
        sta  PPU_DATA                   ; A817
        iny                             ; A81A
        bne  loc_A802                   ; A81B
        lda  #$20                       ; A81D
        sta  PPU_ADDR                   ; A81F
        lda  #$00                       ; A822
        sta  PPU_ADDR                   ; A824
        ldy  #$00                       ; A827
        lda  PPU_DATA                   ; A829
loc_A82C:
        lda  PPU_DATA                   ; A82C
        cmp  dat_C000,y                 ; A82F
loc_A832:
        bne  loc_A83A                   ; A832
        lda  PPU_DATA                   ; A834
        cmp  dat_C100,y                 ; A837
loc_A83A:
        bne  loc_A842                   ; A83A
        lda  PPU_DATA                   ; A83C
        cmp  dat_C200,y                 ; A83F
loc_A842:
        bne  loc_A84A                   ; A842
        lda  PPU_DATA                   ; A844
        cmp  dat_C300,y                 ; A847
loc_A84A:
        bne  loc_A864                   ; A84A
        iny                             ; A84C
        bne  loc_A82C                   ; A84D
        lda  #$24                       ; A84F
        sta  PPU_ADDR                   ; A851
        lda  #$00                       ; A854
        sta  PPU_ADDR                   ; A856
        ldy  #$00                       ; A859
        lda  PPU_DATA                   ; A85B
loc_A85E:
        lda  PPU_DATA                   ; A85E
        cmp  dat_C400,y                 ; A861
loc_A864:
        bne  loc_A86C                   ; A864
        lda  PPU_DATA                   ; A866
        cmp  dat_C500,y                 ; A869
loc_A86C:
        bne  loc_A874                   ; A86C
        lda  PPU_DATA                   ; A86E
        cmp  dat_C600,y                 ; A871
loc_A874:
        bne  loc_A87C                   ; A874
        lda  PPU_DATA                   ; A876
        cmp  dat_C700,y                 ; A879
loc_A87C:
        bne  loc_A893                   ; A87C
        iny                             ; A87E
        bne  loc_A85E                   ; A87F
        lda  $4E                        ; A881
        cmp  #$55                       ; A883
        bne  loc_A890                   ; A885
        lda  $4F                        ; A887
        cmp  #$AA                       ; A889
        bne  loc_A890                   ; A88B
        jmp  testapp_install_nmi_cold   ; A88D
loc_A890:
        ; static (not seen in traces)
        jmp  loc_A303                   ; A890
loc_A893:
        lda  $4E                        ; A893
        cmp  #$55                       ; A895
        bne  loc_A89D                   ; A897
        lda  $4F                        ; A899
        cmp  #$AA                       ; A89B
loc_A89D:
        bne  loc_A8E7                   ; A89D
        lda  #$3F                       ; A89F
        sta  PPU_ADDR                   ; A8A1
        lda  #$10                       ; A8A4
        sta  PPU_ADDR                   ; A8A6
        lda  #$0A                       ; A8A9
        sta  PPU_DATA                   ; A8AB
        lda  #$30                       ; A8AE
        sta  PPU_DATA                   ; A8B0
        lda  #$00                       ; A8B3
        sta  PPU_SCROLL                 ; A8B5
        sta  PPU_SCROLL                 ; A8B8
        sta  PPU_ADDR                   ; A8BB
        sta  PPU_ADDR                   ; A8BE
        nop                             ; A8C1
        ldy  #$00                       ; A8C2
        sty  OAM_ADDR                   ; A8C4
loc_A8C7:
        lda  dat_B1DE,y                 ; A8C7
        sta  OAM_DATA                   ; A8CA
        iny                             ; A8CD
        cpy  #$1C                       ; A8CE
        bne  loc_A8C7                   ; A8D0
        lda  #$00                       ; A8D2
loc_A8D4:
        sta  OAM_DATA                   ; A8D4
        iny                             ; A8D7
        bne  loc_A8D4                   ; A8D8
        lda  #$00                       ; A8DA
        sta  PPU_CTRL                   ; A8DC
        lda  #$10                       ; A8DF
        sta  PPU_MASK                   ; A8E1
        jmp  loc_A97A                   ; A8E4
loc_A8E7:
        lda  #$3F                       ; A8E7
        sta  PPU_ADDR                   ; A8E9
        lda  #$10                       ; A8EC
        sta  PPU_ADDR                   ; A8EE
        lda  #$0A                       ; A8F1
        sta  PPU_DATA                   ; A8F3
        lda  #$30                       ; A8F6
        sta  PPU_DATA                   ; A8F8
        lda  #$00                       ; A8FB
        sta  PPU_SCROLL                 ; A8FD
        sta  PPU_SCROLL                 ; A900
        sta  PPU_ADDR                   ; A903
        sta  PPU_ADDR                   ; A906
        nop                             ; A909
        ldy  #$00                       ; A90A
        sty  OAM_ADDR                   ; A90C
loc_A90F:
        lda  dat_B1C2,y                 ; A90F
        sta  OAM_DATA                   ; A912
        iny                             ; A915
        cpy  #$38                       ; A916
        bne  loc_A90F                   ; A918
        lda  #$00                       ; A91A
loc_A91C:
        sta  OAM_DATA                   ; A91C
        iny                             ; A91F
        bne  loc_A91C                   ; A920
        lda  #$00                       ; A922
        sta  PPU_CTRL                   ; A924
        lda  #$10                       ; A927
        sta  PPU_MASK                   ; A929
loc_A92C:
        lda  #$0F                       ; A92C
        sta  APU_STATUS                 ; A92E
        lda  #$3F                       ; A931
        sta  APU_4004                   ; A933
        lda  #$F7                       ; A936
        sta  APU_4005                   ; A938
        lda  #$00                       ; A93B
        sta  APU_4006                   ; A93D
        lda  #$01                       ; A940
        sta  APU_4007                   ; A942
        lda  #$0F                       ; A945
        sta  APU_STATUS                 ; A947
        lda  #$FF                       ; A94A
        sta  APU_4000                   ; A94C
        lda  #$FF                       ; A94F
        sta  APU_4001                   ; A951
        lda  #$40                       ; A954
        sta  APU_4002                   ; A956
        lda  #$01                       ; A959
        sta  APU_4003                   ; A95B
        ldy  #$00                       ; A95E
loc_A960:
        ldx  #$00                       ; A960
loc_A962:
        dex                             ; A962
        bne  loc_A962                   ; A963
loc_A965:
        dex                             ; A965
        bne  loc_A965                   ; A966
loc_A968:
        dex                             ; A968
        bne  loc_A968                   ; A969
loc_A96B:
        dex                             ; A96B
        bne  loc_A96B                   ; A96C
loc_A96E:
        dex                             ; A96E
        bne  loc_A96E                   ; A96F
loc_A971:
        dex                             ; A971
        bne  loc_A971                   ; A972
        iny                             ; A974
        bne  loc_A960                   ; A975
        jmp  loc_A92C                   ; A977
loc_A97A:
        lda  #$0F                       ; A97A
        sta  APU_STATUS                 ; A97C
        lda  #$3F                       ; A97F
        sta  APU_4004                   ; A981
        lda  #$F7                       ; A984
        sta  APU_4005                   ; A986
        lda  #$00                       ; A989
        sta  APU_4006                   ; A98B
        lda  #$01                       ; A98E
        sta  APU_4007                   ; A990
        ldy  #$00                       ; A993
loc_A995:
        ldx  #$00                       ; A995
loc_A997:
        dex                             ; A997
        bne  loc_A997                   ; A998
loc_A99A:
        dex                             ; A99A
        bne  loc_A99A                   ; A99B
loc_A99D:
        dex                             ; A99D
        bne  loc_A99D                   ; A99E
loc_A9A0:
        dex                             ; A9A0
        bne  loc_A9A0                   ; A9A1
loc_A9A3:
        dex                             ; A9A3
        bne  loc_A9A3                   ; A9A4
loc_A9A6:
        dex                             ; A9A6
        bne  loc_A9A6                   ; A9A7
        iny                             ; A9A9
        bne  loc_A995                   ; A9AA
        jmp  loc_A97A                   ; A9AC
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A9AF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A9BF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A9CF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A9DF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A9EF
        .byte $FF ; A9FF
sound_test_step:
        lda  snd_step                   ; AA00
        cmp  #$00                       ; AA02
        bne  loc_AA28                   ; AA04
        lda  #$01                       ; AA06
        sta  APU_STATUS                 ; AA08
        lda  #$BF                       ; AA0B
        sta  APU_4000                   ; AA0D
        lda  #$84                       ; AA10
        sta  APU_4001                   ; AA12
        lda  #$10                       ; AA15
        sta  APU_4002                   ; AA17
        lda  #$00                       ; AA1A
        sta  APU_4003                   ; AA1C
        lda  #$01                       ; AA1F
        sta  snd_step                   ; AA21
        lda  #$30                       ; AA23
        sta  snd_timer                  ; AA25
        rts                             ; AA27
loc_AA28:
        cmp  #$01                       ; AA28
        bne  loc_AA35                   ; AA2A
        dec  snd_timer                  ; AA2C
        bne  loc_AA34                   ; AA2E
        lda  #$02                       ; AA30
        sta  snd_step                   ; AA32
loc_AA34:
        rts                             ; AA34
loc_AA35:
        cmp  #$02                       ; AA35
        bne  loc_AA56                   ; AA37
        lda  #$A0                       ; AA39
        sta  APU_4000                   ; AA3B
        lda  #$8D                       ; AA3E
        sta  APU_4001                   ; AA40
        lda  #$FF                       ; AA43
        sta  APU_4002                   ; AA45
        lda  #$07                       ; AA48
        sta  APU_4003                   ; AA4A
        lda  #$03                       ; AA4D
        sta  snd_step                   ; AA4F
        lda  #$48                       ; AA51
        sta  snd_timer                  ; AA53
        rts                             ; AA55
loc_AA56:
        cmp  #$03                       ; AA56
        bne  loc_AA63                   ; AA58
        dec  snd_timer                  ; AA5A
        bne  loc_AA62                   ; AA5C
        ; static (not seen in traces)
        lda  #$04                       ; AA5E
        sta  snd_step                   ; AA60
loc_AA62:
        rts                             ; AA62
loc_AA63:
        ; static (not seen in traces)
        cmp  #$04                       ; AA63
        bne  loc_AA89                   ; AA65
        lda  #$02                       ; AA67
        sta  APU_STATUS                 ; AA69
        lda  #$A0                       ; AA6C
        sta  APU_4004                   ; AA6E
        lda  #$86                       ; AA71
        sta  APU_4005                   ; AA73
        lda  #$40                       ; AA76
        sta  APU_4006                   ; AA78
        lda  #$00                       ; AA7B
        sta  APU_4007                   ; AA7D
        lda  #$05                       ; AA80
        sta  snd_step                   ; AA82
        lda  #$68                       ; AA84
        sta  snd_timer                  ; AA86
        rts                             ; AA88
loc_AA89:
        cmp  #$05                       ; AA89
        bne  loc_AA96                   ; AA8B
        dec  snd_timer                  ; AA8D
        bne  loc_AA95                   ; AA8F
        lda  #$06                       ; AA91
        sta  snd_step                   ; AA93
loc_AA95:
        rts                             ; AA95
loc_AA96:
        cmp  #$06                       ; AA96
        bne  loc_AAB7                   ; AA98
        lda  #$BF                       ; AA9A
        sta  APU_4004                   ; AA9C
        lda  #$8C                       ; AA9F
        sta  APU_4005                   ; AAA1
        lda  #$FF                       ; AAA4
        sta  APU_4006                   ; AAA6
        lda  #$07                       ; AAA9
        sta  APU_4007                   ; AAAB
        lda  #$07                       ; AAAE
        sta  snd_step                   ; AAB0
        lda  #$30                       ; AAB2
        sta  snd_timer                  ; AAB4
        rts                             ; AAB6
loc_AAB7:
        cmp  #$07                       ; AAB7
        bne  loc_AACC                   ; AAB9
        dec  snd_timer                  ; AABB
        bne  loc_AACB                   ; AABD
        lda  #$08                       ; AABF
        sta  snd_step                   ; AAC1
        lda  #$01                       ; AAC3
        sta  snd_timer                  ; AAC5
        lda  #$20                       ; AAC7
        sta  $32                        ; AAC9
loc_AACB:
        rts                             ; AACB
loc_AACC:
        cmp  #$08                       ; AACC
        bne  loc_AAF6                   ; AACE
        dec  snd_timer                  ; AAD0
        bne  loc_AAF5                   ; AAD2
        lda  #$0C                       ; AAD4
        sta  snd_timer                  ; AAD6
        lda  #$04                       ; AAD8
        sta  APU_STATUS                 ; AADA
        ldx  $32                        ; AADD
        lda  dat_AB80,x                 ; AADF
        sta  APU_4008                   ; AAE2
        sta  APU_400A                   ; AAE5
        lda  #$00                       ; AAE8
        sta  APU_400B                   ; AAEA
        dec  $32                        ; AAED
        bne  loc_AAF5                   ; AAEF
        lda  #$09                       ; AAF1
        sta  snd_step                   ; AAF3
loc_AAF5:
        rts                             ; AAF5
loc_AAF6:
        cmp  #$09                       ; AAF6
        bne  loc_AB07                   ; AAF8
        lda  #$0A                       ; AAFA
        sta  snd_step                   ; AAFC
        lda  #$05                       ; AAFE
        sta  snd_timer                  ; AB00
        lda  #$20                       ; AB02
        sta  $32                        ; AB04
        rts                             ; AB06
loc_AB07:
        cmp  #$0A                       ; AB07
        bne  loc_AB37                   ; AB09
        dec  snd_timer                  ; AB0B
        bne  loc_AB36                   ; AB0D
        lda  #$05                       ; AB0F
        sta  snd_timer                  ; AB11
        lda  #$08                       ; AB13
        sta  APU_STATUS                 ; AB15
        lda  #$04                       ; AB18
        sta  APU_400C                   ; AB1A
        ldx  $32                        ; AB1D
        lda  dat_ABA0,x                 ; AB1F
        sta  APU_400E                   ; AB22
        lda  #$10                       ; AB25
        sta  APU_400F                   ; AB27
        dec  $32                        ; AB2A
        bne  loc_AB36                   ; AB2C
        lda  #$0B                       ; AB2E
        sta  snd_step                   ; AB30
        lda  #$10                       ; AB32
        sta  snd_timer                  ; AB34
loc_AB36:
        rts                             ; AB36
loc_AB37:
        cmp  #$0B                       ; AB37
        bne  loc_AB44                   ; AB39
        dec  snd_timer                  ; AB3B
        bne  loc_AB43                   ; AB3D
        lda  #$0C                       ; AB3F
        sta  snd_step                   ; AB41
loc_AB43:
        rts                             ; AB43
loc_AB44:
        cmp  #$0C                       ; AB44
        bne  loc_AB65                   ; AB46
        lda  #$FA                       ; AB48
        sta  APU_4013                   ; AB4A
        lda  #$00                       ; AB4D
        sta  APU_4012                   ; AB4F
        lda  #$0E                       ; AB52
        sta  APU_4010                   ; AB54
        lda  #$10                       ; AB57
        sta  APU_STATUS                 ; AB59
        lda  #$0D                       ; AB5C
        sta  snd_step                   ; AB5E
        lda  #$50                       ; AB60
        sta  snd_timer                  ; AB62
loc_AB64:
        rts                             ; AB64
loc_AB65:
        cmp  #$0D                       ; AB65
        bne  loc_AB64                   ; AB67
        dec  snd_timer                  ; AB69
        bne  loc_AB64                   ; AB6B
        inc  $32                        ; AB6D
        lda  #$02                       ; AB6F
        cmp  $32                        ; AB71
        bne  loc_AB7A                   ; AB73
        lda  #$00                       ; AB75
        sta  snd_step                   ; AB77
        rts                             ; AB79
loc_AB7A:
        lda  #$0C                       ; AB7A
        sta  snd_step                   ; AB7C
        rts                             ; AB7E
        .byte $FF ; AB7F
dat_AB80:
        .byte $FF,$F0,$E1,$D2,$C3,$B4,$A5,$96,$87,$78,$69,$5A,$4B,$3C,$2D,$1E ; AB80
        .byte $0F,$00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE ; AB90
dat_ABA0:
        .byte $FF,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01 ; ABA0
        .byte $00,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E ; ABB0
        .byte $1F ; ABC0
dat_ABC1:
        .byte $0C,$11,$0A,$17,$17,$0E,$15,$24,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ABC1
show_sound_step:
        lda  #$23                       ; ABD0
        sta  PPU_ADDR                   ; ABD2
        lda  #$0B                       ; ABD5
        sta  PPU_ADDR                   ; ABD7
        ldx  #$00                       ; ABDA
        ldy  #$08                       ; ABDC
loc_ABDE:
        lda  dat_ABC1,x                 ; ABDE
        sta  PPU_DATA                   ; ABE1
        inx                             ; ABE4
        dey                             ; ABE5
        bne  loc_ABDE                   ; ABE6
        lda  snd_step                   ; ABE8
        cmp  #$00                       ; ABEA
        bne  loc_ABF6                   ; ABEC
        ldx  #$01                       ; ABEE
        stx  PPU_DATA                   ; ABF0
        jmp  sound_test_step            ; ABF3
loc_ABF6:
        cmp  #$04                       ; ABF6
        bne  loc_AC02                   ; ABF8
        ; static (not seen in traces)
        ldx  #$02                       ; ABFA
        stx  PPU_DATA                   ; ABFC
        jmp  sound_test_step            ; ABFF
loc_AC02:
        cmp  #$08                       ; AC02
        bne  loc_AC0E                   ; AC04
        ; static (not seen in traces)
        ldx  #$03                       ; AC06
        stx  PPU_DATA                   ; AC08
        jmp  sound_test_step            ; AC0B
loc_AC0E:
        cmp  #$0A                       ; AC0E
        bne  loc_AC1A                   ; AC10
        ; static (not seen in traces)
        ldx  #$04                       ; AC12
        stx  PPU_DATA                   ; AC14
        jmp  sound_test_step            ; AC17
loc_AC1A:
        cmp  #$0C                       ; AC1A
        bne  loc_AC23                   ; AC1C
        ; static (not seen in traces)
        ldx  #$05                       ; AC1E
        stx  PPU_DATA                   ; AC20
loc_AC23:
        jmp  sound_test_step            ; AC23
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC26
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC36
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC46
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC56
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC66
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC76
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC86
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AC96
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACA6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACB6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACC6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACD6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACE6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ACF6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD06
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD16
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD26
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD36
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD46
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD56
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD66
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD76
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD86
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AD96
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADA6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADB6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADC6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADD6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADE6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADF6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE06
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE16
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE26
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE36
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE46
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE56
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE66
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE76
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE86
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE96
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEA6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEB6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEC6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AED6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEE6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEF6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF06
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF16
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF26
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF36
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF46
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF56
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF66
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF76
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF86
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF96
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFA6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFB6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFC6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFD6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFE6
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFF6
loc_B000:
        rts                             ; B000
        .byte $00,$8D,$00,$20,$EA,$EA,$8D,$06,$20,$A9,$00,$EA,$8D,$06,$20,$85 ; B001
        .byte $80,$A9,$80,$85,$81,$A0,$00,$B1,$80,$E6,$80,$8D,$07,$20,$D0,$F7 ; B011
        .byte $E6,$81,$A5,$81,$C9,$A0,$D0,$EF,$60,$EA,$EA,$EA,$EA,$EA,$EA ; B021
wait_vblank_b030:
        lda  PPU_STATUS                 ; B030
        bpl  wait_vblank_b030           ; B033
        jmp  loc_B000                   ; B035
        .byte $60,$78,$60,$00,$EA,$8D,$06,$20,$85,$80,$A9,$FC,$85,$81,$A0,$00 ; B038
        .byte $B1,$80,$E6,$80,$8D,$07,$20,$D0,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B048
        .byte $60,$56,$00,$60,$60,$52,$00,$70,$60,$41,$00,$78,$60,$4D,$00,$80 ; B058
        .byte $68,$45,$00,$68,$68,$52,$00,$70,$68,$52,$00,$78,$FF,$FF,$FF,$FF ; B068
        .byte $A9,$20,$A0,$00,$8D,$06,$20,$8C,$06,$20,$A2,$08,$8C,$07,$20,$88 ; B078
        .byte $D0,$FA,$88,$CA,$D0,$F6,$A2,$07,$8C,$07,$20,$88,$CA,$D0,$F9,$A9 ; B088
        .byte $20,$A0,$00,$8D,$06,$20,$8C,$06,$20,$A2,$08,$AD,$07,$20,$84,$88 ; B098
        .byte $AD,$07,$20,$C5,$88,$D0,$18,$C6,$88,$D0,$F5,$C6,$88,$CA,$D0,$F0 ; B0A8
        .byte $A2,$07,$AD,$07,$20,$C5,$88,$D0,$06,$C6,$88,$CA,$D0,$F4,$60,$A9 ; B0B8
        .byte $01,$85,$28,$60,$A9,$01,$C5,$28,$D0,$0E,$A2,$00,$A0,$1C,$BD,$58 ; B0C8
        .byte $B0,$9D,$C0,$07,$E8,$88,$D0,$F6,$60,$B0,$30,$00,$40,$B0,$31,$00 ; B0D8
        .byte $48,$B0,$32,$00,$10,$B0,$33,$00,$18,$B0,$34,$00,$20,$B0,$35,$00 ; B0E8
        .byte $28,$B0,$36,$00,$30,$B0,$37,$00,$38,$C0,$30,$00,$40,$C0,$31,$00 ; B0F8
        .byte $48,$C0,$32,$00,$10,$C0,$33,$00,$18,$C0,$34,$00,$20,$C0,$35,$00 ; B108
        .byte $28,$C0,$36,$00,$30,$C0,$37,$00,$38,$C8,$30,$00,$40,$C8,$31,$00 ; B118
        .byte $48,$C8,$32,$00,$10,$C8,$33,$00,$18,$C8,$34,$00,$20,$C8,$35,$00 ; B128
        .byte $28,$C8,$36,$00,$30,$C8,$37,$00,$38,$D0,$30,$00,$40,$D0,$31,$00 ; B138
        .byte $48,$D0,$32,$00,$10,$D0,$33,$00,$18,$D0,$34,$00,$20,$D0,$35,$00 ; B148
        .byte $28,$D0,$36,$00,$30,$D0,$37,$00,$38,$D8,$30,$00,$40,$D8,$31,$00 ; B158
        .byte $48,$D8,$32,$00,$10,$D8,$33,$00,$18,$D8,$34,$00,$20,$D8,$35,$00 ; B168
        .byte $28,$D8,$36,$00,$30,$D8,$37,$00,$38,$E0,$30,$00,$40,$E0,$31,$00 ; B178
        .byte $48,$E0,$32,$00,$10,$E0,$33,$00,$18,$E0,$34,$00,$20,$E0,$35,$00 ; B188
        .byte $28,$E0,$36,$00,$30,$E0,$37,$00,$38,$B8,$30,$00,$40,$B8,$31,$00 ; B198
        .byte $48,$B8,$32,$00,$10,$B8,$33,$00,$18,$B8,$34,$00,$20,$B8,$35,$00 ; B1A8
        .byte $28,$B8,$36,$00,$30,$B8,$37,$00,$38,$FF ; B1B8
dat_B1C2:
        .byte $40,$00,$00,$60,$40,$01,$00,$68,$40,$02,$00,$70,$40,$03,$00,$78 ; B1C2
        .byte $40,$04,$00,$88,$40,$05,$00,$90,$40,$05,$00,$98 ; B1D2
dat_B1DE:
        .byte $80,$06,$00,$60,$80,$01,$00,$68,$80,$02,$00,$70,$80,$03,$00,$78 ; B1DE
        .byte $80,$04,$00,$88,$80,$05,$00,$90,$80,$05,$00,$98 ; B1EE
dat_B1FA:
        .byte $7E,$63,$63,$63,$7E,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1FA
        .byte $7E,$63,$63,$67,$7C,$6E,$67,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B20A
        .byte $1C,$36,$63,$63,$7F,$63,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B21A
        .byte $63,$77,$7F,$7F,$6B,$63,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B22A
        .byte $3F,$30,$30,$3E,$30,$30,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B23A
        .byte $7E,$63,$63,$67,$7C,$6E,$67,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B24A
        .byte $63,$63,$63,$77,$3E,$1C,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B25A
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B26A
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B27A
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B28A
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B29A
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B2AA
        .byte $00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2BA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2CA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2EA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2FA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B30A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B31A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B32A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B33A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B34A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B35A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B36A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B37A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B38A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B39A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B3AA
        .byte $FF,$FF,$FF,$FF,$FF,$FF ; B3BA
dat_B3C0:
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$F0,$F0,$70,$50,$F0,$F0,$F0 ; B3C0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA,$55,$00,$FF,$AA,$55,$00 ; B3D0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B3E0
        .byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; B3F0
draw_attr_and_grid:
        sta  PPU_CTRL                   ; B400
        ldy  #$00                       ; B403
        lda  #$23                       ; B405
        sta  PPU_ADDR                   ; B407
        lda  #$C0                       ; B40A
        sta  PPU_ADDR                   ; B40C
loc_B40F:
        lda  dat_B3C0,y                 ; B40F
        sta  PPU_DATA                   ; B412
        iny                             ; B415
        cpy  #$40                       ; B416
        bne  loc_B40F                   ; B418
        ldx  #$04                       ; B41A
        lda  #$21                       ; B41C
        sta  PPU_ADDR                   ; B41E
        lda  #$A0                       ; B421
        sta  PPU_ADDR                   ; B423
        ldy  #$60                       ; B426
loc_B428:
        sty  PPU_DATA                   ; B428
        sty  PPU_DATA                   ; B42B
        sty  PPU_DATA                   ; B42E
        sty  PPU_DATA                   ; B431
        iny                             ; B434
        cpy  #$70                       ; B435
        bne  loc_B428                   ; B437
        ldy  #$21                       ; B439
        sty  PPU_ADDR                   ; B43B
        lda  #$9F                       ; B43E
        sta  PPU_ADDR                   ; B440
        ldx  #$30                       ; B443
        stx  PPU_DATA                   ; B445
        sty  PPU_ADDR                   ; B448
        lda  #$BF                       ; B44B
        sta  PPU_ADDR                   ; B44D
        stx  PPU_DATA                   ; B450
        sty  PPU_ADDR                   ; B453
        lda  #$DF                       ; B456
        sta  PPU_ADDR                   ; B458
        stx  PPU_DATA                   ; B45B
        sty  PPU_ADDR                   ; B45E
        lda  #$FF                       ; B461
        sta  PPU_ADDR                   ; B463
        stx  PPU_DATA                   ; B466
        rts                             ; B469
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B46A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B47A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B48A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B49A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4AA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4BA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4CA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$A9,$FF,$85,$24,$4C,$D8,$A0,$FF,$FF,$FF ; B4EA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4FA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B50A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B51A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B52A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B53A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B54A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B55A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B56A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B57A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B58A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B59A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5AA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5BA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5CA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5EA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5FA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B60A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B61A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B62A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B63A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B64A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B65A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B66A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B67A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B68A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B69A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6AA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6BA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6CA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6EA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B6FA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B70A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B71A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B72A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B73A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B74A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B75A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B76A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B77A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B78A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B79A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B7AA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B7BA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B7CA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B7DA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B7EA
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$58,$AD,$80,$06,$C9,$57,$F0,$20 ; B7FA
testapp_install_nmi_cold:
        lda  #$4C                       ; B808
        sta  nmi_jmp_06A0               ; B80A
        lda  #$00                       ; B80D
        sta  nmi_jmp_06A1               ; B80F
        lda  #$A2                       ; B812
        sta  nmi_jmp_06A2               ; B814
        lda  #$57                       ; B817
        sta  warm_marker                ; B819
        sei                             ; B81C
        jsr  wait_vblank_ppu_off        ; B81D
        lda  #$80                       ; B820
        sta  $D0                        ; B822
        jmp  testapp_main               ; B824
        .byte $FF ; B827
testapp_warm_reset_to_langsel:
        ; static (not seen in traces)
        lda  #$4C                       ; B828
        sta  nmi_jmp_06A0               ; B82A
        lda  #$32                       ; B82D
        sta  nmi_jmp_06A1               ; B82F
        lda  #$E5                       ; B832
        sta  nmi_jmp_06A2               ; B834
        lda  #$00                       ; B837
        sta  warm_marker                ; B839
        sei                             ; B83C
        jsr  wait_vblank_ppu_off        ; B83D
        jmp  langsel_entry              ; B840
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B843
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B853
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B863
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B873
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B883
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B893
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8A3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8B3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8C3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8D3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8E3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B8F3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B903
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B913
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B923
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B933
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B943
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B953
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B963
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B973
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B983
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B993
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9A3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9B3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9C3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9D3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9E3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9F3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA03
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA13
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA23
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA33
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA43
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA53
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA63
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA73
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA83
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA93
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAA3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAB3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAC3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAD3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAE3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAF3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB03
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB13
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB23
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB33
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB43
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB53
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB63
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF ; BB73
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB83
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB93
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBA3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBB3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBC3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBD3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBE3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBF3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC03
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC13
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC23
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC33
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC43
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC53
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC63
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC73
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC83
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC93
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCA3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCB3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCC3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCD3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCE3
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCF3
wait_vblank_ppu_off:
        lda  PPU_STATUS                 ; BD00
        bpl  wait_vblank_ppu_off        ; BD03
        lda  #$00                       ; BD05
        sta  PPU_CTRL                   ; BD07
        sta  PPU_MASK                   ; BD0A
        rts                             ; BD0D
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD0E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD1E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD2E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD3E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD4E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD5E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD6E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD7E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD8E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD9E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDAE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDBE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDCE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDDE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDEE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDFE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE0E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE1E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE2E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE3E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE4E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE5E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE6E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE7E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE8E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE9E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEAE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEBE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BECE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEDE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEEE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEFE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF0E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF1E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF2E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF3E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF4E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF5E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF6E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF7E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF8E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF9E
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFAE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFBE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFCE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFDE
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$E2,$00,$E0 ; BFEE
        .byte $FF,$AA ; BFFE
