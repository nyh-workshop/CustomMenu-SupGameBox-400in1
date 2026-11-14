; Sup 400-in-1 TFT/LCD init (bank $15), 8 KiB PRG bank $15 (file 0x2A000), mapped at CPU $A000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK15"

tft_entry:
        jsr  tft_detect_and_init        ; A000
        jmp  $FF60                      ; A003
tft_detect_and_init:
        jsr  lcd_reset_pulse            ; A006
        jsr  lcd_read_id_cmd0A_F1       ; A009
        lda  lcd_id0                    ; A00C
        cmp  #$08                       ; A00F
        bne  loc_A022                   ; A011
        ; static (not seen in traces)
        lda  lcd_id1                    ; A013
        cmp  #$04                       ; A016
        bne  loc_A022                   ; A018
        lda  #$1E                       ; A01A
        sta  panel_type                 ; A01C
        jmp  panel_init_A36E            ; A01F
loc_A022:
        jsr  lcd_read_id_cmd04          ; A022
        lda  lcd_id1                    ; A025
        cmp  #$93                       ; A028
        bne  loc_A03B                   ; A02A
        ; static (not seen in traces)
        lda  lcd_id2                    ; A02C
        cmp  #$06                       ; A02F
        bne  loc_A03B                   ; A031
        lda  #$01                       ; A033
        sta  panel_type                 ; A035
        jmp  panel_init_A2EE            ; A038
loc_A03B:
        lda  lcd_id0                    ; A03B
        cmp  #$85                       ; A03E
        bne  loc_A058                   ; A040
        ; static (not seen in traces)
        lda  lcd_id1                    ; A042
        cmp  #$85                       ; A045
        bne  loc_A058                   ; A047
        lda  lcd_id2                    ; A049
        cmp  #$52                       ; A04C
        bne  loc_A058                   ; A04E
        lda  #$02                       ; A050
        sta  panel_type                 ; A052
        jmp  panel_init_A2FE            ; A055
loc_A058:
        lda  lcd_id1                    ; A058
        cmp  #$93                       ; A05B
        bne  loc_A06E                   ; A05D
        ; static (not seen in traces)
        lda  lcd_id2                    ; A05F
        cmp  #$02                       ; A062
        bne  loc_A06E                   ; A064
        lda  #$03                       ; A066
        sta  panel_type                 ; A068
        jmp  panel_init_A30E            ; A06B
loc_A06E:
        lda  lcd_id1                    ; A06E
        cmp  #$30                       ; A071
        bne  loc_A084                   ; A073
        ; static (not seen in traces)
        lda  lcd_id2                    ; A075
        cmp  #$33                       ; A078
        bne  loc_A084                   ; A07A
        lda  #$1B                       ; A07C
        sta  panel_type                 ; A07E
        jmp  panel_init_A34E            ; A081
loc_A084:
        jsr  lcd_read_id_cmdD3          ; A084
        lda  lcd_id1                    ; A087
        cmp  #$93                       ; A08A
        bne  loc_A09D                   ; A08C
        ; static (not seen in traces)
        lda  lcd_id2                    ; A08E
        cmp  #$41                       ; A091
        bne  loc_A09D                   ; A093
        lda  #$04                       ; A095
        sta  panel_type                 ; A097
        jmp  panel_init_A31E            ; A09A
loc_A09D:
        lda  lcd_id1                    ; A09D
        cmp  #$31                       ; A0A0
        bne  loc_A0B3                   ; A0A2
        ; static (not seen in traces)
        lda  lcd_id2                    ; A0A4
        cmp  #$29                       ; A0A7
        bne  loc_A0B3                   ; A0A9
        lda  #$1C                       ; A0AB
        sta  panel_type                 ; A0AD
        jmp  panel_init_A35E            ; A0B0
loc_A0B3:
        jsr  lcd_read_id_cmdD5          ; A0B3
        lda  lcd_id1                    ; A0B6
        cmp  #$93                       ; A0B9
        bne  loc_A0CC                   ; A0BB
        ; static (not seen in traces)
        lda  lcd_id2                    ; A0BD
        cmp  #$40                       ; A0C0
        bne  loc_A0CC                   ; A0C2
        lda  #$05                       ; A0C4
        sta  panel_type                 ; A0C6
        jmp  panel_init_A32E            ; A0C9
loc_A0CC:
        jsr  lcd_read_id_cmd67          ; A0CC
        lda  lcd_id1                    ; A0CF
        cmp  #$47                       ; A0D2
        bne  loc_A0DE                   ; A0D4
        ; static (not seen in traces)
        lda  #$07                       ; A0D6
        sta  panel_type                 ; A0D8
        jmp  panel_init_A4AE            ; A0DB
loc_A0DE:
        lda  lcd_id1                    ; A0DE
        cmp  #$46                       ; A0E1
        bne  loc_A0ED                   ; A0E3
        ; static (not seen in traces)
        lda  #$20                       ; A0E5
        sta  panel_type                 ; A0E7
        jmp  panel_init_A4BE            ; A0EA
loc_A0ED:
        jsr  lcd_read_id_cmd00          ; A0ED
        lda  lcd_id0                    ; A0F0
        and  #$0F                       ; A0F3
        cmp  #$08                       ; A0F5
        bne  loc_A108                   ; A0F7
        ; static (not seen in traces)
        lda  lcd_id1                    ; A0F9
        cmp  #$09                       ; A0FC
        bne  loc_A108                   ; A0FE
        lda  #$06                       ; A100
        sta  panel_type                 ; A102
        jmp  panel_init_A37E            ; A105
loc_A108:
        lda  lcd_id0                    ; A108
        cmp  #$68                       ; A10B
        bne  loc_A11E                   ; A10D
        ; static (not seen in traces)
        lda  lcd_id1                    ; A10F
        cmp  #$07                       ; A112
        bne  loc_A11E                   ; A114
        lda  #$06                       ; A116
        sta  panel_type                 ; A118
        jmp  panel_init_A37E            ; A11B
loc_A11E:
        lda  lcd_id0                    ; A11E
        cmp  #$68                       ; A121
        bne  loc_A134                   ; A123
        ; static (not seen in traces)
        lda  lcd_id1                    ; A125
        cmp  #$01                       ; A128
        bne  loc_A134                   ; A12A
        lda  #$06                       ; A12C
        sta  panel_type                 ; A12E
        jmp  panel_init_A37E            ; A131
loc_A134:
        lda  lcd_id0                    ; A134
        and  #$0F                       ; A137
        cmp  #$03                       ; A139
        bne  loc_A16A                   ; A13B
        ; static (not seen in traces)
        lda  lcd_id1                    ; A13D
        cmp  #$25                       ; A140
        bne  loc_A16A                   ; A142
        jsr  lcd_read_id_cmdCD          ; A144
        lda  lcd_id2                    ; A147
        cmp  #$74                       ; A14A
        beq  loc_A162                   ; A14C
        cmp  #$44                       ; A14E
        beq  loc_A15A                   ; A150
        lda  #$0A                       ; A152
        sta  panel_type                 ; A154
        jmp  panel_init_A38E            ; A157
loc_A15A:
        lda  #$0B                       ; A15A
        sta  panel_type                 ; A15C
        jmp  panel_init_A38E            ; A15F
loc_A162:
        lda  #$0C                       ; A162
        sta  panel_type                 ; A164
        jmp  panel_init_A39E            ; A167
loc_A16A:
        lda  lcd_id0                    ; A16A
        and  #$0F                       ; A16D
        cmp  #$03                       ; A16F
        bne  loc_A182                   ; A171
        ; static (not seen in traces)
        lda  lcd_id1                    ; A173
        cmp  #$28                       ; A176
        bne  loc_A182                   ; A178
        lda  #$09                       ; A17A
        sta  panel_type                 ; A17C
        jmp  panel_init_A38E            ; A17F
loc_A182:
        lda  lcd_id0                    ; A182
        and  #$0F                       ; A185
        cmp  #$03                       ; A187
        bne  loc_A19A                   ; A189
        ; static (not seen in traces)
        lda  lcd_id1                    ; A18B
        cmp  #$20                       ; A18E
        bne  loc_A19A                   ; A190
        lda  #$0D                       ; A192
        sta  panel_type                 ; A194
        jmp  panel_init_A45E            ; A197
loc_A19A:
        lda  lcd_id1                    ; A19A
        cmp  #$47                       ; A19D
        bne  loc_A1A9                   ; A19F
        ; static (not seen in traces)
        lda  #$08                       ; A1A1
        sta  panel_type                 ; A1A3
        jmp  panel_init_A48E            ; A1A6
loc_A1A9:
        lda  lcd_id1                    ; A1A9
        cmp  #$75                       ; A1AC
        bne  loc_A1B8                   ; A1AE
        ; static (not seen in traces)
        lda  #$1D                       ; A1B0
        sta  panel_type                 ; A1B2
        jmp  panel_init_A49E            ; A1B5
loc_A1B8:
        lda  lcd_id0                    ; A1B8
        cmp  #$01                       ; A1BB
        bne  loc_A1CE                   ; A1BD
        ; static (not seen in traces)
        lda  lcd_id1                    ; A1BF
        cmp  #$39                       ; A1C2
        bne  loc_A1CE                   ; A1C4
        lda  #$0E                       ; A1C6
        sta  panel_type                 ; A1C8
        jmp  panel_init_A3AE            ; A1CB
loc_A1CE:
        lda  lcd_id0                    ; A1CE
        and  #$0F                       ; A1D1
        cmp  #$05                       ; A1D3
        bne  loc_A1E6                   ; A1D5
        ; static (not seen in traces)
        lda  lcd_id1                    ; A1D7
        cmp  #$35                       ; A1DA
        bne  loc_A1E6                   ; A1DC
        lda  #$0F                       ; A1DE
        sta  panel_type                 ; A1E0
        jmp  panel_init_A3BE            ; A1E3
loc_A1E6:
        lda  lcd_id0                    ; A1E6
        and  #$0F                       ; A1E9
        cmp  #$05                       ; A1EB
        bne  loc_A210                   ; A1ED
        ; static (not seen in traces)
        lda  lcd_id1                    ; A1EF
        cmp  #$05                       ; A1F2
        bne  loc_A210                   ; A1F4
        jsr  lcd_read_id_cmd28          ; A1F6
        lda  lcd_id2                    ; A1F9
        cmp  #$0F                       ; A1FC
        beq  loc_A208                   ; A1FE
        lda  #$11                       ; A200
        sta  panel_type                 ; A202
        jmp  panel_init_A46E            ; A205
