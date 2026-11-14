; Sup 400-in-1 English menu, 8 KiB PRG bank $3F (file 0x7E000), mapped at CPU $E000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK3F"

        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E000
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E010
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E020
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E030
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E040
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E050
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E060
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E070
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E080
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E090
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0A0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0B0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0C0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0D0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0E0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0F0
draw_nametable_0:
        ldx  #$00                       ; E100
        jsr  sub_E1B9                   ; E102
        rts                             ; E105
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E106
dat_E110:
        .byte $40 ; E110
dat_E111:
        .byte $E1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E111
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; E121
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80 ; E131
        .byte $E2,$0F,$01,$1B,$20,$0F,$05,$16,$27,$0F,$20,$16,$2C,$0F,$13,$20 ; E141
        .byte $30,$0F,$25,$30,$30,$0E,$25,$30,$30,$00,$00,$00,$00,$00,$00,$00 ; E151
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; E161
unpack_nametable_rle:
        asl  a                          ; E169
        asl  a                          ; E16A
        clc                             ; E16B
        adc  #$20                       ; E16C
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
sub_E1B9:
        ldy  #$00                       ; E1B9
        sty  PPU_CTRL                   ; E1BB
        sty  PPU_MASK                   ; E1BE
        ldy  #$00                       ; E1C1
        tya                             ; E1C3
        pha                             ; E1C4
        lda  dat_E110,x                 ; E1C5
        sta  $08                        ; E1C8
        lda  dat_E111,x                 ; E1CA
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
        jsr  sub_E1FD                   ; E1E0
        ldy  #$00                       ; E1E3
        lda  ($08),y                    ; E1E5
        pha                             ; E1E7
        iny                             ; E1E8
        lda  ($08),y                    ; E1E9
        sta  $09                        ; E1EB
        pla                             ; E1ED
        sta  $08                        ; E1EE
        pla                             ; E1F0
        jsr  unpack_nametable_rle       ; E1F1
        rts                             ; E1F4
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; E1F5
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
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF ; E211
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E221
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E231
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E241
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E251
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E261
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA ; E271
        .byte $00,$0D,$82,$83,$84,$85,$86,$87,$00,$88,$89,$8A,$8B,$8C,$8D,$93 ; E281
        .byte $00,$0D,$8E,$8F,$90,$91,$92,$93,$00,$94,$95,$96,$97,$00,$98,$FF ; E291
        .byte $00,$FF,$00,$FF,$00,$EC,$00,$06,$41,$42,$44,$00,$41,$42,$9A,$00 ; E2A1
        .byte $04,$43,$41,$42,$41,$9C,$00,$82,$42,$05,$45,$46,$49,$00,$44,$99 ; E2B1
        .byte $00,$82,$42,$02,$47,$48,$82,$00,$02,$42,$41,$99,$00,$06,$43,$4B ; E2C1
        .byte $4C,$4F,$50,$44,$99,$00,$08,$4A,$44,$4D,$4E,$51,$52,$42,$41,$98 ; E2D1
        .byte $00,$82,$42,$06,$44,$00,$43,$42,$41,$42,$83,$00,$01,$57,$84,$00 ; E2E1
        .byte $02,$5B,$5C,$8C,$00,$02,$54,$00,$83,$42,$06,$41,$42,$44,$00,$41 ; E2F1
        .byte $42,$84,$00,$04,$58,$59,$5A,$5D,$8B,$00,$03,$53,$55,$56,$85,$00 ; E301
        .byte $03,$41,$42,$41,$82,$00,$02,$42,$44,$82,$00,$04,$65,$67,$68,$6B ; E311
        .byte $85,$00,$02,$41,$42,$82,$00,$05,$41,$42,$5E,$61,$62,$85,$00,$02 ; E321
        .byte $43,$41,$82,$00,$83,$42,$07,$41,$00,$66,$69,$6A,$6C,$57,$84,$00 ; E331
        .byte $02,$43,$41,$82,$00,$05,$43,$5F,$60,$63,$64,$84,$00,$03,$43,$41 ; E341
        .byte $42,$87,$00,$04,$6D,$6F,$70,$71,$84,$00,$01,$43,$84,$00,$04,$43 ; E351
        .byte $42,$43,$42,$84,$00,$02,$4A,$44,$88,$00,$02,$6E,$57,$86,$00,$02 ; E361
        .byte $4A,$44,$84,$00,$04,$42,$44,$42,$44,$84,$00,$01,$88,$83,$AA,$01 ; E371
        .byte $22,$A1,$00,$02,$54,$11,$8C,$00,$02,$C0,$FF,$88,$00,$00,$11,$85 ; E381
        .byte $00,$01,$F0,$87,$00,$01,$0F,$88,$00,$00,$9F,$A0,$00,$A1,$A2,$A3 ; E391
        .byte $A2,$A4,$A5,$A6,$00,$A7,$A8,$A9,$00,$AA,$00,$A4,$A5,$AB,$AC,$A7 ; E3A1
        .byte $A8,$87,$00,$19,$AD,$AE,$AF,$B0,$00,$B1,$B2,$B3,$B4,$B5,$B6,$B7 ; E3B1
        .byte $00,$B8,$B9,$BA,$BB,$BC,$00,$B5,$B6,$BD,$BE,$B8,$B9,$87,$00,$04 ; E3C1
        .byte $BF,$C0,$C1,$C2,$95,$00,$02,$C3,$C4,$84,$00,$05,$C5,$C6,$C7,$C8 ; E3D1
        .byte $C9,$94,$00,$03,$CA,$CB,$CC,$83,$00,$07,$CD,$CE,$CF,$D0,$D1,$D2 ; E3E1
        .byte $D3,$8B,$00,$0B,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$82 ; E3F1
        .byte $00,$08,$DF,$E0,$E1,$E2,$E3,$E4,$E5,$E6,$8B,$00,$0E,$E7,$E8,$E9 ; E401
        .byte $EA,$EB,$EC,$ED,$EE,$DC,$DD,$DE,$00,$55,$5D,$84,$FF,$B2,$55,$88 ; E411
        .byte $05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF ; E421
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E431
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E441
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E451
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E461
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E471
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E481
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E491
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4A1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4B1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4C1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4D1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4E1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E4F1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E501
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E511
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E521
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E531
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E541
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E551
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E561
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E571
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E581
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E591
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5A1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5B1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5C1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5D1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5E1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E5F1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E601
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E611
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E621
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E631
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E641
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E651
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E661
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E671
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E681
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E691
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6A1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6B1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6C1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6D1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6E1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E6F1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E701
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E711
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E721
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E731
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E741
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E751
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E761
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E771
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E781
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E791
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E7A1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E7B1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E7C1
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E7D1
reset_vector_jmpchain:
        jmp  loc_E7E3                   ; E7E0
loc_E7E3:
        jmp  loc_E7E6                   ; E7E3
loc_E7E6:
        jmp  loc_E7E9                   ; E7E6
loc_E7E9:
        jmp  reset_jmpchain_2           ; E7E9
        .byte $00,$00,$00,$00,$FF ; E7EC
