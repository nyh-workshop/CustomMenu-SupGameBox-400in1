"""Chinese menu: file 0x30000-0x3FFFF.  Banks $1C-$1F (file 0x38000-0x3FFFF) run at
$8000-$FFFF and are disassembled; banks $18-$1B (0x30000-0x37FFF) are data paged in
at $8000 through $4107 = $38-$3B ($410B=1 -> inner mask $1F)."""
import os, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
ROMF = os.path.join(ROOT, 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_30000H.bin')
ROM = open(ROMF, 'rb').read()
FILE_BASE = 0x30000
COV = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'trace_coverage_cn.json'))).items()}
STUBS = {0xDE5C: (0x0408, 0xDA)}
EXTRA = [0xCD8B, 0xCDE9, 0xCE4E, 0xCE7A, 0xCE7B, 0xDDD5, 0xC006, 0xC009, 0xC00C, 0xC012, 0xC015, 0xC018, 0xC01B]
BANKS = [(0x8000, 'BANK1C', 0x1C), (0xA000, 'BANK1D', 0x1D), (0xC000, 'BANK1E', 0x1E), (0xE000, 'BANK1F', 0x1F)]
TITLE = 'Sup 400-in-1 Chinese menu'
NAME_COUNT = 0
NAMES = {0xF9EE: 'reset', 0xFA51: 'nmi_handler', 0xFBC8: 'irq_handler', 0xFA4B: 'main_loop',
    0xFC19: 'nmi_call_hook_24', 0xFC27: 'state_dispatch_main',
    0xC000: 'jt_C9E6', 0xC003: 'jt_clear_oam_from_y', 0xC006: 'jt_CAA1', 0xC009: 'jt_CAF4', 0xC00C: 'jt_CA2E',
    0xC00F: 'jt_CC27', 0xC012: 'jt_CC33', 0xC015: 'jt_CC31', 0xC018: 'jt_CC32', 0xC01B: 'jt_prng_step',
    0xC01E: 'prng_step', 0xC03C: 'hw_init', 0xC05E: 'init_ppu_shadows', 0xC07A: 'read_4119_flag',
    0xC08C: 'read_pad', 0xC3D6: 'clear_oam_from_y', 0xC3E4: 'clear_oam_and_sprite_slots',
    0xC402: 'update_sprite_slots', 0xC5DA: 'load_screen_desc', 0xC6C4: 'screen_exit', 0xC70F: 'screen_enable',
    0xCD40: 'tbl_menu_states', 0xCD42: 'tbl_state0_steps', 0xCD56: 'screen_desc_1', 0xCD5F: 'screen_desc_2',
    0xCD68: 'screen_desc_3', 0xCD77: 'step_common_init',
    0xCD8B: 'step0_screen2', 0xCDE9: 'step1_screen1', 0xCE4E: 'step2_screen3', 0xCE7A: 'step3_rts', 0xCE7B: 'step4_rts',
    0xCE7C: 'select_screen_desc_1', 0xCE88: 'select_screen_desc_2', 0xCE94: 'select_screen_desc_3',
    0xDBC2: 'step0_exit_launch', 0xDBCC: 'step1_exit_launch',
    0xDD6C: 'launch_selected_game', 0xDE36: 'dat_launch_0100_init', 0xDDD5: 'chr_regs_reset_code',
    0xDE5C: 'ram_stub_launch_0408',
    0xF680: 'set_page_bg_chr', 0xF6A0: 'tbl_page_bg_chr', 0xC170: 'load_screen_record_chr',
    0xCC27: 'goto_state_step', 0xCEC7: 'chooser_input', 0xD331: 'list_input', 0xD2A7: 'load_char_tile_map',
    0xD2C0: 'draw_header_text', 0xD648: 'load_list_header', 0xDA55: 'count_list4_entries', 0xDA99: 'count_list2_entries',
    0xDAC2: 'pick_random_unused_entry', 0xDAFE: 'build_ascii_name_row', 0xDC8E: 'launch_ptr_from_ascii_entry',
    0xDCF1: 'launch_ptr_skip_to_stub',
    0xE34A: 'sound_tick', 0xE351: 'sound_play', 0xE379: 'sound_init'}
