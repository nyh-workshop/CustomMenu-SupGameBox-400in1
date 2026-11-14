# Sup 400-in-1 (OneBus) - menu sources, tools and the custom multicart builder.   README_Claude.md has the overview.
#
# Needs Python 3 (+ Pillow for pictures).  The source rebuilds use cc65 (ca65 + ld65) when it is found: on PATH, or
# CC65=/path/to/cc65/bin.  Without it they run tools/asmcheck.py, a strict stand-in that reads the same sources.
PYTHON ?= python3
CC65   ?=
export CC65
ASM    ?= auto
# the two stripped images shipped in roms/ (roms/README.md).  The full 512 KiB dump is not shipped: DUMP=<your copy>
# (opcode bits 4/5 swapped back, sha1 ecb67c77...) adds the full-dump checks and is needed by make base.
BASE      := roms/romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin
BASE_EN   := roms/romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped_EnglishMenu.bin
DUMP      ?=
# the image the tools read by default (ROM= overrides): your dump if given, else the stripped image
SRC_ROM    = $(or $(ROM),$(DUMP),$(BASE))
BLOCKS     = $(PYTHON) tools/build_blocks.py --asm $(ASM) $(if $(or $(ROM),$(DUMP)),--rom "$(or $(ROM),$(DUMP))")
# plain `make` builds the multicart from custom/
.DEFAULT_GOAL := rom

# ---- the menu region from source, compared byte for byte with the dump ------------------------------------------
#   make verify [DUMP=...] all five blocks (against their orig/ files) + the blocks in the stripped image + both stripped
#                          images made again; with DUMP= also the whole 512 KiB dump        (ASM=ca65|check|both)
#   make menu | menu-cn | testapp | boot | tft | blocks | image
#   make identical         the frozen copy in identical/
#   make custom [ROM=...] [OUT=...]   your edited sources into a copy of the stripped image (or ROM=; no match check)
verify: image base-check
menu:
	$(BLOCKS) menu
menu-cn:
	$(BLOCKS) menu_cn
testapp:
	$(BLOCKS) testapp
boot:
	$(BLOCKS) boot
tft:
	$(BLOCKS) tft
blocks:
	$(BLOCKS)
image:
	$(BLOCKS) --image
identical:
	$(MAKE) -C identical PYTHON="$(PYTHON)" ASM="$(ASM)" $(if $(or $(ROM),$(DUMP)),ROM="$(abspath $(or $(ROM),$(DUMP)))")
custom:
	$(PYTHON) tools/build_blocks.py --custom --asm $(ASM) $(if $(ROM),--rom "$(ROM)") $(if $(OUT),--out "$(OUT)")
.PHONY: verify menu menu-cn testapp boot tft blocks image identical custom

# ---- the stripped base the builder starts from --------------------------------------------------------------------
#   make base DUMP=<512 KiB dump>          rebuild roms/..._stripped.bin from your dump
#   make EnglishMenu [DUMP=<512 KiB dump>] rebuild roms/..._stripped_EnglishMenu.bin (from the stripped image, or DUMP=):
#                                          boots straight into the English list, no Chinese menu / language select
#   make base-check [DUMP=...]             make both images again and compare them with the shipped ones
#   make strip-check                       boot the three images on the OneBus model: same CPU path, sound and screens
#   make strip-audit [SF2010=chr.bin]      no Capcom bank, no Street Fighter 2010 tiles, nothing outside the keep map
base:
	@test -n "$(DUMP)" || { echo "make base needs your 512 KiB dump: make base DUMP=<file>"; exit 1; }
	$(PYTHON) tools/strip_rom.py "$(DUMP)" $(BASE)
EnglishMenu:
	$(PYTHON) tools/strip_rom.py --english-menu "$(or $(DUMP),$(BASE))" $(BASE_EN)
base-check:
	$(PYTHON) tools/strip_rom.py --check $(if $(DUMP),"$(DUMP)")
strip-check:
	$(PYTHON) tools/strip_checks/bootcmp.py $(if $(DUMP),--dump "$(DUMP)")
strip-audit:
	$(PYTHON) tools/strip_checks/audit.py $(if $(SF2010),--sf2010 "$(SF2010)") $(if $(DUMP),--dump "$(DUMP)")
.PHONY: base EnglishMenu base-check strip-check strip-audit

# ---- the game list in a menu image ---------------------------------------------------------------------------------
#   make games-list [ROM=image] [OUT=dir]    games.csv + GAMES.md in data/ (default: the stripped image)
#   make games-extract ROM=image [OUT=dir]   every game inside the image as a .nes (e.g. from a built multicart)
games-list:
	mkdir -p "$(or $(OUT),data)"
	$(PYTHON) tools/list_games.py "$(SRC_ROM)" --csv "$(or $(OUT),data)/games.csv" --md "$(or $(OUT),data)/GAMES.md"
