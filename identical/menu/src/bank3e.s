; Sup 400-in-1 English menu, 8 KiB PRG bank $3E (file 0x7C000), mapped at CPU $C000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK3E"

        .byte $88 ; C000
jt_C266:
        jmp  loc_C266                   ; C001
jt_C22B:
        .byte $4C,$2B,$C2 ; C004
jt_C1FB:
        jmp  loc_C1FB                   ; C007
jt_C174:
        .byte $4C,$74,$C2 ; C00A
read_pad_0327_thunk:
        jmp  read_pad_0327              ; C00D
jt_print_string_struct:
        .byte $4C,$45,$C0 ; C010
jt_print_string_queued:
        jmp  print_string_queued        ; C013
jt_C15E:
        jmp  loc_C15E                   ; C016
jt_draw_screen_by_id:
        jmp  draw_screen_by_id          ; C019
jt_menu_run_screen:
        jmp  menu_run_screen            ; C01C
read_pad_0327:
        pha                             ; C01F
        txa                             ; C020
        pha                             ; C021
        tya                             ; C022
        pha                             ; C023
        lda  #$01                       ; C024
        sta  JOY1                       ; C026
        lda  #$00                       ; C029
        sta  JOY1                       ; C02B
        ldx  #$08                       ; C02E
        ldy  #$00                       ; C030
loc_C032:
        lda  JOY1                       ; C032
        lsr  a                          ; C035
        bcs  loc_C039                   ; C036
        lsr  a                          ; C038
loc_C039:
        rol  pad_state                  ; C039
        dex                             ; C03C
        bne  loc_C032                   ; C03D
        pla                             ; C03F
        tay                             ; C040
        pla                             ; C041
        tax                             ; C042
        pla                             ; C043
        rts                             ; C044
print_string_struct:
        tya                             ; C045
        pha                             ; C046
        txa                             ; C047
        pha                             ; C048
        ldy  #$00                       ; C049
        lda  ($70),y                    ; C04B
        sta  $73                        ; C04D
        iny                             ; C04F
        lda  ($70),y                    ; C050
        sta  $72                        ; C052
        iny                             ; C054
        lda  ($70),y                    ; C055
        sta  $75                        ; C057
        iny                             ; C059
        lda  ($70),y                    ; C05A
        sta  $76                        ; C05C
        iny                             ; C05E
        lda  ($70),y                    ; C05F
        sta  $74                        ; C061
        clc                             ; C063
        lda  $70                        ; C064
        adc  #$05                       ; C066
        sta  $70                        ; C068
        lda  $71                        ; C06A
        adc  #$00                       ; C06C
        sta  $71                        ; C06E
        jsr  print_string_queued        ; C070
        pla                             ; C073
        tax                             ; C074
        pla                             ; C075
        tay                             ; C076
        rts                             ; C077
print_string_queued:
        tya                             ; C078
        pha                             ; C079
        txa                             ; C07A
        pha                             ; C07B
        lda  $75                        ; C07C
        sta  $77                        ; C07E
        iny                             ; C080
        lda  $76                        ; C081
        sta  $78                        ; C083
        lda  $72                        ; C085
        asl  a                          ; C087
        sta  $79                        ; C088
        lsr  a                          ; C08A
        lsr  a                          ; C08B
        lsr  a                          ; C08C
        lsr  a                          ; C08D
        clc                             ; C08E
        adc  $0320                      ; C08F
        sta  $7A                        ; C092
        lda  $79                        ; C094
        asl  a                          ; C096
        asl  a                          ; C097
        asl  a                          ; C098
        asl  a                          ; C099
        clc                             ; C09A
        adc  $73                        ; C09B
        sta  $7B                        ; C09D
        clc                             ; C09F
        lda  #$00                       ; C0A0
        sta  $7C                        ; C0A2
        lda  #$00                       ; C0A4
        sta  $7D                        ; C0A6
        lda  #$BF                       ; C0A8
        sta  nmi_hook_ptr               ; C0AA
        lda  #$C0                       ; C0AC
        sta  $B1                        ; C0AE
        lda  #$01                       ; C0B0
        sta  nmi_hook_pending           ; C0B2
loc_C0B5:
        lda  nmi_hook_pending           ; C0B5
        bne  loc_C0B5                   ; C0B8
        pla                             ; C0BA
        tax                             ; C0BB
        pla                             ; C0BC
        tay                             ; C0BD
        rts                             ; C0BE
nmi_hook_write_string:
        tya                             ; C0BF
        pha                             ; C0C0
        txa                             ; C0C1
        pha                             ; C0C2
        ldy  $7D                        ; C0C3
        ldx  $7C                        ; C0C5
        lda  #$00                       ; C0C7
        sta  $7E                        ; C0C9
        clc                             ; C0CB
        lda  $7B                        ; C0CC
        adc  $7D                        ; C0CE
        sta  $79                        ; C0D0
        lda  $7A                        ; C0D2
        adc  #$00                       ; C0D4
        sta  PPU_ADDR                   ; C0D6
        lda  $79                        ; C0D9
        sta  PPU_ADDR                   ; C0DB
loc_C0DE:
        clc                             ; C0DE
        lda  ($70),y                    ; C0DF
        adc  $74                        ; C0E1
        sta  PPU_DATA                   ; C0E3
        iny                             ; C0E6
        inc  $7E                        ; C0E7
        lda  $7E                        ; C0E9
        cmp  #$20                       ; C0EB
        beq  loc_C11F                   ; C0ED
        cpy  $77                        ; C0EF
        bne  loc_C0DE                   ; C0F1
        inx                             ; C0F3
        cpx  $78                        ; C0F4
        beq  loc_C14B                   ; C0F6
        ; static (not seen in traces)
        clc                             ; C0F8
        lda  $7B                        ; C0F9
        adc  #$20                       ; C0FB
        sta  $7B                        ; C0FD
        lda  $7A                        ; C0FF
        adc  #$00                       ; C101
        sta  $7A                        ; C103
        sta  PPU_ADDR                   ; C105
        lda  $7B                        ; C108
        sta  PPU_ADDR                   ; C10A
        clc                             ; C10D
        lda  $70                        ; C10E
        adc  $77                        ; C110
        sta  $70                        ; C112
        lda  $71                        ; C114
        adc  #$00                       ; C116
        sta  $71                        ; C118
        ldy  #$00                       ; C11A
        jmp  loc_C0DE                   ; C11C
loc_C11F:
        cpy  $77                        ; C11F
        bne  loc_C144                   ; C121
        inx                             ; C123
        cpx  $78                        ; C124
        beq  loc_C14B                   ; C126
        clc                             ; C128
        lda  $7B                        ; C129
        adc  #$20                       ; C12B
        sta  $7B                        ; C12D
        lda  $7A                        ; C12F
        adc  #$00                       ; C131
        sta  $7A                        ; C133
        clc                             ; C135
        lda  $70                        ; C136
        adc  $77                        ; C138
        sta  $70                        ; C13A
        lda  $71                        ; C13C
        adc  #$00                       ; C13E
        sta  $71                        ; C140
        ldy  #$00                       ; C142
loc_C144:
        sty  $7D                        ; C144
        stx  $7C                        ; C146
        jmp  loc_C158                   ; C148
loc_C14B:
        lda  #$00                       ; C14B
        sta  nmi_hook_pending           ; C14D
        lda  #$5D                       ; C150
        sta  nmi_hook_ptr               ; C152
        lda  #$C1                       ; C154
        sta  $B1                        ; C156
loc_C158:
        pla                             ; C158
        tax                             ; C159
        pla                             ; C15A
        tay                             ; C15B
        rts                             ; C15C
nmi_hook_15D:
        ; static (not seen in traces)
        rts                             ; C15D
loc_C15E:
        tya                             ; C15E
        pha                             ; C15F
        txa                             ; C160
        pha                             ; C161
        ldy  #$00                       ; C162
loc_C164:
        lda  ($70),y                    ; C164
        sta  $036E,y                    ; C166
        iny                             ; C169
        cpy  #$22                       ; C16A
        bne  loc_C164                   ; C16C
        ldy  #$00                       ; C16E
        ldx  #$00                       ; C170
        lda  #$3F                       ; C172
        sta  $78                        ; C174
        lda  ($70),y                    ; C176
        sta  $77                        ; C178
        iny                             ; C17A
        lda  ($70),y                    ; C17B
        clc                             ; C17D
        adc  #$02                       ; C17E
        sta  $79                        ; C180
        iny                             ; C182
        lda  #$9A                       ; C183
        sta  nmi_hook_ptr               ; C185
        lda  #$C1                       ; C187
        sta  $B1                        ; C189
        lda  #$02                       ; C18B
        sta  nmi_hook_pending           ; C18D
loc_C190:
        lda  nmi_hook_pending           ; C190
        bne  loc_C190                   ; C193
        pla                             ; C195
        tax                             ; C196
        pla                             ; C197
        tay                             ; C198
        rts                             ; C199
nmi_hook_19A:
        lda  $78                        ; C19A
        sta  PPU_ADDR                   ; C19C
        lda  $77                        ; C19F
        sta  PPU_ADDR                   ; C1A1
loc_C1A4:
        lda  ($70),y                    ; C1A4
        bit  PPU_DATA                   ; C1A6
        iny                             ; C1A9
        cpy  $79                        ; C1AA
        bne  loc_C1A4                   ; C1AC
        lda  #$00                       ; C1AE
        sta  nmi_hook_pending           ; C1B0
        lda  #$5D                       ; C1B3
        sta  nmi_hook_ptr               ; C1B5
        lda  #$C1                       ; C1B7
        sta  $B1                        ; C1B9
        rts                             ; C1BB
        .byte $A9,$3F,$8D,$06,$20,$A9,$00,$8D,$06,$20,$A0,$02,$A2,$00,$B1,$70 ; C1BC
        .byte $C5,$77,$90,$04,$29,$0F,$05,$78,$8D,$07,$20,$E8,$C8,$AD,$36,$03 ; C1CC
        .byte $F0,$04,$C9,$01,$F0,$07,$E0,$20,$90,$E4,$4C,$ED,$C1,$E0,$11,$90 ; C1DC
        .byte $DD,$A9,$00,$8D,$22,$03,$A9,$5D,$85,$B0,$A9,$C1,$85,$B1,$60 ; C1EC
loc_C1FB:
        cld                             ; C1FB
        lda  #$00                       ; C1FC
        sta  $0367                      ; C1FE
        sta  $0325                      ; C201
        sta  $0326                      ; C204
loc_C207:
        lsr  $0323                      ; C207
        bcc  loc_C21F                   ; C20A
        clc                             ; C20C
        lda  $0324                      ; C20D
        adc  $0325                      ; C210
        sta  $0325                      ; C213
        lda  $0367                      ; C216
        adc  $0326                      ; C219
        sta  $0326                      ; C21C
loc_C21F:
        asl  $0324                      ; C21F
        rol  $0367                      ; C222
        lda  $0323                      ; C225
        bne  loc_C207                   ; C228
        rts                             ; C22A
        .byte $8A,$48,$98,$48,$A9,$00,$8D,$E9,$03,$8D,$EA,$03,$A2,$10,$0E,$E1 ; C22B
        .byte $03,$2E,$E2,$03,$2E,$E9,$03,$2E,$EA,$03,$AD,$E9,$03,$38,$ED,$E5 ; C23B
        .byte $03,$A8,$AD,$EA,$03,$ED,$E6,$03,$90,$09,$EE,$E1,$03,$8D,$EA,$03 ; C24B
        .byte $8C,$E9,$03,$CA,$D0,$D8,$68,$A8,$68,$AA,$60 ; C25B
loc_C266:
        lda  #$FF                       ; C266
        sta  $0321                      ; C268
loc_C26B:
        lda  $0321                      ; C26B
        bne  loc_C26B                   ; C26E
        dex                             ; C270
        bne  loc_C266                   ; C271
        rts                             ; C273
sub_C274:
        ; static (not seen in traces)
        lda  $0337                      ; C274
        and  #$02                       ; C277
        sta  $0367                      ; C279
        lda  $0338                      ; C27C
        and  #$02                       ; C27F
        eor  $0367                      ; C281
        clc                             ; C284
        beq  loc_C288                   ; C285
        sec                             ; C287
loc_C288:
        ror  $0337                      ; C288
        ror  $0338                      ; C28B
        ror  $0339                      ; C28E
        ror  $033A                      ; C291
        ror  $033B                      ; C294
        ror  $033C                      ; C297
        ror  $033D                      ; C29A
        ror  $033E                      ; C29D
        rts                             ; C2A0
        .byte $AD,$27,$03,$F0,$11,$4D,$2B,$03,$F0,$11,$8D,$2C,$03,$AD,$27,$03 ; C2A1
        .byte $8D,$2B,$03,$4C,$C4,$C2,$A9,$00,$8D,$2B,$03,$A9,$00,$8D,$2C,$03 ; C2B1
        .byte $4C,$C4,$C2,$60 ; C2C1
draw_screen_by_id:
        lda  screen_id                  ; C2C5
        asl  a                          ; C2C8
        tay                             ; C2C9
        lda  tbl_screen_desc,y          ; C2CA
        sta  $C3                        ; C2CD
        lda  dat_FC3D,y                 ; C2CF
        sta  $C4                        ; C2D2
        ldy  #$05                       ; C2D4
        lda  ($C3),y                    ; C2D6
        asl  a                          ; C2D8
        tay                             ; C2D9
        lda  tbl_screen_draw_methods,y  ; C2DA
        sta  $C7                        ; C2DD
        lda  tbl_screen_draw_methods+1,y; C2DF
        sta  $C8                        ; C2E2
        jmp  ($00C7)                    ; C2E4