tbl_game_records:
        .word game_rec_000 ; E7F1
        .word game_rec_001 ; E7F3
        .word game_rec_002 ; E7F5
        .word game_rec_003 ; E7F7
        .word game_rec_004 ; E7F9
        .word game_rec_005 ; E7FB
        .word game_rec_006 ; E7FD
        .word game_rec_007 ; E7FF
        .word game_rec_008 ; E801
        .word game_rec_009 ; E803
        .word game_rec_010 ; E805
        .word game_rec_011 ; E807
        .word game_rec_012 ; E809
        .word game_rec_013 ; E80B
        .word game_rec_014 ; E80D
        .word game_rec_015 ; E80F
        .word game_rec_016 ; E811
        .word game_rec_017 ; E813
        .word game_rec_018 ; E815
        .word game_rec_019 ; E817
        .word game_rec_020 ; E819
        .word game_rec_021 ; E81B
        .word game_rec_022 ; E81D
        .word game_rec_023 ; E81F
        .word game_rec_024 ; E821
        .word game_rec_025 ; E823
        .word game_rec_026 ; E825
        .word game_rec_027 ; E827
        .word game_rec_028 ; E829
        .word game_rec_029 ; E82B
        .word game_rec_030 ; E82D
        .word game_rec_031 ; E82F
        .word game_rec_032 ; E831
        .word game_rec_033 ; E833
        .word game_rec_034 ; E835
        .word game_rec_035 ; E837
        .word game_rec_036 ; E839
        .word game_rec_037 ; E83B
        .word game_rec_038 ; E83D
        .word game_rec_039 ; E83F
        .word game_rec_040 ; E841
        .word game_rec_041 ; E843
        .word game_rec_042 ; E845
        .word game_rec_043 ; E847
        .word game_rec_044 ; E849
        .word game_rec_045 ; E84B
        .word game_rec_046 ; E84D
        .word game_rec_047 ; E84F
        .word game_rec_048 ; E851
        .word game_rec_049 ; E853
        .word game_rec_050 ; E855
        .word game_rec_051 ; E857
        .word game_rec_052 ; E859
        .word game_rec_053 ; E85B
        .word game_rec_054 ; E85D
        .word game_rec_055 ; E85F
        .word game_rec_056 ; E861
        .word game_rec_057 ; E863
        .word game_rec_058 ; E865
        .word game_rec_059 ; E867
        .word game_rec_060 ; E869
        .word game_rec_061 ; E86B
        .word game_rec_062 ; E86D
        .word game_rec_063 ; E86F
        .word game_rec_064 ; E871
        .word game_rec_065 ; E873
        .word game_rec_066 ; E875
        .word game_rec_067 ; E877
        .word game_rec_068 ; E879
        .word game_rec_069 ; E87B
        .word game_rec_070 ; E87D
        .word game_rec_071 ; E87F
        .word game_rec_072 ; E881
        .word game_rec_073 ; E883
        .word game_rec_074 ; E885
        .word game_rec_075 ; E887
        .word game_rec_076 ; E889
        .word game_rec_077 ; E88B
        .word game_rec_078 ; E88D
        .word game_rec_079 ; E88F
        .word game_rec_080 ; E891
        .word game_rec_081 ; E893
        .word game_rec_082 ; E895
        .word game_rec_083 ; E897
        .word game_rec_084 ; E899
        .word game_rec_085 ; E89B
        .word game_rec_086 ; E89D
        .word game_rec_087 ; E89F
        .word game_rec_088 ; E8A1
        .word game_rec_089 ; E8A3
        .word game_rec_090 ; E8A5
        .word game_rec_091 ; E8A7
        .word game_rec_092 ; E8A9
        .word game_rec_093 ; E8AB
        .word game_rec_094 ; E8AD
        .word game_rec_095 ; E8AF
        .word game_rec_096 ; E8B1
        .word game_rec_097 ; E8B3
        .word game_rec_098 ; E8B5
        .word game_rec_099 ; E8B7
        .word game_rec_100 ; E8B9
        .word game_rec_101 ; E8BB
        .word game_rec_102 ; E8BD
        .word game_rec_103 ; E8BF
        .word game_rec_104 ; E8C1
        .word game_rec_105 ; E8C3
        .word game_rec_106 ; E8C5
        .word game_rec_107 ; E8C7
        .word game_rec_108 ; E8C9
        .word game_rec_109 ; E8CB
        .word game_rec_110 ; E8CD
        .word game_rec_111 ; E8CF
        .word game_rec_112 ; E8D1
        .word game_rec_113 ; E8D3
        .word game_rec_114 ; E8D5
        .word game_rec_115 ; E8D7
        .word game_rec_116 ; E8D9
        .word game_rec_117 ; E8DB
        .word game_rec_118 ; E8DD
        .word game_rec_119 ; E8DF
        .word game_rec_120 ; E8E1
        .word game_rec_121 ; E8E3
        .word game_rec_122 ; E8E5
        .word game_rec_123 ; E8E7
        .word game_rec_124 ; E8E9
        .word game_rec_125 ; E8EB
        .word game_rec_126 ; E8ED
        .word game_rec_127 ; E8EF
        .word game_rec_128 ; E8F1
        .word game_rec_129 ; E8F3
        .word game_rec_130 ; E8F5
        .word game_rec_131 ; E8F7
        .word game_rec_132 ; E8F9
        .word game_rec_133 ; E8FB
        .word game_rec_134 ; E8FD
        .word game_rec_135 ; E8FF
        .word game_rec_136 ; E901
        .word game_rec_137 ; E903
        .word game_rec_138 ; E905
        .word game_rec_139 ; E907
        .word game_rec_140 ; E909
        .word game_rec_141 ; E90B
        .word game_rec_142 ; E90D
        .word game_rec_143 ; E90F
        .word game_rec_144 ; E911
        .word game_rec_145 ; E913
        .word game_rec_146 ; E915
        .word game_rec_147 ; E917
        .word game_rec_148 ; E919
        .word game_rec_149 ; E91B
        .word game_rec_150 ; E91D
        .word game_rec_151 ; E91F
        .word game_rec_152 ; E921
        .word game_rec_153 ; E923
        .word game_rec_154 ; E925
        .word game_rec_155 ; E927
        .word game_rec_156 ; E929
        .word game_rec_157 ; E92B
        .word game_rec_158 ; E92D
        .word game_rec_159 ; E92F
        .word game_rec_160 ; E931
        .word game_rec_161 ; E933
        .word game_rec_162 ; E935
        .word game_rec_163 ; E937
        .word game_rec_164 ; E939
        .word game_rec_165 ; E93B
        .word game_rec_166 ; E93D
        .word game_rec_167 ; E93F
        .word game_rec_168 ; E941
        .word game_rec_169 ; E943
        .word game_rec_170 ; E945
        .word game_rec_171 ; E947
        .word game_rec_172 ; E949
        .word game_rec_173 ; E94B
        .word game_rec_174 ; E94D
        .word game_rec_175 ; E94F
        .word game_rec_176 ; E951
        .word game_rec_177 ; E953
        .word game_rec_178 ; E955
        .word game_rec_179 ; E957
        .word game_rec_180 ; E959
        .word game_rec_181 ; E95B
        .word game_rec_182 ; E95D
        .word game_rec_183 ; E95F
        .word game_rec_184 ; E961
        .word game_rec_185 ; E963
        .word game_rec_186 ; E965
        .word game_rec_187 ; E967
        .word game_rec_188 ; E969
        .word game_rec_189 ; E96B
        .word game_rec_190 ; E96D
        .word game_rec_191 ; E96F
        .word game_rec_192 ; E971
        .word game_rec_193 ; E973
        .word game_rec_194 ; E975
        .word game_rec_195 ; E977
        .word game_rec_196 ; E979
        .word game_rec_197 ; E97B
        .word game_rec_198 ; E97D
        .word game_rec_199 ; E97F
        .word game_rec_200 ; E981
        .word game_rec_201 ; E983
        .word game_rec_202 ; E985
        .word game_rec_203 ; E987
        .word game_rec_204 ; E989
        .word game_rec_205 ; E98B
        .word game_rec_206 ; E98D
        .word game_rec_207 ; E98F
        .word game_rec_208 ; E991
        .word game_rec_209 ; E993
        .word game_rec_210 ; E995
        .word game_rec_211 ; E997
        .word game_rec_212 ; E999
        .word game_rec_213 ; E99B
        .word game_rec_214 ; E99D
        .word game_rec_215 ; E99F
        .word game_rec_216 ; E9A1
        .word game_rec_217 ; E9A3
        .word game_rec_218 ; E9A5
        .word game_rec_219 ; E9A7
        .word game_rec_220 ; E9A9
        .word game_rec_221 ; E9AB
        .word game_rec_222 ; E9AD
        .word game_rec_223 ; E9AF
        .word game_rec_224 ; E9B1
        .word game_rec_225 ; E9B3
        .word game_rec_226 ; E9B5
        .word game_rec_227 ; E9B7
        .word game_rec_228 ; E9B9
        .word game_rec_229 ; E9BB
        .word game_rec_230 ; E9BD
        .word game_rec_231 ; E9BF
        .word game_rec_232 ; E9C1
        .word game_rec_233 ; E9C3
        .word game_rec_234 ; E9C5
        .word game_rec_235 ; E9C7
        .word game_rec_236 ; E9C9
        .word game_rec_237 ; E9CB
        .word game_rec_238 ; E9CD
        .word game_rec_239 ; E9CF
        .word game_rec_240 ; E9D1
        .word game_rec_241 ; E9D3
        .word game_rec_242 ; E9D5
        .word game_rec_243 ; E9D7
        .word game_rec_244 ; E9D9
        .word game_rec_245 ; E9DB
        .word game_rec_246 ; E9DD
        .word game_rec_247 ; E9DF
        .word game_rec_248 ; E9E1
        .word game_rec_249 ; E9E3
        .word game_rec_250 ; E9E5
        .word game_rec_251 ; E9E7
        .word game_rec_252 ; E9E9
        .word game_rec_253 ; E9EB
        .word game_rec_254 ; E9ED
        .word game_rec_255 ; E9EF
        .word game_rec_256 ; E9F1
        .word game_rec_257 ; E9F3
        .word game_rec_258 ; E9F5
        .word game_rec_259 ; E9F7
        .word game_rec_260 ; E9F9
        .word game_rec_261 ; E9FB
        .word game_rec_262 ; E9FD
        .word game_rec_263 ; E9FF
        .word game_rec_264 ; EA01
        .word game_rec_265 ; EA03
        .word game_rec_266 ; EA05
        .word game_rec_267 ; EA07
        .word game_rec_268 ; EA09
        .word game_rec_269 ; EA0B
        .word game_rec_270 ; EA0D
        .word game_rec_271 ; EA0F
        .word game_rec_272 ; EA11
        .word game_rec_273 ; EA13
        .word game_rec_274 ; EA15
        .word game_rec_275 ; EA17
        .word game_rec_276 ; EA19
        .word game_rec_277 ; EA1B
        .word game_rec_278 ; EA1D
        .word game_rec_279 ; EA1F
        .word game_rec_280 ; EA21
        .word game_rec_281 ; EA23
        .word game_rec_282 ; EA25
        .word game_rec_283 ; EA27
        .word game_rec_284 ; EA29
        .word game_rec_285 ; EA2B
        .word game_rec_286 ; EA2D
        .word game_rec_287 ; EA2F
        .word game_rec_288 ; EA31
        .word game_rec_289 ; EA33
        .word game_rec_290 ; EA35
        .word game_rec_291 ; EA37
        .word game_rec_292 ; EA39
        .word game_rec_293 ; EA3B
        .word game_rec_294 ; EA3D
        .word game_rec_295 ; EA3F
        .word game_rec_296 ; EA41
        .word game_rec_297 ; EA43
        .word game_rec_298 ; EA45
        .word game_rec_299 ; EA47
        .word game_rec_300 ; EA49
        .word game_rec_301 ; EA4B
        .word game_rec_302 ; EA4D
        .word game_rec_303 ; EA4F
        .word game_rec_304 ; EA51
        .word game_rec_305 ; EA53
        .word game_rec_306 ; EA55
        .word game_rec_307 ; EA57
        .word game_rec_308 ; EA59
        .word game_rec_309 ; EA5B
        .word game_rec_310 ; EA5D
        .word game_rec_311 ; EA5F
        .word game_rec_312 ; EA61
        .word game_rec_313 ; EA63
        .word game_rec_314 ; EA65
        .word game_rec_315 ; EA67
        .word game_rec_316 ; EA69
        .word game_rec_317 ; EA6B
        .word game_rec_318 ; EA6D
        .word game_rec_319 ; EA6F
        .word game_rec_320 ; EA71
        .word game_rec_321 ; EA73
        .word game_rec_322 ; EA75
        .word game_rec_323 ; EA77
        .word game_rec_324 ; EA79
        .word game_rec_325 ; EA7B
        .word game_rec_326 ; EA7D
        .word game_rec_327 ; EA7F
        .word game_rec_328 ; EA81
        .word game_rec_329 ; EA83
        .word game_rec_330 ; EA85
        .word game_rec_331 ; EA87
        .word game_rec_332 ; EA89
        .word game_rec_333 ; EA8B
        .word game_rec_334 ; EA8D
        .word game_rec_335 ; EA8F
        .word game_rec_336 ; EA91
        .word game_rec_337 ; EA93
        .word game_rec_338 ; EA95
        .word game_rec_339 ; EA97
        .word game_rec_340 ; EA99
        .word game_rec_341 ; EA9B
        .word game_rec_342 ; EA9D
        .word game_rec_343 ; EA9F
        .word game_rec_344 ; EAA1
        .word game_rec_345 ; EAA3
        .word game_rec_346 ; EAA5
        .word game_rec_347 ; EAA7
        .word game_rec_348 ; EAA9
        .word game_rec_349 ; EAAB
        .word game_rec_350 ; EAAD
        .word game_rec_351 ; EAAF
        .word game_rec_352 ; EAB1
        .word game_rec_353 ; EAB3
        .word game_rec_354 ; EAB5
        .word game_rec_355 ; EAB7
        .word game_rec_356 ; EAB9
        .word game_rec_357 ; EABB
        .word game_rec_358 ; EABD
        .word game_rec_359 ; EABF
        .word game_rec_360 ; EAC1
        .word game_rec_361 ; EAC3
        .word game_rec_362 ; EAC5
        .word game_rec_363 ; EAC7
        .word game_rec_364 ; EAC9
        .word game_rec_365 ; EACB
        .word game_rec_366 ; EACD
        .word game_rec_367 ; EACF
        .word game_rec_368 ; EAD1
        .word game_rec_369 ; EAD3
        .word game_rec_370 ; EAD5
        .word game_rec_371 ; EAD7
        .word game_rec_372 ; EAD9
        .word game_rec_373 ; EADB
        .word game_rec_374 ; EADD
        .word game_rec_375 ; EADF
        .word game_rec_376 ; EAE1
        .word game_rec_377 ; EAE3
        .word game_rec_378 ; EAE5
        .word game_rec_379 ; EAE7
        .word game_rec_380 ; EAE9
        .word game_rec_381 ; EAEB
        .word game_rec_382 ; EAED
        .word game_rec_383 ; EAEF
        .word game_rec_384 ; EAF1
        .word game_rec_385 ; EAF3
        .word game_rec_386 ; EAF5
        .word game_rec_387 ; EAF7
        .word game_rec_388 ; EAF9
        .word game_rec_389 ; EAFB
        .word game_rec_390 ; EAFD
        .word game_rec_391 ; EAFF
        .word game_rec_392 ; EB01
        .word game_rec_393 ; EB03
        .word game_rec_394 ; EB05
        .word game_rec_395 ; EB07
        .word game_rec_396 ; EB09
        .word game_rec_397 ; EB0B
        .word game_rec_398 ; EB0D
        .word game_rec_399 ; EB0F
game_rec_000:
        .byte $4C,$00,$F6,$12,$00,$00,$3C,$09,$00 ; EB11  SUPER MARIO
game_rec_001:
        .byte $4C,$3D,$C2,$12,$08,$00,$3C,$09,$00 ; EB1A  MARIO 14
game_rec_002:
        .byte $4C,$08,$C0,$12,$10,$00,$3C,$09,$00 ; EB23  MARIO 3
game_rec_003:
        .byte $4C,$00,$FC,$73,$18,$00,$3C,$09,$00 ; EB2C  DR MARIO
game_rec_004:
        .byte $4C,$06,$C0,$73,$19,$00,$3D,$09,$00 ; EB35  MARIO BROS
game_rec_005:
        .byte $4C,$D0,$FD,$73,$1A,$00,$3E,$09,$00 ; EB3E  TURTLES 1
game_rec_006:
        .byte $4C,$65,$F2,$73,$1B,$00,$3F,$09,$00 ; EB47  TURTLES 4
game_rec_007:
        .byte $4C,$A1,$FD,$01,$20,$00,$40,$09,$01 ; EB50  CONTRA 1
game_rec_008:
        .byte $4C,$A8,$F7,$01,$30,$00,$60,$09,$01 ; EB59  CONTRA FORC
game_rec_009:
        .byte $4C,$AE,$FF,$11,$40,$00,$80,$09,$00 ; EB62  CONTRA 7
game_rec_010:
        .byte $4C,$F0,$FF,$11,$50,$00,$90,$09,$00 ; EB6B  KAGE
game_rec_011:
        .byte $4C,$0A,$E7,$12,$60,$00,$A0,$09,$00 ; EB74  JACKAL
game_rec_012:
        .byte $4C,$D8,$FF,$12,$68,$00,$A0,$09,$00 ; EB7D  RUSH'N ATTACK
game_rec_013:
        .byte $4C,$74,$F1,$12,$70,$00,$B0,$09,$00 ; EB86  ADVENTURE ISLAND
game_rec_014:
        .byte $4C,$C3,$FF,$12,$78,$00,$C0,$09,$00 ; EB8F  ADVEN ISLAND 2
game_rec_015:
        .byte $4C,$2B,$FD,$12,$80,$00,$D0,$09,$01 ; EB98  CHIP DALE 1
game_rec_016:
        .byte $4C,$2B,$FD,$12,$88,$00,$E0,$09,$00 ; EBA1  CHIP DALE 3
game_rec_017:
        .byte $4C,$80,$E0,$12,$90,$00,$F0,$09,$00 ; EBAA  BUBBLE BOBBLE 2
game_rec_018:
        .byte $4C,$80,$E0,$12,$98,$00,$00,$0A,$00 ; EBB3  SNOW BROS
game_rec_019:
        .byte $4C,$00,$E0,$12,$A0,$00,$10,$0A,$01 ; EBBC  MITSUME
game_rec_020:
        .byte $4C,$D0,$FF,$12,$A8,$00,$20,$0A,$01 ; EBC5  NINJA GAIDEN 2
game_rec_021:
        .byte $4C,$B7,$FD,$12,$B0,$00,$30,$0A,$01 ; EBCE  DOUBLE DRAGON 2
game_rec_022:
        .byte $4C,$D3,$FD,$12,$B8,$00,$40,$0A,$01 ; EBD7  DOUBLE DRAGON 3
game_rec_023:
        .byte $4C,$80,$FF,$12,$C0,$00,$50,$0A,$01 ; EBE0  HOT HIGH SCHOOL
game_rec_024:
        .byte $4C,$62,$FB,$12,$C8,$00,$60,$0A,$01 ; EBE9  HOT WRESTLE
