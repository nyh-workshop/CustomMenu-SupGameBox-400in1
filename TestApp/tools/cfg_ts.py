"""Language select + Aaronix test app: file 0x68000-0x6FFFF, banks $34-$37 at $8000-$FFFF
($410B=4, $410A=$37 -> middle bits $34)."""
import os, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
ROMF = os.path.join(ROOT, 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_68000H.bin')
ROM = bytes(0x8000) + open(ROMF, 'rb').read()
FILE_BASE = 0x60000
COV = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'trace_coverage_ts.json'))).items()}
STUBS = {0xEEB0: (0x0400, 0x61), 0xE6E4: (0x0400, 0x21)}
EXTRA = [0xA023]
BANKS = [(0x8000, 'BANK34', 0x34), (0xA000, 'BANK35', 0x35), (0xC000, 'BANK36', 0x36), (0xE000, 'BANK37', 0x37)]
TITLE = 'Sup 400-in-1 language select + test app'
NAME_COUNT = 0
NAMES = {
    # ---- language select (bank $37, entered by JMP $E000 from the boot stub at $0400)
    0xE000: 'langsel_entry', 0xE033: 'langsel_loop', 0xE0C5: 'langsel_move_cursor', 0xE088: 'langsel_start_english',
    0xE115: 'langsel_nmi', 0xE154: 'langsel_wait_vblank', 0xE1B9: 'langsel_draw_screen', 0xE364: 'langsel_nmi_sub',
    0xE387: 'langsel_init_e387', 0xE62D: 'langsel_wait_frame_read_pad', 0xEAC0: 'langsel_install_nmi_06A0',
    0xEEB0: 'ram_stub_start_chinese', 0xE6E4: 'ram_stub_start_english', 0xEEF0: 'langsel_eef0_regs',
    
    # ---- Aaronix test app (bank $35 code, bank $36 data); RESET vector $FFE0
    0xFFE0: 'testapp_reset', 0xA2D0: 'testapp_start', 0xA600: 'test_wram_patterns', 0xA5FC: 'tbl_ram_test_patterns',
    0xA66D: 'test_wram_fill_verify', 0xA6C5: 'test_wram_copy_rom_c000', 0xA740: 'ram_test_failed', 0xA743: 'clear_wram',
    0xA761: 'test_vram', 0xB808: 'testapp_install_nmi_cold', 0xB828: 'testapp_warm_reset_to_langsel',
    0xBD00: 'wait_vblank_ppu_off', 0xA000: 'testapp_main', 0xA100: 'print_string', 0xA11A: 'tbl_test_strings',
    0xA180: 'read_both_pads', 0xA0E6: 'read_joy1_bit', 0xA0F3: 'read_joy2_bit', 0xA0C8: 'put_tile_2200',
    0xA0D8: 'sub_1A_minus_9', 0xA0E0: 'low_nibble_minus_10', 0xA200: 'testapp_nmi', 0xA520: 'show_press_rates',
    0xA540: 'count_press', 0xA547: 'copy_a3c0_to_0700', 0xA555: 'set_mask_oam_dma_07', 0xA5F0: 'next_counter_addr',
    0xA4FF: 'tbl_test_palette', 0xAA00: 'sound_test_step', 0xABD0: 'show_sound_step', 0xB030: 'wait_vblank_b030',
    0xB400: 'draw_attr_and_grid', 0xA023: 'irq_target_inside_main'}
WORDS = {0xFFFA: 3}
NAME_LO = NAME_HI = 0
REC_LO, REC_N = 0, 0
ROWS = {}
ROWSTART = {}
STUB_NOTE = {0xEEB0: 'copied to $0400 (97 bytes) when $C1=0: start the Chinese menu', 0xE6E4: 'copied to $0400 (33 bytes) when $C1=1: start the English menu'}
FOREIGN = {0xE6FA: 'English block english_menu_entry ($FB7D, file 0x7FB7D)', 0xEECE: 'reset vector of the Chinese block after the switch ($F9EE)'}
exec(open(os.path.join(HERE, 'regs_common.py')).read())
RAMV = {0x0680: 'warm_marker', 0x06A0: 'nmi_jmp_06A0', 0x06A1: 'nmi_jmp_06A1', 0x06A2: 'nmi_jmp_06A2', 0xC1: 'langsel_cursor', 0xF5: 'langsel_pad_new', 0x30: 'snd_step', 0x31: 'snd_timer'}

# sound driver names (added with the sound analysis)
NAMES.update({0xEA80: 'langsel_click_sfx', 0xEF26: 'sound_tick', 0xEF2D: 'sound_play', 0xEF55: 'sound_init', 0xEF7D: 'music_start_song', 0xEFAD: 'music_start_track', 0xF001: 'snd_credit_checksum', 0xF016: 'sfx_start_channel', 0xF096: 'sfx_tick', 0xF0A0: 'sfx_tick_channels', 0xF0AD: 'sfx_tick_pulse1', 0xF11F: 'sfx_tick_pulse2', 0xF191: 'sfx_tick_triangle', 0xF203: 'sfx_tick_noise', 0xF275: 'music_tick', 0xF2FE: 'music_read_header', 0xF350: 'music_read_commands', 0xF4D8: 'music_cmd_note', 0xF560: 'music_cmd_rest', 0xF570: 'music_skip_if_sfx_owns', 0xF57E: 'music_read_duty', 0xF598: 'music_write_volume_chk', 0xF59B: 'music_write_volume', 0xF5BE: 'music_envelope', 0xF605: 'music_volume_slide', 0xF647: 'music_vibrato', 0xF675: 'apu_write_r0', 0xF684: 'apu_write_r1', 0xF693: 'apu_write_r2', 0xF6A2: 'apu_write_r3', 0xF6B1: 'apu_enable_channels', 0xF6BB: 'apu_write_tri_linear', 0xF6C9: 'apu_check_sfx_channel', 0xF703: 'snd_credit_gb2312', 0xF711: 'tbl_note_period_lo', 0xF712: 'tbl_note_period_hi', 0xF729: 'tbl_chan_bit', 0xF72D: 'tbl_chan_clear_mask', 0xF731: 'tbl_chan_type', 0xF735: 'tbl_vibrato', 0xF7A5: 'tbl_envelope', 0xF845: 'tbl_volume_scale', 0xF945: 'tbl_sfx_ptrs', 0xF946: 'tbl_sfx_ptrs_hi', 0xFDFD: 'tbl_song_ntracks', 0xFDFE: 'tbl_song_first_track', 0xFE03: 'tbl_song_records', 0xFE04: 'tbl_song_records_hi', 0xFE05: 'song0_track_records', 0xFE15: 'song0_pulse1', 0xFE78: 'song0_pulse2', 0xFED1: 'song0_triangle', 0xFF28: 'song0_noise'})
EXTRA = EXTRA + [0xEF2D]