tbl_screen_draw_methods:
        .word screen_draw_method0 ; C2E7
        .word screen_draw_method1 ; C2E9
screen_draw_method0:
        lda  #$FF                       ; C2EB
        sta  keep_ppu_addr              ; C2ED
        lda  #$00                       ; C2F0
        sta  PPU_CTRL                   ; C2F2
        sta  PPU_MASK                   ; C2F5
        sta  nmi_dispatch_on            ; C2F8
        sta  nmi_step_on                ; C2FB
        ldy  #$20                       ; C2FE
        sty  PPU_ADDR                   ; C300
        lda  #$00                       ; C303
        sta  PPU_ADDR                   ; C305
        ldx  #$00                       ; C308
loc_C30A:
        sta  PPU_DATA                   ; C30A
        inx                             ; C30D
        bne  loc_C30A                   ; C30E
        iny                             ; C310
        cpy  #$40                       ; C311
        bne  loc_C30A                   ; C313
        ldx  #$3F                       ; C315
        stx  PPU_ADDR                   ; C317
        ldx  #$00                       ; C31A
        stx  PPU_ADDR                   ; C31C
        lda  #$0E                       ; C31F
loc_C321:
        sta  PPU_DATA                   ; C321
        inx                             ; C324
        cpx  #$20                       ; C325
        bne  loc_C321                   ; C327
        lda  #$00                       ; C329
        sta  PPU_ADDR                   ; C32B
        sta  PPU_ADDR                   ; C32E
        ldy  #$00                       ; C331
        lda  ($C3),y                    ; C333
        sta  $82                        ; C335
        iny                             ; C337
        lda  ($C3),y                    ; C338
        sta  $83                        ; C33A
        jsr  draw_nametable_0           ; C33C
        ldy  #$04                       ; C33F
        lda  ($C3),y                    ; C341
        sta  chr_shadow_r0              ; C343
        clc                             ; C346
        adc  #$02                       ; C347
        sta  chr_shadow_r1              ; C349
        ldy  #$02                       ; C34C
        lda  ($C3),y                    ; C34E
        sta  $82                        ; C350
        iny                             ; C352
        lda  ($C3),y                    ; C353
        sta  $83                        ; C355
        lda  #$00                       ; C357
        sta  keep_ppu_addr              ; C359
        lda  ppu_ctrl_shadow            ; C35C
        sta  PPU_CTRL                   ; C35F
        lda  $0369                      ; C362
        sta  PPU_MASK                   ; C365
        lda  #$FF                       ; C368
        sta  list_dirty                 ; C36A
        jsr  sub_C422                   ; C36D
        jsr  redraw_list_page_if_dirty  ; C370
        lda  #$01                       ; C373
        sta  nmi_dispatch_on            ; C375
        sta  nmi_step_on                ; C378
        lda  $82                        ; C37B
        sta  $70                        ; C37D
        lda  $83                        ; C37F
        sta  $71                        ; C381
        jsr  jt_C15E                    ; C383
        lda  #$1E                       ; C386
        sta  PPU_MASK                   ; C388
        rts                             ; C38B
screen_draw_method1:
        ; static (not seen in traces)
        lda  #$FF                       ; C38C
        sta  keep_ppu_addr              ; C38E
        lda  #$00                       ; C391
        sta  PPU_CTRL                   ; C393
        sta  PPU_MASK                   ; C396
        sta  nmi_dispatch_on            ; C399
        sta  nmi_step_on                ; C39C
        ldy  #$00                       ; C39F
        lda  ($C3),y                    ; C3A1
        sta  $82                        ; C3A3
        iny                             ; C3A5
        lda  ($C3),y                    ; C3A6
        sta  $83                        ; C3A8
        jsr  sub_C854                   ; C3AA
        ldy  #$04                       ; C3AD
        lda  ($C3),y                    ; C3AF
        sta  chr_shadow_r0              ; C3B1
        clc                             ; C3B4
        adc  #$02                       ; C3B5
        sta  chr_shadow_r1              ; C3B7
        ldy  #$02                       ; C3BA
        lda  ($C3),y                    ; C3BC
        sta  $82                        ; C3BE
        iny                             ; C3C0
        lda  ($C3),y                    ; C3C1
        sta  $83                        ; C3C3
        lda  #$00                       ; C3C5
        sta  keep_ppu_addr              ; C3C7
        lda  ppu_ctrl_shadow            ; C3CA
        sta  PPU_CTRL                   ; C3CD
        lda  $0369                      ; C3D0
        sta  PPU_MASK                   ; C3D3
        lda  #$FF                       ; C3D6
        sta  list_dirty                 ; C3D8
        lda  #$01                       ; C3DB
        sta  nmi_dispatch_on            ; C3DD
        sta  nmi_step_on                ; C3E0
        lda  $82                        ; C3E3
        sta  $70                        ; C3E5
        lda  $83                        ; C3E7
        sta  $71                        ; C3E9
        jsr  jt_C15E                    ; C3EB
        lda  #$1E                       ; C3EE
        sta  PPU_MASK                   ; C3F0
        rts                             ; C3F3
        .byte $A9,$45,$85,$C3,$A9,$CE,$85,$C4,$A0,$00,$B1,$C3,$C0,$05,$90,$07 ; C3F4
        .byte $38,$E9,$20,$AA,$BD,$D0,$CD,$99,$26,$06,$C8,$C0,$20,$D0,$EB,$A9 ; C404
        .byte $26,$85,$70,$A9,$06,$85,$71,$20,$45,$C0,$4C,$54,$C4,$60 ; C414
sub_C422:
        lda  $0698                      ; C422
        asl  a                          ; C425
        asl  a                          ; C426
        tay                             ; C427
        lda  dat_CE34,y                 ; C428
        sta  $C3                        ; C42B
        lda  dat_CE35,y                 ; C42D
        sta  $C4                        ; C430
        ldy  #$00                       ; C432
loc_C434:
        lda  ($C3),y                    ; C434
        cpy  #$05                       ; C436
        bcc  loc_C441                   ; C438
        sec                             ; C43A
        sbc  #$20                       ; C43B
        tax                             ; C43D
        lda  dat_CDD0,x                 ; C43E
loc_C441:
        sta  $0626,y                    ; C441
        iny                             ; C444
        cpy  #$20                       ; C445
        bne  loc_C434                   ; C447
        lda  #$26                       ; C449
        sta  $70                        ; C44B
        lda  #$06                       ; C44D
        sta  $71                        ; C44F
        jsr  sub_AA20                   ; C451
        ldx  #$00                       ; C454
        lda  #$00                       ; C456
loc_C458:
        sta  $0626,x                    ; C458
        inx                             ; C45B
        cpx  #$20                       ; C45C
        bne  loc_C458                   ; C45E
        rts                             ; C460
menu_run_screen:
        lda  #$00                       ; C461
        sta  menu_start_pressed         ; C463
        sta  cursor_sprite_inited       ; C466
        sta  $036A                      ; C469
        jsr  jt_draw_screen_by_id       ; C46C
        jsr  sfx_beep                   ; C46F
        lda  #$01                       ; C472
        sta  nmi_dispatch_on            ; C474
        sta  nmi_step_on                ; C477
        ldx  #$01                       ; C47A
        jsr  jt_C266                    ; C47C
loc_C47F:
        jsr  redraw_list_page_if_dirty  ; C47F
        lda  menu_start_pressed         ; C482
        beq  loc_C47F                   ; C485
        lda  #$00                       ; C487
        sta  nmi_step_on                ; C489
        rts                             ; C48C
sub_C48D:
        txa                             ; C48D
        pha                             ; C48E
        tya                             ; C48F
        pha                             ; C490
        lda  #$00                       ; C491
        sta  $03E9                      ; C493
        sta  $03EA                      ; C496
        sta  $03EB                      ; C499
        sta  $03EC                      ; C49C
        ldx  #$20                       ; C49F
loc_C4A1:
        asl  $03E1                      ; C4A1
        rol  $03E2                      ; C4A4
        rol  $03E3                      ; C4A7
        rol  $03E4                      ; C4AA
        rol  $03E9                      ; C4AD
        rol  $03EA                      ; C4B0
        rol  $03EB                      ; C4B3
        rol  $03EC                      ; C4B6
        sec                             ; C4B9
        lda  $03E9                      ; C4BA
        sbc  $03E5                      ; C4BD
        lda  $03EA                      ; C4C0
        sbc  $03E6                      ; C4C3
        lda  $03EB                      ; C4C6
        sbc  $03E7                      ; C4C9
        lda  $03EC                      ; C4CC
        sbc  $03E8                      ; C4CF
        bcc  loc_C4FB                   ; C4D2
        inc  $03E1                      ; C4D4
        lda  $03E9                      ; C4D7
        sbc  $03E5                      ; C4DA
        sta  $03E9                      ; C4DD
        lda  $03EA                      ; C4E0
        sbc  $03E6                      ; C4E3
        sta  $03EA                      ; C4E6
        lda  $03EB                      ; C4E9
        sbc  $03E7                      ; C4EC
        sta  $03EB                      ; C4EF
        lda  $03EC                      ; C4F2
        sbc  $03E8                      ; C4F5
        sta  $03EC                      ; C4F8
loc_C4FB:
        dex                             ; C4FB
        bne  loc_C4A1                   ; C4FC
        pla                             ; C4FE
        tay                             ; C4FF
        pla                             ; C500
        tax                             ; C501
        rts                             ; C502
sub_C503:
        ; static (not seen in traces)
        lda  #$00                       ; C503
        sta  $03E0                      ; C505
        sta  $03DF                      ; C508
        sta  $03DE                      ; C50B
        sta  $03DD                      ; C50E
        ldx  #$20                       ; C511
loc_C513:
        lsr  $03D8                      ; C513
        ror  $03D7                      ; C516
        ror  $03D6                      ; C519
        ror  $03D5                      ; C51C
        bcc  loc_C546                   ; C51F
        lda  $03DD                      ; C521
        clc                             ; C524
        adc  $03D1                      ; C525
        sta  $03DD                      ; C528
        lda  $03DE                      ; C52B
        adc  $03D2                      ; C52E
        sta  $03DE                      ; C531
        lda  $03DF                      ; C534
        adc  $03D3                      ; C537
        sta  $03DF                      ; C53A
        lda  $03E0                      ; C53D
        adc  $03D4                      ; C540
        sta  $03E0                      ; C543
loc_C546:
        lsr  $03E0                      ; C546
        ror  $03DF                      ; C549
        ror  $03DE                      ; C54C
        ror  $03DD                      ; C54F
        ror  $03DC                      ; C552
        ror  $03DB                      ; C555
        ror  $03DA                      ; C558
        ror  $03D9                      ; C55B
        dex                             ; C55E
        bne  loc_C513                   ; C55F
        rts                             ; C561
redraw_list_page_if_dirty:
        lda  list_dirty                 ; C562
        bne  loc_C568                   ; C565
        rts                             ; C567
loc_C568:
        jsr  sub_C5F2                   ; C568
        lda  $0618                      ; C56B
        sta  $0337                      ; C56E
        lda  $0619                      ; C571
        sta  $0338                      ; C574
loc_C577:
        jsr  sub_C66D                   ; C577
        jsr  sub_C7B5                   ; C57A
        jsr  sub_C7BE                   ; C57D
        jsr  sub_C649                   ; C580
        jsr  sub_C5B2                   ; C583
        inc  draw_row                   ; C586
        lda  draw_row                   ; C589
        cmp  rows_per_page              ; C58C
        bcc  loc_C577                   ; C58F
loc_C591:
        lda  draw_row                   ; C591
        cmp  $0604                      ; C594
        beq  loc_C5AC                   ; C597
        ; static (not seen in traces)
        jsr  sub_C649                   ; C599
        inc  draw_row                   ; C59C
        lda  $72                        ; C59F
        clc                             ; C5A1
        adc  $0605                      ; C5A2
        adc  #$01                       ; C5A5
        sta  $72                        ; C5A7
        jmp  loc_C591                   ; C5A9
loc_C5AC:
        lda  #$00                       ; C5AC
        sta  list_dirty                 ; C5AE
        rts                             ; C5B1
sub_C5B2:
        lda  $061C                      ; C5B2
        clc                             ; C5B5
        adc  #$01                       ; C5B6
        sta  $061C                      ; C5B8
        lda  $061D                      ; C5BB
        adc  #$00                       ; C5BE
        sta  $061D                      ; C5C0
        lda  $061E                      ; C5C3
        adc  #$00                       ; C5C6
        sta  $061E                      ; C5C8
        lda  $061F                      ; C5CB
        adc  #$00                       ; C5CE
        sta  $061F                      ; C5D0
        lda  $72                        ; C5D3
        clc                             ; C5D5
        adc  $0605                      ; C5D6
        adc  #$01                       ; C5D9
        sta  $72                        ; C5DB
        lda  #$00                       ; C5DD
        sta  $0646                      ; C5DF
        sta  $0648                      ; C5E2
        ldx  #$00                       ; C5E5
        lda  #$00                       ; C5E7
loc_C5E9:
        sta  $0626,x                    ; C5E9
        inx                             ; C5EC
        cpx  #$20                       ; C5ED
        bne  loc_C5E9                   ; C5EF
        rts                             ; C5F1