WORDS = {0xFFFA: 3, 0xCD40: 1, 0xCD42: 10}
ROWS = {0xCD56: (9, 3, 'screen_desc'), 0xF6A0: (1, 40, 'page_bg_chr')}
NAME_LO = NAME_HI = 0
REC_LO, REC_N = 0, 0
ROWSTART = {}
for r0, (rl, rc, nm) in ROWS.items():
    for k in range(rc):
        ROWSTART[r0 + rl * k] = (rl, k, nm)
STUB_NOTE = {0xDE5C: 'copied to $0408 (218 bytes) by launch_selected_game; only the first part runs: it maps the English block and jumps to $AAB1 there'}
FOREIGN = {0xDE72: 'English bank $3D: launch_from_chinese_menu ($AAB1, file 0x7AAB1)'}
exec(open(os.path.join(HERE, 'regs_common.py')).read())
RAMV = {0x00: 'ppu_ctrl_shadow', 0x01: 'ppu_mask_shadow', 0x02: 'video_2010_shadow', 0x03: 'scroll_x_shadow',
        0x04: 'scroll_y_shadow', 0x06: 'frame_counter', 0x08: 'prg8000_shadow', 0x0D: 'flag_4119',
        0x1B: 'frame_done', 0x1C: 'nmi_hook_mode', 0x1D: 'bg_chr_base', 0x24: 'nmi_hook_ptr',
        0x30: 'menu_state', 0x31: 'menu_step', 0x32: 'step_exit', 0x3A: 'screen_id', 0x4D: 'spr_chr_base',
        0xB0: 'state_tbl_ptr', 0xB2: 'handler_ptr', 0xB4: 'screen_desc_ptr', 0xDB: 'sound_id',
        0x011D: 'prng_state', 0x0375: 'cn_page', 0x03C3: 'cn_row', 0x03F7: 'list_header_sel', 0x007D: 'chooser_option', 0x0365: 'list4_ptr_lo', 0x0366: 'list4_ptr_hi', 0x0372: 'list4_count_lo', 0x0373: 'list4_count_hi'}

# sound driver names (added with the sound analysis)
NAMES.update({0xE34A: 'sound_tick', 0xE351: 'sound_play', 0xE379: 'sound_init', 0xE3A1: 'music_start_song', 0xE3D1: 'music_start_track', 0xE425: 'snd_credit_checksum', 0xE43A: 'sfx_start_channel', 0xE4BA: 'sfx_tick', 0xE4C4: 'sfx_tick_channels', 0xE4D1: 'sfx_tick_pulse1', 0xE543: 'sfx_tick_pulse2', 0xE5B5: 'sfx_tick_triangle', 0xE627: 'sfx_tick_noise', 0xE699: 'music_tick', 0xE722: 'music_read_header', 0xE774: 'music_read_commands', 0xE8FC: 'music_cmd_note', 0xE984: 'music_cmd_rest', 0xE994: 'music_skip_if_sfx_owns', 0xE9A2: 'music_read_duty', 0xE9BC: 'music_write_volume_chk', 0xE9BF: 'music_write_volume', 0xE9E2: 'music_envelope', 0xEA29: 'music_volume_slide', 0xEA6B: 'music_vibrato', 0xEA99: 'apu_write_r0', 0xEAA8: 'apu_write_r1', 0xEAB7: 'apu_write_r2', 0xEAC6: 'apu_write_r3', 0xEAD5: 'apu_enable_channels', 0xEADF: 'apu_write_tri_linear', 0xEAED: 'apu_check_sfx_channel', 0xEB27: 'snd_credit_gb2312', 0xEB35: 'tbl_note_period_lo', 0xEB36: 'tbl_note_period_hi', 0xEB4D: 'tbl_chan_bit', 0xEB51: 'tbl_chan_clear_mask', 0xEB55: 'tbl_chan_type', 0xEB59: 'tbl_vibrato', 0xEBC9: 'tbl_envelope', 0xEC69: 'tbl_volume_scale', 0xED69: 'tbl_sfx_ptrs', 0xED6A: 'tbl_sfx_ptrs_hi', 0xEFB9: 'tbl_song_ntracks', 0xEFBA: 'tbl_song_first_track', 0xEFBF: 'tbl_song_records', 0xEFC0: 'tbl_song_records_hi', 0xEFC5: 'song0_track_records', 0xEFD5: 'song0_pulse1', 0xF0EA: 'song0_pulse2', 0xF25F: 'song0_triangle', 0xF374: 'song0_noise'})