game_rec_025:
        .byte $4C,$E0,$FF,$12,$D0,$00,$70,$0A,$01 ; EBF2  ROBOCOP
game_rec_026:
        .byte $4C,$8D,$FE,$12,$D8,$00,$80,$0A,$01 ; EBFB  MORTAL KOMBAT 4
game_rec_027:
        .byte $4C,$75,$FF,$12,$E0,$00,$90,$0A,$01 ; EC04  SPIDER MAN
game_rec_028:
        .byte $4C,$84,$FF,$12,$E8,$00,$A0,$0A,$00 ; EC0D  10 YARD FIGHT
game_rec_029:
        .byte $4C,$00,$FF,$12,$F0,$00,$B0,$0A,$01 ; EC16  90 TANK
game_rec_030:
        .byte $4C,$00,$FF,$12,$F8,$00,$C0,$0A,$01 ; EC1F  KAGE LEGEND
game_rec_031:
        .byte $4C,$68,$F7,$12,$00,$01,$D0,$0A,$01 ; EC28  ALADDIN 3
game_rec_032:
        .byte $4C,$F8,$F8,$12,$08,$01,$E0,$0A,$00 ; EC31  ANTARCTIC ADVEN
game_rec_033:
        .byte $4C,$00,$FF,$12,$10,$01,$F0,$0A,$01 ; EC3A  ARABIAN
game_rec_034:
        .byte $4C,$AE,$FF,$12,$18,$01,$00,$0B,$01 ; EC43  BALLOON FIGHT
game_rec_035:
        .byte $4C,$AE,$FF,$12,$20,$01,$10,$0B,$01 ; EC4C  BASE BALL
game_rec_036:
        .byte $4C,$00,$FE,$12,$28,$01,$20,$0B,$00 ; EC55  BINARY LAND
game_rec_037:
        .byte $4C,$E0,$FF,$12,$30,$01,$30,$0B,$01 ; EC5E  BIRD WEEK
game_rec_038:
        .byte $4C,$00,$E0,$12,$38,$01,$40,$0B,$01 ; EC67  BOMBER MAN
game_rec_039:
        .byte $4C,$F4,$FF,$12,$40,$01,$50,$0B,$00 ; EC70  BOMB SWEEPER
game_rec_040:
        .byte $4C,$85,$FF,$12,$48,$01,$60,$0B,$00 ; EC79  BRUSH ROLLER
game_rec_041:
        .byte $4C,$A1,$FF,$12,$50,$01,$70,$0B,$00 ; EC82  BURGER TIME
game_rec_042:
        .byte $4C,$A1,$FF,$12,$58,$01,$80,$0B,$01 ; EC8B  CHACK AND POP
game_rec_043:
        .byte $4C,$80,$FF,$12,$60,$01,$90,$0B,$01 ; EC94  CHESS
game_rec_044:
        .byte $4C,$10,$F0,$12,$68,$01,$A0,$0B,$01 ; EC9D  CIRCUS CHARLIE
game_rec_045:
        .byte $4C,$00,$FE,$12,$70,$01,$B0,$0B,$01 ; ECA6  CLU CLU LAND
game_rec_046:
        .byte $4C,$4B,$F4,$12,$78,$01,$C0,$0B,$00 ; ECAF  COMBAT
game_rec_047:
        .byte $4C,$00,$E8,$12,$80,$01,$D0,$0B,$01 ; ECB8  DEFENDER
game_rec_048:
        .byte $4C,$00,$E0,$12,$88,$01,$E0,$0B,$01 ; ECC1  DEVIL WORLD
game_rec_049:
        .byte $4C,$D0,$F8,$12,$90,$01,$F0,$0B,$01 ; ECCA  DIG DUG 1
game_rec_050:
        .byte $4C,$A0,$FF,$12,$98,$01,$00,$0C,$00 ; ECD3  DONKEY KONG 1
game_rec_051:
        .byte $4C,$D0,$FF,$12,$A0,$01,$10,$0C,$00 ; ECDC  DONKEY KONG 2
game_rec_052:
        .byte $4C,$F6,$FF,$12,$A8,$01,$20,$0C,$00 ; ECE5  DONKEY KONG 3
game_rec_053:
        .byte $4C,$00,$FF,$12,$B0,$01,$30,$0C,$00 ; ECEE  DONKEY KONG JR
game_rec_054:
        .byte $4C,$00,$FE,$12,$B8,$01,$40,$0C,$01 ; ECF7  DOOR DOOR
game_rec_055:
        .byte $4C,$80,$FF,$12,$C0,$01,$50,$0C,$00 ; ED00  EXCITE BIKE
game_rec_056:
        .byte $4C,$00,$E0,$12,$C8,$01,$60,$0C,$00 ; ED09  EXERION
game_rec_057:
        .byte $4C,$16,$C0,$12,$D0,$01,$70,$0C,$00 ; ED12  F1 RACE
game_rec_058:
        .byte $4C,$00,$FE,$12,$D8,$01,$80,$0C,$00 ; ED1B  FORMATION Z
game_rec_059:
        .byte $4C,$86,$F1,$12,$E0,$01,$90,$0C,$01 ; ED24  FRONT LINE
game_rec_060:
        .byte $4C,$A5,$F0,$12,$E8,$01,$A0,$0C,$01 ; ED2D  GALAGA
game_rec_061:
        .byte $4C,$F5,$EF,$12,$F0,$01,$B0,$0C,$00 ; ED36  GALAXIAN
game_rec_062:
        .byte $4C,$D0,$FF,$12,$F8,$01,$C0,$0C,$00 ; ED3F  GOLF
game_rec_063:
        .byte $4C,$00,$FB,$12,$00,$02,$D0,$0C,$01 ; ED48  RAID O BUNGELING
game_rec_064:
        .byte $4C,$B0,$FB,$12,$08,$02,$E0,$0C,$01 ; ED51  HYPER OLYMPIC
game_rec_065:
        .byte $4C,$B1,$FF,$12,$10,$02,$F0,$0C,$01 ; ED5A  HYPER SPORTS
game_rec_066:
        .byte $4C,$00,$F8,$12,$18,$02,$00,$0D,$00 ; ED63  ICE CLIMBER
game_rec_067:
        .byte $4C,$05,$E0,$12,$20,$02,$10,$0D,$00 ; ED6C  JOUST
game_rec_068:
        .byte $4C,$00,$E0,$12,$28,$02,$20,$0D,$00 ; ED75  KARATEKA
game_rec_069:
        .byte $4C,$00,$C0,$12,$30,$02,$30,$0D,$00 ; ED7E  LODE RUNNER
game_rec_070:
        .byte $4C,$01,$FF,$12,$38,$02,$40,$0D,$01 ; ED87  LUNAR BALL
game_rec_071:
        .byte $4C,$DD,$FF,$12,$40,$02,$50,$0D,$00 ; ED90  MACROSS
game_rec_072:
        .byte $4C,$F0,$FF,$12,$48,$02,$60,$0D,$01 ; ED99  MAGIC JEWELRY
game_rec_073:
        .byte $4C,$00,$FF,$12,$50,$02,$70,$0D,$00 ; EDA2  MAHJONG 4P
game_rec_074:
        .byte $4C,$F4,$FF,$12,$58,$02,$80,$0D,$00 ; EDAB  MAHJONG 2p
game_rec_075:
        .byte $4C,$F4,$FF,$12,$60,$02,$90,$0D,$01 ; EDB4  MAPPY
game_rec_076:
        .byte $4C,$F4,$FF,$12,$68,$02,$A0,$0D,$01 ; EDBD  MILK N NUTS
game_rec_077:
        .byte $4C,$F4,$FF,$12,$70,$02,$B0,$0D,$00 ; EDC6  MILLIPEDE
game_rec_078:
        .byte $4C,$61,$FF,$12,$78,$02,$C0,$0D,$01 ; EDCF  MUSICE
game_rec_079:
        .byte $4C,$C2,$F6,$82,$80,$02,$D0,$0D,$00 ; EDD8  NAITOU
game_rec_080:
        .byte $4C,$00,$EC,$82,$88,$02,$D8,$0D,$00 ; EDE1  NIBBLES
game_rec_081:
        .byte $4C,$00,$80,$44,$90,$02,$E0,$0D,$00 ; EDEA  NINJA 1
game_rec_082:
        .byte $4C,$00,$80,$44,$92,$02,$E4,$0D,$01 ; EDF3  NINJA 3
game_rec_083:
        .byte $4C,$33,$80,$44,$94,$02,$E8,$0D,$01 ; EDFC  ROAD FIGHTER
game_rec_084:
        .byte $4C,$12,$F2,$99,$96,$02,$EC,$0D,$00 ; EE05  OTHELLO
game_rec_085:
        .byte $4C,$04,$80,$44,$98,$02,$F0,$0D,$01 ; EE0E  PACMAN
game_rec_086:
        .byte $4C,$D3,$83,$44,$9A,$02,$F4,$0D,$01 ; EE17  PIN BALL
game_rec_087:
        .byte $4C,$25,$82,$44,$9C,$02,$F8,$0D,$00 ; EE20  POOYAN
game_rec_088:
        .byte $4C,$5E,$FD,$99,$9E,$02,$FC,$0D,$01 ; EE29  POPEYE
game_rec_089:
        .byte $4C,$04,$80,$44,$A0,$02,$00,$0E,$01 ; EE32  SKY DESTROYER
game_rec_090:
        .byte $4C,$00,$80,$44,$A2,$02,$04,$0E,$00 ; EE3B  SPACE ET
game_rec_091:
        .byte $4C,$AC,$90,$44,$A4,$02,$08,$0E,$00 ; EE44  STAR FORCE
game_rec_092:
        .byte $4C,$85,$CA,$44,$A6,$02,$0C,$0E,$00 ; EE4D  STAR GATE
game_rec_093:
        .byte $4C,$80,$80,$44,$A8,$02,$10,$0E,$01 ; EE56  TENNIS
game_rec_094:
        .byte $4C,$46,$80,$44,$AA,$02,$14,$0E,$01 ; EE5F  URBAN CHAMPION
game_rec_095:
        .byte $4C,$00,$C0,$44,$AC,$02,$18,$0E,$00 ; EE68  WARPMAN
game_rec_096:
        .byte $4C,$BC,$AE,$44,$AE,$02,$1C,$0E,$00 ; EE71  YIE AR KUNG FU
game_rec_097:
        .byte $4C,$06,$81,$44,$B0,$02,$20,$0E,$00 ; EE7A  ZIPPY RACE
game_rec_098:
        .byte $4C,$04,$80,$44,$B2,$02,$24,$0E,$00 ; EE83  WAREHOUSE BOY
game_rec_099:
        .byte $4C,$03,$80,$44,$B4,$02,$28,$0E,$01 ; EE8C  1942
game_rec_100:
        .byte $4C,$00,$80,$44,$B6,$02,$2C,$0E,$00 ; EE95  ARKANOID
game_rec_101:
        .byte $4C,$00,$80,$44,$B8,$02,$30,$0E,$00 ; EE9E  ASTRO ROBO SASA
game_rec_102:
        .byte $4C,$A7,$B9,$44,$BA,$02,$34,$0E,$00 ; EEA7  B WINGS
game_rec_103:
        .byte $4C,$00,$80,$44,$BC,$02,$38,$0E,$01 ; EEB0  BADMINGTON
game_rec_104:
        .byte $4C,$00,$80,$44,$BE,$02,$3C,$0E,$01 ; EEB9  BALTRON
game_rec_105:
        .byte $4C,$00,$80,$44,$C0,$02,$40,$0E,$00 ; EEC2  BOKOSUKA WARS
game_rec_106:
        .byte $4C,$04,$B1,$44,$C2,$02,$44,$0E,$01 ; EECB  BOMB JACK
game_rec_107:
        .byte $4C,$00,$81,$44,$C4,$02,$48,$0E,$01 ; EED4  PORTER
game_rec_108:
        .byte $4C,$48,$80,$44,$C6,$02,$4C,$0E,$01 ; EEDD  CHUBBY CHERUB
game_rec_109:
        .byte $4C,$01,$80,$44,$C8,$02,$50,$0E,$00 ; EEE6  DESTROY
game_rec_110:
        .byte $4C,$00,$80,$44,$CA,$02,$54,$0E,$01 ; EEEF  DIG DUG 2
game_rec_111:
        .byte $4C,$10,$80,$44,$CC,$02,$58,$0E,$00 ; EEF8  DOUGH BOY
game_rec_112:
        .byte $4C,$04,$9A,$44,$CE,$02,$5C,$0E,$01 ; EF01  DRAGON
game_rec_113:
        .byte $4C,$00,$80,$44,$D0,$02,$60,$0E,$00 ; EF0A  DRUAGA
game_rec_114:
        .byte $4C,$E4,$FD,$44,$D2,$02,$64,$0E,$01 ; EF13  DUCK
game_rec_115:
        .byte $4C,$04,$80,$44,$D4,$02,$68,$0E,$00 ; EF1C  ELEVATOR ACTION
game_rec_116:
        .byte $4C,$10,$80,$44,$D6,$02,$6C,$0E,$00 ; EF25  EXED EXES
game_rec_117:
        .byte $4C,$00,$80,$44,$D8,$02,$70,$0E,$00 ; EF2E  FLAPPY