sub_C5F2:
        ldx  #$00                       ; C5F2
        lda  #$FF                       ; C5F4
loc_C5F6:
        sta  $064D,x                    ; C5F6
        sta  $0666,x                    ; C5F9
        sta  $067F,x                    ; C5FC
        inx                             ; C5FF
        cpx  #$19                       ; C600
        bne  loc_C5F6                   ; C602
        lda  $0606                      ; C604
        sta  $73                        ; C607
        lda  $0607                      ; C609
        sta  $72                        ; C60C
        lda  #$00                       ; C60E
        sta  $0646                      ; C610
        sta  $0648                      ; C613
        sta  draw_row                   ; C616
sub_C619:
        lda  $0618                      ; C619
        cmp  $0610                      ; C61C
        bne  loc_C642                   ; C61F
        ; static (not seen in traces)
        lda  $0619                      ; C621
        cmp  $0611                      ; C624
        bne  loc_C642                   ; C627
        lda  $061A                      ; C629
        cmp  $0612                      ; C62C
        bne  loc_C642                   ; C62F
        lda  $061B                      ; C631
        cmp  $0613                      ; C634
        bne  loc_C642                   ; C637
        lda  $0614                      ; C639
        sta  rows_per_page              ; C63C
        jmp  loc_C648                   ; C63F
loc_C642:
        lda  $0604                      ; C642
        sta  rows_per_page              ; C645
loc_C648:
        rts                             ; C648
sub_C649:
        ldx  #$00                       ; C649
loc_C64B:
        lda  $0626,x                    ; C64B
        clc                             ; C64E
        adc  #$00                       ; C64F
        sta  $0626,x                    ; C651
        inx                             ; C654
        cpx  #$20                       ; C655
        bne  loc_C64B                   ; C657
        lda  #$15                       ; C659
        sta  $75                        ; C65B
        lda  #$01                       ; C65D
        sta  $76                        ; C65F
        lda  #$26                       ; C661
        sta  $70                        ; C663
        lda  #$06                       ; C665
        sta  $71                        ; C667
        jsr  jt_print_string_queued     ; C669
        rts                             ; C66C
sub_C66D:
        lda  $061C                      ; C66D
        sta  $03E1                      ; C670
        lda  $061D                      ; C673
        sta  $03E2                      ; C676
        lda  $061E                      ; C679
        sta  $03E3                      ; C67C
        lda  $061F                      ; C67F
        sta  $03E4                      ; C682
        lda  #$00                       ; C685
        sta  $03E5                      ; C687
        lda  #$E1                       ; C68A
        sta  $03E6                      ; C68C
        lda  #$F5                       ; C68F
        sta  $03E7                      ; C691
        lda  #$05                       ; C694
        sta  $03E8                      ; C696
loc_C699:
        jsr  sub_C48D                   ; C699
        lda  $03E1                      ; C69C
        clc                             ; C69F
        adc  #$10                       ; C6A0
        tay                             ; C6A2
        lda  dat_CDD0,y                 ; C6A3
        ldx  $0646                      ; C6A6
        sta  $0626,x                    ; C6A9
        lda  $03E1                      ; C6AC
        beq  loc_C6BC                   ; C6AF
        lda  #$FF                       ; C6B1
        sta  $0648                      ; C6B3
        inc  $0646                      ; C6B6
        jmp  loc_C6C4                   ; C6B9
loc_C6BC:
        lda  $0648                      ; C6BC
        beq  loc_C6C4                   ; C6BF
        inc  $0646                      ; C6C1
loc_C6C4:
        lda  $03E9                      ; C6C4
        pha                             ; C6C7
        lda  $03EA                      ; C6C8
        pha                             ; C6CB
        lda  $03EB                      ; C6CC
        pha                             ; C6CF
        lda  $03EC                      ; C6D0
        pha                             ; C6D3
        lda  $03E5                      ; C6D4
        sta  $03E1                      ; C6D7
        lda  $03E6                      ; C6DA
        sta  $03E2                      ; C6DD
        lda  $03E7                      ; C6E0
        sta  $03E3                      ; C6E3
        lda  $03E8                      ; C6E6
        sta  $03E4                      ; C6E9
        lda  #$0A                       ; C6EC
        sta  $03E5                      ; C6EE
        lda  #$00                       ; C6F1
        sta  $03E6                      ; C6F3
        sta  $03E7                      ; C6F6
        sta  $03E8                      ; C6F9
        jsr  sub_C48D                   ; C6FC
        lda  $03E1                      ; C6FF
        sta  $03E5                      ; C702
        lda  $03E2                      ; C705
        sta  $03E6                      ; C708
        lda  $03E3                      ; C70B
        sta  $03E7                      ; C70E
        lda  $03E4                      ; C711
        sta  $03E8                      ; C714
        pla                             ; C717
        sta  $03E4                      ; C718
        pla                             ; C71B
        sta  $03E3                      ; C71C
        pla                             ; C71F
        sta  $03E2                      ; C720
        pla                             ; C723
        sta  $03E1                      ; C724
        lda  $03E5                      ; C727
        bne  loc_C73E                   ; C72A
        lda  $03E6                      ; C72C
        bne  loc_C73E                   ; C72F
        lda  $03E7                      ; C731
        bne  loc_C73E                   ; C734
        lda  $03E8                      ; C736
        bne  loc_C73E                   ; C739
        jmp  loc_C741                   ; C73B
loc_C73E:
        jmp  loc_C699                   ; C73E
loc_C741:
        rts                             ; C741
sub_C742:
        lda  $0608                      ; C742
        sta  $C3                        ; C745
        lda  $0609                      ; C747
        sta  $C4                        ; C74A
        ldy  #$00                       ; C74C
        sty  $0615                      ; C74E
loc_C751:
        ldy  #$00                       ; C751
        lda  ($C3),y                    ; C753
        cmp  #$FF                       ; C755
        bne  loc_C764                   ; C757
        iny                             ; C759
        lda  ($C3),y                    ; C75A
        dey                             ; C75C
        cmp  #$FF                       ; C75D
        bne  loc_C764                   ; C75F
        jmp  loc_C777                   ; C761
loc_C764:
        lda  $C3                        ; C764
        clc                             ; C766
        adc  #$04                       ; C767
        sta  $C3                        ; C769
        lda  $C4                        ; C76B
        adc  #$00                       ; C76D
        sta  $C4                        ; C76F
        inc  $0615                      ; C771
        jmp  loc_C751                   ; C774
loc_C777:
        rts                             ; C777
loc_C778:
        ; static (not seen in traces)
        jsr  sub_C274                   ; C778
        lda  $0337                      ; C77B
        cmp  $0615                      ; C77E
        bcc  loc_C786                   ; C781
        jmp  loc_C778                   ; C783
loc_C786:
        ldx  #$00                       ; C786
loc_C788:
        lda  $064D,x                    ; C788
        cmp  #$FF                       ; C78B
        bne  loc_C799                   ; C78D
        lda  $064E,x                    ; C78F
        cmp  #$FF                       ; C792
        bne  loc_C799                   ; C794
        jmp  loc_C7A9                   ; C796
loc_C799:
        lda  $064D,x                    ; C799
        cmp  $0337                      ; C79C
        bne  loc_C7A4                   ; C79F
        jmp  loc_C778                   ; C7A1
loc_C7A4:
        inx                             ; C7A4
        inx                             ; C7A5
        jmp  loc_C788                   ; C7A6
loc_C7A9:
        lda  $0337                      ; C7A9
        sta  $0620                      ; C7AC
        lda  #$00                       ; C7AF
        sta  $0621                      ; C7B1
        rts                             ; C7B4
sub_C7B5:
        ldx  $0646                      ; C7B5
        lda  #$06                       ; C7B8
        sta  $0626,x                    ; C7BA
        rts                             ; C7BD
sub_C7BE:
        inc  $0646                      ; C7BE
        lda  $0608                      ; C7C1
        sta  $C3                        ; C7C4
        lda  $0609                      ; C7C6
        sta  $C4                        ; C7C9
        lda  $061C                      ; C7CB
        sec                             ; C7CE
        sbc  #$01                       ; C7CF
        sta  $0620                      ; C7D1
        lda  $061D                      ; C7D4
        sbc  #$00                       ; C7D7
        sta  $0621                      ; C7D9
        lda  $0621                      ; C7DC
        cmp  $060F                      ; C7DF
        bcc  loc_C7F3                   ; C7E2
        ; static (not seen in traces)
        beq  loc_C7E8                   ; C7E4
        bcs  loc_C7F0                   ; C7E6
loc_C7E8:
        lda  $0620                      ; C7E8
        cmp  $060E                      ; C7EB
        bcc  loc_C7F3                   ; C7EE
loc_C7F0:
        jsr  loc_C778                   ; C7F0
loc_C7F3:
        lda  draw_row                   ; C7F3
        asl  a                          ; C7F6
        tax                             ; C7F7
        lda  $0620                      ; C7F8
        sta  $064D,x                    ; C7FB
        sta  $069C                      ; C7FE
        lda  $0621                      ; C801
        sta  $064E,x                    ; C804
        sta  $069D                      ; C807
        asl  $069C                      ; C80A
        rol  $069D                      ; C80D
        asl  $069C                      ; C810
        rol  $069D                      ; C813
        lda  $C3                        ; C816
        clc                             ; C818
        adc  $069C                      ; C819
        sta  $C3                        ; C81C
        lda  $C4                        ; C81E
        adc  $069D                      ; C820
        sta  $C4                        ; C823
        ldy  #$00                       ; C825
        lda  ($C3),y                    ; C827
        sta  $C5                        ; C829
        iny                             ; C82B
        lda  ($C3),y                    ; C82C
        sta  $C6                        ; C82E
        ldy  #$00                       ; C830
        ldx  $0646                      ; C832
loc_C835:
        lda  ($C5),y                    ; C835
        cmp  #$FF                       ; C837
        beq  loc_C853                   ; C839
        sec                             ; C83B
        sbc  #$20                       ; C83C
        sty  $0624                      ; C83E
        tay                             ; C841
        lda  dat_CDD0,y                 ; C842
        sta  $0626,x                    ; C845
        ldy  $0624                      ; C848
        iny                             ; C84B
        inx                             ; C84C
        inc  $0646                      ; C84D
        jmp  loc_C835                   ; C850
loc_C853:
        rts                             ; C853
sub_C854:
        ; static (not seen in traces)
        rts                             ; C854
        .byte $98,$48,$8A,$48,$A0,$01,$B1,$82,$8D,$06,$20,$88,$B1,$82,$8D,$06 ; C855
        .byte $20,$A0,$02,$B1,$82,$85,$84,$C8,$B1,$82,$85,$85,$A5,$82,$18,$69 ; C865
        .byte $04,$85,$82,$A5,$83,$69,$00,$85,$83,$A0,$08,$B1,$82,$85,$10,$A9 ; C875
        .byte $00,$85,$87,$A9,$09,$85,$86,$A2,$01,$66,$10,$90,$07,$A4,$86,$B1 ; C885
        .byte $82,$AA,$E6,$86,$A4,$87,$B1,$82,$8D,$07,$20,$C6,$84,$D0,$06,$A5 ; C895
        .byte $85,$F0,$1E,$C6,$85,$CA,$D0,$EC,$E6,$87,$A4,$87,$C0,$08,$90,$D7 ; C8A5
        .byte $A5,$82,$18,$65,$86,$85,$82,$A5,$83,$69,$00,$85,$83,$F0,$BA,$D0 ; C8B5
        .byte $B8,$68,$AA,$68,$A8,$68,$60 ; C8C5
call_idle_hook:
        .byte $AD,$99,$06,$F0,$03,$6C,$D4,$00 ; C8CC
idle_hook_rts:
        ; static (not seen in traces)
        rts                             ; C8D4
set_prg_r6r7_3E3F:
        .byte $A9,$06,$8D,$00,$80,$A9,$3E,$8D,$01,$80,$A9,$07,$8D,$00,$80,$A9 ; C8D5
        .byte $3F,$8D,$01,$80,$A9,$00,$8D,$99,$06,$A9,$01,$85,$6D,$20,$4F,$90 ; C8E5
        .byte $60 ; C8F5
tbl_menu_states:
        .word tbl_state0_steps ; C8F6
tbl_state0_steps:
        .word state0_step0_main ; C8F8
        .word state0_step0_nmi ; C8FA
        .word state0_step1_main ; C8FC
        .word state0_step1_nmi ; C8FE
state0_step1_main:
        ; static (not seen in traces)
        lda  #$01                       ; C900
        sta  screen_id                  ; C902
        lda  #$00                       ; C905
        sta  menu_start_pressed         ; C907
        sta  cursor_sprite_inited       ; C90A
        sta  $036A                      ; C90D
        jsr  jt_draw_screen_by_id       ; C910
        jsr  sfx_beep                   ; C913
        lda  #$01                       ; C916
        sta  nmi_dispatch_on            ; C918
        sta  nmi_step_on                ; C91B
        ldx  #$01                       ; C91E
        jsr  jt_C266                    ; C920
loc_C923:
        lda  menu_start_pressed         ; C923
        beq  loc_C923                   ; C926
        lda  #$00                       ; C928
        sta  nmi_step_on                ; C92A
        rts                             ; C92D
state0_step1_nmi:
        inc  $06A1                      ; C92E
        lda  $06A1                      ; C931
        cmp  #$32                       ; C934
        beq  loc_C93D                   ; C936
        lda  pad_state                  ; C938
        beq  loc_C947                   ; C93B