loc_A208:
        lda  #$12                       ; A208
        sta  panel_type                 ; A20A
        jmp  panel_init_A47E            ; A20D
loc_A210:
        lda  lcd_id0                    ; A210
        and  #$0F                       ; A213
        cmp  #$05                       ; A215
        bne  loc_A228                   ; A217
        ; static (not seen in traces)
        lda  lcd_id1                    ; A219
        cmp  #$31                       ; A21C
        bne  loc_A228                   ; A21E
        lda  #$10                       ; A220
        sta  panel_type                 ; A222
        jmp  panel_init_A3CE            ; A225
loc_A228:
        lda  lcd_id0                    ; A228
        and  #$0F                       ; A22B
        cmp  #$09                       ; A22D
        bne  loc_A240                   ; A22F
        ; static (not seen in traces)
        lda  lcd_id1                    ; A231
        cmp  #$89                       ; A234
        bne  loc_A240                   ; A236
        lda  #$13                       ; A238
        sta  panel_type                 ; A23A
        jmp  panel_init_A3EE            ; A23D
loc_A240:
        lda  lcd_id0                    ; A240
        and  #$0F                       ; A243
        cmp  #$09                       ; A245
        bne  loc_A258                   ; A247
        ; static (not seen in traces)
        lda  lcd_id1                    ; A249
        cmp  #$97                       ; A24C
        bne  loc_A258                   ; A24E
        lda  #$1A                       ; A250
        sta  panel_type                 ; A252
        jmp  panel_init_A3EE            ; A255
loc_A258:
        lda  lcd_id0                    ; A258
        and  #$0F                       ; A25B
        cmp  #$04                       ; A25D
        bne  loc_A270                   ; A25F
        ; static (not seen in traces)
        lda  lcd_id1                    ; A261
        cmp  #$08                       ; A264
        bne  loc_A270                   ; A266
        lda  #$14                       ; A268
        sta  panel_type                 ; A26A
        jmp  panel_init_A3FE            ; A26D
loc_A270:
        lda  lcd_id0                    ; A270
        cmp  #$01                       ; A273
        bne  loc_A286                   ; A275
        ; static (not seen in traces)
        lda  lcd_id1                    ; A277
        cmp  #$54                       ; A27A
        bne  loc_A286                   ; A27C
        lda  #$16                       ; A27E
        sta  panel_type                 ; A280
        jmp  panel_init_A3DE            ; A283
loc_A286:
        lda  lcd_id0                    ; A286
        and  #$0F                       ; A289
        cmp  #$05                       ; A28B
        bne  loc_A29E                   ; A28D
        ; static (not seen in traces)
        lda  lcd_id1                    ; A28F
        cmp  #$80                       ; A292
        bne  loc_A29E                   ; A294
        lda  #$17                       ; A296
        sta  panel_type                 ; A298
        jmp  panel_init_A42E            ; A29B
loc_A29E:
        lda  lcd_id0                    ; A29E
        and  #$0F                       ; A2A1
        cmp  #$07                       ; A2A3
        bne  loc_A2B6                   ; A2A5
        ; static (not seen in traces)
        lda  lcd_id1                    ; A2A7
        cmp  #$83                       ; A2AA
        bne  loc_A2B6                   ; A2AC
        lda  #$18                       ; A2AE
        sta  panel_type                 ; A2B0
        jmp  panel_init_A44E            ; A2B3
loc_A2B6:
        lda  lcd_id0                    ; A2B6
        and  #$0F                       ; A2B9
        cmp  #$03                       ; A2BB
        bne  loc_A2CE                   ; A2BD
        ; static (not seen in traces)
        lda  lcd_id1                    ; A2BF
        cmp  #$35                       ; A2C2
        bne  loc_A2CE                   ; A2C4
        lda  #$19                       ; A2C6
        sta  panel_type                 ; A2C8
        jmp  panel_init_A43E            ; A2CB
loc_A2CE:
        lda  lcd_id0                    ; A2CE
        and  #$0F                       ; A2D1
        cmp  #$03                       ; A2D3
        bne  loc_A2E6                   ; A2D5
        ; static (not seen in traces)
        lda  lcd_id1                    ; A2D7
        cmp  #$31                       ; A2DA
        bne  loc_A2E6                   ; A2DC
        lda  #$1F                       ; A2DE
        sta  panel_type                 ; A2E0
        jmp  panel_init_A43E            ; A2E3
loc_A2E6:
        lda  #$00                       ; A2E6
        sta  panel_type                 ; A2E8
        jmp  panel_init_A2EE            ; A2EB
panel_init_A2EE:
        lda  #$EF                       ; A2EE
        sta  lcd_cmd_ptr                ; A2F0
        lda  #$A7                       ; A2F2
        sta  $F9                        ; A2F4
        lda  #$00                       ; A2F6
        sta  lcd_cmd_format             ; A2F8
        jmp  lcd_run_cmd_list           ; A2FB
panel_init_A2FE:
        ; static (not seen in traces)
        lda  #$EF                       ; A2FE
        sta  lcd_cmd_ptr                ; A300
        lda  #$A8                       ; A302
        sta  $F9                        ; A304
        lda  #$00                       ; A306
        sta  lcd_cmd_format             ; A308
        jmp  lcd_run_cmd_list           ; A30B
panel_init_A30E:
        lda  #$49                       ; A30E
        sta  lcd_cmd_ptr                ; A310
        lda  #$A9                       ; A312
        sta  $F9                        ; A314
        lda  #$00                       ; A316
        sta  lcd_cmd_format             ; A318
        jmp  lcd_run_cmd_list           ; A31B
panel_init_A31E:
        lda  #$98                       ; A31E
        sta  lcd_cmd_ptr                ; A320
        lda  #$A9                       ; A322
        sta  $F9                        ; A324
        lda  #$00                       ; A326
        sta  lcd_cmd_format             ; A328
        jmp  lcd_run_cmd_list           ; A32B
panel_init_A32E:
        lda  #$6E                       ; A32E
        sta  lcd_cmd_ptr                ; A330
        lda  #$A8                       ; A332
        sta  $F9                        ; A334
        lda  #$00                       ; A336
        sta  lcd_cmd_format             ; A338
        jmp  lcd_run_cmd_list           ; A33B
panel_init_A33E:
        .byte $A9,$10,$85,$F8,$A9,$AA,$85,$F9,$A9,$00,$8D,$14,$01,$4C,$DE,$A4 ; A33E
panel_init_A34E:
        ; static (not seen in traces)
        lda  #$BB                       ; A34E
        sta  lcd_cmd_ptr                ; A350
        lda  #$AA                       ; A352
        sta  $F9                        ; A354
        lda  #$00                       ; A356
        sta  lcd_cmd_format             ; A358
        jmp  lcd_run_cmd_list           ; A35B
panel_init_A35E:
        lda  #$55                       ; A35E
        sta  lcd_cmd_ptr                ; A360
        lda  #$AB                       ; A362
        sta  $F9                        ; A364
        lda  #$00                       ; A366
        sta  lcd_cmd_format             ; A368
        jmp  lcd_run_cmd_list           ; A36B
panel_init_A36E:
        lda  #$DD                       ; A36E
        sta  lcd_cmd_ptr                ; A370
        lda  #$AB                       ; A372
        sta  $F9                        ; A374
        lda  #$00                       ; A376
        sta  lcd_cmd_format             ; A378
        jmp  lcd_run_cmd_list           ; A37B
panel_init_A37E:
        lda  #$37                       ; A37E
        sta  lcd_cmd_ptr                ; A380
        lda  #$AE                       ; A382
        sta  $F9                        ; A384
        lda  #$01                       ; A386
        sta  lcd_cmd_format             ; A388
        jmp  lcd_run_cmd_list           ; A38B
panel_init_A38E:
        lda  #$BD                       ; A38E
        sta  lcd_cmd_ptr                ; A390
        lda  #$AE                       ; A392
        sta  $F9                        ; A394
        lda  #$01                       ; A396
        sta  lcd_cmd_format             ; A398
        jmp  lcd_run_cmd_list           ; A39B
panel_init_A39E:
        lda  #$52                       ; A39E
        sta  lcd_cmd_ptr                ; A3A0
        lda  #$AF                       ; A3A2
        sta  $F9                        ; A3A4
        lda  #$01                       ; A3A6
        sta  lcd_cmd_format             ; A3A8
        jmp  lcd_run_cmd_list           ; A3AB
panel_init_A3AE:
        lda  #$EA                       ; A3AE
        sta  lcd_cmd_ptr                ; A3B0
        lda  #$AF                       ; A3B2
        sta  $F9                        ; A3B4
        lda  #$01                       ; A3B6
        sta  lcd_cmd_format             ; A3B8
        jmp  lcd_run_cmd_list           ; A3BB
panel_init_A3BE:
        lda  #$37                       ; A3BE
        sta  lcd_cmd_ptr                ; A3C0
        lda  #$B0                       ; A3C2
        sta  $F9                        ; A3C4
        lda  #$01                       ; A3C6
        sta  lcd_cmd_format             ; A3C8
        jmp  lcd_run_cmd_list           ; A3CB
panel_init_A3CE:
        lda  #$7F                       ; A3CE
        sta  lcd_cmd_ptr                ; A3D0
        lda  #$B2                       ; A3D2
        sta  $F9                        ; A3D4
        lda  #$01                       ; A3D6
        sta  lcd_cmd_format             ; A3D8
        jmp  lcd_run_cmd_list           ; A3DB
panel_init_A3DE:
        lda  #$F0                       ; A3DE
        sta  lcd_cmd_ptr                ; A3E0
        lda  #$B2                       ; A3E2
        sta  $F9                        ; A3E4
        lda  #$01                       ; A3E6
        sta  lcd_cmd_format             ; A3E8
        jmp  lcd_run_cmd_list           ; A3EB
panel_init_A3EE:
        lda  #$64                       ; A3EE
        sta  lcd_cmd_ptr                ; A3F0
        lda  #$B3                       ; A3F2
        sta  $F9                        ; A3F4
        lda  #$01                       ; A3F6
        sta  lcd_cmd_format             ; A3F8
        jmp  lcd_run_cmd_list           ; A3FB
panel_init_A3FE:
        lda  #$E1                       ; A3FE
        sta  lcd_cmd_ptr                ; A400
        lda  #$B3                       ; A402
        sta  $F9                        ; A404
        lda  #$01                       ; A406
        sta  lcd_cmd_format             ; A408
        jmp  lcd_run_cmd_list           ; A40B
