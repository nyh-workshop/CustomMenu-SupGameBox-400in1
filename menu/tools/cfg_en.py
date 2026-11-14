"""English menu: file 0x70000-0x7FFFF (only $8000-$FFFF = banks $3C-$3F disassembled)."""
import os, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
ROMF = os.path.join(ROOT, 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_70000H.bin')
ROM = open(ROMF, 'rb').read()            # index = CPU address for $8000-$FFFF
FILE_BASE = 0x70000                      # file offset of ROM[0]
COV = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'trace_coverage_en.json'))).items()}
STUBS = {0xFB8C: (0x0200, 0x100), 0xFF70: (0x0400, 0x31), 0xAB00: (0x0400, 0x60),
         0xAA78: (0x0400, 0x31), 0xAD60: (0x0400, 0x31)}
EXTRA = [0xAAB1, 0xC948, 0xC957, 0xC900, 0xC92E, 0xC2EB, 0xC38C, 0xC0BF, 0xC15D, 0xC19A, 0xC8D4]
BANKS = [(0x8000, 'BANK3C', 0x3C), (0xA000, 'BANK3D', 0x3D), (0xC000, 'BANK3E', 0x3E), (0xE000, 'BANK3F', 0x3F)]
TITLE = 'Sup 400-in-1 English menu'
NAME_COUNT = 500
# ---------------------------------------------------------------- names
NAMES = {
    0xE7E0: 'reset_vector_jmpchain', 0xFFD0: 'reset_jmpchain_2', 0xFFD9: 'reset_early_init',
    0xFEF5: 'reset_main_init', 0xFF1C: 'boot_check_ab_then_menu', 0xFF24: 'set_412B_412C',
    0xFF30: 'select_r7_33_jump_bank33', 0xFF40: 'fill_palette_0F', 0xFF60: 'run_ram_stub_boot_select',
    0xFF70: 'ram_stub_boot_select', 0xFFB0: 'jump_bank15_tft_init',
    0xA9E0: 'set_chr_banks_mmc3', 0xA000: 'relaunch_saved_game', 0xA220: 'relaunch_prepare',
    0xA800: 'store_069F_06E0', 0xA82C: 'launch_game', 0xA880: 'ppu_off_wait_vblank',
    0xA8A0: 'init_reg_pointer_table', 0xA8B1: 'tbl_reg_pointers', 0xA8C1: 'relaunch_continue',
    0xAA40: 'read_pad_edge', 0xAA60: 'check_AB_support_app', 0xAA78: 'ram_stub_support_app',
    0xAB00: 'ram_stub_game_launch', 0xAB75: 'prelaunch_mirroring_save_ptrs',
    0xAD40: 'run_ram_stub_outer_88', 0xAD60: 'ram_stub_outer_88',
    0xC00D: 'read_pad_0327_thunk', 0xC01F: 'read_pad_0327',
    0xC8CC: 'call_idle_hook', 0xC8D4: 'idle_hook_rts', 0xC8D5: 'set_prg_r6r7_3E3F',
    0xF9C0: 'set_prg_r6r7_3C3D',
    0xFA16: 'menu_main', 0xFA37: 'nmi_vector_jmp_d0', 0xFA3A: 'nmi_handler',
    0xFA9D: 'nmi_set_scroll', 0xFABF: 'nmi_call_hook_b0', 0xFAC8: 'nmi_frame_tail',
    0xFAEC: 'irq_rti', 0xFB40: 'nmi_sound_or_anim', 0xFB7D: 'english_menu_entry',
    0xFB8C: 'ram_stub_0200_chr_setup', 0xAAB1: 'launch_from_chinese_menu',
    # bank $3E API jump table at $C001 (3-byte JMPs)
    0xC001: 'jt_C266', 0xC004: 'jt_C22B', 0xC007: 'jt_C1FB', 0xC00A: 'jt_C174', 0xC010: 'jt_print_string_struct',
    0xC013: 'jt_print_string_queued', 0xC016: 'jt_C15E', 0xC019: 'jt_draw_screen_by_id', 0xC01C: 'jt_menu_run_screen',
    0xC045: 'print_string_struct', 0xC078: 'print_string_queued', 0xC0BF: 'nmi_hook_write_string',
    0xC15D: 'nmi_hook_15D', 0xC19A: 'nmi_hook_19A',
    0xC2C5: 'draw_screen_by_id', 0xC2E7: 'tbl_screen_draw_methods', 0xC2EB: 'screen_draw_method0', 0xC38C: 'screen_draw_method1',
    0xC461: 'menu_run_screen', 0xC562: 'redraw_list_page_if_dirty',
    0xC8F6: 'tbl_menu_states', 0xC8F8: 'tbl_state0_steps',
    0xC900: 'state0_step1_main', 0xC92E: 'state0_step1_nmi', 0xC948: 'state0_step0_main', 0xC957: 'state0_step0_nmi',
    0xC963: 'menu_update_cursor_sprite', 0xC9A9: 'menu_handle_input', 0xCA4A: 'menu_input_tail',
    0xCA51: 'page_forward_n', 0xCB18: 'cursor_past_bottom_next_page', 0xCB88: 'page_back_n', 0xCC2B: 'cursor_past_top_prev_page',
    0xCE30: 'tbl_list_order_ptrs',
    0xA28A: 'sfx_beep', 0xE100: 'draw_nametable_0', 0xE169: 'unpack_nametable_rle',
    0xFAED: 'menu_video_init', 0xFB0D: 'init_palette_buffer_0E', 0xFB1A: 'state_dispatch_main',
    0xFB72: 'clear_oam_buffer', 0xFC3C: 'tbl_screen_desc', 0xE7F1: 'tbl_game_records',
    0x8000: 'game_names', 0xF9EF: 'boot_hotkey_A_select', 0xF9FC: 'boot_hotkey_B_select', 0xFA09: 'boot_hotkey_select_start',
}
# word tables: start -> count (emitted as .word with labels where possible)
WORDS = {0xFFFA: 3, 0xC8F6: 1, 0xC8F8: 4, 0xC2E7: 2, 0xE7F1: 400}
NAME_LO, NAME_HI = 0x8000, 0x8000 + 16 * 500
REC_LO, REC_N = 0xEB11, 400
ROWS = {0xB000: (8, 512, 'launch_param'), 0xCE7B: (4, 256, 'list_entry_lo'), 0xD27B: (4, 244, 'list_entry_hi')}
NAMES.update({0xB000: 'tbl_launch_params_b0', 0xB800: 'tbl_launch_params_b8',
              0xCE7B: 'tbl_list_entries_lo', 0xD27B: 'tbl_list_entries_hi'})