loc_C93D:
        lda  #$00                       ; C93D
        sta  menu_step                  ; C93F
        lda  #$FF                       ; C942
        sta  menu_start_pressed         ; C944
loc_C947:
        rts                             ; C947
state0_step0_main:
        lda  #$00                       ; C948
        sta  screen_id                  ; C94A
        jsr  sub_CD0C                   ; C94D
        jsr  jt_menu_run_screen         ; C950
        jmp  relaunch_saved_game        ; C953
        .byte $60 ; C956
state0_step0_nmi:
        jsr  menu_update_cursor_sprite  ; C957
        lda  list_dirty                 ; C95A
        bne  loc_C962                   ; C95D
        jsr  menu_handle_input          ; C95F
loc_C962:
        rts                             ; C962
menu_update_cursor_sprite:
        lda  cursor_sprite_inited       ; C963
        bne  loc_C99B                   ; C966
        lda  #$FF                       ; C968
        sta  cursor_sprite_inited       ; C96A
        lda  #$00                       ; C96D
        sta  cursor_row                 ; C96F
        lda  $0607                      ; C972
        asl  a                          ; C975
        asl  a                          ; C976
        asl  a                          ; C977
        clc                             ; C978
        adc  dat_C9A5                   ; C979
        sta  $0200                      ; C97C
        lda  dat_C9A6                   ; C97F
        sta  $0201                      ; C982
        lda  dat_C9A7                   ; C985
        sta  $0202                      ; C988
        lda  $0606                      ; C98B
        asl  a                          ; C98E
        asl  a                          ; C98F
        asl  a                          ; C990
        clc                             ; C991
        adc  dat_C9A8                   ; C992
        sec                             ; C995
        sbc  #$0C                       ; C996
        sta  $0203                      ; C998
loc_C99B:
        rts                             ; C99B
        .byte $01,$00,$00,$00,$80,$00,$2C,$00,$48 ; C99C
dat_C9A5:
        .byte $08 ; C9A5
dat_C9A6:
        .byte $2E ; C9A6
dat_C9A7:
        .byte $01 ; C9A7
dat_C9A8:
        .byte $00 ; C9A8
menu_handle_input:
        lda  frame_div7                 ; C9A9
        bne  loc_C9DF                   ; C9AC
        lda  pad_state                  ; C9AE
        and  #$08                       ; C9B1
        bne  loc_CA22                   ; C9B3
        lda  pad_state                  ; C9B5
        and  #$04                       ; C9B8
        bne  loc_CA30                   ; C9BA
        lda  pad_state                  ; C9BC
        and  #$02                       ; C9BF
        bne  loc_C9EA                   ; C9C1
        lda  pad_state                  ; C9C3
        and  #$01                       ; C9C6
        bne  loc_C9F8                   ; C9C8
        lda  pad_state                  ; C9CA
        and  #$10                       ; C9CD
        bne  loc_C9E2                   ; C9CF
        lda  pad_state                  ; C9D1
        and  #$80                       ; C9D4
        bne  loc_CA14                   ; C9D6
        lda  pad_state                  ; C9D8
        and  #$40                       ; C9DB
        bne  loc_CA06                   ; C9DD
loc_C9DF:
        jmp  menu_input_tail            ; C9DF
loc_C9E2:
        lda  #$FF                       ; C9E2
        sta  menu_start_pressed         ; C9E4
        jmp  menu_input_tail            ; C9E7
loc_C9EA:
        ; static (not seen in traces)
        jsr  sfx_beep                   ; C9EA
        lda  #$01                       ; C9ED
        sta  page_step                  ; C9EF
        jsr  page_back_n                ; C9F2
        jmp  menu_input_tail            ; C9F5
loc_C9F8:
        jsr  sfx_beep                   ; C9F8
        lda  #$01                       ; C9FB
        sta  page_step                  ; C9FD
        jsr  page_forward_n             ; CA00
        jmp  menu_input_tail            ; CA03
loc_CA06:
        jsr  sfx_beep                   ; CA06
        lda  #$05                       ; CA09
        sta  page_step                  ; CA0B
        jsr  page_back_n                ; CA0E
        jmp  menu_input_tail            ; CA11
loc_CA14:
        jsr  sfx_beep                   ; CA14
        lda  #$05                       ; CA17
        sta  page_step                  ; CA19
        jsr  page_forward_n             ; CA1C
        jmp  menu_input_tail            ; CA1F
loc_CA22:
        jsr  sfx_beep                   ; CA22
        lda  cursor_row                 ; CA25
        beq  loc_CA41                   ; CA28
        dec  cursor_row                 ; CA2A
        jmp  menu_input_tail            ; CA2D
loc_CA30:
        jsr  sfx_beep                   ; CA30
        inc  cursor_row                 ; CA33
        lda  cursor_row                 ; CA36
        cmp  rows_per_page              ; CA39
        bcs  loc_CA47                   ; CA3C
        jmp  menu_input_tail            ; CA3E
loc_CA41:
        ; static (not seen in traces)
        jsr  cursor_past_top_prev_page  ; CA41
        jmp  menu_input_tail            ; CA44
loc_CA47:
        jsr  cursor_past_bottom_next_page; CA47
menu_input_tail:
        jsr  sub_CCE0                   ; CA4A
        jsr  sub_C619                   ; CA4D
        rts                             ; CA50
page_forward_n:
        ; static (not seen in traces)
        lda  #$FF                       ; CA51
        sta  list_dirty                 ; CA53
        sec                             ; CA56
        lda  $0618                      ; CA57
        sbc  $0610                      ; CA5A
        lda  $0619                      ; CA5D
        sbc  $0611                      ; CA60
        lda  $061A                      ; CA63
        sbc  $0612                      ; CA66
        lda  $061B                      ; CA69
        sbc  $0613                      ; CA6C
        bcc  loc_CA95                   ; CA6F
loc_CA71:
        lda  #$00                       ; CA71
        sta  $0618                      ; CA73
        sta  $0619                      ; CA76
        sta  $061A                      ; CA79
        sta  $061B                      ; CA7C
        sta  cursor_row                 ; CA7F
        lda  #$01                       ; CA82
        sta  $061C                      ; CA84
        lda  #$00                       ; CA87
        sta  $061D                      ; CA89
        sta  $061E                      ; CA8C
        sta  $061F                      ; CA8F
        jmp  loc_CBDD                   ; CA92
loc_CA95:
        lda  $0618                      ; CA95
        clc                             ; CA98
        adc  page_step                  ; CA99
        sta  $0618                      ; CA9C
        lda  $0619                      ; CA9F
        adc  #$00                       ; CAA2
        sta  $0619                      ; CAA4
        lda  $061A                      ; CAA7
        adc  #$00                       ; CAAA
        sta  $061A                      ; CAAC
        lda  $061B                      ; CAAF
        adc  #$00                       ; CAB2
        sta  $061B                      ; CAB4
        sec                             ; CAB7
        lda  $0610                      ; CAB8
        sbc  $0618                      ; CABB
        lda  $0611                      ; CABE
        sbc  $0619                      ; CAC1
        lda  $0612                      ; CAC4
        sbc  $061A                      ; CAC7
        lda  $0613                      ; CACA
        sbc  $061B                      ; CACD
        bcs  loc_CAD5                   ; CAD0
        jmp  loc_CA71                   ; CAD2
loc_CAD5:
        jsr  sub_CAF2                   ; CAD5
        bne  loc_CAEE                   ; CAD8
        lda  cursor_row                 ; CADA
        cmp  $0614                      ; CADD
        bcc  loc_CAEE                   ; CAE0
        lda  $0614                      ; CAE2
        sec                             ; CAE5
        sbc  #$01                       ; CAE6
        sta  cursor_row                 ; CAE8
        jmp  loc_CAEE                   ; CAEB
loc_CAEE:
        jmp  loc_CBDD                   ; CAEE
        .byte $60 ; CAF1
sub_CAF2:
        ; static (not seen in traces)
        lda  $0610                      ; CAF2
        cmp  $0618                      ; CAF5
        bne  loc_CB15                   ; CAF8
        lda  $0611                      ; CAFA
        cmp  $0619                      ; CAFD
        bne  loc_CB15                   ; CB00
        lda  $0612                      ; CB02
        cmp  $061A                      ; CB05
        bne  loc_CB15                   ; CB08
        lda  $0613                      ; CB0A
        cmp  $061B                      ; CB0D
        bne  loc_CB15                   ; CB10
        lda  #$00                       ; CB12
        rts                             ; CB14
loc_CB15:
        lda  #$01                       ; CB15
        rts                             ; CB17
cursor_past_bottom_next_page:
        lda  #$FF                       ; CB18
        sta  list_dirty                 ; CB1A
        lda  $0618                      ; CB1D
        cmp  $0610                      ; CB20
        bne  loc_CB61                   ; CB23
        lda  $0619                      ; CB25
        cmp  $0611                      ; CB28
        bne  loc_CB61                   ; CB2B
        lda  $061A                      ; CB2D
        cmp  $0612                      ; CB30
        bne  loc_CB61                   ; CB33
        lda  $061B                      ; CB35
        cmp  $0613                      ; CB38
        bne  loc_CB61                   ; CB3B
        lda  #$00                       ; CB3D
        sta  $0618                      ; CB3F
        sta  $0619                      ; CB42
        sta  $061A                      ; CB45
        sta  $061B                      ; CB48
        lda  #$01                       ; CB4B
        sta  $061C                      ; CB4D
        lda  #$00                       ; CB50
        sta  $061D                      ; CB52
        sta  $061E                      ; CB55
        sta  $061F                      ; CB58
        sta  cursor_row                 ; CB5B
        jmp  loc_CB87                   ; CB5E
loc_CB61:
        lda  $0618                      ; CB61
        clc                             ; CB64
        adc  #$01                       ; CB65
        sta  $0618                      ; CB67
        lda  $0619                      ; CB6A
        adc  #$00                       ; CB6D
        sta  $0619                      ; CB6F
        lda  $061A                      ; CB72
        adc  #$00                       ; CB75
        sta  $061A                      ; CB77
        lda  $061B                      ; CB7A
        adc  #$00                       ; CB7D
        sta  $061B                      ; CB7F
        lda  #$00                       ; CB82
        sta  cursor_row                 ; CB84
loc_CB87:
        rts                             ; CB87
page_back_n:
        lda  #$FF                       ; CB88
        sta  list_dirty                 ; CB8A
        sec                             ; CB8D
        lda  $0618                      ; CB8E
        sbc  page_step                  ; CB91
        sta  $0618                      ; CB94
        lda  $0619                      ; CB97
        sbc  #$00                       ; CB9A
        sta  $0619                      ; CB9C
        lda  $061A                      ; CB9F
        sbc  #$00                       ; CBA2
        sta  $061A                      ; CBA4
        lda  $061B                      ; CBA7
        sbc  #$00                       ; CBAA
        sta  $061B                      ; CBAC
        bcs  loc_CBDD                   ; CBAF
        lda  $0610                      ; CBB1
        sta  $0618                      ; CBB4
        lda  $0611                      ; CBB7
        sta  $0619                      ; CBBA
        lda  $0612                      ; CBBD
        sta  $061A                      ; CBC0
        lda  $0613                      ; CBC3
        sta  $061B                      ; CBC6
        lda  cursor_row                 ; CBC9
        cmp  $0614                      ; CBCC
        bcc  loc_CBDD                   ; CBCF
        lda  $0614                      ; CBD1
        sec                             ; CBD4
        sbc  #$01                       ; CBD5
        sta  cursor_row                 ; CBD7
        jmp  loc_CBDD                   ; CBDA
loc_CBDD:
        lda  $0618                      ; CBDD
        sta  $03D1                      ; CBE0
        lda  $0619                      ; CBE3
        sta  $03D2                      ; CBE6
        lda  $061A                      ; CBE9
        sta  $03D3                      ; CBEC
        lda  $061B                      ; CBEF
        sta  $03D4                      ; CBF2
        lda  $0604                      ; CBF5
        sta  $03D5                      ; CBF8
        lda  #$00                       ; CBFB
        sta  $03D6                      ; CBFD
        sta  $03D7                      ; CC00
        sta  $03D8                      ; CC03
        jsr  sub_C503                   ; CC06
        lda  $03D9                      ; CC09
        clc                             ; CC0C
        adc  #$01                       ; CC0D
        sta  $061C                      ; CC0F
        lda  $03DA                      ; CC12
        adc  #$00                       ; CC15
        sta  $061D                      ; CC17
        lda  $03DB                      ; CC1A
        adc  #$00                       ; CC1D
        sta  $061E                      ; CC1F
        lda  $03DC                      ; CC22
        adc  #$00                       ; CC25
        sta  $061F                      ; CC27
        rts                             ; CC2A
cursor_past_top_prev_page:
        lda  #$FF                       ; CC2B
        sta  list_dirty                 ; CC2D
        lda  $0618                      ; CC30
        bne  loc_CC68                   ; CC33
        lda  $0619                      ; CC35
        bne  loc_CC68                   ; CC38
        lda  $061A                      ; CC3A
        bne  loc_CC68                   ; CC3D
        lda  $061B                      ; CC3F
        bne  loc_CC68                   ; CC42
        lda  $0610                      ; CC44
        sta  $0618                      ; CC47
        lda  $0611                      ; CC4A
        sta  $0619                      ; CC4D
        lda  $0612                      ; CC50
        sta  $061A                      ; CC53
        lda  $0613                      ; CC56
        sta  $061B                      ; CC59
        lda  $0614                      ; CC5C
        sec                             ; CC5F
        sbc  #$01                       ; CC60
        sta  cursor_row                 ; CC62
        jmp  loc_CC92                   ; CC65