game_rec_118:
        .byte $4C,$00,$80,$44,$DA,$02,$74,$0E,$00 ; EF37  FRUIT PIG
game_rec_119:
        .byte $4C,$00,$80,$44,$DC,$02,$78,$0E,$00 ; EF40  GALG
game_rec_120:
        .byte $4C,$0C,$80,$44,$DE,$02,$7C,$0E,$00 ; EF49  GEIMOS
game_rec_121:
        .byte $4C,$D0,$FF,$44,$E0,$02,$80,$0E,$00 ; EF52  GYRODINE
game_rec_122:
        .byte $4C,$00,$8C,$44,$E2,$02,$84,$0E,$01 ; EF5B  HEXA
game_rec_123:
        .byte $4C,$00,$FE,$44,$E4,$02,$88,$0E,$00 ; EF64  ICE HOCKEY
game_rec_124:
        .byte $4C,$00,$80,$44,$E6,$02,$8C,$0E,$00 ; EF6D  LOT LOT
game_rec_125:
        .byte $4C,$2A,$F2,$44,$E8,$02,$90,$0E,$00 ; EF76  MAGMAX
game_rec_126:
        .byte $4C,$00,$80,$44,$EA,$02,$94,$0E,$01 ; EF7F  PIKA CHU
game_rec_127:
        .byte $4C,$00,$81,$44,$EC,$02,$98,$0E,$00 ; EF88  NINJA 2
game_rec_128:
        .byte $4C,$00,$80,$44,$EE,$02,$9C,$0E,$00 ; EF91  QBAKE
game_rec_129:
        .byte $4C,$00,$C1,$44,$F0,$02,$A0,$0E,$00 ; EF9A  ONYANKO TOWN
game_rec_130:
        .byte $4C,$00,$80,$44,$F2,$02,$A4,$0E,$01 ; EFA3  PAC LAND
game_rec_131:
        .byte $4C,$87,$FF,$44,$F4,$02,$A8,$0E,$00 ; EFAC  PACHI COM
game_rec_132:
        .byte $4C,$33,$80,$44,$F6,$02,$AC,$0E,$01 ; EFB5  PRO WRESTLING
game_rec_133:
        .byte $4C,$52,$8E,$44,$F8,$02,$B0,$0E,$01 ; EFBE  PYRAMID
game_rec_134:
        .byte $4C,$D3,$A4,$44,$FA,$02,$B4,$0E,$00 ; EFC7  ROUTE-16
game_rec_135:
        .byte $4C,$01,$80,$44,$FC,$02,$B8,$0E,$00 ; EFD0  SEICROSS
game_rec_136:
        .byte $4C,$00,$C0,$44,$FE,$02,$BC,$0E,$00 ; EFD9  SLALOM
game_rec_137:
        .byte $4C,$00,$80,$44,$00,$03,$C0,$0E,$00 ; EFE2  SOCCER
game_rec_138:
        .byte $4C,$00,$80,$44,$02,$03,$C4,$0E,$00 ; EFEB  SONSON
game_rec_139:
        .byte $4C,$00,$80,$44,$04,$03,$C8,$0E,$00 ; EFF4  SPARTAN X
game_rec_140:
        .byte $4C,$0B,$80,$44,$06,$03,$CC,$0E,$00 ; EFFD  SPELUNKER
game_rec_141:
        .byte $4C,$00,$80,$44,$08,$03,$D0,$0E,$00 ; F006  SPY VS SPY
game_rec_142:
        .byte $4C,$00,$80,$44,$0A,$03,$D4,$0E,$00 ; F00F  SQOON
game_rec_143:
        .byte $4C,$80,$80,$44,$0C,$03,$D8,$0E,$01 ; F018  STAR LUSTER
game_rec_144:
        .byte $4C,$3B,$A0,$44,$0E,$03,$DC,$0E,$00 ; F021  TETRIS 2
game_rec_145:
        .byte $4C,$00,$80,$44,$10,$03,$E0,$0E,$01 ; F02A  THEXDER
game_rec_146:
        .byte $4C,$A8,$80,$44,$12,$03,$E4,$0E,$01 ; F033  VOLGUARD II
game_rec_147:
        .byte $4C,$00,$80,$44,$14,$03,$E8,$0E,$00 ; F03C  VOLLEY BALL
game_rec_148:
        .byte $4C,$00,$80,$44,$16,$03,$EC,$0E,$00 ; F045  WARS
game_rec_149:
        .byte $4C,$00,$80,$44,$18,$03,$F0,$0E,$00 ; F04E  XEVIOUS
game_rec_150:
        .byte $4C,$00,$80,$44,$1A,$03,$F4,$0E,$00 ; F057  CHINESE CHESS
game_rec_151:
        .byte $4C,$D7,$82,$44,$1C,$03,$F8,$0E,$00 ; F060  CHALLENG
game_rec_152:
        .byte $4C,$00,$80,$44,$1E,$03,$FC,$0E,$00 ; F069  MACH RIDER
game_rec_153:
        .byte $4C,$00,$80,$44,$20,$03,$00,$0F,$00 ; F072  ARGUS
game_rec_154:
        .byte $4C,$90,$BF,$64,$22,$03,$03,$0F,$01 ; F07B  GOONIES
game_rec_155:
        .byte $4C,$00,$80,$44,$24,$03,$04,$0F,$00 ; F084  SUPER CHINESE
game_rec_156:
        .byte $4C,$D0,$FF,$64,$26,$03,$07,$0F,$00 ; F08D  TWIN BEE
game_rec_157:
        .byte $4C,$00,$FF,$44,$28,$03,$08,$0F,$00 ; F096  STAR SOLDIER
game_rec_158:
        .byte $4C,$64,$FF,$64,$2A,$03,$0B,$0F,$00 ; F09F  TRACK FIELD
game_rec_159:
        .byte $4C,$00,$80,$54,$2C,$03,$0C,$0F,$00 ; F0A8  FRIDAY THE 13
game_rec_160:
        .byte $4C,$00,$80,$54,$2E,$03,$0E,$0F,$00 ; F0B1  ARKISTAS RING
game_rec_161:
        .byte $4C,$01,$80,$54,$30,$03,$10,$0F,$00 ; F0BA  ASO
game_rec_162:
        .byte $4C,$11,$80,$54,$32,$03,$12,$0F,$01 ; F0C3  ALPHA MISSION
game_rec_163:
        .byte $4C,$00,$80,$54,$34,$03,$14,$0F,$01 ; F0CC  BOWLING
game_rec_164:
        .byte $4C,$11,$80,$54,$36,$03,$16,$0F,$00 ; F0D5  FLIPULL
game_rec_165:
        .byte $4C,$00,$80,$64,$38,$03,$18,$0F,$01 ; F0DE  BACK TO FUTURE
game_rec_166:
        .byte $4C,$02,$80,$64,$3A,$03,$19,$0F,$00 ; F0E7  GRADIUS
game_rec_167:
        .byte $4C,$00,$80,$64,$3C,$03,$1A,$0F,$00 ; F0F0  HOKUTO NO KEN
game_rec_168:
        .byte $4C,$00,$80,$64,$3E,$03,$1B,$0F,$00 ; F0F9  KING KNIGHT
game_rec_169:
        .byte $4C,$00,$80,$64,$40,$03,$1C,$0F,$01 ; F102  KICKEY MOUSE
game_rec_170:
        .byte $4C,$00,$80,$64,$42,$03,$1D,$0F,$01 ; F10B  NEW MAN
game_rec_171:
        .byte $4C,$00,$80,$64,$44,$03,$1E,$0F,$00 ; F114  PAPERBOY
game_rec_172:
        .byte $4C,$CD,$9A,$64,$46,$03,$1F,$0F,$01 ; F11D  POWER SOCCER
game_rec_173:
        .byte $4C,$2D,$A5,$64,$48,$03,$20,$0F,$00 ; F126  QUARTH
game_rec_174:
        .byte $4C,$00,$80,$64,$4A,$03,$21,$0F,$00 ; F12F  SOLOMON
game_rec_175:
        .byte $4C,$90,$D8,$64,$4C,$03,$22,$0F,$01 ; F138  SKY HUNTER
game_rec_176:
        .byte $4C,$00,$80,$64,$4E,$03,$23,$0F,$00 ; F141  TIGER HELI
game_rec_177:
        .byte $4C,$9D,$B8,$64,$50,$03,$24,$0F,$01 ; F14A  TRANSFORMERS
game_rec_178:
        .byte $4C,$00,$80,$64,$52,$03,$25,$0F,$01 ; F153  WISDOM
game_rec_179:
        .byte $4C,$00,$80,$64,$54,$03,$26,$0F,$01 ; F15C  MOAI-KUN
game_rec_180:
        .byte $4C,$07,$80,$64,$56,$03,$27,$0F,$01 ; F165  CASTLE EXCELLENT
game_rec_181:
        .byte $4C,$F0,$FF,$64,$58,$03,$28,$0F,$00 ; F16E  BUMP N JUMP
game_rec_182:
        .byte $4C,$00,$80,$64,$5A,$03,$29,$0F,$01 ; F177  ANGRY BIRD
game_rec_183:
        .byte $4C,$D0,$B8,$64,$5C,$03,$2A,$0F,$01 ; F180  AQUARIUM
game_rec_184:
        .byte $4C,$A5,$EF,$64,$5E,$03,$2B,$0F,$00 ; F189  ARENA
game_rec_185:
        .byte $4C,$00,$80,$64,$60,$03,$2C,$0F,$00 ; F192  AIR ALERT
game_rec_186:
        .byte $4C,$00,$80,$64,$62,$03,$2D,$0F,$00 ; F19B  AWFUL RUSHING
game_rec_187:
        .byte $4C,$00,$80,$64,$64,$03,$2E,$0F,$00 ; F1A4  AIMLESS
game_rec_188:
        .byte $4C,$76,$BC,$64,$66,$03,$2F,$0F,$01 ; F1AD  BURBLES
game_rec_189:
        .byte $4C,$2F,$FA,$64,$68,$03,$30,$0F,$01 ; F1B6  BURROW EXPLORER
game_rec_190:
        .byte $4C,$00,$80,$64,$6A,$03,$31,$0F,$00 ; F1BF  BUGS WAR
game_rec_191:
        .byte $4C,$00,$80,$64,$6C,$03,$32,$0F,$00 ; F1C8  BOMB KING
game_rec_192:
        .byte $4C,$00,$80,$64,$6E,$03,$33,$0F,$00 ; F1D1  BASEBALL NEW
game_rec_193:
        .byte $4C,$52,$80,$64,$70,$03,$34,$0F,$00 ; F1DA  BUBBLE
game_rec_194:
        .byte $4C,$E0,$86,$64,$72,$03,$35,$0F,$01 ; F1E3  CABBONADE
game_rec_195:
        .byte $4C,$43,$FD,$64,$74,$03,$36,$0F,$01 ; F1EC  CLOSE QUARTERS
game_rec_196:
        .byte $4C,$00,$C8,$64,$76,$03,$37,$0F,$01 ; F1F5  COAST GUARD
game_rec_197:
        .byte $4C,$00,$80,$64,$78,$03,$38,$0F,$01 ; F1FE  CUB ADVENTURE
game_rec_198:
        .byte $4C,$00,$80,$64,$7A,$03,$39,$0F,$00 ; F207  DEPTH BOMB
game_rec_199:
        .byte $4C,$50,$80,$64,$7C,$03,$3A,$0F,$00 ; F210  DEVILDOM DOOM
game_rec_200:
        .byte $4C,$00,$80,$64,$7E,$03,$3B,$0F,$00 ; F219  DIAMOND
game_rec_201:
        .byte $4C,$00,$80,$64,$80,$03,$3C,$0F,$00 ; F222  DUNE WAR
game_rec_202:
        .byte $4C,$58,$82,$64,$82,$03,$3D,$0F,$01 ; F22B  FIREBASE
game_rec_203:
        .byte $4C,$00,$80,$64,$84,$03,$3E,$0F,$00 ; F234  FIRST DEFENDER
game_rec_204:
        .byte $4C,$00,$80,$64,$86,$03,$3F,$0F,$01 ; F23D  FIVE DAYS
game_rec_205:
        .byte $4C,$41,$80,$64,$88,$03,$40,$0F,$00 ; F246  FRANTIC MOUSE
game_rec_206:
        .byte $4C,$4C,$80,$64,$8A,$03,$41,$0F,$01 ; F24F  FRUIT DISH
game_rec_207:
        .byte $4C,$00,$80,$64,$8C,$03,$42,$0F,$00 ; F258  GALLAGANT
game_rec_208:
        .byte $4C,$11,$A9,$64,$8E,$03,$43,$0F,$00 ; F261  GARDEN WAR
game_rec_209:
        .byte $4C,$E3,$93,$64,$90,$03,$44,$0F,$01 ; F26A  GATE
game_rec_210:
        .byte $4C,$00,$80,$64,$92,$03,$45,$0F,$00 ; F273  HALLIHOO
game_rec_211:
        .byte $4C,$00,$80,$64,$94,$03,$46,$0F,$00 ; F27C  HEXAPOD NEW
game_rec_212:
        .byte $4C,$00,$80,$64,$96,$03,$47,$0F,$00 ; F285  HEXAPOD WAR
game_rec_213:
        .byte $4C,$D9,$FA,$64,$98,$03,$48,$0F,$01 ; F28E  LABYRINTH