ROWSTART = {}
for r0, (rl, rc, nm) in ROWS.items():
    for k in range(rc):
        ROWSTART[r0 + rl * k] = (rl, k, nm)
for i in range(REC_N):
    NAMES[REC_LO + 9 * i] = 'game_rec_%03d' % i
STUB_NOTE = {0xFB8C: 'copied to $0200 by english_menu_entry and run there',
             0xFF70: 'copied to $0400 (49 bytes) by run_ram_stub_boot_select',
             0xAB00: 'copied to $0400 (96 bytes) by launch_game',
             0xAA78: 'copied to $0400 (49 bytes) by check_AB_support_app',
             0xAD60: 'copied to $0400 (49 bytes) by run_ram_stub_outer_88'}
# absolute jump targets that, at run time, are in a bank other than this file's
FOREIGN = {0xFF3A: 'bank $33 at $A000 (file 0x66000)', 0xFFB9: 'bank $15 at $A000 (file 0x2A000)',
           0xFF9A: 'bank $37 at $E000 (file 0x6E000), language select', 0xFF89: None}
exec(open(os.path.join(HERE, 'regs_common.py')).read())
# RAM variables named from how the code uses them (see README for evidence)
RAMV = {0x22: 'pad_held_aa40', 0x23: 'pad_new_aa40', 0xB0: 'nmi_hook_ptr', 0xC2: 'frame_counter',
        0xD0: 'nmi_vector_ptr', 0xD4: 'idle_hook_ptr', 0xD8: 'regptr_410B', 0xDA: 'regptr_201A',
        0xDC: 'regptr_4100', 0xDE: 'regptr_2018',
        0x0322: 'nmi_hook_pending', 0x0327: 'pad_state', 0x032D: 'chr_shadow_r2', 0x032E: 'chr_shadow_r3',
        0x032F: 'chr_shadow_r4', 0x0330: 'chr_shadow_r5', 0x0332: 'chr_shadow_r0', 0x0333: 'chr_shadow_r1',
        0x035B: 'screen_id', 0x035C: 'menu_state', 0x035D: 'menu_step', 0x035E: 'nmi_dispatch_on',
        0x035F: 'menu_start_pressed', 0x0360: 'cursor_sprite_inited', 0x0362: 'frame_div7', 0x0363: 'nmi_step_on',
        0x0368: 'ppu_ctrl_shadow', 0x036C: 'scroll_y_shadow', 0x03D0: 'keep_ppu_addr',
        0x0480: 'launch_p0', 0x0482: 'launch_201A', 0x0483: 'launch_prg_bank', 0x0484: 'launch_outer_lo',
        0x0485: 'launch_2018', 0x0486: 'launch_410B',
        0x0625: 'page_step', 0x0649: 'rows_per_page', 0x064A: 'draw_row', 0x064B: 'cursor_row', 0x064C: 'list_dirty',
        0x069F: 'game_number_lo', 0x06A0: 'game_number_hi', 0x0375: 'cn_page', 0x03C3: 'cn_row'}

