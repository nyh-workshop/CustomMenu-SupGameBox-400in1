"""Sup 400-in-1 TFT/LCD init (bank $15): file 0x2A000-0x2BFFF (8 KiB bank $15), run at CPU $A000."""
import os, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
ROMF = os.path.join(ROOT, 'orig', 'romdump_sup400in1_10042024_201812_opcode_bits45_swap_2A000H_8KiB.bin')
ROM = bytes(0xA000) + open(ROMF, 'rb').read() + bytes(0x4000)   # index = CPU address
FILE_BASE = 0x2A000 - 0xA000
LO, HI = 0xA000, 0xC000
VECTORS = ()
COV = {int(k, 16): v for k, v in json.load(open(os.path.join(HERE, 'trace_coverage_tft.json'))).items()}
STUBS = {}
EXTRA = [0xA000]
BANKS = [(0xA000, 'BANK15', 0x15)]
TITLE = 'Sup 400-in-1 TFT/LCD init (bank $15)'
RAM_INC = 'ram_tft.inc'
NAME_COUNT = 0
NAMES = {0xA000: 'tft_entry', 0xA006: 'tft_detect_and_init', 0xA5CF: 'lcd_reset_pulse',
    0xA5FC: 'lcd_set_4FF0_block_B7', 0xA620: 'lcd_set_4FF0_block_BD',
    0xA644: 'lcd_send_cmd', 0xA64C: 'lcd_cmd_strobe', 0xA67A: 'lcd_send_data', 0xA682: 'lcd_data_strobe',
    0xA6B5: 'lcd_read_byte', 0xA6D2: 'lcd_read_word',
    0xA706: 'lcd_read_id_cmd00', 0xA70B: 'lcd_read_id_cmd67', 0xA712: 'lcd_read_id_2',
    0xA733: 'lcd_read_id_cmdCD', 0xA738: 'lcd_read_id_cmd28', 0xA73D: 'lcd_read_id_1',
    0xA75B: 'lcd_read_id_cmd04', 0xA760: 'lcd_read_id_cmdD3', 0xA765: 'lcd_read_id_cmdD5', 0xA76A: 'lcd_read_id_3',
    0xA797: 'lcd_read_id_cmd0A_F1', 0xA7DC: 'delay_long', 0xA7EF: 'tbl_lcd_init_cmds'}
for a in range(0xA2EE, 0xA4C0, 0x10):
    NAMES.setdefault(a, 'panel_init_%04X' % a)
NAME_LO = NAME_HI = 0
REC_LO, REC_N = 0, 0
ROWS = {}
ROWSTART = {}
STUB_NOTE = {}
FOREIGN = {}
exec(open(os.path.join(HERE, 'regs_common.py')).read())
STRS = {47180: 13, 47193: 5, 47198: 5, 47203: 5, 47208: 5, 47213: 6, 47219: 6, 47225: 6, 47231: 6, 47237: 5, 47242: 5, 47247: 6, 47253: 6, 47259: 5, 47264: 5, 47269: 5, 47274: 5, 47279: 7, 47286: 7, 47293: 5, 47298: 6, 47304: 6, 47310: 8, 47318: 6, 47324: 5, 47329: 5, 47334: 5, 47339: 6, 47345: 6, 47351: 6, 47357: 8, 47365: 5, 47370: 5}
WORDS = {0xB80A: 33}
NAMES.update({47180: 'str_lcd_00', 47193: 'str_lcd_01', 47198: 'str_lcd_02', 47203: 'str_lcd_03', 47208: 'str_lcd_04', 47213: 'str_lcd_05', 47219: 'str_lcd_06', 47225: 'str_lcd_07', 47231: 'str_lcd_08', 47237: 'str_lcd_09', 47242: 'str_lcd_0A', 47247: 'str_lcd_0B', 47253: 'str_lcd_0C', 47259: 'str_lcd_0D', 47264: 'str_lcd_0E', 47269: 'str_lcd_0F', 47274: 'str_lcd_10', 47279: 'str_lcd_11', 47286: 'str_lcd_12', 47293: 'str_lcd_13', 47298: 'str_lcd_14', 47304: 'str_lcd_15', 47310: 'str_lcd_16', 47318: 'str_lcd_17', 47324: 'str_lcd_18', 47329: 'str_lcd_19', 47334: 'str_lcd_1A', 47339: 'str_lcd_1B', 47345: 'str_lcd_1C', 47351: 'str_lcd_1D', 47357: 'str_lcd_1E', 47365: 'str_lcd_1F', 47370: 'str_lcd_20'})
NAMES.update({0xB80A: 'tbl_lcd_names'})
NAMES.update({0xA7EF: 'lcd_cmds_A7EF', 0xA8EF: 'lcd_cmds_A8EF', 0xA949: 'lcd_cmds_A949', 0xA998: 'lcd_cmds_A998', 0xA86E: 'lcd_cmds_A86E', 0xAA10: 'lcd_cmds_AA10', 0xAABB: 'lcd_cmds_AABB', 0xAB55: 'lcd_cmds_AB55', 0xABDD: 'lcd_cmds_ABDD', 0xAE37: 'lcd_cmds_AE37', 0xAEBD: 'lcd_cmds_AEBD', 0xAF52: 'lcd_cmds_AF52', 0xAFEA: 'lcd_cmds_AFEA', 0xB037: 'lcd_cmds_B037', 0xB27F: 'lcd_cmds_B27F', 0xB2F0: 'lcd_cmds_B2F0', 0xB364: 'lcd_cmds_B364', 0xB3E1: 'lcd_cmds_B3E1', 0xB497: 'lcd_cmds_B497', 0xB54D: 'lcd_cmds_B54D', 0xB5D6: 'lcd_cmds_B5D6', 0xB665: 'lcd_cmds_B665', 0xB6CD: 'lcd_cmds_B6CD', 0xB0B7: 'lcd_cmds_B0B7', 0xB158: 'lcd_cmds_B158', 0xB1F3: 'lcd_cmds_B1F3', 0xAC55: 'lcd_cmds_AC55', 0xACD5: 'lcd_cmds_ACD5', 0xAD57: 'lcd_cmds_AD57', 0xADCF: 'lcd_cmds_ADCF'})
NAMES.update({0xA4DE: 'lcd_run_cmd_list', 0xA527: 'lcd_cmds_fmt0_fe_separated', 0xA545: 'lcd_cmds_fmt1_reg16', 0xA578: 'lcd_cmds_fmt2_reg8', 0xA5A2: 'lcd_cmds_fmt3_raw16'})
RAMV = {0x00F8: 'lcd_cmd_ptr', 0x0114: 'lcd_cmd_format', 0x0110: 'lcd_id0', 0x0111: 'lcd_id1', 0x0112: 'lcd_id2', 0x0116: 'panel_type'}
