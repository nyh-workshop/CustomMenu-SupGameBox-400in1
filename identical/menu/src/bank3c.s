; Sup 400-in-1 English menu, 8 KiB PRG bank $3C (file 0x78000), mapped at CPU $8000
; Generated from the ROM + FCEUX traces. Untraced code is marked "static".
.segment "BANK3C"

game_names:
        .byte "SUPER MARIO",$FF,$FF,$FF,$FF,$FF ; 8000  #0
        .byte "MARIO 14",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8010  #1
        .byte "MARIO 3",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8020  #2
        .byte "DR MARIO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8030  #3
        .byte "MARIO BROS",$FF,$FF,$FF,$FF,$FF,$FF ; 8040  #4
        .byte "TURTLES 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8050  #5
        .byte "TURTLES 4",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8060  #6
        .byte "CONTRA 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8070  #7
        .byte "CONTRA FORC",$FF,$FF,$FF,$FF,$FF ; 8080  #8
        .byte "CONTRA 7",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8090  #9
        .byte "KAGE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 80A0  #10
        .byte "JACKAL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 80B0  #11
        .byte "RUSH'N ATTACK",$FF,$FF,$FF ; 80C0  #12
        .byte "ADVENTURE ISLAND" ; 80D0  #13
        .byte "ADVEN ISLAND 2",$FF,$FF ; 80E0  #14
        .byte "CHIP DALE 1",$FF,$FF,$FF,$FF,$FF ; 80F0  #15
        .byte "CHIP DALE 3",$FF,$FF,$FF,$FF,$FF ; 8100  #16
        .byte "BUBBLE BOBBLE 2",$FF ; 8110  #17
        .byte "SNOW BROS",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8120  #18
        .byte "MITSUME",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8130  #19
        .byte "NINJA GAIDEN 2",$FF,$FF ; 8140  #20
        .byte "DOUBLE DRAGON 2",$FF ; 8150  #21
        .byte "DOUBLE DRAGON 3",$FF ; 8160  #22
        .byte "HOT HIGH SCHOOL",$FF ; 8170  #23
        .byte "HOT WRESTLE",$FF,$FF,$FF,$FF,$FF ; 8180  #24
        .byte "ROBOCOP",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8190  #25
        .byte "MORTAL KOMBAT 4",$FF ; 81A0  #26
        .byte "SPIDER MAN",$FF,$FF,$FF,$FF,$FF,$FF ; 81B0  #27
        .byte "10 YARD FIGHT",$FF,$FF,$FF ; 81C0  #28
        .byte "90 TANK",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 81D0  #29
        .byte "KAGE LEGEND",$FF,$FF,$FF,$FF,$FF ; 81E0  #30
        .byte "ALADDIN 3",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 81F0  #31
        .byte "ANTARCTIC ADVEN",$FF ; 8200  #32
        .byte "ARABIAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8210  #33
        .byte "BALLOON FIGHT",$FF,$FF,$FF ; 8220  #34
        .byte "BASE BALL",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8230  #35
        .byte "BINARY LAND",$FF,$FF,$FF,$FF,$FF ; 8240  #36
        .byte "BIRD WEEK",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8250  #37
        .byte "BOMBER MAN",$FF,$FF,$FF,$FF,$FF,$FF ; 8260  #38
        .byte "BOMB SWEEPER",$FF,$FF,$FF,$FF ; 8270  #39
        .byte "BRUSH ROLLER",$FF,$FF,$FF,$FF ; 8280  #40
        .byte "BURGER TIME",$FF,$FF,$FF,$FF,$FF ; 8290  #41
        .byte "CHACK AND POP",$FF,$FF,$FF ; 82A0  #42
        .byte "CHESS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 82B0  #43
        .byte "CIRCUS CHARLIE",$FF,$FF ; 82C0  #44
        .byte "CLU CLU LAND",$FF,$FF,$FF,$FF ; 82D0  #45
        .byte "COMBAT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 82E0  #46
        .byte "DEFENDER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 82F0  #47
        .byte "DEVIL WORLD",$FF,$FF,$FF,$FF,$FF ; 8300  #48
        .byte "DIG DUG 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8310  #49
        .byte "DONKEY KONG 1",$FF,$FF,$FF ; 8320  #50
        .byte "DONKEY KONG 2",$FF,$FF,$FF ; 8330  #51
        .byte "DONKEY KONG 3",$FF,$FF,$FF ; 8340  #52
        .byte "DONKEY KONG JR",$FF,$FF ; 8350  #53
        .byte "DOOR DOOR",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8360  #54
        .byte "EXCITE BIKE",$FF,$FF,$FF,$FF,$FF ; 8370  #55
        .byte "EXERION",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8380  #56
        .byte "F1 RACE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8390  #57
        .byte "FORMATION Z",$FF,$FF,$FF,$FF,$FF ; 83A0  #58
        .byte "FRONT LINE",$FF,$FF,$FF,$FF,$FF,$FF ; 83B0  #59
        .byte "GALAGA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83C0  #60
        .byte "GALAXIAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83D0  #61
        .byte "GOLF",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83E0  #62
        .byte "RAID O BUNGELING" ; 83F0  #63
        .byte "HYPER OLYMPIC",$FF,$FF,$FF ; 8400  #64
        .byte "HYPER SPORTS",$FF,$FF,$FF,$FF ; 8410  #65
        .byte "ICE CLIMBER",$FF,$FF,$FF,$FF,$FF ; 8420  #66
        .byte "JOUST",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8430  #67
        .byte "KARATEKA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8440  #68
        .byte "LODE RUNNER",$FF,$FF,$FF,$FF,$FF ; 8450  #69
        .byte "LUNAR BALL",$FF,$FF,$FF,$FF,$FF,$FF ; 8460  #70
        .byte "MACROSS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8470  #71
        .byte "MAGIC JEWELRY",$FF,$FF,$FF ; 8480  #72
        .byte "MAHJONG 4P",$FF,$FF,$FF,$FF,$FF,$FF ; 8490  #73
        .byte "MAHJONG 2p",$FF,$FF,$FF,$FF,$FF,$FF ; 84A0  #74
        .byte "MAPPY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84B0  #75
        .byte "MILK N NUTS",$FF,$FF,$FF,$FF,$FF ; 84C0  #76
        .byte "MILLIPEDE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84D0  #77
        .byte "MUSICE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84E0  #78
        .byte "NAITOU",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84F0  #79
        .byte "NIBBLES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8500  #80
        .byte "NINJA 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8510  #81
        .byte "NINJA 3",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8520  #82
        .byte "ROAD FIGHTER",$FF,$FF,$FF,$FF ; 8530  #83
        .byte "OTHELLO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8540  #84
        .byte "PACMAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8550  #85
        .byte "PIN BALL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8560  #86
        .byte "POOYAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8570  #87
        .byte "POPEYE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8580  #88
        .byte "SKY DESTROYER",$FF,$FF,$FF ; 8590  #89
        .byte "SPACE ET",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85A0  #90
        .byte "STAR FORCE",$FF,$FF,$FF,$FF,$FF,$FF ; 85B0  #91
        .byte "STAR GATE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85C0  #92
        .byte "TENNIS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85D0  #93
        .byte "URBAN CHAMPION",$FF,$FF ; 85E0  #94
        .byte "WARPMAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85F0  #95
        .byte "YIE AR KUNG FU",$FF,$FF ; 8600  #96
        .byte "ZIPPY RACE",$FF,$FF,$FF,$FF,$FF,$FF ; 8610  #97
        .byte "WAREHOUSE BOY",$FF,$FF,$FF ; 8620  #98
        .byte "1942",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8630  #99
        .byte "ARKANOID",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8640  #100
        .byte "ASTRO ROBO SASA",$FF ; 8650  #101
        .byte "B WINGS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8660  #102
        .byte "BADMINGTON",$FF,$FF,$FF,$FF,$FF,$FF ; 8670  #103
        .byte "BALTRON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8680  #104
        .byte "BOKOSUKA WARS",$FF,$FF,$FF ; 8690  #105
        .byte "BOMB JACK",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86A0  #106
        .byte "PORTER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86B0  #107
        .byte "CHUBBY CHERUB",$FF,$FF,$FF ; 86C0  #108
        .byte "DESTROY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86D0  #109
        .byte "DIG DUG 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86E0  #110
        .byte "DOUGH BOY",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86F0  #111
        .byte "DRAGON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8700  #112
        .byte "DRUAGA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8710  #113
        .byte "DUCK",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8720  #114
        .byte "ELEVATOR ACTION",$FF ; 8730  #115
        .byte "EXED EXES",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8740  #116
        .byte "FLAPPY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8750  #117
        .byte "FRUIT PIG",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8760  #118
        .byte "GALG",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8770  #119
        .byte "GEIMOS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8780  #120
        .byte "GYRODINE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8790  #121
        .byte "HEXA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87A0  #122
        .byte "ICE HOCKEY",$FF,$FF,$FF,$FF,$FF,$FF ; 87B0  #123
        .byte "LOT LOT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87C0  #124
        .byte "MAGMAX",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87D0  #125
        .byte "PIKA CHU",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87E0  #126
        .byte "NINJA 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87F0  #127
        .byte "QBAKE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8800  #128
        .byte "ONYANKO TOWN",$FF,$FF,$FF,$FF ; 8810  #129
        .byte "PAC LAND",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8820  #130
        .byte "PACHI COM",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8830  #131
        .byte "PRO WRESTLING",$FF,$FF,$FF ; 8840  #132
        .byte "PYRAMID",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8850  #133
        .byte "ROUTE-16",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8860  #134
        .byte "SEICROSS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8870  #135
        .byte "SLALOM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8880  #136
        .byte "SOCCER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8890  #137
        .byte "SONSON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 88A0  #138
        .byte "SPARTAN X",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 88B0  #139
        .byte "SPELUNKER",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 88C0  #140
        .byte "SPY VS SPY",$FF,$FF,$FF,$FF,$FF,$FF ; 88D0  #141
        .byte "SQOON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 88E0  #142
        .byte "STAR LUSTER",$FF,$FF,$FF,$FF,$FF ; 88F0  #143
        .byte "TETRIS 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8900  #144
        .byte "THEXDER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8910  #145
        .byte "VOLGUARD II",$FF,$FF,$FF,$FF,$FF ; 8920  #146
        .byte "VOLLEY BALL",$FF,$FF,$FF,$FF,$FF ; 8930  #147
        .byte "WARS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8940  #148
        .byte "XEVIOUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8950  #149
        .byte "CHINESE CHESS",$FF,$FF,$FF ; 8960  #150
        .byte "CHALLENG",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8970  #151
        .byte "MACH RIDER",$FF,$FF,$FF,$FF,$FF,$FF ; 8980  #152
        .byte "ARGUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8990  #153
        .byte "GOONIES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 89A0  #154
        .byte "SUPER CHINESE",$FF,$FF,$FF ; 89B0  #155
        .byte "TWIN BEE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 89C0  #156
        .byte "STAR SOLDIER",$FF,$FF,$FF,$FF ; 89D0  #157
        .byte "TRACK FIELD",$FF,$FF,$FF,$FF,$FF ; 89E0  #158
        .byte "FRIDAY THE 13",$FF,$FF,$FF ; 89F0  #159
        .byte "ARKISTAS RING",$FF,$FF,$FF ; 8A00  #160
        .byte "ASO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8A10  #161
        .byte "ALPHA MISSION",$FF,$FF,$FF ; 8A20  #162
        .byte "BOWLING",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8A30  #163
        .byte "FLIPULL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8A40  #164
        .byte "BACK TO FUTURE",$FF,$FF ; 8A50  #165
        .byte "GRADIUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8A60  #166
        .byte "HOKUTO NO KEN",$FF,$FF,$FF ; 8A70  #167
        .byte "KING KNIGHT",$FF,$FF,$FF,$FF,$FF ; 8A80  #168
        .byte "KICKEY MOUSE",$FF,$FF,$FF,$FF ; 8A90  #169
        .byte "NEW MAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8AA0  #170
        .byte "PAPERBOY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8AB0  #171
        .byte "POWER SOCCER",$FF,$FF,$FF,$FF ; 8AC0  #172
        .byte "QUARTH",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8AD0  #173
        .byte "SOLOMON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8AE0  #174
        .byte "SKY HUNTER",$FF,$FF,$FF,$FF,$FF,$FF ; 8AF0  #175
        .byte "TIGER HELI",$FF,$FF,$FF,$FF,$FF,$FF ; 8B00  #176
        .byte "TRANSFORMERS",$FF,$FF,$FF,$FF ; 8B10  #177
        .byte "WISDOM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8B20  #178
        .byte "MOAI-KUN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8B30  #179
        .byte "CASTLE EXCELLENT" ; 8B40  #180
        .byte "BUMP N JUMP",$FF,$FF,$FF,$FF,$FF ; 8B50  #181
        .byte "ANGRY BIRD",$FF,$FF,$FF,$FF,$FF,$FF ; 8B60  #182
        .byte "AQUARIUM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8B70  #183
        .byte "ARENA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8B80  #184
        .byte "AIR ALERT",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8B90  #185
        .byte "AWFUL RUSHING",$FF,$FF,$FF ; 8BA0  #186
        .byte "AIMLESS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8BB0  #187
        .byte "BURBLES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8BC0  #188
        .byte "BURROW EXPLORER",$FF ; 8BD0  #189
        .byte "BUGS WAR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8BE0  #190
        .byte "BOMB KING",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8BF0  #191
        .byte "BASEBALL NEW",$FF,$FF,$FF,$FF ; 8C00  #192
        .byte "BUBBLE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8C10  #193
        .byte "CABBONADE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8C20  #194
        .byte "CLOSE QUARTERS",$FF,$FF ; 8C30  #195
        .byte "COAST GUARD",$FF,$FF,$FF,$FF,$FF ; 8C40  #196
        .byte "CUB ADVENTURE",$FF,$FF,$FF ; 8C50  #197
        .byte "DEPTH BOMB",$FF,$FF,$FF,$FF,$FF,$FF ; 8C60  #198
        .byte "DEVILDOM DOOM",$FF,$FF,$FF ; 8C70  #199
        .byte "DIAMOND",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8C80  #200
        .byte "DUNE WAR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8C90  #201
        .byte "FIREBASE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8CA0  #202
        .byte "FIRST DEFENDER",$FF,$FF ; 8CB0  #203
        .byte "FIVE DAYS",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8CC0  #204
        .byte "FRANTIC MOUSE",$FF,$FF,$FF ; 8CD0  #205
        .byte "FRUIT DISH",$FF,$FF,$FF,$FF,$FF,$FF ; 8CE0  #206
        .byte "GALLAGANT",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8CF0  #207
        .byte "GARDEN WAR",$FF,$FF,$FF,$FF,$FF,$FF ; 8D00  #208
        .byte "GATE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D10  #209
        .byte "HALLIHOO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D20  #210
        .byte "HEXAPOD NEW",$FF,$FF,$FF,$FF,$FF ; 8D30  #211
        .byte "HEXAPOD WAR",$FF,$FF,$FF,$FF,$FF ; 8D40  #212
        .byte "LABYRINTH",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D50  #213
        .byte "LUNARIAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D60  #214
        .byte "MAD XMAS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D70  #215
        .byte "MOTOBOAT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8D80  #216
        .byte "PANZER ATTACK",$FF,$FF,$FF ; 8D90  #217
        .byte "PENTA BASE",$FF,$FF,$FF,$FF,$FF,$FF ; 8DA0  #218
        .byte "POBBLE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8DB0  #219
        .byte "POLAR BAT",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8DC0  #220
        .byte "RURALGOBLIN",$FF,$FF,$FF,$FF,$FF ; 8DD0  #221
        .byte "ROBOT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8DE0  #222
        .byte "SEASON GARDEN",$FF,$FF,$FF ; 8DF0  #223
        .byte "SHREW MOUSE",$FF,$FF,$FF,$FF,$FF ; 8E00  #224
        .byte "SNOWBALL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8E10  #225
        .byte "STAR FIGHTER",$FF,$FF,$FF,$FF ; 8E20  #226
        .byte "STRAFE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8E30  #227
        .byte "SMALL DINOSAUR",$FF,$FF ; 8E40  #228
        .byte "SILENT HUNTER",$FF,$FF,$FF ; 8E50  #229
        .byte "THE ARCHER",$FF,$FF,$FF,$FF,$FF,$FF ; 8E60  #230
        .byte "TWIN CARDS",$FF,$FF,$FF,$FF,$FF,$FF ; 8E70  #231
        .byte "UNDERSEA ARENA",$FF,$FF ; 8E80  #232
        .byte "WARRIOR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8E90  #233
        .byte "ABSCONDEE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8EA0  #234
        .byte "AETHER CRUISER",$FF,$FF ; 8EB0  #235
        .byte "AIM CRUISE",$FF,$FF,$FF,$FF,$FF,$FF ; 8EC0  #236
        .byte "ANIMAL CONTEST",$FF,$FF ; 8ED0  #237
        .byte "BLOCKS WORLD",$FF,$FF,$FF,$FF ; 8EE0  #238
        .byte "BUG CATCHER",$FF,$FF,$FF,$FF,$FF ; 8EF0  #239
        .byte "BUSY BAR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8F00  #240
        .byte "CANDY WORKSHOP",$FF,$FF ; 8F10  #241
        .byte "CONTEST",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8F20  #242
        .byte "COOKIE LABYRINTH" ; 8F30  #243
        .byte "CRYSTAL BLAST",$FF,$FF,$FF ; 8F40  #244
        .byte "DEFORMABLE",$FF,$FF,$FF,$FF,$FF,$FF ; 8F50  #245
        .byte "DEJIECTILE",$FF,$FF,$FF,$FF,$FF,$FF ; 8F60  #246
        .byte "EGG CONTEST",$FF,$FF,$FF,$FF,$FF ; 8F70  #247
        .byte "ESCAPEWAY",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8F80  #248
        .byte "FAIRS TREASURE",$FF,$FF ; 8F90  #249
        .byte "FALLING BLOCKS",$FF,$FF ; 8FA0  #250
        .byte "FATED PIRATE",$FF,$FF,$FF,$FF ; 8FB0  #251
        .byte "FINAL BLOOD",$FF,$FF,$FF,$FF,$FF ; 8FC0  #252
        .byte "FISH STORY",$FF,$FF,$FF,$FF,$FF,$FF ; 8FD0  #253
        .byte "FLING BALL",$FF,$FF,$FF,$FF,$FF,$FF ; 8FE0  #254
        .byte "FOREST ADVENTURE" ; 8FF0  #255
        .byte "FRUIT GIFT",$FF,$FF,$FF,$FF,$FF,$FF ; 9000  #256
        .byte "GHOST CASTLE",$FF,$FF,$FF,$FF ; 9010  #257
        .byte "GOLDEN BIRD",$FF,$FF,$FF,$FF,$FF ; 9020  #258
        .byte "GREEDS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9030  #259
        .byte "HAMMER N NAIL",$FF,$FF,$FF ; 9040  #260
        .byte "HAPPY MATCH",$FF,$FF,$FF,$FF,$FF ; 9050  #261
        .byte "ICE OCEAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9060  #262
        .byte "IQ CHAMPION",$FF,$FF,$FF,$FF,$FF ; 9070  #263
        .byte "ISLAND",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9080  #264
        .byte "JUMP JUMP",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9090  #265
        .byte "JUMPING KID",$FF,$FF,$FF,$FF,$FF ; 90A0  #266
        .byte "LIGHTNING",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 90B0  #267
        .byte "LITTLE WITCH",$FF,$FF,$FF,$FF ; 90C0  #268
        .byte "MAGIC EGG",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 90D0  #269
        .byte "MAN IN RED",$FF,$FF,$FF,$FF,$FF,$FF ; 90E0  #270
        .byte "MECCANO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 90F0  #271
        .byte "MIRROE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9100  #272
        .byte "MOUSE SNARE",$FF,$FF,$FF,$FF,$FF ; 9110  #273
        .byte "MOUSE HERO",$FF,$FF,$FF,$FF,$FF,$FF ; 9120  #274
        .byte "MOWING",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9130  #275
        .byte "NUT CRACKY",$FF,$FF,$FF,$FF,$FF,$FF ; 9140  #276
        .byte "CRYSTAL BALL",$FF,$FF,$FF,$FF ; 9150  #277
        .byte "POLICE DOG LASY",$FF ; 9160  #278
        .byte "POLICE VS THIEF",$FF ; 9170  #279
        .byte "PONGPONG",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9180  #280
        .byte "POWER ROBOT",$FF,$FF,$FF,$FF,$FF ; 9190  #281
        .byte "PULVERATION",$FF,$FF,$FF,$FF,$FF ; 91A0  #282
        .byte "RABBIT VILLAGE",$FF,$FF ; 91B0  #283
        .byte "RIVER JUMP",$FF,$FF,$FF,$FF,$FF,$FF ; 91C0  #284
        .byte "SEAPORT GUARL",$FF,$FF,$FF ; 91D0  #285
        .byte "SEAWOLF",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 91E0  #286
        .byte "SPACE BASE",$FF,$FF,$FF,$FF,$FF,$FF ; 91F0  #287
        .byte "SPIDERMAN 2",$FF,$FF,$FF,$FF,$FF ; 9200  #288
        .byte "SPIDERMAN 1",$FF,$FF,$FF,$FF,$FF ; 9210  #289
        .byte "SPRING WORLD",$FF,$FF,$FF,$FF ; 9220  #290
        .byte "STAR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9230  #291
        .byte "SUBMARINE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9240  #292
        .byte "THROUGHMAN",$FF,$FF,$FF,$FF,$FF,$FF ; 9250  #293
        .byte "TOY FACTORY",$FF,$FF,$FF,$FF,$FF ; 9260  #294
        .byte "UTMOST WARFARE",$FF,$FF ; 9270  #295
        .byte "VIGILANT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9280  #296
        .byte "WAR ZONE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9290  #297
        .byte "WATER PIPE",$FF,$FF,$FF,$FF,$FF,$FF ; 92A0  #298
        .byte "WILD WORM",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 92B0  #299
        .byte "WONDER BALL",$FF,$FF,$FF,$FF,$FF ; 92C0  #300
        .byte "LUNATION",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 92D0  #301
        .byte "CLIMBING",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 92E0  #302
        .byte "SEAMAID",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 92F0  #303
        .byte "STRONG PILL",$FF,$FF,$FF,$FF,$FF ; 9300  #304
        .byte "APPLE CHESS",$FF,$FF,$FF,$FF,$FF ; 9310  #305
        .byte "FISHWAR",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9320  #306
        .byte "PUZZLE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9330  #307
        .byte "SHOT PUT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9340  #308
        .byte "ORCHARD",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9350  #309
        .byte "MOVE BOX",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9360  #310
        .byte "TROOPER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9370  #311
        .byte "GOBLET TOWER",$FF,$FF,$FF,$FF ; 9380  #312
        .byte "TURTLES 4",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9390  #313
        .byte "CONTRA 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 93A0  #314
        .byte "CONTRA FORC",$FF,$FF,$FF,$FF,$FF ; 93B0  #315
        .byte "CONTRA 7",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 93C0  #316
        .byte "KAGE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 93D0  #317
        .byte "SUPER MARIO",$FF,$FF,$FF,$FF,$FF ; 93E0  #318
        .byte "MARIO 6",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 93F0  #319
        .byte "MARIO 9",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9400  #320
        .byte "MARIO 10",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9410  #321
        .byte "DR MARIO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9420  #322
        .byte "MARIO BROS",$FF,$FF,$FF,$FF,$FF,$FF ; 9430  #323
        .byte "ADVENTURE ISLAND" ; 9440  #324
        .byte "ADVEN ISLAND 2",$FF,$FF ; 9450  #325
        .byte "CHIP DALE 1",$FF,$FF,$FF,$FF,$FF ; 9460  #326
        .byte "CHIP DALE 3",$FF,$FF,$FF,$FF,$FF ; 9470  #327
        .byte "BUBBLE BOBBLE 2",$FF ; 9480  #328
        .byte "SNOW BROS",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9490  #329
        .byte "MITSUME",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 94A0  #330
        .byte "NINJA GAIDEN 2",$FF,$FF ; 94B0  #331
        .byte "DOUBLE DRAGON 2",$FF ; 94C0  #332
        .byte "DOUBLE DRAGON 3",$FF ; 94D0  #333
        .byte "HOT HIGH SCHOOL",$FF ; 94E0  #334
        .byte "HOT WRESTLE",$FF,$FF,$FF,$FF,$FF ; 94F0  #335
        .byte "ROBOCOP",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9500  #336
        .byte "MORTAL KOMBAT 4",$FF ; 9510  #337
        .byte "SPIDER MAN",$FF,$FF,$0A,$FF,$FF,$FF ; 9520  #338
        .byte "10 YARD FIGHT",$FF,$FF,$FF ; 9530  #339
        .byte "90 TANK",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9540  #340
        .byte "KAGE LEGEND",$FF,$FF,$FF,$FF,$FF ; 9550  #341
        .byte "ALADDIN 3",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9560  #342
        .byte "ANTARCTIC ADVEN",$FF ; 9570  #343
        .byte "ARABIAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9580  #344
        .byte "BALLOON FIGHT",$FF,$FF,$FF ; 9590  #345
        .byte "BASE BALL",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 95A0  #346
        .byte "BINARY LAND",$FF,$FF,$FF,$FF,$FF ; 95B0  #347
        .byte "BIRD WEEK",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 95C0  #348
        .byte "BOMBER MAN",$FF,$FF,$FF,$FF,$FF,$FF ; 95D0  #349
        .byte "BOMB SWEEPER",$FF,$FF,$FF,$FF ; 95E0  #350
        .byte "BRUSH ROLLER",$FF,$FF,$FF,$FF ; 95F0  #351
        .byte "BURGER TIME",$FF,$FF,$FF,$FF,$FF ; 9600  #352
        .byte "CHACK AND POP",$FF,$FF,$FF ; 9610  #353
        .byte "CHESS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9620  #354
        .byte "CIRCUS CHARLIE",$FF,$FF ; 9630  #355
        .byte "CLU CLU LAND",$FF,$FF,$FF,$FF ; 9640  #356
        .byte "COMBAT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9650  #357
        .byte "DEFENDER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9660  #358
        .byte "DEVIL WORLD",$FF,$FF,$FF,$FF,$FF ; 9670  #359
        .byte "DIG DUG 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9680  #360
        .byte "DONKEY KONG 1",$FF,$FF,$FF ; 9690  #361
        .byte "DONKEY KONG 2",$FF,$FF,$FF ; 96A0  #362
        .byte "DONKEY KONG 3",$FF,$FF,$FF ; 96B0  #363
        .byte "DONKEY KONG JR",$FF,$FF ; 96C0  #364
        .byte "DOOR DOOR",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 96D0  #365
        .byte "EXCITE BIKE",$FF,$FF,$FF,$FF,$FF ; 96E0  #366
        .byte "EXERION",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 96F0  #367
        .byte "F1 RACE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9700  #368
        .byte "FORMATION Z",$FF,$FF,$FF,$FF,$FF ; 9710  #369
        .byte "FRONT LINE",$FF,$FF,$FF,$FF,$FF,$FF ; 9720  #370
        .byte "GALAGA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9730  #371
        .byte "GALAXIAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9740  #372
        .byte "GOLF",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9750  #373
        .byte "RAID O BUNGELING" ; 9760  #374
        .byte "HYPER OLYMPIC",$FF,$FF,$FF ; 9770  #375
        .byte "HYPER SPORTS",$FF,$FF,$FF,$FF ; 9780  #376
        .byte "ICE CLIMBER",$FF,$FF,$FF,$FF,$FF ; 9790  #377
        .byte "JOUST",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 97A0  #378
        .byte "KARATEKA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 97B0  #379
        .byte "LODE RUNNER",$FF,$FF,$FF,$FF,$FF ; 97C0  #380
        .byte "LUNAR BALL",$FF,$FF,$FF,$FF,$FF,$FF ; 97D0  #381
        .byte "MACROSS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 97E0  #382
        .byte "MAGIC JEWELRY",$FF,$FF,$FF ; 97F0  #383
        .byte "MAHJONG 4P",$FF,$FF,$FF,$FF,$FF,$FF ; 9800  #384
        .byte "MAHJONG 2p",$FF,$FF,$FF,$FF,$FF,$FF ; 9810  #385
        .byte "MAPPY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9820  #386
        .byte "MILK N NUTS",$FF,$FF,$FF,$FF,$FF ; 9830  #387
        .byte "MILLIPEDE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9840  #388
        .byte "MUSICE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9850  #389
        .byte "NAITOU",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9860  #390
        .byte "NIBBLES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9870  #391
        .byte "NINJA 1",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9880  #392
        .byte "NINJA 3",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9890  #393
        .byte "ROAD FIGHTER",$FF,$FF,$FF,$FF ; 98A0  #394
        .byte "OTHELLO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 98B0  #395
        .byte "PACMAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 98C0  #396
        .byte "PIN BALL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 98D0  #397
        .byte "POOYAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 98E0  #398
        .byte "POPEYE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 98F0  #399
        .byte "SKY DESTROYER",$FF,$FF,$FF ; 9900  #400
        .byte "SPACE ET",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9910  #401
        .byte "STAR FORCE",$FF,$FF,$FF,$FF,$FF,$FF ; 9920  #402
        .byte "STAR GATE",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9930  #403
        .byte "TENNIS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9940  #404
        .byte "URBAN CHAMPION",$FF,$FF ; 9950  #405
        .byte "WARPMAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9960  #406
        .byte "YIE AR KUNG FU",$FF,$FF ; 9970  #407
        .byte "ZIPPY RACE",$FF,$FF,$FF,$FF,$FF,$FF ; 9980  #408
        .byte "WAREHOUSE BOY",$FF,$FF,$FF ; 9990  #409
        .byte "1942",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 99A0  #410
        .byte "ARKANOID",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 99B0  #411
        .byte "ASTRO ROBO SASA",$FF ; 99C0  #412
        .byte "B WINGS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 99D0  #413
        .byte "BADMINGTON",$FF,$FF,$FF,$FF,$FF,$FF ; 99E0  #414
        .byte "BALTRON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 99F0  #415
        .byte "BOKOSUKA WARS",$FF,$FF,$FF ; 9A00  #416
        .byte "BOMB JACK",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A10  #417
        .byte "PORTER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A20  #418
        .byte "CHUBBY CHERUB",$FF,$FF,$FF ; 9A30  #419
        .byte "DESTROY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A40  #420
        .byte "DIG DUG 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A50  #421
        .byte "DOUGH BOY",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A60  #422
        .byte "DRAGON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A70  #423
        .byte "DRUAGA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A80  #424
        .byte "DUCK",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9A90  #425
        .byte "ELEVATOR ACTION",$FF ; 9AA0  #426
        .byte "EXED EXES",$FF,$FF,$0A,$FF,$FF,$FF,$FF ; 9AB0  #427
        .byte "FLAPPY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9AC0  #428
        .byte "FRUIT PIG",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9AD0  #429
        .byte "GALG",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9AE0  #430
        .byte "GEIMOS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9AF0  #431
        .byte "GYRODINE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B00  #432
        .byte "HEXA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B10  #433
        .byte "ICE HOCKEY",$FF,$FF,$FF,$FF,$FF,$FF ; 9B20  #434
        .byte "LOT LOT",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B30  #435
        .byte "MAGMAX",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B40  #436
        .byte "PIKA CHU",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B50  #437
        .byte "NINJA 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B60  #438
        .byte "QBAKE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B70  #439
        .byte "ONYANKO TOWN",$FF,$FF,$FF,$FF ; 9B80  #440
        .byte "PAC LAND",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9B90  #441
        .byte "PACHI COM",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9BA0  #442
        .byte "PRO WRESTLING",$FF,$FF,$FF ; 9BB0  #443
        .byte "PYRAMID",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9BC0  #444
        .byte "ROUTE-16",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9BD0  #445
        .byte "SEICROSS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9BE0  #446
        .byte "SLALOM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9BF0  #447
        .byte "SOCCER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C00  #448
        .byte "SONSON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C10  #449
        .byte "SPARTAN X",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C20  #450
        .byte "SPELUNKER",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C30  #451
        .byte "SPY VS SPY",$FF,$FF,$FF,$FF,$FF,$FF ; 9C40  #452
        .byte "SQOON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C50  #453
        .byte "STAR LUSTER",$FF,$FF,$FF,$FF,$FF ; 9C60  #454
        .byte "TETRIS 2",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C70  #455
        .byte "THEXDER",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9C80  #456
        .byte "VOLGUARD II",$FF,$FF,$FF,$FF,$FF ; 9C90  #457
        .byte "VOLLEY BALL",$FF,$FF,$FF,$FF,$FF ; 9CA0  #458
        .byte "WARS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9CB0  #459
        .byte "XEVIOUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9CC0  #460
        .byte "CHINESE CHESS",$FF,$FF,$FF ; 9CD0  #461
        .byte "CHALLENG",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9CE0  #462
        .byte "MACH RIDER",$FF,$FF,$FF,$FF,$FF,$FF ; 9CF0  #463
        .byte "ARGUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9D00  #464
        .byte "GOONIES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9D10  #465
        .byte "SUPER CHINESE",$FF,$FF,$FF ; 9D20  #466
        .byte "TWIN BEE",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9D30  #467
        .byte "STAR SOLDIER",$FF,$FF,$FF,$FF ; 9D40  #468
        .byte "TRACK FIELD",$FF,$FF,$FF,$FF,$FF ; 9D50  #469
        .byte "FRIDAY THE 13",$FF,$FF,$FF ; 9D60  #470
        .byte "ARKISTAS RING",$FF,$FF,$FF ; 9D70  #471
        .byte "ASO",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9D80  #472
        .byte "ALPHA MISSION",$FF,$FF,$FF ; 9D90  #473
        .byte "BOWLING",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9DA0  #474
        .byte "FLIPULL",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9DB0  #475
        .byte "BACK TO FUTURE",$FF,$FF ; 9DC0  #476
        .byte "GRADIUS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9DD0  #477
        .byte "HOKUTO NO KEN",$FF,$FF,$FF ; 9DE0  #478
        .byte "KING KNIGHT",$FF,$FF,$FF,$FF,$FF ; 9DF0  #479
        .byte "KICKEY MOUSE",$FF,$FF,$FF,$FF ; 9E00  #480
        .byte "NEW MAN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9E10  #481
        .byte "PAPERBOY",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9E20  #482
        .byte "POWER SOCCER",$FF,$FF,$FF,$FF ; 9E30  #483
        .byte "QUARTH",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9E40  #484
        .byte "SOLOMON",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9E50  #485
        .byte "SKY HUNTER",$FF,$FF,$FF,$FF,$FF,$FF ; 9E60  #486
        .byte "TIGER HELI",$FF,$FF,$FF,$FF,$FF,$FF ; 9E70  #487
        .byte "TRANSFORMERS",$FF,$FF,$FF,$FF ; 9E80  #488
        .byte "WISDOM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9E90  #489
        .byte "MOAI-KUN",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9EA0  #490
        .byte "CASTLE EXCELLENT" ; 9EB0  #491
        .byte "BUMP N JUMP",$FF,$FF,$FF,$FF,$FF ; 9EC0  #492
        .byte "ANGRY BIRD",$FF,$FF,$FF,$FF,$FF,$FF ; 9ED0  #493
        .byte "AQUARIUM",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9EE0  #494
        .byte "ARENA",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9EF0  #495
        .byte "AIR ALERT",$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F00  #496
        .byte "AWFUL RUSHING",$FF,$FF,$FF ; 9F10  #497
        .byte "AIMLESS",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F20  #498
        .byte "BURBLES",$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F30  #499
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F40
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F50
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F60
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F70
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F80
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9F90
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FA0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FB0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FC0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FD0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FE0
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 9FF0