game_rec_214:
        .byte $4C,$15,$F8,$64,$9A,$03,$49,$0F,$00 ; F297  LUNARIAN
game_rec_215:
        .byte $4C,$00,$80,$64,$9C,$03,$4A,$0F,$00 ; F2A0  MAD XMAS
game_rec_216:
        .byte $4C,$00,$80,$64,$9E,$03,$4B,$0F,$00 ; F2A9  MOTOBOAT
game_rec_217:
        .byte $4C,$75,$F2,$64,$A0,$03,$4C,$0F,$00 ; F2B2  PANZER ATTACK
game_rec_218:
        .byte $4C,$00,$F0,$64,$A2,$03,$4D,$0F,$00 ; F2BB  PENTA BASE
game_rec_219:
        .byte $4C,$00,$F1,$64,$A4,$03,$4E,$0F,$01 ; F2C4  POBBLE
game_rec_220:
        .byte $4C,$00,$F0,$64,$A6,$03,$4F,$0F,$00 ; F2CD  POLAR BAT
game_rec_221:
        .byte $4C,$00,$F0,$64,$A8,$03,$50,$0F,$00 ; F2D6  RURALGOBLIN
game_rec_222:
        .byte $4C,$D6,$CC,$64,$AA,$03,$51,$0F,$00 ; F2DF  ROBOT
game_rec_223:
        .byte $4C,$00,$F0,$64,$AC,$03,$52,$0F,$00 ; F2E8  SEASON GARDEN
game_rec_224:
        .byte $4C,$0E,$CB,$64,$AE,$03,$53,$0F,$00 ; F2F1  SHREW MOUSE
game_rec_225:
        .byte $4C,$00,$F0,$64,$B0,$03,$54,$0F,$00 ; F2FA  SNOWBALL
game_rec_226:
        .byte $4C,$00,$F0,$64,$B2,$03,$55,$0F,$00 ; F303  STAR FIGHTER
game_rec_227:
        .byte $4C,$00,$F0,$64,$B4,$03,$56,$0F,$00 ; F30C  STRAFE
game_rec_228:
        .byte $4C,$04,$FA,$64,$B6,$03,$57,$0F,$00 ; F315  SMALL DINOSAUR
game_rec_229:
        .byte $4C,$50,$E9,$64,$B8,$03,$58,$0F,$00 ; F31E  SILENT HUNTER
game_rec_230:
        .byte $4C,$CA,$F0,$64,$BA,$03,$59,$0F,$00 ; F327  THE ARCHER
game_rec_231:
        .byte $4C,$00,$FC,$64,$BC,$03,$5A,$0F,$00 ; F330  TWIN CARDS
game_rec_232:
        .byte $4C,$42,$F6,$64,$BE,$03,$5B,$0F,$00 ; F339  UNDERSEA ARENA
game_rec_233:
        .byte $4C,$B0,$E1,$64,$C0,$03,$5C,$0F,$01 ; F342  WARRIOR
game_rec_234:
        .byte $4C,$AB,$CE,$64,$C2,$03,$5D,$0F,$01 ; F34B  ABSCONDEE
game_rec_235:
        .byte $4C,$D3,$FA,$64,$C4,$03,$5E,$0F,$00 ; F354  AETHER CRUISER
game_rec_236:
        .byte $4C,$00,$F0,$64,$C6,$03,$5F,$0F,$01 ; F35D  AIM CRUISE
game_rec_237:
        .byte $4C,$00,$F0,$64,$C8,$03,$60,$0F,$00 ; F366  ANIMAL CONTEST
game_rec_238:
        .byte $4C,$00,$F0,$64,$CA,$03,$61,$0F,$00 ; F36F  BLOCKS WORLD
game_rec_239:
        .byte $4C,$D4,$F8,$64,$CC,$03,$62,$0F,$00 ; F378  BUG CATCHER
game_rec_240:
        .byte $4C,$00,$F0,$64,$CE,$03,$63,$0F,$00 ; F381  BUSY BAR
game_rec_241:
        .byte $4C,$00,$FC,$64,$D0,$03,$64,$0F,$00 ; F38A  CANDY WORKSHOP
game_rec_242:
        .byte $4C,$81,$E7,$64,$D2,$03,$65,$0F,$00 ; F393  CONTEST
game_rec_243:
        .byte $4C,$00,$F0,$64,$D4,$03,$66,$0F,$00 ; F39C  COOKIE LABYRINTH
game_rec_244:
        .byte $4C,$1F,$AB,$64,$D6,$03,$67,$0F,$00 ; F3A5  CRYSTAL BLAST
game_rec_245:
        .byte $4C,$68,$C0,$64,$D8,$03,$68,$0F,$00 ; F3AE  DEFORMABLE
game_rec_246:
        .byte $4C,$1B,$E0,$64,$DA,$03,$69,$0F,$01 ; F3B7  DEJIECTILE
game_rec_247:
        .byte $4C,$00,$F0,$64,$DC,$03,$6A,$0F,$00 ; F3C0  EGG CONTEST
game_rec_248:
        .byte $4C,$00,$F0,$64,$DE,$03,$6B,$0F,$00 ; F3C9  ESCAPEWAY
game_rec_249:
        .byte $4C,$00,$F0,$64,$E0,$03,$6C,$0F,$01 ; F3D2  FAIRS TREASURE
game_rec_250:
        .byte $4C,$34,$DE,$64,$E2,$03,$6D,$0F,$00 ; F3DB  FALLING BLOCKS
game_rec_251:
        .byte $4C,$00,$FA,$64,$E4,$03,$6E,$0F,$01 ; F3E4  FATED PIRATE
game_rec_252:
        .byte $4C,$00,$F0,$64,$E6,$03,$6F,$0F,$01 ; F3ED  FINAL BLOOD
game_rec_253:
        .byte $4C,$B7,$E7,$64,$E8,$03,$70,$0F,$00 ; F3F6  FISH STORY
game_rec_254:
        .byte $4C,$00,$FD,$64,$EA,$03,$71,$0F,$00 ; F3FF  FLING BALL
game_rec_255:
        .byte $4C,$00,$F0,$64,$EC,$03,$72,$0F,$00 ; F408  FOREST ADVENTURE
game_rec_256:
        .byte $4C,$7F,$F6,$64,$EE,$03,$73,$0F,$00 ; F411  FRUIT GIFT
game_rec_257:
        .byte $4C,$00,$80,$64,$F0,$03,$74,$0F,$00 ; F41A  GHOST CASTLE
game_rec_258:
        .byte $4C,$00,$F8,$64,$F2,$03,$75,$0F,$00 ; F423  GOLDEN BIRD
game_rec_259:
        .byte $4C,$00,$FC,$64,$F4,$03,$76,$0F,$00 ; F42C  GREEDS
game_rec_260:
        .byte $4C,$D3,$F4,$64,$F6,$03,$77,$0F,$01 ; F435  HAMMER N NAIL
game_rec_261:
        .byte $4C,$A5,$EB,$64,$F8,$03,$78,$0F,$00 ; F43E  HAPPY MATCH
game_rec_262:
        .byte $4C,$00,$F0,$64,$FA,$03,$79,$0F,$00 ; F447  ICE OCEAN
game_rec_263:
        .byte $4C,$00,$FC,$64,$FC,$03,$7A,$0F,$01 ; F450  IQ CHAMPION
game_rec_264:
        .byte $4C,$00,$F0,$64,$FE,$03,$7B,$0F,$00 ; F459  ISLAND
game_rec_265:
        .byte $4C,$00,$F0,$64,$00,$04,$7C,$0F,$01 ; F462  JUMP JUMP
game_rec_266:
        .byte $4C,$14,$F0,$64,$02,$04,$7D,$0F,$01 ; F46B  JUMPING KID
game_rec_267:
        .byte $4C,$00,$F0,$64,$04,$04,$7E,$0F,$00 ; F474  LIGHTNING
game_rec_268:
        .byte $4C,$00,$F0,$64,$06,$04,$7F,$0F,$01 ; F47D  LITTLE WITCH
game_rec_269:
        .byte $4C,$00,$F0,$64,$08,$04,$80,$0F,$00 ; F486  MAGIC EGG
game_rec_270:
        .byte $4C,$00,$F0,$64,$0A,$04,$81,$0F,$00 ; F48F  MAN IN RED
game_rec_271:
        .byte $4C,$00,$F0,$64,$0C,$04,$82,$0F,$00 ; F498  MECCANO
game_rec_272:
        .byte $4C,$00,$F0,$64,$0E,$04,$83,$0F,$00 ; F4A1  MIRROE
game_rec_273:
        .byte $4C,$00,$F0,$64,$10,$04,$84,$0F,$00 ; F4AA  MOUSE SNARE
game_rec_274:
        .byte $4C,$00,$F0,$64,$12,$04,$85,$0F,$00 ; F4B3  MOUSE HERO
game_rec_275:
        .byte $4C,$00,$F0,$64,$14,$04,$86,$0F,$00 ; F4BC  MOWING
game_rec_276:
        .byte $4C,$89,$9E,$64,$16,$04,$87,$0F,$00 ; F4C5  NUT CRACKY
game_rec_277:
        .byte $4C,$0A,$E7,$64,$18,$04,$88,$0F,$00 ; F4CE  CRYSTAL BALL
game_rec_278:
        .byte $4C,$00,$F0,$64,$1A,$04,$89,$0F,$01 ; F4D7  POLICE DOG LASY
game_rec_279:
        .byte $4C,$40,$D6,$64,$1C,$04,$8A,$0F,$00 ; F4E0  POLICE VS THIEF
game_rec_280:
        .byte $4C,$00,$F0,$64,$1E,$04,$8B,$0F,$00 ; F4E9  PONGPONG
game_rec_281:
        .byte $4C,$F1,$F8,$64,$20,$04,$8C,$0F,$00 ; F4F2  POWER ROBOT
game_rec_282:
        .byte $4C,$00,$F0,$64,$22,$04,$8D,$0F,$00 ; F4FB  PULVERATION
game_rec_283:
        .byte $4C,$00,$F8,$64,$24,$04,$8E,$0F,$00 ; F504  RABBIT VILLAGE
game_rec_284:
        .byte $4C,$00,$F0,$64,$26,$04,$8F,$0F,$00 ; F50D  RIVER JUMP
game_rec_285:
        .byte $4C,$00,$F0,$64,$28,$04,$90,$0F,$00 ; F516  SEAPORT GUARL
game_rec_286:
        .byte $4C,$00,$80,$73,$2A,$04,$91,$0F,$01 ; F51F  SEAWOLF
game_rec_287:
        .byte $4C,$70,$C0,$73,$2B,$04,$92,$0F,$00 ; F528  SPACE BASE
game_rec_288:
        .byte $4C,$4A,$F2,$73,$2C,$04,$93,$0F,$01 ; F531  SPIDERMAN 2
game_rec_289:
        .byte $4C,$0C,$80,$73,$2D,$04,$94,$0F,$01 ; F53A  SPIDERMAN 1
game_rec_290:
        .byte $4C,$00,$C0,$73,$2E,$04,$95,$0F,$01 ; F543  SPRING WORLD
game_rec_291:
        .byte $4C,$C5,$C3,$73,$2F,$04,$96,$0F,$01 ; F54C  STAR
game_rec_292:
        .byte $4C,$00,$C0,$73,$30,$04,$97,$0F,$01 ; F555  SUBMARINE
game_rec_293:
        .byte $4C,$27,$FD,$73,$31,$04,$98,$0F,$00 ; F55E  THROUGHMAN
game_rec_294:
        .byte $4C,$00,$C0,$73,$32,$04,$99,$0F,$00 ; F567  TOY FACTORY
game_rec_295:
        .byte $4C,$55,$C6,$73,$33,$04,$9A,$0F,$00 ; F570  UTMOST WARFARE
game_rec_296:
        .byte $4C,$D4,$92,$73,$34,$04,$9B,$0F,$00 ; F579  VIGILANT
game_rec_297:
        .byte $4C,$24,$FD,$73,$35,$04,$9C,$0F,$01 ; F582  WAR ZONE
game_rec_298:
        .byte $4C,$00,$80,$73,$36,$04,$9D,$0F,$01 ; F58B  WATER PIPE
game_rec_299:
        .byte $4C,$00,$C7,$73,$37,$04,$9E,$0F,$01 ; F594  WILD WORM
game_rec_300:
        .byte $4C,$00,$C0,$73,$38,$04,$9F,$0F,$00 ; F59D  WONDER BALL
game_rec_301:
        .byte $4C,$96,$C1,$73,$39,$04,$A0,$0F,$01 ; F5A6  LUNATION
game_rec_302:
        .byte $4C,$00,$80,$73,$3A,$04,$A1,$0F,$01 ; F5AF  CLIMBING
game_rec_303:
        .byte $4C,$83,$C9,$73,$3B,$04,$A2,$0F,$00 ; F5B8  SEAMAID
game_rec_304:
        .byte $4C,$00,$C0,$73,$3C,$04,$A3,$0F,$01 ; F5C1  STRONG PILL
game_rec_305:
        .byte $4C,$00,$C0,$73,$3D,$04,$A4,$0F,$01 ; F5CA  APPLE CHESS
game_rec_306:
        .byte $4C,$9E,$C7,$73,$3E,$04,$A5,$0F,$01 ; F5D3  FISHWAR