games-extract:
	$(PYTHON) tools/list_games.py "$(SRC_ROM)" --extract "$(or $(OUT),build/extracted)"
.PHONY: games-list games-extract

# ---- your own multicart (rombuilder/) -------------------------------------------------------------------------------
# Everything you change lives in custom/ (custom/README.md):
#   custom/games.csv + custom/games/*.nes    your games (no games.csv: every .nes in custom/games/)
#   custom/music/music.txt (+ .mid, .txt)    the list music and the cursor sound
#   custom/wallpaper/english.png             the game-list background (optional)
#   custom/wallpaper/colors.txt              the list colours: text, around the text, cursor, title (optional)
#
#   make rom [SIZE=8|16] [OUT=build/rom/multicart_8M.bin]  -> .bin (emulators), .nes (FCEUX), _unit.bin (the real
#            handheld: flash this one), _games.csv, _layout.txt, _build.log
#   options: VERIFY=1 (or auto|full|quick)   also check the image on the OneBus model (slower)
#            WAV=1                           _music.wav preview of the list music
#            SCAN=1                          ignore games.csv: every .nes in the games folder (written back as a list)
#            UNIT=0                          no _unit.bin;  UNIT_DUMP=f.bin  compare with the handheld's own 0x70000-0x7FFFF
#            CUSTOM=dir, CSV=..., GAMES=..., MUSIC=..., PNG_ENGLISH=..., COLORS=..., BASE_ROM=...   override single items
#   make rom-EnglishMenu [same options]      the same multicart on the English-menu-only base (no Chinese menu or
#                                            language select in the flash) -> build/rom/multicart_8M_EnglishMenu.bin
#   make rom-test BASE_ROM=$(BASE_EN)         the builder self-test on that base
#   make unit [ROM=image.bin] [OUT=...]      the handheld image of any image (default: the last make rom output)
#   make rom-verify OUT=my.bin                re-check a built image on the OneBus model
#   make rom-test                             self-test of the builder (examples, scan, 500 games, music, errors)
#   make rom-fceux [OUT=my.bin]               run the .nes in FCEUX (builds a headless FCEUX from source the first time)
#   make rom-carts                            rebuild the test carts in rombuilder/examples/carts/ (needs ca65/ld65)
SIZE ?= 8
VERIFY_MODE = $(if $(filter 1 yes,$(VERIFY)),auto,$(or $(VERIFY),none))
ROM_OUT = $(or $(OUT),build/rom/multicart_$(SIZE)M.bin)
rom:
	$(PYTHON) rombuilder/build_rom.py --base "$(or $(BASE_ROM),$(BASE))" --size $(SIZE) --custom "$(or $(CUSTOM),custom)" \
	  $(if $(SCAN),--scan) $(if $(CSV),--csv "$(CSV)") $(if $(GAMES),--games "$(GAMES)") $(if $(MUSIC),--music "$(MUSIC)") \
	  $(if $(PNG_ENGLISH),--wallpaper "$(PNG_ENGLISH)") $(if $(COLORS),--colors "$(COLORS)") $(if $(WAV),--wav) \
	  $(if $(filter 0 no,$(UNIT)),--no-unit) $(if $(UNIT_DUMP),--unit-dump "$(UNIT_DUMP)") $(if $(OUT),--out "$(OUT)") --verify $(VERIFY_MODE)
unit:
	$(PYTHON) rombuilder/unit.py "$(or $(ROM),$(ROM_OUT))" $(if $(OUT),"$(OUT)") $(if $(UNIT_DUMP),--unit-dump "$(UNIT_DUMP)")
rom-EnglishMenu:
	$(MAKE) rom BASE_ROM="$(BASE_EN)" OUT="$(or $(OUT),build/rom/multicart_$(SIZE)M_EnglishMenu.bin)"
rom-test:
	$(PYTHON) rombuilder/selftest.py "$(or $(BASE_ROM),$(BASE))"
rom-verify:
	$(PYTHON) rombuilder/verify.py "$(ROM_OUT)" --mode $(if $(filter none,$(VERIFY_MODE)),auto,$(VERIFY_MODE))
rom-fceux:
	test -x rombuilder/fceux/bin/fceux_headless || sh rombuilder/fceux/build.sh
	$(PYTHON) rombuilder/fceux/check.py "$(basename $(ROM_OUT)).nes"
rom-carts:
	$(PYTHON) rombuilder/examples/make_test_carts.py
.PHONY: rom unit rom-EnglishMenu rom-test rom-verify rom-fceux rom-carts