panel_init_A40E:
        .byte $A9,$97,$85,$F8,$A9,$B4,$85,$F9,$A9,$01,$8D,$14,$01,$4C,$DE,$A4 ; A40E
panel_init_A41E:
        .byte $A9,$4D,$85,$F8,$A9,$B5,$85,$F9,$A9,$01,$8D,$14,$01,$4C,$DE,$A4 ; A41E
panel_init_A42E:
        ; static (not seen in traces)
        lda  #$D6                       ; A42E
        sta  lcd_cmd_ptr                ; A430
        lda  #$B5                       ; A432
        sta  $F9                        ; A434
        lda  #$01                       ; A436
        sta  lcd_cmd_format             ; A438
        jmp  lcd_run_cmd_list           ; A43B
panel_init_A43E:
        lda  #$65                       ; A43E
        sta  lcd_cmd_ptr                ; A440
        lda  #$B6                       ; A442
        sta  $F9                        ; A444
        lda  #$01                       ; A446
        sta  lcd_cmd_format             ; A448
        jmp  lcd_run_cmd_list           ; A44B
panel_init_A44E:
        lda  #$CD                       ; A44E
        sta  lcd_cmd_ptr                ; A450
        lda  #$B6                       ; A452
        sta  $F9                        ; A454
        lda  #$01                       ; A456
        sta  lcd_cmd_format             ; A458
        jmp  lcd_run_cmd_list           ; A45B
panel_init_A45E:
        lda  #$B7                       ; A45E
        sta  lcd_cmd_ptr                ; A460
        lda  #$B0                       ; A462
        sta  $F9                        ; A464
        lda  #$01                       ; A466
        sta  lcd_cmd_format             ; A468
        jmp  lcd_run_cmd_list           ; A46B
panel_init_A46E:
        lda  #$58                       ; A46E
        sta  lcd_cmd_ptr                ; A470
        lda  #$B1                       ; A472
        sta  $F9                        ; A474
        lda  #$01                       ; A476
        sta  lcd_cmd_format             ; A478
        jmp  lcd_run_cmd_list           ; A47B
panel_init_A47E:
        lda  #$F3                       ; A47E
        sta  lcd_cmd_ptr                ; A480
        lda  #$B1                       ; A482
        sta  $F9                        ; A484
        lda  #$01                       ; A486
        sta  lcd_cmd_format             ; A488
        jmp  lcd_run_cmd_list           ; A48B
panel_init_A48E:
        lda  #$55                       ; A48E
        sta  lcd_cmd_ptr                ; A490
        lda  #$AC                       ; A492
        sta  $F9                        ; A494
        lda  #$02                       ; A496
        sta  lcd_cmd_format             ; A498
        jmp  lcd_run_cmd_list           ; A49B
panel_init_A49E:
        lda  #$D5                       ; A49E
        sta  lcd_cmd_ptr                ; A4A0
        lda  #$AC                       ; A4A2
        sta  $F9                        ; A4A4
        lda  #$02                       ; A4A6
        sta  lcd_cmd_format             ; A4A8
        jmp  lcd_run_cmd_list           ; A4AB
panel_init_A4AE:
        lda  #$57                       ; A4AE
        sta  lcd_cmd_ptr                ; A4B0
        lda  #$AD                       ; A4B2
        sta  $F9                        ; A4B4
        lda  #$02                       ; A4B6
        sta  lcd_cmd_format             ; A4B8
        jmp  lcd_run_cmd_list           ; A4BB
panel_init_A4BE:
        lda  #$CF                       ; A4BE
        sta  lcd_cmd_ptr                ; A4C0
        lda  #$AD                       ; A4C2
        sta  $F9                        ; A4C4
        lda  #$02                       ; A4C6
        sta  lcd_cmd_format             ; A4C8
        jmp  lcd_run_cmd_list           ; A4CB
        .byte $A9,$38,$85,$F8,$A9,$B7,$85,$F9,$A9,$03,$8D,$14,$01,$4C,$DE,$A4 ; A4CE
lcd_run_cmd_list:
        lda  lcd_cmd_format             ; A4DE
        cmp  #$01                       ; A4E1
        beq  loc_A4F3                   ; A4E3
        cmp  #$02                       ; A4E5
        beq  loc_A4F9                   ; A4E7
        cmp  #$03                       ; A4E9
        beq  loc_A4FF                   ; A4EB
        jsr  lcd_cmds_fmt0_fe_separated ; A4ED
        jmp  loc_A50C                   ; A4F0
loc_A4F3:
        ; static (not seen in traces)
        jsr  lcd_cmds_fmt1_reg16        ; A4F3
        jmp  loc_A50C                   ; A4F6
loc_A4F9:
        jsr  lcd_cmds_fmt2_reg8         ; A4F9
        jmp  loc_A50C                   ; A4FC
loc_A4FF:
        jsr  lcd_cmds_fmt3_raw16        ; A4FF
        nop                             ; A502
        nop                             ; A503
        nop                             ; A504
        nop                             ; A505
        jsr  lcd_set_4FF0_block_BD      ; A506
        jmp  loc_A513                   ; A509
loc_A50C:
        nop                             ; A50C
        nop                             ; A50D
        nop                             ; A50E
        nop                             ; A50F
        jsr  lcd_set_4FF0_block_B7      ; A510
loc_A513:
        lda  PPU_STATUS                 ; A513
        and  #$80                       ; A516
        beq  loc_A513                   ; A518
loc_A51A:
        lda  PPU_STATUS                 ; A51A
        and  #$80                       ; A51D
        beq  loc_A51A                   ; A51F
        lda  #$81                       ; A521
        sta  REG_4FF6                   ; A523
        rts                             ; A526
lcd_cmds_fmt0_fe_separated:
        ldy  #$00                       ; A527
loc_A529:
        lda  (lcd_cmd_ptr),y            ; A529
        jsr  lcd_send_cmd               ; A52B
        iny                             ; A52E
loc_A52F:
        lda  (lcd_cmd_ptr),y            ; A52F
        cmp  #$FE                       ; A531
        beq  loc_A540                   ; A533
        cmp  #$FF                       ; A535
        beq  loc_A544                   ; A537
        jsr  lcd_send_data              ; A539
        iny                             ; A53C
        jmp  loc_A52F                   ; A53D
loc_A540:
        iny                             ; A540
        jmp  loc_A529                   ; A541
loc_A544:
        rts                             ; A544
lcd_cmds_fmt1_reg16:
        ; static (not seen in traces)
        ldy  #$00                       ; A545
loc_A547:
        lda  (lcd_cmd_ptr),y            ; A547
        cmp  #$FF                       ; A549
        beq  loc_A563                   ; A54B
        jsr  lcd_send_cmd               ; A54D
        iny                             ; A550
        lda  (lcd_cmd_ptr),y            ; A551
        sta  REG_4FF8                   ; A553
        iny                             ; A556
        lda  (lcd_cmd_ptr),y            ; A557
        sta  REG_4FF7                   ; A559
        jsr  lcd_data_strobe            ; A55C
        iny                             ; A55F
        jmp  loc_A547                   ; A560
loc_A563:
        iny                             ; A563
        lda  (lcd_cmd_ptr),y            ; A564
        cmp  #$FF                       ; A566
        beq  loc_A572                   ; A568
        tax                             ; A56A
        jsr  delay_long                 ; A56B
        iny                             ; A56E
        jmp  loc_A547                   ; A56F
loc_A572:
        lda  #$22                       ; A572
        jsr  lcd_send_cmd               ; A574
        rts                             ; A577
lcd_cmds_fmt2_reg8:
        ldy  #$00                       ; A578
loc_A57A:
        lda  (lcd_cmd_ptr),y            ; A57A
        cmp  #$FF                       ; A57C
        beq  loc_A58D                   ; A57E
        jsr  lcd_send_cmd               ; A580
        iny                             ; A583
        lda  (lcd_cmd_ptr),y            ; A584
        jsr  lcd_send_data              ; A586
        iny                             ; A589
        jmp  loc_A57A                   ; A58A
loc_A58D:
        iny                             ; A58D
        lda  (lcd_cmd_ptr),y            ; A58E
        cmp  #$FF                       ; A590
        beq  loc_A59C                   ; A592
        tax                             ; A594
        jsr  delay_long                 ; A595
        iny                             ; A598
        jmp  loc_A57A                   ; A599
loc_A59C:
        lda  #$22                       ; A59C
        jsr  lcd_send_cmd               ; A59E
        rts                             ; A5A1
lcd_cmds_fmt3_raw16:
        ldy  #$00                       ; A5A2
loc_A5A4:
        lda  (lcd_cmd_ptr),y            ; A5A4
        cmp  #$FF                       ; A5A6
        beq  loc_A5BF                   ; A5A8
        sta  REG_4FF8                   ; A5AA
        iny                             ; A5AD
        lda  (lcd_cmd_ptr),y            ; A5AE
        sta  REG_4FF7                   ; A5B0
        jsr  lcd_cmd_strobe             ; A5B3
        lda  #$51                       ; A5B6
        sta  REG_4FF0                   ; A5B8
        iny                             ; A5BB
        jmp  loc_A5A4                   ; A5BC
loc_A5BF:
        iny                             ; A5BF
        lda  (lcd_cmd_ptr),y            ; A5C0
        cmp  #$FF                       ; A5C2
        beq  loc_A5CE                   ; A5C4
        tax                             ; A5C6
        jsr  delay_long                 ; A5C7
        iny                             ; A5CA
        jmp  loc_A5A4                   ; A5CB
loc_A5CE:
        rts                             ; A5CE
lcd_reset_pulse:
        lda  #$DC                       ; A5CF
        sta  REG_412D                   ; A5D1
        lda  #$C1                       ; A5D4
        sta  REG_4FF6                   ; A5D6
        lda  #$71                       ; A5D9
        sta  REG_4FF0                   ; A5DB
        lda  #$02                       ; A5DE
        sta  REG_4139                   ; A5E0
        lda  #$FF                       ; A5E3
        sta  REG_410F                   ; A5E5
        jsr  delay_long                 ; A5E8
        lda  #$DF                       ; A5EB
        sta  REG_410F                   ; A5ED
        jsr  delay_long                 ; A5F0
        lda  #$FF                       ; A5F3
        sta  REG_410F                   ; A5F5
        jsr  delay_long                 ; A5F8
        rts                             ; A5FB