game_rec_307:
        .byte $4C,$6E,$C6,$73,$3F,$04,$A6,$0F,$01 ; F5DC  PUZZLE
game_rec_308:
        .byte $4C,$00,$C0,$73,$40,$04,$A7,$0F,$00 ; F5E5  SHOT PUT
game_rec_309:
        .byte $4C,$1E,$C4,$73,$41,$04,$A8,$0F,$00 ; F5EE  ORCHARD
game_rec_310:
        .byte $4C,$C0,$C3,$73,$42,$04,$A9,$0F,$00 ; F5F7  MOVE BOX
game_rec_311:
        .byte $4C,$84,$C1,$73,$43,$04,$AA,$0F,$00 ; F600  TROOPER
game_rec_312:
        .byte $4C,$00,$80,$73,$44,$04,$AB,$0F,$01 ; F609  GOBLET TOWER
game_rec_313:
        .byte $4C,$00,$C0,$73,$45,$04,$AC,$0F,$00 ; F612  TURTLES 4
game_rec_314:
        .byte $4C,$00,$80,$73,$46,$04,$AD,$0F,$01 ; F61B  CONTRA 1
game_rec_315:
        .byte $4C,$00,$C0,$73,$47,$04,$AE,$0F,$01 ; F624  CONTRA FORC
game_rec_316:
        .byte $4C,$00,$C0,$73,$48,$04,$AF,$0F,$01 ; F62D  CONTRA 7
game_rec_317:
        .byte $4C,$01,$C0,$73,$49,$04,$B0,$0F,$01 ; F636  KAGE
game_rec_318:
        .byte $4C,$00,$C0,$73,$4A,$04,$B1,$0F,$01 ; F63F  SUPER MARIO
game_rec_319:
        .byte $4C,$00,$C0,$73,$4B,$04,$B2,$0F,$00 ; F648  MARIO 6
game_rec_320:
        .byte $4C,$10,$C0,$73,$4C,$04,$B3,$0F,$00 ; F651  MARIO 9
game_rec_321:
        .byte $4C,$1B,$C0,$73,$4D,$04,$B4,$0F,$00 ; F65A  MARIO 10
game_rec_322:
        .byte $4C,$14,$C0,$73,$4E,$04,$B5,$0F,$01 ; F663  DR MARIO
game_rec_323:
        .byte $4C,$00,$C0,$73,$4F,$04,$B6,$0F,$00 ; F66C  MARIO BROS
game_rec_324:
        .byte $4C,$00,$C0,$73,$50,$04,$B7,$0F,$00 ; F675  ADVENTURE ISLAND
game_rec_325:
        .byte $4C,$00,$C0,$73,$51,$04,$B8,$0F,$00 ; F67E  ADVEN ISLAND 2
game_rec_326:
        .byte $4C,$09,$E8,$73,$52,$04,$B9,$0F,$00 ; F687  CHIP DALE 1
game_rec_327:
        .byte $4C,$00,$C0,$73,$53,$04,$BA,$0F,$00 ; F690  CHIP DALE 3
game_rec_328:
        .byte $4C,$C0,$9F,$73,$54,$04,$BB,$0F,$00 ; F699  BUBBLE BOBBLE 2
game_rec_329:
        .byte $4C,$00,$C0,$73,$55,$04,$BC,$0F,$00 ; F6A2  SNOW BROS
game_rec_330:
        .byte $4C,$43,$CA,$73,$56,$04,$BD,$0F,$00 ; F6AB  MITSUME
game_rec_331:
        .byte $4C,$31,$C0,$73,$57,$04,$BE,$0F,$00 ; F6B4  NINJA GAIDEN 2
game_rec_332:
        .byte $4C,$00,$C0,$73,$58,$04,$BF,$0F,$00 ; F6BD  DOUBLE DRAGON 2
game_rec_333:
        .byte $4C,$00,$C0,$73,$59,$04,$C0,$0F,$00 ; F6C6  DOUBLE DRAGON 3
game_rec_334:
        .byte $4C,$35,$C7,$73,$5A,$04,$C1,$0F,$01 ; F6CF  HOT HIGH SCHOOL
game_rec_335:
        .byte $4C,$00,$80,$73,$5B,$04,$C2,$0F,$00 ; F6D8  HOT WRESTLE
game_rec_336:
        .byte $4C,$00,$C0,$73,$5C,$04,$C3,$0F,$00 ; F6E1  ROBOCOP
game_rec_337:
        .byte $4C,$83,$F1,$73,$5D,$04,$C4,$0F,$01 ; F6EA  MORTAL KOMBAT 4
game_rec_338:
        .byte $4C,$00,$80,$73,$5E,$04,$C5,$0F,$01 ; F6F3  SPIDER MAN
game_rec_339:
        .byte $4C,$00,$80,$73,$5F,$04,$C6,$0F,$00 ; F6FC  10 YARD FIGHT
game_rec_340:
        .byte $4C,$10,$C0,$73,$60,$04,$C7,$0F,$01 ; F705  90 TANK
game_rec_341:
        .byte $4C,$82,$C1,$73,$61,$04,$C8,$0F,$00 ; F70E  KAGE LEGEND
game_rec_342:
        .byte $4C,$00,$F6,$73,$62,$04,$C9,$0F,$01 ; F717  ALADDIN 3
game_rec_343:
        .byte $4C,$00,$C0,$73,$63,$04,$CA,$0F,$01 ; F720  ANTARCTIC ADVEN
game_rec_344:
        .byte $4C,$00,$C0,$73,$64,$04,$CB,$0F,$00 ; F729  ARABIAN
game_rec_345:
        .byte $4C,$49,$C6,$73,$65,$04,$CC,$0F,$01 ; F732  BALLOON FIGHT
game_rec_346:
        .byte $4C,$00,$C0,$73,$66,$04,$CD,$0F,$01 ; F73B  BASE BALL
game_rec_347:
        .byte $4C,$00,$80,$73,$67,$04,$CE,$0F,$01 ; F744  BINARY LAND
game_rec_348:
        .byte $4C,$00,$C0,$73,$68,$04,$CF,$0F,$00 ; F74D  BIRD WEEK
game_rec_349:
        .byte $4C,$00,$C0,$73,$69,$04,$D0,$0F,$01 ; F756  BOMBER MAN
game_rec_350:
        .byte $4C,$00,$CA,$73,$6A,$04,$D1,$0F,$00 ; F75F  BOMB SWEEPER
game_rec_351:
        .byte $4C,$40,$C0,$73,$6B,$04,$D2,$0F,$01 ; F768  BRUSH ROLLER
game_rec_352:
        .byte $4C,$10,$C0,$73,$6C,$04,$D3,$0F,$00 ; F771  BURGER TIME
game_rec_353:
        .byte $4C,$00,$80,$73,$6D,$04,$D4,$0F,$01 ; F77A  CHACK AND POP
game_rec_354:
        .byte $4C,$06,$ED,$73,$6E,$04,$D5,$0F,$00 ; F783  CHESS
game_rec_355:
        .byte $4C,$4E,$E7,$73,$6F,$04,$D6,$0F,$00 ; F78C  CIRCUS CHARLIE
game_rec_356:
        .byte $4C,$00,$F5,$73,$70,$04,$D7,$0F,$00 ; F795  CLU CLU LAND
game_rec_357:
        .byte $4C,$00,$FE,$73,$71,$04,$D8,$0F,$00 ; F79E  COMBAT
game_rec_358:
        .byte $4C,$00,$FA,$73,$72,$04,$D9,$0F,$00 ; F7A7  DEFENDER
game_rec_359:
        .byte $4C,$1A,$FC,$73,$73,$04,$DA,$0F,$01 ; F7B0  DEVIL WORLD
game_rec_360:
        .byte $4C,$00,$FE,$73,$74,$04,$DB,$0F,$01 ; F7B9  DIG DUG 1
game_rec_361:
        .byte $4C,$D0,$FD,$73,$75,$04,$DC,$0F,$00 ; F7C2  DONKEY KONG 1
game_rec_362:
        .byte $4C,$96,$FD,$73,$76,$04,$DD,$0F,$00 ; F7CB  DONKEY KONG 2
game_rec_363:
        .byte $4C,$CC,$F9,$73,$77,$04,$DE,$0F,$00 ; F7D4  DONKEY KONG 3
game_rec_364:
        .byte $4C,$68,$FC,$73,$78,$04,$DF,$0F,$00 ; F7DD  DONKEY KONG JR
game_rec_365:
        .byte $4C,$00,$F5,$73,$79,$04,$E0,$0F,$01 ; F7E6  DOOR DOOR
game_rec_366:
        .byte $4C,$00,$FC,$73,$7A,$04,$E1,$0F,$00 ; F7EF  EXCITE BIKE
game_rec_367:
        .byte $4C,$80,$FD,$73,$7B,$04,$E2,$0F,$00 ; F7F8  EXERION
game_rec_368:
        .byte $4C,$7A,$FD,$73,$7C,$04,$E3,$0F,$01 ; F801  F1 RACE
game_rec_369:
        .byte $4C,$67,$EC,$73,$7D,$04,$E4,$0F,$01 ; F80A  FORMATION Z
game_rec_370:
        .byte $4C,$F7,$EE,$73,$7E,$04,$E5,$0F,$00 ; F813  FRONT LINE
game_rec_371:
        .byte $4C,$00,$F4,$73,$7F,$04,$E6,$0F,$01 ; F81C  GALAGA
game_rec_372:
        .byte $4C,$00,$FC,$73,$80,$04,$E7,$0F,$00 ; F825  GALAXIAN
game_rec_373:
        .byte $4C,$8D,$E9,$73,$81,$04,$E8,$0F,$01 ; F82E  GOLF
game_rec_374:
        .byte $4C,$87,$FC,$73,$82,$04,$E9,$0F,$01 ; F837  RAID O BUNGELING
game_rec_375:
        .byte $4C,$E8,$DE,$73,$83,$04,$EA,$0F,$01 ; F840  HYPER OLYMPIC
game_rec_376:
        .byte $4C,$9C,$EE,$73,$84,$04,$EB,$0F,$00 ; F849  HYPER SPORTS
game_rec_377:
        .byte $4C,$00,$FC,$73,$85,$04,$EC,$0F,$01 ; F852  ICE CLIMBER
game_rec_378:
        .byte $4C,$00,$FC,$73,$86,$04,$ED,$0F,$00 ; F85B  JOUST
game_rec_379:
        .byte $4C,$00,$FC,$73,$87,$04,$EE,$0F,$00 ; F864  KARATEKA
game_rec_380:
        .byte $4C,$00,$FC,$73,$88,$04,$EF,$0F,$00 ; F86D  LODE RUNNER
game_rec_381:
        .byte $4C,$66,$F6,$73,$89,$04,$F0,$0F,$00 ; F876  LUNAR BALL
game_rec_382:
        .byte $4C,$D6,$EB,$73,$8A,$04,$F1,$0F,$00 ; F87F  MACROSS
game_rec_383:
        .byte $4C,$6B,$F1,$73,$8B,$04,$F2,$0F,$01 ; F888  MAGIC JEWELRY
game_rec_384:
        .byte $4C,$00,$FC,$73,$8C,$04,$F3,$0F,$01 ; F891  MAHJONG 4P
game_rec_385:
        .byte $4C,$BA,$FA,$73,$8D,$04,$F4,$0F,$00 ; F89A  MAHJONG 2p
game_rec_386:
        .byte $4C,$00,$FE,$73,$8E,$04,$F5,$0F,$00 ; F8A3  MAPPY
game_rec_387:
        .byte $4C,$00,$FC,$73,$8F,$04,$F6,$0F,$00 ; F8AC  MILK N NUTS
game_rec_388:
        .byte $4C,$23,$FC,$73,$90,$04,$F7,$0F,$00 ; F8B5  MILLIPEDE
game_rec_389:
        .byte $4C,$00,$FE,$73,$91,$04,$F8,$0F,$01 ; F8BE  MUSICE
game_rec_390:
        .byte $4C,$00,$FC,$73,$92,$04,$F9,$0F,$00 ; F8C7  NAITOU
game_rec_391:
        .byte $4C,$60,$F6,$73,$93,$04,$FA,$0F,$00 ; F8D0  NIBBLES
game_rec_392:
        .byte $4C,$6F,$F1,$73,$94,$04,$FB,$0F,$00 ; F8D9  NINJA 1
game_rec_393:
        .byte $4C,$65,$F7,$73,$95,$04,$FC,$0F,$00 ; F8E2  NINJA 3
game_rec_394:
        .byte $4C,$38,$EA,$73,$96,$04,$FD,$0F,$00 ; F8EB  ROAD FIGHTER
game_rec_395:
        .byte $4C,$82,$F9,$73,$97,$04,$FE,$0F,$00 ; F8F4  OTHELLO
game_rec_396:
        .byte $4C,$00,$F5,$73,$98,$04,$FF,$0F,$00 ; F8FD  PACMAN
game_rec_397:
        .byte $4C,$61,$FC,$73,$99,$04,$38,$09,$00 ; F906  PIN BALL
game_rec_398:
        .byte $4C,$00,$FA,$73,$9A,$04,$39,$09,$00 ; F90F  POOYAN
