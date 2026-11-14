# Sound driver names shared by the Chinese block (shift 0) and the language-select block (shift $BDC).
DRV = {
 0xE34A: 'sound_tick', 0xE351: 'sound_play', 0xE379: 'sound_init',
 0xE3A1: 'music_start_song', 0xE3D1: 'music_start_track', 0xE425: 'snd_credit_checksum', 0xE43A: 'sfx_start_channel',
 0xE4BA: 'sfx_tick', 0xE4C4: 'sfx_tick_channels', 0xE4D1: 'sfx_tick_pulse1', 0xE543: 'sfx_tick_pulse2',
 0xE5B5: 'sfx_tick_triangle', 0xE627: 'sfx_tick_noise', 0xE699: 'music_tick', 0xE722: 'music_read_header',
 0xE774: 'music_read_commands', 0xE8FC: 'music_cmd_note', 0xE984: 'music_cmd_rest', 0xE994: 'music_skip_if_sfx_owns',
 0xE9A2: 'music_read_duty', 0xE9BC: 'music_write_volume_chk', 0xE9BF: 'music_write_volume', 0xE9E2: 'music_envelope',
 0xEA29: 'music_volume_slide', 0xEA6B: 'music_vibrato', 0xEA99: 'apu_write_r0', 0xEAA8: 'apu_write_r1',
 0xEAB7: 'apu_write_r2', 0xEAC6: 'apu_write_r3', 0xEAD5: 'apu_enable_channels', 0xEADF: 'apu_write_tri_linear',
 0xEAED: 'apu_check_sfx_channel',
 0xEB27: 'snd_credit_gb2312', 0xEB35: 'tbl_note_period_lo', 0xEB36: 'tbl_note_period_hi', 0xEB4D: 'tbl_chan_bit',
 0xEB51: 'tbl_chan_clear_mask', 0xEB55: 'tbl_chan_type', 0xEB59: 'tbl_vibrato', 0xEBC9: 'tbl_envelope', 0xEC69: 'tbl_volume_scale',
 0xED69: 'tbl_sfx_ptrs', 0xED6A: 'tbl_sfx_ptrs_hi',
}
SONG_CN = {0xEFB9: 'tbl_song_ntracks', 0xEFBA: 'tbl_song_first_track', 0xEFBF: 'tbl_song_records', 0xEFC0: 'tbl_song_records_hi',
           0xEFC5: 'song0_track_records', 0xEFD5: 'song0_pulse1', 0xF0EA: 'song0_pulse2', 0xF25F: 'song0_triangle', 0xF374: 'song0_noise'}
SONG_LS = {0xFDFD: 'tbl_song_ntracks', 0xFDFE: 'tbl_song_first_track', 0xFE03: 'tbl_song_records', 0xFE04: 'tbl_song_records_hi',
           0xFE05: 'song0_track_records', 0xFE15: 'song0_pulse1', 0xFE78: 'song0_pulse2', 0xFED1: 'song0_triangle', 0xFF28: 'song0_noise'}
def cn():
    d = dict(DRV); d.update(SONG_CN)
    d.update({0x8000: 'old_snd_jt_tick', 0x8003: 'old_snd_jt_start', 0x806C: 'old_snd_tick', 0x80FE: 'old_snd_start'})
    return d
def ls():
    d = {a + 0xBDC: n for a, n in DRV.items()}; d.update(SONG_LS); d[0xEA80] = 'langsel_click_sfx'
    return d