lcd_set_4FF0_block_B7:
        lda  #$B7                       ; A5FC
        sta  REG_4FF0                   ; A5FE
        lda  #$FF                       ; A601
        sta  REG_4FF1                   ; A603
        lda  #$A4                       ; A606
        sta  REG_4FF2                   ; A608
        lda  #$5A                       ; A60B
        sta  REG_4FF3                   ; A60D
        lda  #$9A                       ; A610
        sta  REG_4FF4                   ; A612
        lda  #$FE                       ; A615
        sta  REG_4FF5                   ; A617
        lda  #$0E                       ; A61A
        sta  REG_4FFA                   ; A61C
        rts                             ; A61F
lcd_set_4FF0_block_BD:
        ; static (not seen in traces)
        lda  #$BD                       ; A620
        sta  REG_4FF0                   ; A622
        lda  #$FF                       ; A625
        sta  REG_4FF1                   ; A627
        lda  #$52                       ; A62A
        sta  REG_4FF2                   ; A62C
        lda  #$58                       ; A62F
        sta  REG_4FF3                   ; A631
        lda  #$98                       ; A634
        sta  REG_4FF4                   ; A636
        lda  #$FD                       ; A639
        sta  REG_4FF5                   ; A63B
        lda  #$0D                       ; A63E
        sta  REG_4FFA                   ; A640
        rts                             ; A643
lcd_send_cmd:
        sta  REG_4FF7                   ; A644
        lda  #$00                       ; A647
        sta  REG_4FF8                   ; A649
lcd_cmd_strobe:
        lda  #$51                       ; A64C
        sta  REG_4FF0                   ; A64E
        lda  #$11                       ; A651
        sta  REG_4FF0                   ; A653
        lda  #$11                       ; A656
        sta  REG_4FF0                   ; A658
        lda  #$01                       ; A65B
        sta  REG_4FF0                   ; A65D
        lda  #$01                       ; A660
        sta  REG_4FF0                   ; A662
        lda  #$01                       ; A665
        sta  REG_4FF0                   ; A667
        lda  #$01                       ; A66A
        sta  REG_4FF0                   ; A66C
        lda  #$11                       ; A66F
        sta  REG_4FF0                   ; A671
        lda  #$11                       ; A674
        sta  REG_4FF0                   ; A676
        rts                             ; A679
lcd_send_data:
        sta  REG_4FF7                   ; A67A
        lda  #$00                       ; A67D
        sta  REG_4FF8                   ; A67F
lcd_data_strobe:
        lda  #$31                       ; A682
        sta  REG_4FF0                   ; A684
        lda  #$21                       ; A687
        sta  REG_4FF0                   ; A689
        lda  #$21                       ; A68C
        sta  REG_4FF0                   ; A68E
        lda  #$21                       ; A691
        sta  REG_4FF0                   ; A693
        lda  #$21                       ; A696
        sta  REG_4FF0                   ; A698
        lda  #$31                       ; A69B
        sta  REG_4FF0                   ; A69D
        lda  #$31                       ; A6A0
        sta  REG_4FF0                   ; A6A2
        lda  #$31                       ; A6A5
        sta  REG_4FF0                   ; A6A7
        lda  #$31                       ; A6AA
        sta  REG_4FF0                   ; A6AC
        lda  #$71                       ; A6AF
        sta  REG_4FF0                   ; A6B1
        rts                             ; A6B4
lcd_read_byte:
        lda  #$31                       ; A6B5
        sta  REG_4FF0                   ; A6B7
        lda  #$02                       ; A6BA
        sta  REG_4139                   ; A6BC
        lda  #$02                       ; A6BF
        sta  REG_4139                   ; A6C1
        lda  #$00                       ; A6C4
        sta  REG_4139                   ; A6C6
        lda  #$00                       ; A6C9
        sta  REG_4139                   ; A6CB
        lda  REG_4135                   ; A6CE
        rts                             ; A6D1
lcd_read_word:
        lda  #$31                       ; A6D2
        sta  REG_4FF0                   ; A6D4
        lda  #$02                       ; A6D7
        sta  REG_4139                   ; A6D9
        lda  #$02                       ; A6DC
        sta  REG_4139                   ; A6DE
        lda  #$00                       ; A6E1
        sta  REG_4139                   ; A6E3
        lda  #$00                       ; A6E6
        sta  REG_4139                   ; A6E8
        ldx  REG_4136                   ; A6EB
        lda  #$02                       ; A6EE
        sta  REG_4139                   ; A6F0
        lda  #$02                       ; A6F3
        sta  REG_4139                   ; A6F5
        lda  #$00                       ; A6F8
        sta  REG_4139                   ; A6FA
        lda  #$00                       ; A6FD
        sta  REG_4139                   ; A6FF
        lda  REG_4135                   ; A702
        rts                             ; A705
lcd_read_id_cmd00:
        lda  #$00                       ; A706
        jmp  lcd_read_id_2              ; A708
lcd_read_id_cmd67:
        lda  #$67                       ; A70B
        jmp  lcd_read_id_2              ; A70D
        .byte $A9,$F4 ; A710
lcd_read_id_2:
        jsr  lcd_send_cmd               ; A712
        lda  #$FC                       ; A715
        sta  REG_412D                   ; A717
        jsr  lcd_read_word              ; A71A
        stx  lcd_id0                    ; A71D
        sta  lcd_id1                    ; A720
        lda  #$02                       ; A723
        sta  REG_4139                   ; A725
        lda  #$71                       ; A728
        sta  REG_4FF0                   ; A72A
        lda  #$DC                       ; A72D
        sta  REG_412D                   ; A72F
        rts                             ; A732
lcd_read_id_cmdCD:
        ; static (not seen in traces)
        lda  #$CD                       ; A733
        jmp  lcd_read_id_1              ; A735
lcd_read_id_cmd28:
        lda  #$28                       ; A738
        jmp  lcd_read_id_1              ; A73A
lcd_read_id_1:
        jsr  lcd_send_cmd               ; A73D
        lda  #$FC                       ; A740
        sta  REG_412D                   ; A742
        jsr  lcd_read_word              ; A745
        sta  lcd_id2                    ; A748
        lda  #$02                       ; A74B
        sta  REG_4139                   ; A74D
        lda  #$71                       ; A750
        sta  REG_4FF0                   ; A752
        lda  #$DC                       ; A755
        sta  REG_412D                   ; A757
        rts                             ; A75A
lcd_read_id_cmd04:
        lda  #$04                       ; A75B
        jmp  lcd_read_id_3              ; A75D
lcd_read_id_cmdD3:
        lda  #$D3                       ; A760
        jmp  lcd_read_id_3              ; A762
lcd_read_id_cmdD5:
        lda  #$D5                       ; A765
        jmp  lcd_read_id_3              ; A767
lcd_read_id_3:
        jsr  lcd_send_cmd               ; A76A
        lda  #$FC                       ; A76D
        sta  REG_412D                   ; A76F
        jsr  lcd_read_byte              ; A772
        jsr  lcd_read_byte              ; A775
        sta  lcd_id0                    ; A778
        jsr  lcd_read_byte              ; A77B
        sta  lcd_id1                    ; A77E
        jsr  lcd_read_byte              ; A781
        sta  lcd_id2                    ; A784
        lda  #$02                       ; A787
        sta  REG_4139                   ; A789
        lda  #$71                       ; A78C
        sta  REG_4FF0                   ; A78E
        lda  #$DC                       ; A791
        sta  REG_412D                   ; A793
        rts                             ; A796
lcd_read_id_cmd0A_F1:
        lda  #$0A                       ; A797
        jsr  lcd_send_cmd               ; A799
        lda  #$FC                       ; A79C
        sta  REG_412D                   ; A79E
        jsr  lcd_read_byte              ; A7A1
        jsr  lcd_read_byte              ; A7A4
        sta  lcd_id0                    ; A7A7
        lda  #$02                       ; A7AA
        sta  REG_4139                   ; A7AC
        lda  #$71                       ; A7AF
        sta  REG_4FF0                   ; A7B1
        lda  #$DC                       ; A7B4
        sta  REG_412D                   ; A7B6
        lda  #$F1                       ; A7B9
        jsr  lcd_send_cmd               ; A7BB
        lda  #$FC                       ; A7BE
        sta  REG_412D                   ; A7C0
        jsr  lcd_read_byte              ; A7C3
        jsr  lcd_read_byte              ; A7C6
        sta  lcd_id1                    ; A7C9
        lda  #$02                       ; A7CC
        sta  REG_4139                   ; A7CE
        lda  #$71                       ; A7D1
        sta  REG_4FF0                   ; A7D3
        lda  #$DC                       ; A7D6
        sta  REG_412D                   ; A7D8
        rts                             ; A7DB
delay_long:
        txa                             ; A7DC
        pha                             ; A7DD
        tya                             ; A7DE
        pha                             ; A7DF
        ldx  #$00                       ; A7E0
        ldy  #$00                       ; A7E2
loc_A7E4:
        dex                             ; A7E4
        bne  loc_A7E4                   ; A7E5
        dey                             ; A7E7
        bne  loc_A7E4                   ; A7E8
        pla                             ; A7EA
        tay                             ; A7EB
        pla                             ; A7EC
        tax                             ; A7ED
        rts                             ; A7EE
lcd_cmds_A7EF:
        .byte $FE,$FE,$EF,$FE,$36,$28,$FE,$3A,$05,$FE,$A4,$44,$44,$FE,$A5,$42 ; A7EF
        .byte $42,$FE,$AA,$88,$88,$FE,$E8,$11,$0B,$FE,$E3,$01,$10,$FE,$FF,$61 ; A7FF
        .byte $FE,$AC,$00,$FE,$AD,$33,$FE,$AE,$2B,$FE,$AF,$55,$FE,$A6,$2A,$2A ; A80F
        .byte $FE,$A7,$2B,$2B,$FE,$A8,$00,$00,$FE,$A9,$2A,$2A,$FE,$2A,$00,$00 ; A81F
        .byte $01,$3F,$FE,$2B,$00,$00,$00,$EF,$FE,$F0,$02,$00,$00,$00,$00,$01 ; A82F
        .byte $FE,$F1,$01,$01,$00,$00,$0E,$17,$FE,$F2,$00,$04,$1E,$06,$05,$30 ; A83F
        .byte $FE,$F3,$18,$0D,$52,$04,$03,$64,$FE,$F4,$0E,$1B,$19,$03,$05,$0F ; A84F
        .byte $FE,$F5,$06,$12,$12,$34,$33,$0F,$FE,$11,$FE,$29,$FE,$2C,$FF ; A85F