game_rec_399:
        .byte $4C,$16,$F2,$73,$9B,$04,$3A,$09,$01 ; F918  POPEYE
        .byte $23,$F9,$2B,$F9,$04,$00,$00,$00,$80,$00,$A5,$C9,$04,$00,$00,$00 ; F921
        .byte $00,$00,$FF,$FF ; F931
loc_F935:
        sei                             ; F935
        cld                             ; F936
        lda  #$00                       ; F937
        sta  PPU_CTRL                   ; F939
        sta  PPU_MASK                   ; F93C
        sta  APU_STATUS                 ; F93F
        sta  PPU_SCROLL                 ; F942
        sta  PPU_SCROLL                 ; F945
        lda  #$C0                       ; F948
        sta  JOY2_FRAME                 ; F94A
        ldx  #$04                       ; F94D
loc_F94F:
        bit  PPU_STATUS                 ; F94F
        bpl  loc_F94F                   ; F952
loc_F954:
        bit  PPU_STATUS                 ; F954
        bmi  loc_F954                   ; F957
        dex                             ; F959
        bpl  loc_F94F                   ; F95A
        txs                             ; F95C
        ldy  #$20                       ; F95D
        sty  PPU_ADDR                   ; F95F
        lda  #$00                       ; F962
        sta  PPU_ADDR                   ; F964
        ldx  #$00                       ; F967
loc_F969:
        sta  PPU_DATA                   ; F969
        inx                             ; F96C
        bne  loc_F969                   ; F96D
        iny                             ; F96F
        cpy  #$40                       ; F970
        bne  loc_F969                   ; F972
        ldx  #$3F                       ; F974
        stx  PPU_ADDR                   ; F976
        ldx  #$00                       ; F979
        stx  PPU_ADDR                   ; F97B
        lda  #$0E                       ; F97E
loc_F980:
        sta  PPU_DATA                   ; F980
        inx                             ; F983
        cpx  #$20                       ; F984
        bne  loc_F980                   ; F986
        lda  #$00                       ; F988
        sta  PPU_ADDR                   ; F98A
        sta  PPU_ADDR                   ; F98D
        ldy  $0337                      ; F990
        lda  #$00                       ; F993
        tax                             ; F995
loc_F996:
        sta  $00,x                      ; F996
        sta  $0100,x                    ; F998
        sta  $0200,x                    ; F99B
        sta  $0300,x                    ; F99E
        sta  $0400,x                    ; F9A1
        sta  $0500,x                    ; F9A4
        sta  $0600,x                    ; F9A7
        sta  $0700,x                    ; F9AA
        inx                             ; F9AD
        bne  loc_F996                   ; F9AE
        cpy  #$00                       ; F9B0
        bne  loc_F9B6                   ; F9B2
        ldy  #$5A                       ; F9B4
loc_F9B6:
        sty  $0337                      ; F9B6
        lda  #$00                       ; F9B9
        bit  REG_4242                   ; F9BB
        lda  #$06                       ; F9BE
set_prg_r6r7_3C3D:
        sta  MMC3_BANK_SELECT           ; F9C0
        lda  #$3C                       ; F9C3
        sta  MMC3_BANK_DATA             ; F9C5
        lda  #$07                       ; F9C8
        sta  MMC3_BANK_SELECT           ; F9CA
        lda  #$3D                       ; F9CD
        sta  MMC3_BANK_DATA             ; F9CF
        jsr  read_pad_0327              ; F9D2
        lda  pad_state                  ; F9D5
        cmp  #$A0                       ; F9D8
        beq  boot_hotkey_A_select       ; F9DA
        cmp  #$60                       ; F9DC
        beq  boot_hotkey_B_select       ; F9DE
        cmp  #$30                       ; F9E0
        beq  boot_hotkey_select_start   ; F9E2
        lda  #$00                       ; F9E4
        sta  menu_state                 ; F9E6
        sta  menu_step                  ; F9E9
        jmp  menu_main                  ; F9EC
boot_hotkey_A_select:
        ; static (not seen in traces)
        lda  #$05                       ; F9EF
        sta  game_number_lo             ; F9F1
        lda  #$00                       ; F9F4
        sta  game_number_hi             ; F9F6
        jmp  loc_A0BE                   ; F9F9
boot_hotkey_B_select:
        lda  #$30                       ; F9FC
        sta  game_number_lo             ; F9FE
        lda  #$00                       ; FA01
        sta  game_number_hi             ; FA03
        jmp  loc_A0BE                   ; FA06
boot_hotkey_select_start:
        lda  #$9D                       ; FA09
        sta  game_number_lo             ; FA0B
        lda  #$00                       ; FA0E
        sta  game_number_hi             ; FA10
        jmp  loc_A0BE                   ; FA13
menu_main:
        bit  english_menu_entry         ; FA16
        lda  #$00                       ; FA19
        sta  $0698                      ; FA1B
        lda  #$D4                       ; FA1E
        sta  idle_hook_ptr              ; FA20
        lda  #$C8                       ; FA22
        sta  $D5                        ; FA24
        lda  #$3A                       ; FA26
        sta  nmi_vector_ptr             ; FA28
        lda  #$FA                       ; FA2A
        sta  $D1                        ; FA2C
        jsr  menu_video_init            ; FA2E
loc_FA31:
        jsr  state_dispatch_main        ; FA31
        ; static (not seen in traces)
        jmp  loc_FA31                   ; FA34
nmi_vector_jmp_d0:
        jmp  (nmi_vector_ptr)           ; FA37
nmi_handler:
        pha                             ; FA3A
        tya                             ; FA3B
        pha                             ; FA3C
        txa                             ; FA3D
        pha                             ; FA3E
        jsr  nmi_call_hook_b0           ; FA3F
        lda  #$02                       ; FA42
        sta  OAM_DMA                    ; FA44
        lda  #$00                       ; FA47
        sta  MMC3_BANK_SELECT           ; FA49
        lda  chr_shadow_r0              ; FA4C
        sta  MMC3_BANK_DATA             ; FA4F
        lda  #$01                       ; FA52
        sta  MMC3_BANK_SELECT           ; FA54
        lda  chr_shadow_r1              ; FA57
        sta  MMC3_BANK_DATA             ; FA5A
        lda  #$02                       ; FA5D
        sta  MMC3_BANK_SELECT           ; FA5F
        lda  chr_shadow_r2              ; FA62
        sta  MMC3_BANK_DATA             ; FA65
        lda  #$03                       ; FA68
        sta  MMC3_BANK_SELECT           ; FA6A
        lda  chr_shadow_r3              ; FA6D
        sta  MMC3_BANK_DATA             ; FA70
        lda  #$04                       ; FA73
        sta  MMC3_BANK_SELECT           ; FA75
        lda  chr_shadow_r4              ; FA78
        sta  MMC3_BANK_DATA             ; FA7B
        lda  #$05                       ; FA7E
        sta  MMC3_BANK_SELECT           ; FA80
        lda  chr_shadow_r5              ; FA83
        sta  MMC3_BANK_DATA             ; FA86
        jsr  nmi_set_scroll             ; FA89
        jsr  nmi_sound_or_anim          ; FA8C
        jsr  nmi_frame_tail             ; FA8F
        lda  #$0F                       ; FA92
        sta  APU_STATUS                 ; FA94
        pla                             ; FA97
        tax                             ; FA98
        pla                             ; FA99
        tay                             ; FA9A
        pla                             ; FA9B
        rti                             ; FA9C
nmi_set_scroll:
        lda  keep_ppu_addr              ; FA9D
        bne  loc_FAAA                   ; FAA0
        lda  #$00                       ; FAA2
        sta  PPU_ADDR                   ; FAA4
        sta  PPU_ADDR                   ; FAA7
loc_FAAA:
        lda  $036B                      ; FAAA
        lda  #$00                       ; FAAD
        sta  PPU_SCROLL                 ; FAAF
        lda  scroll_y_shadow            ; FAB2
        sta  PPU_SCROLL                 ; FAB5
        lda  ppu_ctrl_shadow            ; FAB8
        sta  PPU_CTRL                   ; FABB
        rts                             ; FABE
nmi_call_hook_b0:
        lda  nmi_hook_pending           ; FABF
        beq  loc_FAC7                   ; FAC2
        jmp  (nmi_hook_ptr)             ; FAC4
loc_FAC7:
        rts                             ; FAC7
nmi_frame_tail:
        lda  $0337                      ; FAC8
        bne  loc_FAD2                   ; FACB
        lda  #$0F                       ; FACD
        sta  $0338                      ; FACF
loc_FAD2:
        jsr  read_pad_0327_thunk        ; FAD2
        lda  #$00                       ; FAD5
        sta  $0321                      ; FAD7
        inc  frame_counter              ; FADA
        inc  frame_div7                 ; FADC
        lda  frame_div7                 ; FADF
        cmp  #$07                       ; FAE2
        bne  loc_FAEB                   ; FAE4
        lda  #$00                       ; FAE6
        sta  frame_div7                 ; FAE8
loc_FAEB:
        rts                             ; FAEB
irq_rti:
        ; static (not seen in traces)
        rti                             ; FAEC
menu_video_init:
        jsr  init_palette_buffer_0E     ; FAED
        lda  #$00                       ; FAF0
        sta  menu_state                 ; FAF2
        lda  #$00                       ; FAF5
        sta  menu_step                  ; FAF7
        lda  #$20                       ; FAFA
        sta  $0320                      ; FAFC
        lda  #$80                       ; FAFF
        sta  ppu_ctrl_shadow            ; FB01
        sta  PPU_CTRL                   ; FB04
        lda  #$1E                       ; FB07
        sta  $0369                      ; FB09
        rts                             ; FB0C
init_palette_buffer_0E:
        ldx  #$00                       ; FB0D
        lda  #$0E                       ; FB0F
loc_FB11:
        sta  $036E,x                    ; FB11
        inx                             ; FB14
        cpx  #$22                       ; FB15
        bne  loc_FB11                   ; FB17
        rts                             ; FB19
state_dispatch_main:
        lda  #$00                       ; FB1A
        sta  nmi_step_on                ; FB1C
        lda  menu_state                 ; FB1F
        asl  a                          ; FB22
        tax                             ; FB23
        lda  tbl_menu_states,x          ; FB24
        sta  $C3                        ; FB27
        lda  tbl_menu_states+1,x        ; FB29
        sta  $C4                        ; FB2C
        lda  menu_step                  ; FB2E
        asl  a                          ; FB31
        asl  a                          ; FB32
        tay                             ; FB33
        lda  ($C3),y                    ; FB34
        sta  $C5                        ; FB36
        iny                             ; FB38
        lda  ($C3),y                    ; FB39
        sta  $C6                        ; FB3B
        jmp  ($00C5)                    ; FB3D
nmi_sound_or_anim:
        lda  nmi_dispatch_on            ; FB40
        bne  loc_FB49                   ; FB43
        jsr  clear_oam_buffer           ; FB45
        rts                             ; FB48
loc_FB49:
        lda  nmi_step_on                ; FB49
        beq  loc_FB71                   ; FB4C
        lda  menu_state                 ; FB4E
        asl  a                          ; FB51
        tax                             ; FB52
        lda  tbl_menu_states,x          ; FB53
        sta  $BE                        ; FB56
        lda  tbl_menu_states+1,x        ; FB58
        sta  $BF                        ; FB5B
        lda  menu_step                  ; FB5D
        asl  a                          ; FB60
        asl  a                          ; FB61
        tay                             ; FB62
        iny                             ; FB63
        iny                             ; FB64
        lda  ($BE),y                    ; FB65
        sta  $C0                        ; FB67
        iny                             ; FB69
        lda  ($BE),y                    ; FB6A
        sta  $C1                        ; FB6C
        jmp  ($00C0)                    ; FB6E
loc_FB71:
        rts                             ; FB71
clear_oam_buffer:
        ldx  #$00                       ; FB72
        lda  #$F0                       ; FB74
loc_FB76:
        sta  $0200,x                    ; FB76
        inx                             ; FB79
        bne  loc_FB76                   ; FB7A
        rts                             ; FB7C
english_menu_entry:
        ldx  #$00                       ; FB7D
loc_FB7F:
        lda  ram_stub_0200_chr_setup,x  ; FB7F
        sta  $0200,x                    ; FB82
        inx                             ; FB85
        bne  loc_FB7F                   ; FB86
        jmp  $0200                      ; FB88
        .byte $60 ; FB8B
; ---- RAM stub: copied to $0200 by english_menu_entry and run there
ram_stub_0200_chr_setup:
        ; static (not seen in traces)
        lda  #$10                       ; FB8C
        sta  OB_CHR_2018                ; FB8E
        lda  #$8E                       ; FB91
        sta  OB_CHR_201A                ; FB93
        lda  #$00                       ; FB96
        asl  a                          ; FB98
        asl  a                          ; FB99
        asl  a                          ; FB9A
        ldx  #$00                       ; FB9B
loc_FB9D:
        stx  MMC3_BANK_SELECT           ; FB9D
        sta  MMC3_BANK_DATA             ; FBA0
        clc                             ; FBA3
        adc  #$02                       ; FBA4
        inx                             ; FBA6
        cpx  #$02                       ; FBA7
        bne  loc_FB9D                   ; FBA9
        clc                             ; FBAB
        ldx  #$02                       ; FBAC