# ---- menu music and sound effects of the original menus (music/, sound/) -------------------------------------------
#   make midi-info SRC=song.mid                                 channels of a MIDI file and the default voice mapping
#   make music-export [ROM=...] [WAV=1]                         songs + effects -> music/export/ (NSF, raw, listings, WAV)
#   make music [ROM=...] [CN_SONG=a.mid] [LS_SONG=b.mid] [CN_OPT="drums=simple"] [LS_OPT=...]
#              [CN_CURSOR=c.txt] [EN_BEEP=d.txt] [LS_CHIME=e.txt] [OUT=my.bin] [WAV=1]   -> a copy with them
#   make music-preview SRC=song.mid [MENU=cn|ls] [OPTS="drums=simple"]   -> build/music_preview/*.wav, nothing kept
#   make music-test                                             MIDI -> driver -> menus self-test
midi-info:
	$(PYTHON) music/menu_music.py info "$(SRC)"
music-export:
	$(PYTHON) sound/tools/extract.py "$(SRC_ROM)" music/export $(if $(WAV),,--no-wav)
music:
	mkdir -p build
	$(PYTHON) music/menu_music.py build "$(SRC_ROM)" -o "$(or $(OUT),build/music_custom.bin)" \
	  $(if $(CN_SONG),--cn-song "$(CN_SONG)") $(if $(LS_SONG),--ls-song "$(LS_SONG)") \
	  $(foreach o,$(CN_OPT),--cn-opt $(o)) $(foreach o,$(LS_OPT),--ls-opt $(o)) \
	  $(if $(CN_CURSOR),--cn-cursor "$(CN_CURSOR)") $(if $(EN_BEEP),--en-beep "$(EN_BEEP)") $(if $(LS_CHIME),--ls-chime "$(LS_CHIME)") \
	  $(if $(WAV),--preview build/music_wav)
music-preview:
	mkdir -p build/music_preview
	$(PYTHON) music/menu_music.py build "$(SRC_ROM)" -o build/music_preview/tmp.bin --$(or $(MENU),cn)-song "$(SRC)" \
	  $(foreach o,$(OPTS),--$(or $(MENU),cn)-opt $(o)) --preview build/music_preview
	rm -f build/music_preview/tmp.bin
music-test:
	$(PYTHON) music/selftest.py "$(SRC_ROM)"
.PHONY: midi-info music-export music music-preview music-test

# ---- menu wallpapers (wallpaper/) --------------------------------------------------------------------------------
#   make wallpaper-export [ROM=...]       -> wallpaper/out/{langsel,english,chinese}.png (+ _guide.png, .nam/.chr/.pal)
#   make wallpaper [ROM=...] [PNG_LANGSEL=a.png] [PNG_ENGLISH=b.png] [PNG_CHINESE=c.png] [OUT=my.bin]
wallpaper-export:
	for s in langsel english chinese; do $(PYTHON) wallpaper/wallpaper.py export "$(SRC_ROM)" $$s wallpaper/out --guide wallpaper/out/$${s}_guide.png; done
wallpaper:
	mkdir -p build
	cp "$(SRC_ROM)" build/wallpaper_tmp.bin
	$(if $(PNG_LANGSEL),$(PYTHON) wallpaper/wallpaper.py import-png build/wallpaper_tmp.bin langsel "$(PNG_LANGSEL)" -o build/wallpaper_tmp2.bin && mv build/wallpaper_tmp2.bin build/wallpaper_tmp.bin)
	$(if $(PNG_ENGLISH),$(PYTHON) wallpaper/wallpaper.py import-png build/wallpaper_tmp.bin english "$(PNG_ENGLISH)" -o build/wallpaper_tmp2.bin && mv build/wallpaper_tmp2.bin build/wallpaper_tmp.bin)
	$(if $(PNG_CHINESE),$(PYTHON) wallpaper/wallpaper.py import-png build/wallpaper_tmp.bin chinese "$(PNG_CHINESE)" -o build/wallpaper_tmp2.bin && mv build/wallpaper_tmp2.bin build/wallpaper_tmp.bin)
	mv build/wallpaper_tmp.bin "$(or $(OUT),build/wallpaper_custom.bin)"
	@echo "wrote $(or $(OUT),build/wallpaper_custom.bin)"
.PHONY: wallpaper wallpaper-export

# ---- the readable C (reference/): compile check (cc65 when found, else the host C compiler) --------------------------
reference-check:
	$(PYTHON) tools/check_reference.py
.PHONY: reference-check

# ---- research tools ------------------------------------------------------------------------------------------------
#   make cn-screens       the hidden Chinese screens (steps 0 and 2) forced on the OneBus model -> tools/cn_hidden_screens/shots/
#   make capcom-compare ROMS="game1.nes game2.nes"   is the dormant bank $1C sound bank from one of these games?
capcom-compare:
	$(PYTHON) tools/capcom_compare.py $(if $(DUMP),--dump "$(DUMP)") $(ROMS)
cn-screens:
	cd tools/cn_hidden_screens && ROM="$(abspath $(SRC_ROM))" $(PYTHON) make_shots.py
clean:
	rm -rf build menu/build menu_cn/build TestApp/build tft_driver/build identical/build
.PHONY: cn-screens capcom-compare clean