lcd_cmds_A86E:
        .byte $3A,$55,$FE,$B4,$80,$FE,$B7,$FD,$42,$04,$44,$04,$02,$04,$FE,$BA ; A86E
        .byte $1B,$13,$20,$FE,$BB,$74,$66,$33,$FE,$CD,$20,$20,$00,$FE,$E8,$11 ; A87E
        .byte $11,$33,$33,$55,$FE,$E9,$40,$84,$65,$30,$C0,$00,$FD,$33,$88,$FE ; A88E
        .byte $EA,$02,$52,$18,$E2,$04,$00,$00,$FE,$F2,$00,$80,$FE,$F5,$BB,$FE ; A89E
        .byte $BC,$00,$10,$00,$10,$0B,$FE,$BC,$09,$FE,$E4,$00,$05,$0D,$06,$15 ; A8AE
        .byte $08,$39,$66,$49,$04,$0D,$0B,$1A,$1E,$0F,$FE,$E5,$00,$05,$0D,$07 ; A8BE
        .byte $15,$08,$39,$56,$48,$05,$0D,$0C,$1A,$1D,$0F,$FE,$36,$60,$FE,$2A ; A8CE
        .byte $00,$00,$01,$3F,$FE,$2B,$00,$00,$00,$EF,$FE,$11,$FE,$29,$FE,$2C ; A8DE
        .byte $FF ; A8EE
lcd_cmds_A8EF:
        .byte $11,$FE,$36,$60,$FE,$3A,$55,$FE,$B2,$0C,$0C,$00,$33,$33,$FE,$B7 ; A8EF
        .byte $35,$FE,$BB,$19,$FE,$C0,$2C,$FE,$C2,$01,$FE,$C3,$12,$FE,$C4,$20 ; A8FF
        .byte $FE,$C6,$0F,$FE,$D0,$A4,$A1,$FE,$E0,$D0,$04,$0D,$11,$13,$2B,$3F ; A90F
        .byte $54,$4C,$18,$0D,$0B,$1F,$23,$FE,$E1,$D0,$04,$0C,$11,$13,$2C,$3F ; A91F
        .byte $44,$51,$2F,$1F,$1F,$20,$23,$FE,$2A,$00,$00,$01,$3F,$FE,$2B,$00 ; A92F
        .byte $00,$00,$EF,$FE,$11,$FE,$29,$FE,$2C,$FF ; A93F
lcd_cmds_A949:
        .byte $3A,$05,$FE,$36,$28,$FE,$FE,$FE,$EF,$FE,$E9,$20,$FE,$A3,$0C,$FE ; A949
        .byte $A4,$93,$FE,$FF,$13,$FE,$FD,$1A,$FE,$F0,$00,$FE,$F1,$55,$FE,$F2 ; A959
        .byte $04,$FE,$F3,$52,$FE,$F4,$01,$FE,$F5,$00,$FE,$F7,$37,$FE,$F8,$22 ; A969
        .byte $FE,$F9,$77,$FE,$FA,$25,$FE,$FB,$00,$FE,$FC,$02,$FE,$2A,$00,$00 ; A979
        .byte $01,$3F,$FE,$2B,$00,$00,$00,$EF,$FE,$11,$FE,$29,$FE,$2C,$FF ; A989
lcd_cmds_A998:
        .byte $EF,$03,$80,$02,$FE,$CF,$00,$BA,$B0,$FE,$ED,$67,$03,$12,$81,$FE ; A998
        .byte $E8,$85,$11,$79,$FE,$CB,$39,$2C,$00,$34,$06,$FE,$F7,$20,$FE,$EA ; A9A8
        .byte $00,$00,$FE,$C0,$1D,$FE,$C1,$12,$FE,$C5,$44,$3C,$FE,$C7,$9E,$FE ; A9B8
        .byte $3A,$55,$FE,$36,$68,$FE,$B1,$00,$17,$FE,$B6,$0A,$A2,$FE,$F2,$00 ; A9C8
        .byte $FE,$26,$01,$FE,$E0,$0F,$22,$1C,$1B,$08,$0F,$48,$B8,$34,$05,$0C ; A9D8
        .byte $09,$0F,$07,$00,$FE,$E1,$00,$23,$24,$07,$10,$07,$38,$47,$4B,$0A ; A9E8
        .byte $13,$06,$30,$38,$0F,$FE,$11,$FE,$29,$FE,$2A,$00,$00,$01,$3F,$FE ; A9F8
        .byte $2B,$00,$00,$00,$EF,$FE,$2C,$FF ; AA08
lcd_cmds_AA10:
        .byte $B0,$3F,$3F,$FE,$B3,$02,$00,$00,$00,$00,$FE,$B4,$00,$FE,$C0,$33 ; AA10
        .byte $4F,$00,$10,$A2,$00,$01,$00,$FE,$C1,$01,$02,$1B,$08,$08,$FE,$C3 ; AA20
        .byte $01,$00,$1B,$08,$08,$FE,$C4,$11,$01,$23,$04,$00,$C5,$10,$3C,$FE ; AA30
        .byte $C8,$05,$0C,$0B,$14,$16,$0E,$06,$08,$08,$10,$00,$08,$08,$06,$0E ; AA40
        .byte $16,$14,$0B,$0C,$05,$05,$00,$FE,$C9,$05,$0C,$0B,$14,$16,$0E,$06 ; AA50
        .byte $08,$08,$10,$00,$08,$08,$06,$0E,$16,$14,$0B,$0C,$05,$05,$00,$FE ; AA60
        .byte $CA,$05,$0C,$0B,$14,$16,$0E,$06,$08,$08,$10,$00,$08,$08,$06,$0E ; AA70
        .byte $16,$14,$0B,$0C,$05,$05,$00,$FE,$D0,$33,$53,$87,$3B,$30,$00,$FE ; AA80
        .byte $D1,$25,$57,$10,$FE,$D2,$03,$24,$FE,$D4,$03,$24,$FE,$E2,$3F,$FE ; AA90
        .byte $35,$00,$FE,$36,$68,$FE,$3A,$55,$FE,$2A,$00,$00,$01,$3F,$FE,$2B ; AAA0
        .byte $00,$00,$00,$EF,$FE,$11,$FE,$29,$FE,$2C,$FF ; AAB0
lcd_cmds_AABB:
        .byte $FD,$06,$07,$FE,$66,$80,$FE,$80,$05,$FE,$80,$01,$FE,$B6,$02,$A2 ; AABB
        .byte $FE,$36,$68,$FE,$3A,$65,$FE,$60,$22,$FE,$63,$08,$FE,$64,$0C,$FE ; AACB
        .byte $68,$70,$FE,$69,$1F,$FE,$6A,$C4,$FE,$6B,$3F,$FE,$6C,$16,$FE,$6D ; AADB
        .byte $77,$FE,$6E,$84,$FE,$6F,$48,$FE,$F7,$10,$FE,$70,$44,$FE,$F6,$01 ; AAEB
        .byte $10,$80,$FE,$ED,$F9,$F9,$00,$00,$11,$00,$FE,$E0,$10,$19,$0D,$1A ; AAFB
        .byte $07,$13,$14,$FE,$E1,$2B,$5F,$FE,$E2,$1B,$28,$28,$18,$15,$17,$FE ; AB0B
        .byte $E3,$10,$17,$05,$13,$08,$13,$06,$FE,$E4,$0B,$50,$FE,$E5,$17,$24 ; AB1B
        .byte $15,$17,$17,$1F,$FE,$67,$07,$FE,$B1,$00,$12,$FE,$EC,$33,$11,$11 ; AB2B
        .byte $00,$18,$18,$FE,$FD,$FA,$FB,$FE,$2A,$00,$00,$01,$3F,$FE,$2B,$00 ; AB3B
        .byte $00,$00,$EF,$FE,$11,$FE,$29,$FE,$2C,$FF ; AB4B
lcd_cmds_AB55:
        .byte $11,$FE,$06,$FE,$07,$FE,$B1,$00,$12,$FE,$B4,$02,$FE,$B6,$00,$A0 ; AB55
        .byte $27,$00,$FE,$C0,$11,$FE,$C1,$51,$DD,$75,$FE,$CA,$21,$FE,$CB,$03 ; AB65
        .byte $FE,$C4,$00,$FE,$C5,$03,$FE,$C6,$00,$FE,$C7,$06,$FE,$C8,$34,$FE ; AB75
        .byte $CC,$0E,$FE,$CD,$05,$FE,$CE,$00,$FE,$CF,$00,$FE,$F9,$15,$15,$FE ; AB85
        .byte $F3,$0A,$02,$0A,$FE,$F6,$01,$10,$00,$FE,$E0,$63,$FE,$E1,$15,$FE ; AB95
        .byte $E2,$77,$FE,$E3,$03,$FE,$E4,$80,$FE,$E5,$E0,$FE,$E6,$00,$FE,$E7 ; ABA5
        .byte $36,$FE,$08,$03,$FE,$E9,$60,$FE,$EA,$E0,$FE,$EB,$80,$FE,$FA,$FE ; ABB5
        .byte $FB,$FE,$36,$68,$FE,$3A,$05,$FE,$2A,$00,$00,$01,$3F,$FE,$2B,$00 ; ABC5
        .byte $00,$00,$EF,$FE,$29,$FE,$2C,$FF ; ABD5
lcd_cmds_ABDD:
        .byte $11,$FE,$F0,$5A,$5A,$FE,$D9,$00,$5A,$FE,$F3,$80,$2E,$00,$0A,$44 ; ABDD
        .byte $55,$55,$FE,$F4,$60,$60,$7F,$7F,$44,$FE,$F2,$0D,$16,$03,$08,$07 ; ABED
        .byte $08,$07,$20,$00,$19,$16,$FE,$F5,$10,$00,$06,$05,$30,$14,$FE,$F7 ; ABFD
        .byte $06,$03,$04,$0A,$10,$1A,$22,$2C,$13,$12,$1D,$11,$02,$22,$22,$FE ; AC0D
        .byte $F9,$06,$03,$04,$0A,$10,$1A,$22,$2C,$13,$12,$1D,$11,$02,$22,$22 ; AC1D
        .byte $FE,$FB,$06,$03,$04,$0A,$10,$1A,$22,$2C,$13,$12,$1D,$11,$02,$22 ; AC2D
        .byte $22,$FE,$3A,$55,$FE,$36,$28,$FE,$2A,$00,$00,$01,$3F,$FE,$2B,$00 ; AC3D
        .byte $00,$00,$EF,$FE,$29,$FE,$2C,$FF ; AC4D