loc_FBAE:
        stx  MMC3_BANK_SELECT           ; FBAE
        sta  MMC3_BANK_DATA             ; FBB1
        adc  #$01                       ; FBB4
        inx                             ; FBB6
        cpx  #$06                       ; FBB7
        bne  loc_FBAE                   ; FBB9
        jmp  boot_check_ab_then_menu    ; FBBB
        .byte $FF,$FF,$FF,$01,$80,$A9,$05,$8D,$00,$80,$AD,$30,$03,$8D,$01,$80 ; FBBE
        .byte $A9,$06,$8D,$00,$80,$A9,$FC,$8D,$01,$80,$A9,$00,$8D,$00,$80,$A9 ; FBCE
        .byte $00,$8D,$01,$80,$A9,$01,$8D,$00,$80,$A9,$02,$8D,$01,$80,$A9,$02 ; FBDE
        .byte $8D,$00,$80,$A9,$04,$8D,$01,$80,$A9,$03,$8D,$00,$80,$A9,$05,$8D ; FBEE
        .byte $01,$80,$A9,$04,$8D,$00,$80,$A9,$06,$8D,$01,$80,$A9,$05,$8D,$00 ; FBFE
        .byte $80,$A9,$07,$8D,$01,$80,$A9,$00,$8D,$06,$20,$8D,$06,$20,$85,$C3 ; FC0E
        .byte $A9,$80,$85,$C4,$A2,$20,$A0,$00,$B1,$C3,$2C,$07,$20,$C8,$D0,$F8 ; FC1E
        .byte $E6,$C4,$CA,$D0,$F3,$A9,$00,$8D,$06,$20,$8D,$06,$20,$60 ; FC2E
tbl_screen_desc:
        .byte $40 ; FC3C
dat_FC3D:
        .byte $FC,$46,$FC,$4C,$FC,$9E,$FD,$00,$00,$C0,$FD,$DD,$FE,$04,$01,$00 ; FC3D
        .byte $20,$01,$04,$00,$2F,$30,$31,$32,$33,$00,$34,$41,$26,$03,$35,$36 ; FC4D
        .byte $37,$38,$36,$39,$3A,$3B,$00,$3C,$3D,$3E,$00,$3F,$40,$41,$42,$08 ; FC5D
        .byte $0A,$43,$41,$44,$45,$46,$00,$47,$48,$00,$49,$4A,$4B,$4C,$4D,$4E ; FC6D
        .byte $4F,$50,$00,$51,$52,$00,$53,$54,$55,$56,$57,$04,$09,$58,$59,$5A ; FC7D
        .byte $5B,$5C,$00,$5D,$5E,$00,$5F,$60,$61,$62,$63,$64,$65,$66,$00,$67 ; FC8D
        .byte $00,$68,$69,$6A,$6B,$6C,$6D,$02,$0A,$6E,$0D,$08,$08,$00,$1C,$21 ; FC9D
        .byte $00,$00,$09,$75,$00,$76,$00,$77,$78,$00,$90,$02,$0B,$79,$7A,$7B ; FCAD
        .byte $7C,$7D,$7E,$7F,$80,$00,$81,$00,$82,$83,$00,$84,$85,$86,$00,$87 ; FCBD
        .byte $88,$00,$89,$8A,$00,$8B,$8C,$20,$0D,$8D,$8E,$8F,$00,$90,$91,$00 ; FCCD
        .byte $92,$08,$03,$8A,$00,$93,$00,$94,$00,$00,$95,$68,$02,$FE,$EE,$96 ; FCDD
        .byte $97,$98,$00,$99,$9A,$9B,$9C,$08,$1C,$00,$9D,$9E,$9F,$A0,$00,$A1 ; FCED
        .byte $A2,$01,$00,$A3,$A2,$A4,$A5,$A6,$00,$A7,$A8,$00,$A9,$00,$AA,$00 ; FCFD
        .byte $A4,$A5,$AB,$AC,$00,$A7,$A8,$00,$AD,$AE,$AF,$B0,$00,$04,$07,$B1 ; FD0D
        .byte $B2,$B3,$B4,$B5,$B6,$B7,$00,$00,$B8,$B9,$BA,$BB,$BC,$00,$B5,$B6 ; FD1D
        .byte $00,$BD,$BE,$B8,$B9,$00,$BF,$C0,$C1,$10,$07,$C2,$00,$C3,$C4,$00 ; FD2D
        .byte $C5,$C6,$C7,$12,$15,$04,$C8,$C9,$00,$CA,$CB,$CC,$00,$CD,$44,$14 ; FD3D
        .byte $03,$CE,$CF,$D0,$D1,$D2,$D3,$00,$D4,$40,$0B,$D5,$D6,$D7,$D8,$D9 ; FD4D
        .byte $DA,$DB,$DC,$00,$DD,$DE,$00,$DF,$E0,$E1,$E2,$E3,$04,$02,$E4,$E5 ; FD5D
        .byte $E6,$00,$E7,$E8,$E9,$EA,$08,$0B,$EB,$EC,$ED,$EE,$DC,$DD,$DE,$00 ; FD6D
        .byte $00,$D5,$FD,$FF,$75,$55,$5D,$DF,$FF,$10,$04,$57,$55,$05,$55,$15 ; FD7D
        .byte $00,$5A,$56,$4A,$1D,$06,$05,$00,$01,$04,$05,$0A,$05,$00,$00,$08 ; FD8D
        .byte $03,$00,$20,$0E,$13,$21,$30,$0E,$13,$21,$30,$0E,$3D,$10,$30,$0E ; FD9D
        .byte $13,$21,$30,$0E,$06,$16,$36,$0E,$13,$21,$30,$0E,$3D,$10,$30,$0E ; FDAD
        .byte $30,$16,$36,$00,$20,$01,$04,$01,$01,$02,$03,$04,$05,$06,$07,$03 ; FDBD
        .byte $FE,$46,$08,$01,$09,$0A,$0B,$0C,$0D,$01,$92,$18,$05,$15,$0E,$0F ; FDCD
        .byte $10,$0B,$11,$12,$13,$0B,$88,$02,$02,$14,$0F,$15,$16,$01,$17,$18 ; FDDD
        .byte $19,$10,$11,$0B,$1A,$1B,$1C,$1D,$1E,$1F,$20,$00,$0B,$21,$22,$23 ; FDED
        .byte $24,$25,$26,$01,$80,$02,$27,$01,$28,$29,$2A,$01,$2B,$2C,$23,$02 ; FDFD
        .byte $03,$04,$2D,$2E,$2F,$30,$31,$0B,$32,$33,$00,$34,$35,$36,$37,$38 ; FE0D
        .byte $39,$3A,$3B,$00,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$00,$44,$45,$46 ; FE1D
        .byte $47,$48,$49,$4A,$4B,$00,$4C,$4D,$4E,$4F,$50,$51,$52,$53,$00,$54 ; FE2D
        .byte $55,$56,$57,$58,$59,$5A,$5B,$00,$5C,$5D,$5E,$3F,$5F,$60,$01,$61 ; FE3D
        .byte $00,$62,$63,$64,$65,$66,$67,$68,$69,$00,$6A,$0B,$6B,$6C,$6D,$6E ; FE4D
        .byte $6F,$70,$00,$71,$0B,$72,$73,$74,$01,$75,$76,$20,$07,$01,$77,$78 ; FE5D
        .byte $01,$79,$7A,$7B,$0B,$01,$06,$7C,$7D,$7E,$7F,$80,$81,$82,$7A,$00 ; FE6D
        .byte $83,$84,$01,$85,$86,$87,$88,$89,$00,$8A,$01,$8B,$8C,$8D,$8E,$8F ; FE7D
        .byte $90,$00,$01,$85,$01,$91,$92,$93,$94,$95,$04,$04,$96,$97,$98,$99 ; FE8D
        .byte $01,$9A,$9B,$9C,$00,$9D,$9E,$9F,$A0,$A1,$A2,$01,$A3,$00,$A4,$A5 ; FE9D
        .byte $A6,$A7,$A8,$A9,$AA,$AB,$00,$01,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$01 ; FEAD
        .byte $04,$01,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$01,$02,$BA,$BB,$BC,$BD,$BE ; FEBD
        .byte $BF,$C0,$C1,$00,$C2,$C3,$C4,$C5,$01,$01,$00,$00,$70,$FE,$42,$40 ; FECD
        .byte $00,$20,$0E,$30,$36,$16,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; FEDD
        .byte $0E,$0E,$0E,$30,$36,$16,$0E,$0E ; FEED
reset_main_init:
        sei                             ; FEF5
        cld                             ; FEF6
        lda  #$0B                       ; FEF7
        sta  REG_4138                   ; FEF9
        nop                             ; FEFC
        lda  #$02                       ; FEFD
        sta  REG_4139                   ; FEFF
        lda  #$00                       ; FF02
        sta  PPU_CTRL                   ; FF04
        sta  PPU_MASK                   ; FF07
        lda  #$3C                       ; FF0A
        sta  OB_PRG_8000                ; FF0C
        lda  #$3D                       ; FF0F
        sta  OB_PRG_A000                ; FF11
        lda  #$00                       ; FF14
        jsr  set_chr_banks_mmc3         ; FF16
        jmp  fill_palette_0F            ; FF19
boot_check_ab_then_menu:
        jsr  check_AB_support_app       ; FF1C
        jmp  loc_F935                   ; FF1F
        .byte $FF,$FF ; FF22
set_412B_412C:
        .byte $A9,$FF,$8D,$2B,$41,$EA,$A9,$00,$8D,$2C,$41,$60 ; FF24
select_r7_33_jump_bank33:
        lda  #$07                       ; FF30
        sta  MMC3_BANK_SELECT           ; FF32
        lda  #$33                       ; FF35
        sta  MMC3_BANK_DATA             ; FF37
        jmp  $A000                      ; FF3A ; -> bank $33 at $A000 (file 0x66000)
        .byte $FF,$FF,$FF ; FF3D
fill_palette_0F:
        lda  #$3F                       ; FF40
        sta  PPU_ADDR                   ; FF42
        lda  #$00                       ; FF45
        sta  PPU_ADDR                   ; FF47
        ldx  #$00                       ; FF4A
        lda  #$0F                       ; FF4C
loc_FF4E:
        sta  PPU_DATA                   ; FF4E
        inx                             ; FF51
        cpx  #$20                       ; FF52
        bne  loc_FF4E                   ; FF54
        jmp  select_r7_33_jump_bank33   ; FF56
        .byte $00,$00,$00,$00,$00,$00,$00 ; FF59
run_ram_stub_boot_select:
        ldx  #$30                       ; FF60
loc_FF62:
        lda  ram_stub_boot_select,x     ; FF62
        sta  $0400,x                    ; FF65
        dex                             ; FF68
        bpl  loc_FF62                   ; FF69
        jmp  $0400                      ; FF6B
        .byte $00,$00 ; FF6E
; ---- RAM stub: copied to $0400 (49 bytes) by run_ram_stub_boot_select
ram_stub_boot_select:
        ; static (not seen in traces)
        lda  #$04                       ; FF70
        sta  OB_PRG_MODE_410B           ; FF72
        ldx  #$3C                       ; FF75
        stx  OB_PRG_8000                ; FF77
        inx                             ; FF7A
        stx  OB_PRG_A000                ; FF7B
        inx                             ; FF7E
        stx  OB_PRG_C000                ; FF7F
        inx                             ; FF82
        stx  OB_PRG_E000                ; FF83
        jsr  check_AB_support_app       ; FF86
        ldx  #$34                       ; FF89
        stx  OB_PRG_8000                ; FF8B
        inx                             ; FF8E
        stx  OB_PRG_A000                ; FF8F
        inx                             ; FF92
        stx  OB_PRG_C000                ; FF93
        inx                             ; FF96
        stx  OB_PRG_E000                ; FF97
        jmp  $E000                      ; FF9A ; -> bank $37 at $E000 (file 0x6E000), language select
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FF9D
        .byte $00,$00,$00 ; FFAD
jump_bank15_tft_init:
        ldx  #$14                       ; FFB0
        stx  OB_PRG_8000                ; FFB2
        inx                             ; FFB5
        stx  OB_PRG_A000                ; FFB6
        jmp  $A000                      ; FFB9 ; -> bank $15 at $A000 (file 0x2A000)
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; FFBC
        .byte $00,$00,$00,$00 ; FFCC
reset_jmpchain_2:
        jmp  loc_FFD3                   ; FFD0
loc_FFD3:
        jmp  loc_FFD6                   ; FFD3
loc_FFD6:
        jmp  reset_early_init           ; FFD6
reset_early_init:
        nop                             ; FFD9
        nop                             ; FFDA
        lda  #$D0                       ; FFDB
        sta  REG_4134                   ; FFDD
        lda  #$DC                       ; FFE0
        sta  REG_412D                   ; FFE2
        lda  #$81                       ; FFE5
        sta  REG_4137                   ; FFE7
        lda  #$05                       ; FFEA
        sta  REG_411C                   ; FFEC
        jmp  reset_main_init            ; FFEF
        .byte $00,$00,$00,$00,$00,$00,$00,$00 ; FFF2
vec_nmi:
        .word nmi_vector_jmp_d0 ; FFFA
vec_reset:
        .byte $E0,$E7 ; FFFC
vec_irq:
        .byte $EC,$FA ; FFFE