loc_CC68:
        lda  $0618                      ; CC68
        sec                             ; CC6B
        sbc  #$01                       ; CC6C
        sta  $0618                      ; CC6E
        lda  $0619                      ; CC71
        sbc  #$00                       ; CC74
        sta  $0619                      ; CC76
        lda  $061A                      ; CC79
        sbc  #$00                       ; CC7C
        sta  $061A                      ; CC7E
        lda  $061B                      ; CC81
        sbc  #$00                       ; CC84
        sta  $061B                      ; CC86
        lda  $0604                      ; CC89
        sec                             ; CC8C
        sbc  #$01                       ; CC8D
        sta  cursor_row                 ; CC8F
loc_CC92:
        lda  $0618                      ; CC92
        sta  $03D1                      ; CC95
        lda  $0619                      ; CC98
        sta  $03D2                      ; CC9B
        lda  $061A                      ; CC9E
        sta  $03D3                      ; CCA1
        lda  $061B                      ; CCA4
        sta  $03D4                      ; CCA7
        lda  $0604                      ; CCAA
        sta  $03D5                      ; CCAD
        lda  #$00                       ; CCB0
        sta  $03D6                      ; CCB2
        sta  $03D7                      ; CCB5
        sta  $03D8                      ; CCB8
        jsr  sub_C503                   ; CCBB
        lda  $03D9                      ; CCBE
        clc                             ; CCC1
        adc  #$01                       ; CCC2
        sta  $061C                      ; CCC4
        lda  $03DA                      ; CCC7
        adc  #$00                       ; CCCA
        sta  $061D                      ; CCCC
        lda  $03DB                      ; CCCF
        adc  #$00                       ; CCD2
        sta  $061E                      ; CCD4
        lda  $03DC                      ; CCD7
        adc  #$00                       ; CCDA
        sta  $061F                      ; CCDC
        rts                             ; CCDF
sub_CCE0:
        lda  $0605                      ; CCE0
        clc                             ; CCE3
        adc  #$01                       ; CCE4
        asl  a                          ; CCE6
        asl  a                          ; CCE7
        asl  a                          ; CCE8
        sta  $0323                      ; CCE9
        lda  cursor_row                 ; CCEC
        sta  $0324                      ; CCEF
        jsr  jt_C1FB                    ; CCF2
        lda  $0325                      ; CCF5
        sta  $0200                      ; CCF8
        lda  $0607                      ; CCFB
        asl  a                          ; CCFE
        asl  a                          ; CCFF
        asl  a                          ; CD00
        clc                             ; CD01
        adc  $0200                      ; CD02
        sec                             ; CD05
        sbc  #$02                       ; CD06
        sta  $0200                      ; CD08
        rts                             ; CD0B
sub_CD0C:
        lda  #$01                       ; CD0C
        sta  $061C                      ; CD0E
        lda  #$00                       ; CD11
        sta  $061D                      ; CD13
        sta  $061E                      ; CD16
        sta  $061F                      ; CD19
        sta  $0618                      ; CD1C
        sta  $0619                      ; CD1F
        sta  $061A                      ; CD22
        sta  $061B                      ; CD25
        lda  $0698                      ; CD28
        asl  a                          ; CD2B
        asl  a                          ; CD2C
        tay                             ; CD2D
        lda  dat_CE32,y                 ; CD2E
        sta  $C3                        ; CD31
        lda  dat_CE33,y                 ; CD33
        sta  $C4                        ; CD36
        ldy  #$00                       ; CD38
loc_CD3A:
        lda  ($C3),y                    ; CD3A
        sta  $0600,y                    ; CD3C
        iny                             ; CD3F
        cpy  #$10                       ; CD40
        bne  loc_CD3A                   ; CD42
        jsr  sub_C742                   ; CD44
        lda  $0600                      ; CD47
        sta  $03E1                      ; CD4A
        lda  $0601                      ; CD4D
        sta  $03E2                      ; CD50
        lda  $0602                      ; CD53
        sta  $03E3                      ; CD56
        lda  $0603                      ; CD59
        sta  $03E4                      ; CD5C
        lda  $0604                      ; CD5F
        sta  $03E5                      ; CD62
        lda  #$00                       ; CD65
        sta  $03E6                      ; CD67
        sta  $03E7                      ; CD6A
        sta  $03E8                      ; CD6D
        jsr  sub_C48D                   ; CD70
        lda  $03E9                      ; CD73
        bne  loc_CDB1                   ; CD76
        lda  $03EA                      ; CD78
        bne  loc_CDB1                   ; CD7B
        lda  $03EB                      ; CD7D
        bne  loc_CDB1                   ; CD80
        lda  $03EC                      ; CD82
        bne  loc_CDB1                   ; CD85
        sec                             ; CD87
        lda  $03E1                      ; CD88
        sbc  #$01                       ; CD8B
        sta  $0610                      ; CD8D
        lda  $03E2                      ; CD90
        sbc  #$00                       ; CD93
        sta  $0611                      ; CD95
        lda  $03E3                      ; CD98
        sbc  #$00                       ; CD9B
        sta  $0612                      ; CD9D
        lda  $03E4                      ; CDA0
        sbc  #$00                       ; CDA3
        sta  $0613                      ; CDA5
        lda  $0604                      ; CDA8
        sta  $0614                      ; CDAB
        jmp  loc_CDCF                   ; CDAE
loc_CDB1:
        ; static (not seen in traces)
        lda  $03E1                      ; CDB1
        sta  $0610                      ; CDB4
        lda  $03E2                      ; CDB7
        sta  $0611                      ; CDBA
        lda  $03E3                      ; CDBD
        sta  $0612                      ; CDC0
        lda  $03E4                      ; CDC3
        sta  $0613                      ; CDC6
        lda  $03E9                      ; CDC9
        sta  $0614                      ; CDCC
loc_CDCF:
        rts                             ; CDCF
dat_CDD0:
        .byte $00,$01,$02,$00,$00,$00,$03,$04,$00,$00,$00,$00,$00,$05,$06,$07 ; CDD0
        .byte $08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$00,$00,$00,$00,$00 ; CDE0
        .byte $13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22 ; CDF0
        .byte $23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$00,$00,$00,$00,$00 ; CE00
        .byte $13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22 ; CE10
        .byte $23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$00,$00,$00,$00,$00 ; CE20
tbl_list_order_ptrs:
        .byte $7D ; CE30
dat_CE31:
        .byte $CE ; CE31
dat_CE32:
        .byte $6B ; CE32
dat_CE33:
        .byte $CE ; CE33
dat_CE34:
        .byte $36 ; CE34
dat_CE35:
        .byte $CE,$0B,$08,$08,$01,$00,$35,$30,$30,$20,$49,$4E,$20,$31,$20,$20 ; CE35
        .byte $0B,$16,$0E,$02,$00,$4C,$20,$52,$20,$2D,$20,$4F,$4E,$45,$20,$50 ; CE45
        .byte $41,$47,$45,$0B,$16,$0E,$02,$00,$41,$20,$42,$20,$2D,$46,$49,$56 ; CE55
        .byte $45,$20,$50,$41,$47,$45,$90,$01,$00,$00,$0A,$01,$08,$05,$7B,$CE ; CE65
        .byte $4D,$D6,$4F,$D6,$90,$01 ; CE75