lcd_cmds_AC55:
        .byte $2E,$79,$EE,$0C,$EA,$00,$EB,$20,$EC,$0C,$ED,$C4,$E8,$40,$E9,$38 ; AC55
        .byte $F1,$01,$F2,$10,$27,$A3,$40,$00,$41,$00,$42,$01,$43,$13,$44,$10 ; AC65
        .byte $45,$26,$46,$08,$47,$51,$48,$02,$49,$12,$4A,$18,$4B,$19,$4C,$14 ; AC75
        .byte $50,$19,$51,$2F,$52,$2C,$53,$3E,$54,$3F,$55,$3F,$56,$2E,$57,$77 ; AC85
        .byte $58,$0B,$59,$06,$5A,$07,$5B,$0D,$5C,$1D,$5D,$CC,$1B,$1B,$1A,$01 ; AC95
        .byte $24,$2F,$25,$57,$23,$86,$18,$36,$19,$01,$01,$00,$1F,$88,$1F,$80 ; ACA5
        .byte $1F,$90,$1F,$D0,$17,$05,$36,$00,$28,$38,$28,$3C,$16,$68,$02,$00 ; ACB5
        .byte $03,$00,$04,$01,$05,$3F,$06,$00,$07,$00,$08,$00,$09,$EF,$FF,$FF ; ACC5
lcd_cmds_ACD5:
        .byte $2E,$79,$EE,$0C,$EA,$00,$EB,$20,$EC,$CC,$ED,$FC,$E8,$FE,$E9,$38 ; ACD5
        .byte $F1,$01,$F2,$10,$27,$A3,$40,$01,$41,$07,$42,$07,$43,$13,$44,$12 ; ACE5
        .byte $45,$27,$46,$14,$47,$56,$48,$09,$49,$14,$4A,$17,$4B,$18,$4C,$16 ; ACF5
        .byte $50,$18,$51,$2D,$52,$2C,$53,$38,$54,$38,$55,$3E,$56,$29,$57,$6B ; AD05
        .byte $58,$09,$59,$07,$5A,$08,$5B,$0B,$5C,$16,$5D,$CC,$1B,$1B,$1A,$01 ; AD15
        .byte $24,$1D,$25,$59,$23,$7F,$18,$37,$19,$01,$01,$00,$1F,$88,$1F,$80 ; AD25
        .byte $1F,$90,$1F,$D0,$16,$28,$17,$05,$36,$00,$28,$38,$28,$3C,$60,$08 ; AD35
        .byte $02,$00,$03,$00,$04,$01,$05,$3F,$06,$00,$07,$00,$08,$00,$09,$EF ; AD45
        .byte $FF,$FF ; AD55
lcd_cmds_AD57:
        .byte $46,$95,$47,$51,$48,$00,$49,$36,$4A,$11,$4B,$66,$4C,$14,$4D,$77 ; AD57
        .byte $4E,$13,$4F,$4C,$50,$36,$51,$46,$02,$00,$03,$00,$04,$01,$05,$3F ; AD67
        .byte $06,$00,$07,$00,$08,$00,$09,$EF,$01,$06,$16,$A8,$18,$00,$23,$95 ; AD77
        .byte $24,$95,$25,$FF,$27,$06,$28,$06,$29,$06,$2A,$06,$2C,$06,$2D,$06 ; AD87
        .byte $3A,$01,$3B,$00,$3C,$F0,$3D,$00,$35,$38,$36,$78,$3E,$38,$40,$0F ; AD97
        .byte $41,$F0,$19,$49,$93,$0C,$20,$40,$1D,$07,$1E,$00,$1F,$04,$44,$40 ; ADA7
        .byte $45,$11,$1C,$04,$1B,$18,$1B,$10,$43,$80,$90,$7F,$26,$04,$26,$24 ; ADB7
        .byte $26,$2C,$26,$3C,$21,$00,$FF,$FF ; ADC7
lcd_cmds_ADCF:
        .byte $46,$22,$47,$22,$48,$20,$49,$35,$4A,$00,$4B,$77,$4C,$24,$4D,$75 ; ADCF
        .byte $4E,$12,$4F,$28,$50,$24,$51,$44,$02,$00,$03,$00,$04,$01,$05,$3F ; ADDF
        .byte $06,$00,$07,$00,$08,$00,$09,$EF,$01,$06,$16,$A8,$23,$95,$24,$95 ; ADEF
        .byte $25,$FF,$28,$02,$29,$02,$2A,$02,$2B,$02,$2C,$02,$2D,$02,$3A,$01 ; ADFF
        .byte $3B,$01,$3C,$F0,$3D,$00,$19,$41,$20,$00,$1D,$07,$1E,$00,$1F,$03 ; AE0F
        .byte $44,$30,$45,$0E,$1C,$04,$1B,$18,$1B,$10,$43,$80,$30,$08,$26,$04 ; AE1F
        .byte $26,$24,$26,$2C,$26,$3C,$FF,$FF ; AE2F
lcd_cmds_AE37:
        .byte $01,$01,$00,$02,$07,$00,$03,$10,$28,$04,$00,$00,$08,$02,$02,$09 ; AE37
        .byte $00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00,$00,$0F,$00,$00,$10,$00 ; AE47
        .byte $00,$11,$00,$07,$12,$00,$00,$13,$00,$00,$07,$00,$01,$07,$00,$20 ; AE57
        .byte $10,$14,$90,$11,$02,$27,$12,$00,$8F,$13,$0A,$00,$29,$00,$10,$2B ; AE67
        .byte $00,$0D,$20,$00,$EF,$21,$00,$00,$30,$00,$00,$31,$06,$05,$32,$00 ; AE77
        .byte $05,$35,$04,$03,$36,$02,$00,$37,$02,$07,$38,$02,$01,$39,$07,$07 ; AE87
        .byte $3C,$03,$04,$3D,$00,$02,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53 ; AE97
        .byte $01,$3F,$60,$A7,$00,$61,$00,$01,$6A,$00,$00,$90,$00,$10,$92,$00 ; AEA7
        .byte $00,$07,$01,$33,$FF,$FF ; AEB7
lcd_cmds_AEBD:
        .byte $01,$00,$00,$02,$07,$00,$03,$10,$38,$04,$00,$00,$08,$02,$02,$09 ; AEBD
        .byte $00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00,$00,$0F,$00,$00,$10,$00 ; AECD
        .byte $00,$11,$00,$07,$12,$00,$00,$13,$00,$00,$07,$00,$01,$10,$12,$90 ; AEDD
        .byte $11,$02,$27,$12,$00,$1B,$13,$15,$00,$29,$00,$02,$2B,$00,$0E,$20 ; AEED
        .byte $00,$EF,$21,$01,$3E,$30,$00,$00,$31,$04,$06,$32,$00,$04,$35,$03 ; AEFD
        .byte $05,$36,$00,$04,$37,$02,$07,$38,$01,$03,$39,$07,$07,$3C,$05,$03 ; AF0D
        .byte $3D,$00,$04,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$60 ; AF1D
        .byte $A7,$00,$61,$00,$01,$6A,$00,$00,$80,$00,$00,$81,$00,$00,$82,$00 ; AF2D
        .byte $00,$83,$00,$00,$84,$00,$00,$85,$00,$00,$90,$00,$10,$92,$06,$00 ; AF3D
        .byte $07,$01,$33,$FF,$FF ; AF4D
lcd_cmds_AF52:
        .byte $01,$01,$00,$02,$02,$00,$03,$10,$28,$04,$00,$00,$08,$02,$07,$09 ; AF52
        .byte $00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00,$00,$0F,$00,$00,$10,$00 ; AF62
        .byte $00,$11,$00,$07,$12,$00,$00,$13,$00,$00,$07,$00,$01,$10,$14,$90 ; AF72
        .byte $11,$02,$27,$12,$00,$8C,$13,$1A,$00,$29,$00,$22,$2B,$00,$0B,$20 ; AF82
        .byte $00,$EF,$21,$00,$00,$30,$00,$00,$31,$05,$07,$32,$02,$03,$35,$00 ; AF92
        .byte $05,$36,$00,$04,$37,$04,$05,$38,$00,$02,$39,$07,$07,$3C,$05,$00 ; AFA2
        .byte $3D,$00,$04,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$60 ; AFB2
        .byte $A7,$00,$61,$00,$01,$6A,$00,$00,$80,$00,$00,$81,$00,$00,$82,$00 ; AFC2
        .byte $00,$83,$00,$00,$84,$00,$00,$85,$00,$00,$90,$00,$10,$92,$06,$00 ; AFD2
        .byte $EC,$10,$0F,$07,$01,$33,$FF,$FF ; AFE2
lcd_cmds_AFEA:
        .byte $07,$00,$00,$13,$00,$00,$11,$30,$0C,$14,$15,$0F,$10,$1A,$20,$13 ; AFEA
        .byte $00,$40,$13,$00,$60,$13,$00,$70,$01,$00,$27,$02,$07,$00,$03,$10 ; AFFA
        .byte $B8,$08,$01,$01,$40,$00,$00,$41,$00,$00,$42,$01,$3F,$43,$00,$00 ; B00A
        .byte $44,$01,$3F,$45,$00,$00,$46,$EF,$00,$47,$01,$3F,$48,$00,$00,$07 ; B01A
        .byte $00,$15,$07,$00,$17,$20,$00,$00,$21,$00,$00,$FF,$FF ; B02A
lcd_cmds_B037:
        .byte $15,$00,$30,$9A,$00,$10,$01,$01,$00,$02,$03,$00,$03,$10,$28,$08 ; B037
        .byte $08,$08,$0A,$00,$08,$10,$11,$68,$11,$00,$20,$12,$00,$0A,$13,$10 ; B047
        .byte $38,$10,$34,$20,$12,$00,$16,$13,$24,$28,$20,$00,$EF,$21,$00,$00 ; B057
        .byte $50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$60,$27,$00,$61 ; B067
        .byte $00,$01,$90,$01,$3E,$92,$01,$00,$93,$01,$00,$A0,$30,$00,$A3,$00 ; B077
        .byte $10,$30,$00,$00,$31,$04,$02,$32,$03,$07,$33,$03,$04,$34,$00,$04 ; B087
        .byte $35,$04,$01,$36,$07,$07,$37,$03,$05,$38,$06,$10,$39,$06,$10,$07 ; B097
        .byte $00,$01,$07,$00,$21,$07,$00,$23,$07,$00,$33,$07,$01,$33,$FF,$FF ; B0A7
lcd_cmds_B0B7:
        .byte $E5,$80,$00,$00,$00,$01,$01,$01,$00,$02,$07,$00,$03,$10,$28,$04 ; B0B7
        .byte $00,$00,$08,$02,$02,$09,$00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00 ; B0C7
        .byte $00,$0F,$00,$00,$10,$00,$00,$11,$00,$07,$12,$00,$00,$13,$00,$00 ; B0D7
        .byte $10,$17,$B0,$11,$00,$37,$12,$01,$3A,$13,$12,$00,$29,$00,$0C,$20 ; B0E7
        .byte $00,$EF,$21,$00,$00,$30,$00,$00,$31,$05,$05,$32,$00,$04,$35,$00 ; B0F7
        .byte $06,$36,$07,$07,$37,$01,$05,$38,$00,$02,$39,$07,$07,$3C,$07,$04 ; B107
        .byte $3D,$08,$07,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$60 ; B117
        .byte $27,$00,$61,$00,$01,$6A,$00,$00,$80,$00,$00,$81,$00,$00,$82,$00 ; B127
        .byte $00,$83,$00,$00,$84,$00,$00,$85,$00,$00,$90,$00,$10,$92,$00,$00 ; B137
        .byte $93,$00,$03,$95,$01,$10,$97,$00,$00,$98,$00,$00,$07,$01,$73,$FF ; B147
        .byte $FF ; B157
lcd_cmds_B158:
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$00,$A4 ; B158
        .byte $00,$01,$01,$00,$00,$02,$07,$00,$03,$10,$38,$08,$08,$08,$09,$00 ; B168
        .byte $00,$0A,$00,$08,$0D,$00,$00,$0F,$00,$02,$50,$00,$00,$51,$00,$EF ; B178
        .byte $52,$00,$00,$53,$01,$3F,$20,$00,$00,$21,$00,$00,$60,$27,$00,$61 ; B188
        .byte $00,$01,$6A,$00,$00,$90,$00,$10,$92,$01,$00,$93,$00,$00,$30,$07 ; B198
        .byte $07,$31,$00,$07,$32,$06,$03,$33,$07,$00,$34,$02,$02,$35,$00,$02 ; B1A8
        .byte $36,$1E,$00,$37,$07,$07,$38,$00,$00,$39,$00,$00,$3A,$07,$07,$3B ; B1B8
        .byte $00,$00,$3C,$07,$07,$3D,$00,$00,$07,$00,$01,$17,$00,$01,$10,$17 ; B1C8
        .byte $B0,$11,$00,$07,$12,$01,$98,$13,$0E,$00,$29,$00,$12,$12,$01,$BF ; B1D8
        .byte $07,$00,$21,$07,$00,$61,$07,$01,$73,$FF,$FF ; B1E8
lcd_cmds_B1F3:
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$A4,$00,$01,$60 ; B1F3
        .byte $27,$00,$08,$08,$08,$30,$01,$01,$31,$01,$05,$32,$01,$00,$33,$01 ; B203
        .byte $03,$34,$07,$06,$35,$02,$06,$36,$85,$07,$37,$14,$07,$38,$14,$03 ; B213
        .byte $39,$00,$20,$90,$00,$15,$10,$05,$30,$11,$04,$57,$12,$01,$BF,$13 ; B223
        .byte $14,$00,$29,$00,$64,$2A,$00,$46,$12,$01,$B9,$01,$01,$00,$02,$02 ; B233
        .byte $00,$03,$10,$28,$09,$00,$01,$0A,$00,$00,$0D,$00,$00,$0E,$00,$30 ; B243
        .byte $50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$61,$00,$01,$6A ; B253
        .byte $00,$00,$80,$00,$00,$81,$00,$00,$82,$00,$5F,$92,$01,$00,$93,$07 ; B263
        .byte $01,$07,$01,$00,$20,$00,$EF,$21,$00,$00,$FF,$FF ; B273
lcd_cmds_B27F:
        .byte $07,$00,$00,$00,$00,$01,$11,$05,$10,$10,$11,$68,$12,$00,$06,$12 ; B27F
        .byte $00,$16,$10,$26,$30,$13,$14,$4F,$01,$01,$00,$02,$03,$00,$03,$10 ; B28F
        .byte $28,$0A,$00,$08,$60,$27,$00,$61,$00,$01,$90,$01,$12,$93,$00,$01 ; B29F
        .byte $20,$00,$EF,$21,$00,$00,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53 ; B2AF
        .byte $01,$3F,$30,$01,$01,$31,$01,$05,$32,$01,$00,$33,$01,$03,$34,$07 ; B2BF
        .byte $06,$35,$02,$06,$36,$06,$06,$37,$03,$01,$38,$0B,$0A,$39,$0A,$0B ; B2CF
        .byte $41,$00,$02,$07,$00,$01,$07,$00,$21,$07,$01,$23,$07,$01,$33,$FF ; B2DF
        .byte $FF ; B2EF
lcd_cmds_B2F0:
        .byte $80,$00,$8D,$92,$00,$10,$11,$00,$1F,$12,$50,$00,$13,$00,$70,$14 ; B2F0
        .byte $48,$78,$10,$0C,$00,$11,$01,$1F,$11,$01,$1F,$11,$03,$1F,$11,$07 ; B300
        .byte $1F,$11,$0F,$1F,$11,$0F,$3F,$01,$01,$28,$02,$01,$00,$03,$10,$28 ; B310
        .byte $0C,$00,$00,$0F,$18,$01,$50,$00,$0F,$51,$00,$0F,$52,$00,$00,$53 ; B320
        .byte $03,$00,$54,$00,$00,$55,$08,$00,$56,$00,$00,$57,$00,$03,$58,$02 ; B330
        .byte $1F,$59,$1F,$02,$36,$00,$EF,$37,$00,$00,$38,$01,$3F,$39,$00,$00 ; B340
        .byte $20,$00,$EF,$21,$00,$00,$07,$00,$10,$07,$00,$12,$07,$00,$13,$07 ; B350
        .byte $00,$17,$FF,$FF ; B360
lcd_cmds_B364:
        .byte $00,$00,$01,$10,$00,$00,$07,$00,$33,$03,$AA,$A4,$0C,$00,$00,$0D ; B364
        .byte $00,$0B,$01,$2B,$3F,$02,$06,$00,$11,$60,$28,$0E,$2C,$00,$1E,$00 ; B374
        .byte $65,$05,$00,$00,$06,$00,$00,$16,$EF,$1C,$17,$00,$03,$07,$02,$33 ; B384
        .byte $0B,$53,$01,$0F,$00,$00,$41,$00,$00,$42,$00,$00,$48,$00,$00,$49 ; B394
        .byte $01,$3F,$44,$EF,$00,$45,$00,$00,$46,$01,$3F,$4A,$00,$00,$4B,$00 ; B3A4
        .byte $00,$4E,$00,$EF,$4F,$00,$00,$30,$00,$00,$31,$05,$07,$32,$00,$03 ; B3B4
        .byte $33,$04,$00,$34,$06,$07,$35,$00,$04,$36,$07,$06,$37,$00,$03,$3A ; B3C4
        .byte $09,$00,$3B,$00,$03,$23,$00,$00,$24,$00,$00,$FF,$FF ; B3D4
lcd_cmds_B3E1:
        .byte $00,$00,$00,$01,$01,$00,$02,$07,$00,$03,$10,$28,$04,$00,$00,$08 ; B3E1
        .byte $02,$07,$09,$00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00,$00,$0F,$00 ; B3F1
        .byte $00,$07,$01,$01,$10,$12,$B0,$11,$00,$07,$17,$00,$01,$12,$01,$BD ; B401
        .byte $13,$0A,$00,$29,$00,$08,$30,$01,$02,$31,$0C,$21,$32,$0C,$23,$33 ; B411
        .byte $27,$10,$34,$1E,$0B,$35,$0A,$04,$36,$17,$01,$37,$06,$17,$38,$03 ; B421
        .byte $05,$39,$0A,$05,$3A,$0C,$04,$3B,$0F,$00,$3C,$00,$0F,$3D,$05,$0C ; B431
        .byte $3E,$02,$04,$3F,$04,$04,$20,$00,$EF,$21,$00,$00,$50,$00,$00,$51 ; B441
        .byte $00,$EF,$52,$00,$00,$53,$01,$3F,$60,$27,$00,$61,$00,$01,$6A,$00 ; B451
        .byte $00,$80,$00,$00,$81,$00,$00,$82,$00,$00,$83,$00,$00,$84,$00,$00 ; B461
        .byte $85,$00,$00,$90,$00,$12,$92,$00,$00,$93,$01,$03,$95,$01,$10,$97 ; B471
        .byte $00,$00,$98,$00,$00,$F0,$54,$08,$F3,$00,$12,$F4,$00,$1A,$F0,$00 ; B481
        .byte $00,$07,$01,$73,$FF,$FF ; B491
lcd_cmds_B497:
        .byte $00,$00,$00,$01,$01,$00,$02,$07,$00,$03,$10,$08,$04,$00,$00,$08 ; B497
        .byte $02,$07,$09,$00,$00,$0A,$00,$00,$0C,$00,$00,$0D,$00,$00,$0F,$00 ; B4A7
        .byte $00,$07,$01,$01,$10,$12,$B0,$11,$00,$07,$17,$00,$01,$12,$01,$BD ; B4B7
        .byte $13,$28,$00,$29,$00,$20,$30,$01,$02,$31,$0C,$21,$32,$0C,$23,$33 ; B4C7
        .byte $27,$10,$34,$1E,$0B,$35,$0A,$04,$36,$17,$01,$37,$06,$17,$38,$03 ; B4D7
        .byte $05,$39,$0A,$05,$3A,$0C,$04,$3B,$0F,$00,$3C,$00,$0F,$3D,$05,$0C ; B4E7
        .byte $3E,$02,$04,$3F,$04,$04,$20,$00,$00,$21,$00,$00,$50,$00,$00,$51 ; B4F7
        .byte $00,$EF,$52,$00,$00,$53,$01,$3F,$60,$27,$00,$61,$00,$01,$6A,$00 ; B507
        .byte $00,$80,$00,$00,$81,$00,$00,$82,$00,$00,$83,$00,$00,$84,$00,$00 ; B517
        .byte $85,$00,$00,$90,$00,$12,$92,$00,$00,$93,$01,$03,$95,$01,$10,$97 ; B527
        .byte $00,$00,$98,$00,$00,$F0,$54,$08,$F3,$00,$12,$F4,$00,$1A,$F0,$00 ; B537
        .byte $00,$07,$01,$73,$FF,$FF ; B547