tbl_list_entries_lo:
        .byte $00,$80,$8A,$00 ; CE7B  list_entry_lo 0
        .byte $10,$80,$06,$01 ; CE7F  list_entry_lo 1
        .byte $20,$80,$07,$02 ; CE83  list_entry_lo 2
        .byte $30,$80,$99,$03 ; CE87  list_entry_lo 3
        .byte $40,$80,$45,$04 ; CE8B  list_entry_lo 4
        .byte $50,$80,$00,$05 ; CE8F  list_entry_lo 5
        .byte $60,$80,$01,$06 ; CE93  list_entry_lo 6
        .byte $70,$80,$02,$07 ; CE97  list_entry_lo 7
        .byte $80,$80,$03,$08 ; CE9B  list_entry_lo 8
        .byte $90,$80,$04,$09 ; CE9F  list_entry_lo 9
        .byte $A0,$80,$05,$0A ; CEA3  list_entry_lo 10
        .byte $B0,$80,$08,$0B ; CEA7  list_entry_lo 11
        .byte $C0,$80,$38,$0C ; CEAB  list_entry_lo 12
        .byte $D0,$80,$9D,$0D ; CEAF  list_entry_lo 13
        .byte $E0,$80,$09,$0E ; CEB3  list_entry_lo 14
        .byte $F0,$80,$0A,$0F ; CEB7  list_entry_lo 15
        .byte $00,$81,$0B,$10 ; CEBB  list_entry_lo 16
        .byte $10,$81,$0C,$11 ; CEBF  list_entry_lo 17
        .byte $20,$81,$0D,$12 ; CEC3  list_entry_lo 18
        .byte $30,$81,$0E,$13 ; CEC7  list_entry_lo 19
        .byte $40,$81,$0F,$14 ; CECB  list_entry_lo 20
        .byte $50,$81,$10,$15 ; CECF  list_entry_lo 21
        .byte $60,$81,$11,$16 ; CED3  list_entry_lo 22
        .byte $70,$81,$12,$17 ; CED7  list_entry_lo 23
        .byte $80,$81,$13,$18 ; CEDB  list_entry_lo 24
        .byte $90,$81,$14,$19 ; CEDF  list_entry_lo 25
        .byte $A0,$81,$15,$1A ; CEE3  list_entry_lo 26
        .byte $B0,$81,$16,$1B ; CEE7  list_entry_lo 27
        .byte $C0,$81,$17,$1C ; CEEB  list_entry_lo 28
        .byte $D0,$81,$18,$1D ; CEEF  list_entry_lo 29
        .byte $E0,$81,$96,$1E ; CEF3  list_entry_lo 30
        .byte $F0,$81,$9E,$1F ; CEF7  list_entry_lo 31
        .byte $00,$82,$19,$20 ; CEFB  list_entry_lo 32
        .byte $10,$82,$1A,$21 ; CEFF  list_entry_lo 33
        .byte $20,$82,$1B,$22 ; CF03  list_entry_lo 34
        .byte $30,$82,$1C,$23 ; CF07  list_entry_lo 35
        .byte $40,$82,$1D,$24 ; CF0B  list_entry_lo 36
        .byte $50,$82,$1E,$25 ; CF0F  list_entry_lo 37
        .byte $60,$82,$1F,$26 ; CF13  list_entry_lo 38
        .byte $70,$82,$20,$27 ; CF17  list_entry_lo 39
        .byte $80,$82,$21,$28 ; CF1B  list_entry_lo 40
        .byte $90,$82,$22,$29 ; CF1F  list_entry_lo 41
        .byte $A0,$82,$23,$2A ; CF23  list_entry_lo 42
        .byte $B0,$82,$24,$2B ; CF27  list_entry_lo 43
        .byte $C0,$82,$25,$2C ; CF2B  list_entry_lo 44
        .byte $D0,$82,$26,$2D ; CF2F  list_entry_lo 45
        .byte $E0,$82,$27,$2E ; CF33  list_entry_lo 46
        .byte $F0,$82,$28,$2F ; CF37  list_entry_lo 47
        .byte $00,$83,$29,$30 ; CF3B  list_entry_lo 48
        .byte $10,$83,$2A,$31 ; CF3F  list_entry_lo 49
        .byte $20,$83,$2B,$32 ; CF43  list_entry_lo 50
        .byte $30,$83,$2C,$33 ; CF47  list_entry_lo 51
        .byte $40,$83,$2D,$34 ; CF4B  list_entry_lo 52
        .byte $50,$83,$2E,$35 ; CF4F  list_entry_lo 53
        .byte $60,$83,$2F,$36 ; CF53  list_entry_lo 54
        .byte $70,$83,$30,$37 ; CF57  list_entry_lo 55
        .byte $80,$83,$31,$38 ; CF5B  list_entry_lo 56
        .byte $90,$83,$32,$39 ; CF5F  list_entry_lo 57
        .byte $A0,$83,$33,$3A ; CF63  list_entry_lo 58
        .byte $B0,$83,$34,$3B ; CF67  list_entry_lo 59
        .byte $C0,$83,$35,$3C ; CF6B  list_entry_lo 60
        .byte $D0,$83,$36,$3D ; CF6F  list_entry_lo 61
        .byte $E0,$83,$37,$3E ; CF73  list_entry_lo 62
        .byte $F0,$83,$38,$3F ; CF77  list_entry_lo 63
        .byte $00,$84,$39,$40 ; CF7B  list_entry_lo 64
        .byte $10,$84,$3A,$41 ; CF7F  list_entry_lo 65
        .byte $20,$84,$3B,$42 ; CF83  list_entry_lo 66
        .byte $30,$84,$3C,$43 ; CF87  list_entry_lo 67
        .byte $40,$84,$3D,$44 ; CF8B  list_entry_lo 68
        .byte $50,$84,$3E,$45 ; CF8F  list_entry_lo 69
        .byte $60,$84,$3F,$46 ; CF93  list_entry_lo 70
        .byte $70,$84,$40,$47 ; CF97  list_entry_lo 71
        .byte $80,$84,$41,$48 ; CF9B  list_entry_lo 72
        .byte $90,$84,$42,$49 ; CF9F  list_entry_lo 73
        .byte $A0,$84,$43,$4A ; CFA3  list_entry_lo 74
        .byte $B0,$84,$44,$4B ; CFA7  list_entry_lo 75
        .byte $C0,$84,$46,$4C ; CFAB  list_entry_lo 76
        .byte $D0,$84,$47,$4D ; CFAF  list_entry_lo 77
        .byte $E0,$84,$48,$4E ; CFB3  list_entry_lo 78
        .byte $F0,$84,$49,$4F ; CFB7  list_entry_lo 79
        .byte $00,$85,$4A,$50 ; CFBB  list_entry_lo 80
        .byte $10,$85,$4B,$51 ; CFBF  list_entry_lo 81
        .byte $20,$85,$4C,$52 ; CFC3  list_entry_lo 82
        .byte $30,$85,$4D,$53 ; CFC7  list_entry_lo 83
        .byte $40,$85,$4E,$54 ; CFCB  list_entry_lo 84
        .byte $50,$85,$4F,$55 ; CFCF  list_entry_lo 85
        .byte $60,$85,$50,$56 ; CFD3  list_entry_lo 86
        .byte $70,$85,$51,$57 ; CFD7  list_entry_lo 87
        .byte $80,$85,$52,$58 ; CFDB  list_entry_lo 88
        .byte $90,$85,$53,$59 ; CFDF  list_entry_lo 89
        .byte $A0,$85,$54,$5A ; CFE3  list_entry_lo 90
        .byte $B0,$85,$55,$5B ; CFE7  list_entry_lo 91
        .byte $C0,$85,$56,$5C ; CFEB  list_entry_lo 92
        .byte $D0,$85,$57,$5D ; CFEF  list_entry_lo 93
        .byte $E0,$85,$58,$5E ; CFF3  list_entry_lo 94
        .byte $F0,$85,$59,$5F ; CFF7  list_entry_lo 95
        .byte $00,$86,$5A,$60 ; CFFB  list_entry_lo 96
        .byte $10,$86,$5B,$61 ; CFFF  list_entry_lo 97
        .byte $20,$86,$5C,$62 ; D003  list_entry_lo 98
        .byte $30,$86,$5D,$63 ; D007  list_entry_lo 99
        .byte $40,$86,$5E,$64 ; D00B  list_entry_lo 100
        .byte $50,$86,$5F,$65 ; D00F  list_entry_lo 101
        .byte $60,$86,$60,$66 ; D013  list_entry_lo 102
        .byte $70,$86,$61,$67 ; D017  list_entry_lo 103
        .byte $80,$86,$62,$68 ; D01B  list_entry_lo 104
        .byte $90,$86,$63,$69 ; D01F  list_entry_lo 105
        .byte $A0,$86,$64,$6A ; D023  list_entry_lo 106
        .byte $B0,$86,$65,$6B ; D027  list_entry_lo 107
        .byte $C0,$86,$66,$6C ; D02B  list_entry_lo 108
        .byte $D0,$86,$67,$6D ; D02F  list_entry_lo 109
        .byte $E0,$86,$68,$6E ; D033  list_entry_lo 110
        .byte $F0,$86,$69,$6F ; D037  list_entry_lo 111
        .byte $00,$87,$6A,$70 ; D03B  list_entry_lo 112
        .byte $10,$87,$6B,$71 ; D03F  list_entry_lo 113
        .byte $20,$87,$6C,$72 ; D043  list_entry_lo 114
        .byte $30,$87,$6D,$73 ; D047  list_entry_lo 115
        .byte $40,$87,$6E,$74 ; D04B  list_entry_lo 116
        .byte $50,$87,$6F,$75 ; D04F  list_entry_lo 117
        .byte $60,$87,$70,$76 ; D053  list_entry_lo 118
        .byte $70,$87,$71,$77 ; D057  list_entry_lo 119
        .byte $80,$87,$72,$78 ; D05B  list_entry_lo 120
        .byte $90,$87,$73,$79 ; D05F  list_entry_lo 121
        .byte $A0,$87,$74,$7A ; D063  list_entry_lo 122
        .byte $B0,$87,$75,$7B ; D067  list_entry_lo 123
        .byte $C0,$87,$76,$7C ; D06B  list_entry_lo 124
        .byte $D0,$87,$77,$7D ; D06F  list_entry_lo 125
        .byte $E0,$87,$78,$7E ; D073  list_entry_lo 126
        .byte $F0,$87,$79,$7F ; D077  list_entry_lo 127
        .byte $00,$88,$7A,$80 ; D07B  list_entry_lo 128
        .byte $10,$88,$7B,$81 ; D07F  list_entry_lo 129
        .byte $20,$88,$7C,$82 ; D083  list_entry_lo 130
        .byte $30,$88,$7D,$83 ; D087  list_entry_lo 131
        .byte $40,$88,$7E,$84 ; D08B  list_entry_lo 132
        .byte $50,$88,$7F,$85 ; D08F  list_entry_lo 133
        .byte $60,$88,$80,$86 ; D093  list_entry_lo 134
        .byte $70,$88,$81,$87 ; D097  list_entry_lo 135
        .byte $80,$88,$82,$88 ; D09B  list_entry_lo 136
        .byte $90,$88,$83,$89 ; D09F  list_entry_lo 137
        .byte $A0,$88,$84,$8A ; D0A3  list_entry_lo 138
        .byte $B0,$88,$85,$8B ; D0A7  list_entry_lo 139
        .byte $C0,$88,$86,$8C ; D0AB  list_entry_lo 140
        .byte $D0,$88,$87,$8D ; D0AF  list_entry_lo 141
        .byte $E0,$88,$88,$8E ; D0B3  list_entry_lo 142
        .byte $F0,$88,$89,$8F ; D0B7  list_entry_lo 143
        .byte $00,$89,$8B,$90 ; D0BB  list_entry_lo 144
        .byte $10,$89,$8C,$91 ; D0BF  list_entry_lo 145
        .byte $20,$89,$8D,$92 ; D0C3  list_entry_lo 146
        .byte $30,$89,$8E,$93 ; D0C7  list_entry_lo 147
        .byte $40,$89,$8F,$94 ; D0CB  list_entry_lo 148
        .byte $50,$89,$90,$95 ; D0CF  list_entry_lo 149
        .byte $60,$89,$91,$96 ; D0D3  list_entry_lo 150
        .byte $70,$89,$92,$97 ; D0D7  list_entry_lo 151
        .byte $80,$89,$93,$98 ; D0DB  list_entry_lo 152
        .byte $90,$89,$94,$99 ; D0DF  list_entry_lo 153
        .byte $A0,$89,$95,$9A ; D0E3  list_entry_lo 154
        .byte $B0,$89,$9B,$9B ; D0E7  list_entry_lo 155
        .byte $C0,$89,$97,$9C ; D0EB  list_entry_lo 156
        .byte $D0,$89,$98,$9D ; D0EF  list_entry_lo 157
        .byte $E0,$89,$9A,$9E ; D0F3  list_entry_lo 158
        .byte $F0,$89,$9C,$9F ; D0F7  list_entry_lo 159
        .byte $00,$8A,$9F,$A0 ; D0FB  list_entry_lo 160
        .byte $10,$8A,$A0,$A1 ; D0FF  list_entry_lo 161
        .byte $20,$8A,$A1,$A2 ; D103  list_entry_lo 162
        .byte $30,$8A,$A2,$A3 ; D107  list_entry_lo 163
        .byte $40,$8A,$A3,$A4 ; D10B  list_entry_lo 164
        .byte $50,$8A,$A4,$A5 ; D10F  list_entry_lo 165
        .byte $60,$8A,$A5,$A6 ; D113  list_entry_lo 166
        .byte $70,$8A,$A6,$A7 ; D117  list_entry_lo 167
        .byte $80,$8A,$A7,$A8 ; D11B  list_entry_lo 168
        .byte $90,$8A,$A8,$A9 ; D11F  list_entry_lo 169
        .byte $A0,$8A,$A9,$AA ; D123  list_entry_lo 170
        .byte $B0,$8A,$AA,$AB ; D127  list_entry_lo 171
        .byte $C0,$8A,$AB,$AC ; D12B  list_entry_lo 172
        .byte $D0,$8A,$AC,$AD ; D12F  list_entry_lo 173
        .byte $E0,$8A,$AD,$AE ; D133  list_entry_lo 174
        .byte $F0,$8A,$AE,$AF ; D137  list_entry_lo 175
        .byte $00,$8B,$AF,$B0 ; D13B  list_entry_lo 176
        .byte $10,$8B,$B0,$B1 ; D13F  list_entry_lo 177
        .byte $20,$8B,$B1,$B3 ; D143  list_entry_lo 178
        .byte $30,$8B,$B2,$B3 ; D147  list_entry_lo 179
        .byte $40,$8B,$B3,$B4 ; D14B  list_entry_lo 180
        .byte $50,$8B,$B4,$B5 ; D14F  list_entry_lo 181
        .byte $60,$8B,$B5,$B6 ; D153  list_entry_lo 182
        .byte $70,$8B,$B6,$B7 ; D157  list_entry_lo 183
        .byte $80,$8B,$B7,$B8 ; D15B  list_entry_lo 184
        .byte $90,$8B,$B8,$B9 ; D15F  list_entry_lo 185
        .byte $A0,$8B,$B9,$BA ; D163  list_entry_lo 186
        .byte $B0,$8B,$BA,$BB ; D167  list_entry_lo 187
        .byte $C0,$8B,$BB,$BC ; D16B  list_entry_lo 188
        .byte $D0,$8B,$BC,$BD ; D16F  list_entry_lo 189
        .byte $E0,$8B,$BD,$BE ; D173  list_entry_lo 190
        .byte $F0,$8B,$BE,$BF ; D177  list_entry_lo 191
        .byte $00,$8C,$BF,$C0 ; D17B  list_entry_lo 192
        .byte $10,$8C,$C0,$C1 ; D17F  list_entry_lo 193
        .byte $20,$8C,$C1,$C2 ; D183  list_entry_lo 194
        .byte $30,$8C,$C2,$C3 ; D187  list_entry_lo 195
        .byte $40,$8C,$C3,$C4 ; D18B  list_entry_lo 196
        .byte $50,$8C,$C4,$C5 ; D18F  list_entry_lo 197
        .byte $60,$8C,$C5,$C6 ; D193  list_entry_lo 198
        .byte $70,$8C,$C6,$C7 ; D197  list_entry_lo 199
        .byte $80,$8C,$C7,$C8 ; D19B  list_entry_lo 200
        .byte $90,$8C,$C8,$C9 ; D19F  list_entry_lo 201
        .byte $A0,$8C,$C9,$CA ; D1A3  list_entry_lo 202
        .byte $B0,$8C,$CA,$CB ; D1A7  list_entry_lo 203
        .byte $C0,$8C,$CB,$CC ; D1AB  list_entry_lo 204
        .byte $D0,$8C,$CC,$CD ; D1AF  list_entry_lo 205
        .byte $E0,$8C,$CD,$CE ; D1B3  list_entry_lo 206
        .byte $F0,$8C,$CE,$CF ; D1B7  list_entry_lo 207
        .byte $00,$8D,$CF,$D0 ; D1BB  list_entry_lo 208
        .byte $10,$8D,$D0,$D1 ; D1BF  list_entry_lo 209
        .byte $20,$8D,$D1,$D2 ; D1C3  list_entry_lo 210
        .byte $30,$8D,$D2,$D3 ; D1C7  list_entry_lo 211
        .byte $40,$8D,$D3,$D4 ; D1CB  list_entry_lo 212
        .byte $50,$8D,$D4,$D5 ; D1CF  list_entry_lo 213
        .byte $60,$8D,$D5,$D6 ; D1D3  list_entry_lo 214
        .byte $70,$8D,$D6,$D7 ; D1D7  list_entry_lo 215
        .byte $80,$8D,$D7,$D8 ; D1DB  list_entry_lo 216
        .byte $90,$8D,$D8,$D9 ; D1DF  list_entry_lo 217
        .byte $A0,$8D,$D9,$DA ; D1E3  list_entry_lo 218
        .byte $B0,$8D,$DA,$DB ; D1E7  list_entry_lo 219
        .byte $C0,$8D,$DB,$DC ; D1EB  list_entry_lo 220
        .byte $D0,$8D,$DC,$DD ; D1EF  list_entry_lo 221
        .byte $E0,$8D,$DD,$DE ; D1F3  list_entry_lo 222
        .byte $F0,$8D,$DE,$DF ; D1F7  list_entry_lo 223
        .byte $00,$8E,$DF,$E0 ; D1FB  list_entry_lo 224
        .byte $10,$8E,$E0,$E1 ; D1FF  list_entry_lo 225
        .byte $20,$8E,$E1,$E2 ; D203  list_entry_lo 226
        .byte $30,$8E,$E2,$E3 ; D207  list_entry_lo 227
        .byte $40,$8E,$E3,$E4 ; D20B  list_entry_lo 228
        .byte $50,$8E,$E4,$E5 ; D20F  list_entry_lo 229
        .byte $60,$8E,$E5,$E6 ; D213  list_entry_lo 230
        .byte $70,$8E,$E6,$E7 ; D217  list_entry_lo 231
        .byte $80,$8E,$E7,$E8 ; D21B  list_entry_lo 232
        .byte $90,$8E,$E8,$E9 ; D21F  list_entry_lo 233
        .byte $A0,$8E,$E9,$EA ; D223  list_entry_lo 234
        .byte $B0,$8E,$EA,$EB ; D227  list_entry_lo 235
        .byte $C0,$8E,$EB,$EC ; D22B  list_entry_lo 236
        .byte $D0,$8E,$EC,$ED ; D22F  list_entry_lo 237
        .byte $E0,$8E,$ED,$EE ; D233  list_entry_lo 238
        .byte $F0,$8E,$EE,$EF ; D237  list_entry_lo 239
        .byte $00,$8F,$EF,$F0 ; D23B  list_entry_lo 240
        .byte $10,$8F,$F0,$F1 ; D23F  list_entry_lo 241
        .byte $20,$8F,$F1,$F2 ; D243  list_entry_lo 242
        .byte $30,$8F,$F2,$F3 ; D247  list_entry_lo 243
        .byte $40,$8F,$F3,$F4 ; D24B  list_entry_lo 244
        .byte $50,$8F,$F4,$F5 ; D24F  list_entry_lo 245
        .byte $60,$8F,$F5,$F6 ; D253  list_entry_lo 246
        .byte $70,$8F,$F6,$F7 ; D257  list_entry_lo 247
        .byte $80,$8F,$F7,$F8 ; D25B  list_entry_lo 248
        .byte $90,$8F,$F8,$F9 ; D25F  list_entry_lo 249
        .byte $A0,$8F,$F9,$FA ; D263  list_entry_lo 250
        .byte $B0,$8F,$FA,$FB ; D267  list_entry_lo 251
        .byte $C0,$8F,$FB,$FC ; D26B  list_entry_lo 252
        .byte $D0,$8F,$FC,$FD ; D26F  list_entry_lo 253
        .byte $E0,$8F,$FD,$FE ; D273  list_entry_lo 254
        .byte $F0,$8F,$FE,$FF ; D277  list_entry_lo 255