lcd_cmds_B54D:
        .byte $2B,$00,$02,$00,$00,$01,$AF,$60,$00,$14,$00,$03,$07,$00,$00,$12 ; B54D
        .byte $00,$00,$60,$A7,$00,$08,$04,$05,$98,$02,$02,$01,$01,$00,$30,$00 ; B55D
        .byte $00,$31,$07,$07,$32,$02,$03,$35,$00,$07,$36,$04,$00,$37,$04,$04 ; B56D
        .byte $38,$00,$04,$39,$07,$07,$3C,$06,$00,$3D,$01,$03,$10,$02,$C0,$11 ; B57D
        .byte $02,$47,$12,$01,$19,$13,$14,$00,$29,$00,$07,$01,$01,$00,$02,$07 ; B58D
        .byte $00,$03,$10,$28,$61,$00,$01,$90,$00,$15,$92,$00,$00,$80,$00,$00 ; B59D
        .byte $81,$00,$00,$82,$01,$3F,$83,$00,$00,$84,$00,$00,$85,$01,$3F,$AF ; B5AD
        .byte $60,$00,$14,$00,$03,$50,$00,$00,$51,$00,$EF,$52,$00,$00,$53,$01 ; B5BD
        .byte $3F,$10,$12,$F0,$07,$01,$33,$FF,$FF ; B5CD
lcd_cmds_B5D6:
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5D6
        .byte $00,$00,$A4,$00,$01,$60,$A7,$00,$08,$08,$08,$30,$02,$03,$31,$08 ; B5E6
        .byte $0F,$32,$04,$01,$33,$05,$0B,$34,$33,$30,$35,$0B,$05,$36,$00,$05 ; B5F6
        .byte $37,$0F,$08,$38,$03,$02,$39,$30,$33,$90,$00,$18,$10,$05,$30,$11 ; B606
        .byte $02,$37,$12,$01,$BF,$13,$10,$1F,$01,$00,$00,$02,$02,$00,$03,$10 ; B616
        .byte $38,$09,$00,$01,$0A,$00,$08,$0C,$00,$00,$0D,$D0,$00,$0E,$00,$30 ; B626
        .byte $0F,$00,$00,$20,$00,$00,$21,$00,$00,$29,$00,$2E,$50,$00,$00,$51 ; B636
        .byte $00,$EF,$52,$00,$00,$53,$01,$3F,$61,$00,$01,$6A,$00,$00,$80,$00 ; B646
        .byte $00,$81,$00,$00,$82,$00,$5F,$93,$07,$01,$07,$01,$00,$FF,$FF ; B656
lcd_cmds_B665:
        .byte $01,$00,$00,$02,$02,$00,$03,$10,$38,$08,$02,$02,$09,$00,$00,$0A ; B665
        .byte $00,$00,$0C,$00,$00,$0D,$00,$00,$60,$27,$00,$61,$00,$01,$6A,$00 ; B675
        .byte $00,$10,$14,$90,$11,$02,$27,$12,$00,$8C,$13,$19,$00,$29,$00,$2A ; B685
        .byte $2B,$00,$0D,$20,$00,$00,$21,$00,$00,$30,$00,$00,$31,$03,$03,$32 ; B695
        .byte $01,$02,$35,$01,$01,$36,$00,$08,$37,$05,$06,$38,$04,$04,$39,$07 ; B6A5
        .byte $07,$3C,$01,$01,$3D,$08,$04,$50,$00,$00,$51,$00,$EF,$52,$00,$00 ; B6B5
        .byte $53,$01,$3F,$07,$01,$33,$FF,$FF ; B6C5
lcd_cmds_B6CD:
        .byte $01,$01,$00,$02,$07,$00,$03,$10,$28,$07,$01,$21,$08,$03,$02,$09 ; B6CD
        .byte $02,$00,$0A,$00,$00,$10,$07,$90,$11,$00,$05,$12,$00,$00,$13,$00 ; B6DD
        .byte $00,$10,$12,$90,$11,$00,$07,$12,$00,$8C,$13,$15,$00,$29,$00,$10 ; B6ED
        .byte $30,$00,$00,$31,$05,$07,$32,$00,$03,$35,$02,$00,$36,$01,$06,$37 ; B6FD
        .byte $00,$00,$38,$05,$07,$39,$01,$04,$3C,$02,$00,$3D,$00,$05,$50,$00 ; B70D
        .byte $00,$51,$00,$EF,$52,$00,$00,$53,$01,$3F,$60,$A7,$00,$61,$00,$01 ; B71D
        .byte $90,$00,$30,$09,$00,$00,$07,$01,$33,$FF,$FF,$01,$10,$00,$A0,$03 ; B72D
        .byte $01,$03,$00,$2B,$05,$59,$01,$60,$22,$59,$00,$28,$FF,$1A,$00,$25 ; B73D
        .byte $0A,$19,$6C,$1C,$73,$24,$74,$1E,$01,$18,$C1,$18,$E1,$18,$F1,$18 ; B74D
        .byte $F5,$1B,$09,$1F,$13,$20,$15,$1E,$81,$9D,$00,$C0,$00,$C1,$01,$0E ; B75D
        .byte $00,$0F,$00,$10,$00,$11,$00,$12,$00,$13,$00,$14,$00,$15,$00,$16 ; B76D
        .byte $00,$17,$00,$34,$01,$35,$00,$4B,$00,$4C,$00,$4D,$00,$4E,$00,$4F ; B77D
        .byte $00,$50,$00,$3C,$00,$3D,$00,$3E,$01,$3F,$3F,$40,$02,$41,$02,$86 ; B78D
        .byte $00,$87,$30,$88,$02,$89,$05,$8D,$01,$8B,$20,$33,$01,$37,$01,$76 ; B79D
        .byte $00,$2D,$01,$8F,$10,$90,$67,$91,$07,$92,$56,$93,$07,$94,$01,$95 ; B7AD
        .byte $76,$96,$65,$97,$00,$98,$00,$99,$00,$9A,$00,$3B,$01,$1D,$08,$05 ; B7BD
        .byte $14,$01,$90,$45,$00,$46,$EF,$47,$00,$48,$00,$49,$01,$4A,$3F,$42 ; B7CD
        .byte $00,$43,$00,$44,$00,$45,$00,$46,$EF,$47,$00,$48,$00,$49,$01,$4A ; B7DD
        .byte $3F,$42,$00,$43,$00,$44,$00,$45,$00,$46,$EF,$47,$00,$48,$00,$49 ; B7ED
        .byte $01,$4A,$3F,$42,$EF,$43,$00,$44,$00,$00,$20,$FF,$FF ; B7FD
tbl_lcd_names:
        .word str_lcd_00 ; B80A
        .word str_lcd_01 ; B80C
        .word str_lcd_02 ; B80E
        .word str_lcd_03 ; B810
        .word str_lcd_04 ; B812
        .word str_lcd_05 ; B814
        .word str_lcd_06 ; B816
        .word str_lcd_07 ; B818
        .word str_lcd_08 ; B81A
        .word str_lcd_09 ; B81C
        .word str_lcd_0A ; B81E
        .word str_lcd_0B ; B820
        .word str_lcd_0C ; B822
        .word str_lcd_0D ; B824
        .word str_lcd_0E ; B826
        .word str_lcd_0F ; B828
        .word str_lcd_10 ; B82A
        .word str_lcd_11 ; B82C
        .word str_lcd_12 ; B82E
        .word str_lcd_13 ; B830
        .word str_lcd_14 ; B832
        .word str_lcd_15 ; B834
        .word str_lcd_16 ; B836
        .word str_lcd_17 ; B838
        .word str_lcd_18 ; B83A
        .word str_lcd_19 ; B83C
        .word str_lcd_1A ; B83E
        .word str_lcd_1B ; B840
        .word str_lcd_1C ; B842
        .word str_lcd_1D ; B844
        .word str_lcd_1E ; B846
        .word str_lcd_1F ; B848
        .word str_lcd_20 ; B84A
str_lcd_00:
        .byte "NO CHECK LCD",$00 ; B84C
str_lcd_01:
        .byte "9306",$00 ; B859
str_lcd_02:
        .byte "7789",$00 ; B85E
str_lcd_03:
        .byte "9312",$00 ; B863
str_lcd_04:
        .byte "9341",$00 ; B868
str_lcd_05:
        .byte "9340X",$00 ; B86D
str_lcd_06:
        .byte "68090",$00 ; B873
str_lcd_07:
        .byte "8347A",$00 ; B879
str_lcd_08:
        .byte "8347D",$00 ; B87F
str_lcd_09:
        .byte "9328",$00 ; B885
str_lcd_0A:
        .byte "9325",$00 ; B88A
str_lcd_0B:
        .byte "9325D",$00 ; B88F
str_lcd_0C:
        .byte "9325C",$00 ; B895
str_lcd_0D:
        .byte "9320",$00 ; B89B
str_lcd_0E:
        .byte "0139",$00 ; B8A0
str_lcd_0F:
        .byte "4535",$00 ; B8A5
str_lcd_10:
        .byte "4531",$00 ; B8AA
str_lcd_11:
        .byte "61505U",$00 ; B8AF
str_lcd_12:
        .byte "61505V",$00 ; B8B6
str_lcd_13:
        .byte "1289",$00 ; B8BD
str_lcd_14:
        .byte "5408A",$00 ; B8C2
str_lcd_15:
        .byte "5408B",$00 ; B8C8
str_lcd_16:
        .byte "S6D0154",$00 ; B8CE
str_lcd_17:
        .byte "61580",$00 ; B8D6
str_lcd_18:
        .byte "7781",$00 ; B8DC
str_lcd_19:
        .byte "9335",$00 ; B8E1
str_lcd_1A:
        .byte "1297",$00 ; B8E6
str_lcd_1B:
        .byte "3029E",$00 ; B8EB
str_lcd_1C:
        .byte "3029C",$00 ; B8F1
str_lcd_1D:
        .byte "8347G",$00 ; B8F7
str_lcd_1E:
        .byte "S6D04M0",$00 ; B8FD
str_lcd_1F:
        .byte "9331",$00 ; B905
str_lcd_20:
        .byte "8346",$00 ; B90A
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B90F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B91F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B92F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B93F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B94F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B95F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B96F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B97F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B98F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B99F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9AF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9BF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9CF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9DF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9EF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B9FF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BA9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BABF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BACF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BADF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAEF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BAFF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBBF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBCF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBDF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBEF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBFF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BC9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCBF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCCF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCDF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCEF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCFF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDBF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDCF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDDF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDEF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDFF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEBF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BECF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEDF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEEF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BEFF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF0F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF1F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF2F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF3F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF4F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF5F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF6F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF7F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF8F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BF9F
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFAF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFBF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFCF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFDF
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BFEF
        .byte $FF ; BFFF