tbl_list_entries_hi:
        .byte $00,$90,$38,$00 ; D27B  list_entry_hi 0
        .byte $10,$90,$00,$01 ; D27F  list_entry_hi 1
        .byte $20,$90,$01,$02 ; D283  list_entry_hi 2
        .byte $30,$90,$02,$03 ; D287  list_entry_hi 3
        .byte $40,$90,$03,$04 ; D28B  list_entry_hi 4
        .byte $50,$90,$04,$05 ; D28F  list_entry_hi 5
        .byte $60,$90,$05,$06 ; D293  list_entry_hi 6
        .byte $70,$90,$06,$07 ; D297  list_entry_hi 7
        .byte $80,$90,$07,$08 ; D29B  list_entry_hi 8
        .byte $90,$90,$08,$09 ; D29F  list_entry_hi 9
        .byte $A0,$90,$09,$0A ; D2A3  list_entry_hi 10
        .byte $B0,$90,$0A,$0B ; D2A7  list_entry_hi 11
        .byte $C0,$90,$0B,$0C ; D2AB  list_entry_hi 12
        .byte $D0,$90,$0C,$0D ; D2AF  list_entry_hi 13
        .byte $E0,$90,$0D,$0E ; D2B3  list_entry_hi 14
        .byte $F0,$90,$0E,$0F ; D2B7  list_entry_hi 15
        .byte $00,$91,$0F,$10 ; D2BB  list_entry_hi 16
        .byte $10,$91,$10,$11 ; D2BF  list_entry_hi 17
        .byte $20,$91,$11,$12 ; D2C3  list_entry_hi 18
        .byte $30,$91,$12,$13 ; D2C7  list_entry_hi 19
        .byte $40,$91,$13,$14 ; D2CB  list_entry_hi 20
        .byte $50,$91,$14,$15 ; D2CF  list_entry_hi 21
        .byte $60,$91,$15,$16 ; D2D3  list_entry_hi 22
        .byte $70,$91,$16,$17 ; D2D7  list_entry_hi 23
        .byte $80,$91,$17,$18 ; D2DB  list_entry_hi 24
        .byte $90,$91,$18,$19 ; D2DF  list_entry_hi 25
        .byte $A0,$91,$19,$1A ; D2E3  list_entry_hi 26
        .byte $B0,$91,$1A,$1B ; D2E7  list_entry_hi 27
        .byte $C0,$91,$1B,$1C ; D2EB  list_entry_hi 28
        .byte $D0,$91,$1C,$1D ; D2EF  list_entry_hi 29
        .byte $E0,$91,$1D,$1E ; D2F3  list_entry_hi 30
        .byte $F0,$91,$1E,$1F ; D2F7  list_entry_hi 31
        .byte $00,$92,$1F,$20 ; D2FB  list_entry_hi 32
        .byte $10,$92,$20,$21 ; D2FF  list_entry_hi 33
        .byte $20,$92,$21,$22 ; D303  list_entry_hi 34
        .byte $30,$92,$22,$23 ; D307  list_entry_hi 35
        .byte $40,$92,$23,$24 ; D30B  list_entry_hi 36
        .byte $50,$92,$24,$25 ; D30F  list_entry_hi 37
        .byte $60,$92,$25,$26 ; D313  list_entry_hi 38
        .byte $70,$92,$26,$27 ; D317  list_entry_hi 39
        .byte $80,$92,$27,$28 ; D31B  list_entry_hi 40
        .byte $90,$92,$28,$29 ; D31F  list_entry_hi 41
        .byte $A0,$92,$29,$2A ; D323  list_entry_hi 42
        .byte $B0,$92,$2A,$2B ; D327  list_entry_hi 43
        .byte $C0,$92,$2B,$2C ; D32B  list_entry_hi 44
        .byte $D0,$92,$2C,$2D ; D32F  list_entry_hi 45
        .byte $E0,$92,$2D,$2E ; D333  list_entry_hi 46
        .byte $F0,$92,$2E,$2F ; D337  list_entry_hi 47
        .byte $00,$93,$2F,$30 ; D33B  list_entry_hi 48
        .byte $10,$93,$30,$31 ; D33F  list_entry_hi 49
        .byte $20,$93,$31,$32 ; D343  list_entry_hi 50
        .byte $30,$93,$32,$33 ; D347  list_entry_hi 51
        .byte $40,$93,$33,$34 ; D34B  list_entry_hi 52
        .byte $50,$93,$34,$35 ; D34F  list_entry_hi 53
        .byte $60,$93,$35,$36 ; D353  list_entry_hi 54
        .byte $70,$93,$36,$37 ; D357  list_entry_hi 55
        .byte $80,$93,$37,$38 ; D35B  list_entry_hi 56
        .byte $00,$80,$8A,$00 ; D35F  list_entry_hi 57
        .byte $10,$80,$06,$01 ; D363  list_entry_hi 58
        .byte $20,$80,$07,$02 ; D367  list_entry_hi 59
        .byte $30,$80,$99,$03 ; D36B  list_entry_hi 60
        .byte $40,$80,$45,$04 ; D36F  list_entry_hi 61
        .byte $50,$80,$00,$05 ; D373  list_entry_hi 62
        .byte $60,$80,$01,$06 ; D377  list_entry_hi 63
        .byte $70,$80,$02,$07 ; D37B  list_entry_hi 64
        .byte $80,$80,$03,$08 ; D37F  list_entry_hi 65
        .byte $90,$80,$04,$09 ; D383  list_entry_hi 66
        .byte $A0,$80,$05,$0A ; D387  list_entry_hi 67
        .byte $B0,$80,$08,$0B ; D38B  list_entry_hi 68
        .byte $C0,$80,$38,$0C ; D38F  list_entry_hi 69
        .byte $D0,$80,$9D,$0D ; D393  list_entry_hi 70
        .byte $E0,$80,$09,$0E ; D397  list_entry_hi 71
        .byte $F0,$80,$0A,$0F ; D39B  list_entry_hi 72
        .byte $00,$81,$0B,$10 ; D39F  list_entry_hi 73
        .byte $10,$81,$0C,$11 ; D3A3  list_entry_hi 74
        .byte $20,$81,$0D,$12 ; D3A7  list_entry_hi 75
        .byte $30,$81,$0E,$13 ; D3AB  list_entry_hi 76
        .byte $40,$81,$0F,$14 ; D3AF  list_entry_hi 77
        .byte $50,$81,$10,$15 ; D3B3  list_entry_hi 78
        .byte $60,$81,$11,$16 ; D3B7  list_entry_hi 79
        .byte $70,$81,$12,$17 ; D3BB  list_entry_hi 80
        .byte $80,$81,$13,$18 ; D3BF  list_entry_hi 81
        .byte $90,$81,$14,$19 ; D3C3  list_entry_hi 82
        .byte $A0,$81,$15,$1A ; D3C7  list_entry_hi 83
        .byte $B0,$81,$16,$1B ; D3CB  list_entry_hi 84
        .byte $C0,$81,$17,$1C ; D3CF  list_entry_hi 85
        .byte $D0,$81,$18,$1D ; D3D3  list_entry_hi 86
        .byte $E0,$81,$96,$1E ; D3D7  list_entry_hi 87
        .byte $F0,$81,$9E,$1F ; D3DB  list_entry_hi 88
        .byte $00,$82,$19,$20 ; D3DF  list_entry_hi 89
        .byte $10,$82,$1A,$21 ; D3E3  list_entry_hi 90
        .byte $20,$82,$1B,$22 ; D3E7  list_entry_hi 91
        .byte $30,$82,$1C,$23 ; D3EB  list_entry_hi 92
        .byte $40,$82,$1D,$24 ; D3EF  list_entry_hi 93
        .byte $50,$82,$1E,$25 ; D3F3  list_entry_hi 94
        .byte $60,$82,$1F,$26 ; D3F7  list_entry_hi 95
        .byte $70,$82,$20,$27 ; D3FB  list_entry_hi 96
        .byte $80,$82,$21,$28 ; D3FF  list_entry_hi 97
        .byte $90,$82,$22,$29 ; D403  list_entry_hi 98
        .byte $A0,$82,$23,$2A ; D407  list_entry_hi 99
        .byte $B0,$82,$24,$2B ; D40B  list_entry_hi 100
        .byte $C0,$82,$25,$2C ; D40F  list_entry_hi 101
        .byte $D0,$82,$26,$2D ; D413  list_entry_hi 102
        .byte $E0,$82,$27,$2E ; D417  list_entry_hi 103
        .byte $F0,$82,$28,$2F ; D41B  list_entry_hi 104
        .byte $00,$83,$29,$30 ; D41F  list_entry_hi 105
        .byte $10,$83,$2A,$31 ; D423  list_entry_hi 106
        .byte $20,$83,$2B,$32 ; D427  list_entry_hi 107
        .byte $30,$83,$2C,$33 ; D42B  list_entry_hi 108
        .byte $40,$83,$2D,$34 ; D42F  list_entry_hi 109
        .byte $50,$83,$2E,$35 ; D433  list_entry_hi 110
        .byte $60,$83,$2F,$36 ; D437  list_entry_hi 111
        .byte $70,$83,$30,$37 ; D43B  list_entry_hi 112
        .byte $80,$83,$31,$38 ; D43F  list_entry_hi 113
        .byte $90,$83,$32,$39 ; D443  list_entry_hi 114
        .byte $A0,$83,$33,$3A ; D447  list_entry_hi 115
        .byte $B0,$83,$34,$3B ; D44B  list_entry_hi 116
        .byte $C0,$83,$35,$3C ; D44F  list_entry_hi 117
        .byte $D0,$83,$36,$3D ; D453  list_entry_hi 118
        .byte $E0,$83,$37,$3E ; D457  list_entry_hi 119
        .byte $F0,$83,$38,$3F ; D45B  list_entry_hi 120
        .byte $00,$84,$39,$40 ; D45F  list_entry_hi 121
        .byte $10,$84,$3A,$41 ; D463  list_entry_hi 122
        .byte $20,$84,$3B,$42 ; D467  list_entry_hi 123
        .byte $30,$84,$3C,$43 ; D46B  list_entry_hi 124
        .byte $40,$84,$3D,$44 ; D46F  list_entry_hi 125
        .byte $50,$84,$3E,$45 ; D473  list_entry_hi 126
        .byte $60,$84,$3F,$46 ; D477  list_entry_hi 127
        .byte $70,$84,$40,$47 ; D47B  list_entry_hi 128
        .byte $80,$84,$41,$48 ; D47F  list_entry_hi 129
        .byte $90,$84,$42,$49 ; D483  list_entry_hi 130
        .byte $A0,$84,$43,$4A ; D487  list_entry_hi 131
        .byte $B0,$84,$44,$4B ; D48B  list_entry_hi 132
        .byte $C0,$84,$46,$4C ; D48F  list_entry_hi 133
        .byte $D0,$84,$47,$4D ; D493  list_entry_hi 134
        .byte $E0,$84,$48,$4E ; D497  list_entry_hi 135
        .byte $F0,$84,$49,$4F ; D49B  list_entry_hi 136
        .byte $00,$85,$4A,$50 ; D49F  list_entry_hi 137
        .byte $10,$85,$4B,$51 ; D4A3  list_entry_hi 138
        .byte $20,$85,$4C,$52 ; D4A7  list_entry_hi 139
        .byte $30,$85,$4D,$53 ; D4AB  list_entry_hi 140
        .byte $40,$85,$4E,$54 ; D4AF  list_entry_hi 141
        .byte $50,$85,$4F,$55 ; D4B3  list_entry_hi 142
        .byte $60,$85,$50,$56 ; D4B7  list_entry_hi 143
        .byte $70,$85,$51,$57 ; D4BB  list_entry_hi 144
        .byte $80,$85,$52,$58 ; D4BF  list_entry_hi 145
        .byte $90,$85,$53,$59 ; D4C3  list_entry_hi 146
        .byte $A0,$85,$54,$5A ; D4C7  list_entry_hi 147
        .byte $B0,$85,$55,$5B ; D4CB  list_entry_hi 148
        .byte $C0,$85,$56,$5C ; D4CF  list_entry_hi 149
        .byte $D0,$85,$57,$5D ; D4D3  list_entry_hi 150
        .byte $E0,$85,$58,$5E ; D4D7  list_entry_hi 151
        .byte $F0,$85,$59,$5F ; D4DB  list_entry_hi 152
        .byte $00,$86,$5A,$60 ; D4DF  list_entry_hi 153
        .byte $10,$86,$5B,$61 ; D4E3  list_entry_hi 154
        .byte $20,$86,$5C,$62 ; D4E7  list_entry_hi 155
        .byte $30,$86,$5D,$63 ; D4EB  list_entry_hi 156
        .byte $40,$86,$5E,$64 ; D4EF  list_entry_hi 157
        .byte $50,$86,$5F,$65 ; D4F3  list_entry_hi 158
        .byte $60,$86,$60,$66 ; D4F7  list_entry_hi 159
        .byte $70,$86,$61,$67 ; D4FB  list_entry_hi 160
        .byte $80,$86,$62,$68 ; D4FF  list_entry_hi 161
        .byte $90,$86,$63,$69 ; D503  list_entry_hi 162
        .byte $A0,$86,$64,$6A ; D507  list_entry_hi 163
        .byte $B0,$86,$65,$6B ; D50B  list_entry_hi 164
        .byte $C0,$86,$66,$6C ; D50F  list_entry_hi 165
        .byte $D0,$86,$67,$6D ; D513  list_entry_hi 166
        .byte $E0,$86,$68,$6E ; D517  list_entry_hi 167
        .byte $F0,$86,$69,$6F ; D51B  list_entry_hi 168
        .byte $00,$87,$6A,$70 ; D51F  list_entry_hi 169
        .byte $10,$87,$6B,$71 ; D523  list_entry_hi 170
        .byte $20,$87,$6C,$72 ; D527  list_entry_hi 171
        .byte $30,$87,$6D,$73 ; D52B  list_entry_hi 172
        .byte $40,$87,$6E,$74 ; D52F  list_entry_hi 173
        .byte $50,$87,$6F,$75 ; D533  list_entry_hi 174
        .byte $60,$87,$70,$76 ; D537  list_entry_hi 175
        .byte $70,$87,$72,$77 ; D53B  list_entry_hi 176
        .byte $80,$87,$72,$78 ; D53F  list_entry_hi 177
        .byte $90,$87,$73,$79 ; D543  list_entry_hi 178
        .byte $A0,$87,$74,$7A ; D547  list_entry_hi 179
        .byte $B0,$87,$76,$7B ; D54B  list_entry_hi 180
        .byte $C0,$87,$76,$7C ; D54F  list_entry_hi 181
        .byte $D0,$87,$77,$7D ; D553  list_entry_hi 182
        .byte $E0,$87,$78,$7E ; D557  list_entry_hi 183
        .byte $F0,$87,$7A,$7F ; D55B  list_entry_hi 184
        .byte $FF,$FF,$FF,$FF ; D55F  list_entry_hi 185
        .byte $FF,$FF,$FF,$FF ; D563  list_entry_hi 186
        .byte $FF,$FF,$FF,$FF ; D567  list_entry_hi 187
        .byte $40,$88,$7F,$84 ; D56B  list_entry_hi 188
        .byte $50,$88,$80,$85 ; D56F  list_entry_hi 189
        .byte $60,$88,$81,$86 ; D573  list_entry_hi 190
        .byte $70,$88,$82,$87 ; D577  list_entry_hi 191
        .byte $80,$88,$83,$88 ; D57B  list_entry_hi 192
        .byte $90,$88,$84,$89 ; D57F  list_entry_hi 193
        .byte $A0,$88,$85,$8A ; D583  list_entry_hi 194
        .byte $B0,$88,$86,$8B ; D587  list_entry_hi 195
        .byte $C0,$88,$87,$8C ; D58B  list_entry_hi 196
        .byte $D0,$88,$88,$8D ; D58F  list_entry_hi 197
        .byte $E0,$88,$89,$8E ; D593  list_entry_hi 198
        .byte $F0,$88,$8B,$8F ; D597  list_entry_hi 199
        .byte $00,$89,$8C,$90 ; D59B  list_entry_hi 200
        .byte $10,$89,$8D,$91 ; D59F  list_entry_hi 201
        .byte $20,$89,$8E,$92 ; D5A3  list_entry_hi 202
        .byte $30,$89,$8F,$93 ; D5A7  list_entry_hi 203
        .byte $40,$89,$90,$94 ; D5AB  list_entry_hi 204
        .byte $50,$89,$91,$95 ; D5AF  list_entry_hi 205
        .byte $60,$89,$92,$96 ; D5B3  list_entry_hi 206
        .byte $70,$89,$93,$97 ; D5B7  list_entry_hi 207
        .byte $80,$89,$94,$98 ; D5BB  list_entry_hi 208
        .byte $90,$89,$95,$99 ; D5BF  list_entry_hi 209
        .byte $A0,$89,$9B,$9A ; D5C3  list_entry_hi 210
        .byte $B0,$89,$97,$9B ; D5C7  list_entry_hi 211
        .byte $C0,$89,$98,$9C ; D5CB  list_entry_hi 212
        .byte $D0,$89,$9A,$9D ; D5CF  list_entry_hi 213
        .byte $E0,$89,$9C,$9E ; D5D3  list_entry_hi 214
        .byte $F0,$89,$9F,$9F ; D5D7  list_entry_hi 215
        .byte $00,$8A,$A0,$00 ; D5DB  list_entry_hi 216
        .byte $10,$8A,$A1,$00 ; D5DF  list_entry_hi 217
        .byte $20,$8A,$A2,$00 ; D5E3  list_entry_hi 218
        .byte $30,$8A,$A3,$00 ; D5E7  list_entry_hi 219
        .byte $40,$8A,$A4,$00 ; D5EB  list_entry_hi 220
        .byte $50,$8A,$A5,$00 ; D5EF  list_entry_hi 221
        .byte $60,$8A,$A6,$00 ; D5F3  list_entry_hi 222
        .byte $70,$8A,$A7,$00 ; D5F7  list_entry_hi 223
        .byte $80,$8A,$A8,$00 ; D5FB  list_entry_hi 224
        .byte $90,$8A,$A9,$00 ; D5FF  list_entry_hi 225
        .byte $A0,$8A,$AA,$00 ; D603  list_entry_hi 226
        .byte $B0,$8A,$AB,$00 ; D607  list_entry_hi 227
        .byte $C0,$8A,$AC,$00 ; D60B  list_entry_hi 228
        .byte $D0,$8A,$AD,$00 ; D60F  list_entry_hi 229
        .byte $E0,$8A,$AE,$00 ; D613  list_entry_hi 230
        .byte $F0,$8A,$AF,$00 ; D617  list_entry_hi 231
        .byte $00,$8B,$B0,$00 ; D61B  list_entry_hi 232
        .byte $10,$8B,$B1,$00 ; D61F  list_entry_hi 233
        .byte $20,$8B,$B2,$00 ; D623  list_entry_hi 234
        .byte $30,$8B,$B3,$00 ; D627  list_entry_hi 235
        .byte $40,$8B,$B4,$00 ; D62B  list_entry_hi 236
        .byte $50,$8B,$B5,$00 ; D62F  list_entry_hi 237
        .byte $60,$8B,$B6,$00 ; D633  list_entry_hi 238
        .byte $70,$8B,$B7,$00 ; D637  list_entry_hi 239
        .byte $80,$8B,$B8,$00 ; D63B  list_entry_hi 240
        .byte $90,$8B,$B9,$00 ; D63F  list_entry_hi 241
        .byte $A0,$8B,$BA,$00 ; D643  list_entry_hi 242
        .byte $B0,$8B,$BB,$00 ; D647  list_entry_hi 243
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D64B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D65B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D66B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D67B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D68B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D69B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6AB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6BB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6CB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6DB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6EB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6FB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D70B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D71B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D72B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D73B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D74B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D75B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D76B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D77B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D78B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D79B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7AB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7BB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7CB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7DB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7EB
        .byte $FF,$FF,$FF,$FF,$FF,$20,$48,$D8,$A0,$00,$B9,$03,$D9,$8D,$F8,$4F ; D7FB
        .byte $20,$94,$D8,$C8,$B9,$03,$D9,$C9,$FE,$F0,$13,$C9,$FF,$F0,$13,$8D ; D80B
        .byte $F8,$4F,$20,$C2,$D8,$C8,$A9,$71,$8D,$F0,$4F,$4C,$0F,$D8,$C8,$4C ; D81B
        .byte $05,$D8,$EA,$EA,$EA,$EA,$20,$70,$D8,$AD,$02,$20,$29,$80,$F0,$F9 ; D82B
        .byte $AD,$02,$20,$29,$80,$F0,$F9,$A9,$81,$8D,$F6,$4F,$60,$A9,$CC,$8D ; D83B
        .byte $2D,$41,$A9,$C0,$8D,$F6,$4F,$A9,$71,$8D,$F0,$4F,$A9,$FF,$8D,$0F ; D84B
        .byte $41,$20,$F0,$D8,$A9,$DF,$8D,$0F,$41,$20,$F0,$D8,$A9,$FF,$8D,$0F ; D85B
        .byte $41,$20,$F0,$D8,$60,$A9,$B7,$8D,$F0,$4F,$A9,$FF,$8D,$F1,$4F,$A9 ; D86B
        .byte $A4,$8D,$F2,$4F,$A9,$5A,$8D,$F3,$4F,$A9,$9A,$8D,$F4,$4F,$A9,$FE ; D87B
        .byte $8D,$F5,$4F,$A9,$0E,$8D,$FA,$4F,$60,$A9,$51,$8D,$F0,$4F,$A9,$11 ; D88B
        .byte $8D,$F0,$4F,$A9,$11,$8D,$F0,$4F,$A9,$01,$8D,$F0,$4F,$A9,$01,$8D ; D89B
        .byte $F0,$4F,$A9,$01,$8D,$F0,$4F,$A9,$01,$8D,$F0,$4F,$A9,$11,$8D,$F0 ; D8AB
        .byte $4F,$A9,$11,$8D,$F0,$4F,$60,$A9,$31,$8D,$F0,$4F,$A9,$21,$8D,$F0 ; D8BB
        .byte $4F,$A9,$21,$8D,$F0,$4F,$A9,$21,$8D,$F0,$4F,$A9,$21,$8D,$F0,$4F ; D8CB
        .byte $A9,$31,$8D,$F0,$4F,$A9,$31,$8D,$F0,$4F,$A9,$31,$8D,$F0,$4F,$A9 ; D8DB
        .byte $31,$8D,$F0,$4F,$60,$8A,$48,$98,$48,$A2,$00,$A0,$00,$CA,$D0,$FD ; D8EB
        .byte $88,$D0,$FA,$68,$A8,$68,$AA,$60,$FE,$FE,$EF,$FE,$36,$28,$FE,$3A ; D8FB
        .byte $05,$FE,$A4,$44,$44,$FE,$A5,$42,$42,$FE,$AA,$88,$88,$FE,$E8,$11 ; D90B
        .byte $0B,$FE,$E3,$01,$10,$FE,$FF,$61,$FE,$AC,$00,$FE,$AD,$33,$FE,$AE ; D91B
        .byte $2B,$FE,$AF,$55,$FE,$A6,$2A,$2A,$FE,$A7,$2B,$2B,$FE,$A8,$18,$18 ; D92B
        .byte $FE,$A9,$2A,$2A,$FE,$2A,$00,$00,$01,$3F,$FE,$2B,$00,$00,$00,$EF ; D93B
        .byte $FE,$F0,$02,$00,$00,$00,$00,$01,$FE,$F1,$01,$01,$00,$00,$0E,$17 ; D94B
        .byte $FE,$F2,$00,$04,$1E,$06,$05,$30,$FE,$F3,$18,$0D,$52,$04,$03,$64 ; D95B
        .byte $FE,$F4,$0E,$1B,$19,$03,$05,$0F,$FE,$F5,$06,$12,$12,$34,$33,$0F ; D96B
        .byte $FE,$11,$FE,$29,$FE,$2C,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D97B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D98B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D99B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9AB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9BB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9CB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9DB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9EB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9FB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DABB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DACB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DADB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAEB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAFB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBBB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBCB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBDB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBEB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBFB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCBB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCCB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCDB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCEB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCFB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DD9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDBB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDCB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDDB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDEB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DDFB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DE9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DEAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DEBB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DECB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DEDB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DEEB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DEFB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF0B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF1B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF2B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF3B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF4B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF5B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF6B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF7B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF8B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DF9B
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DFAB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DFBB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DFCB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DFDB
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DFEB
        .byte $FF,$FF,$FF,$FF,$FF ; DFFB
