"""Boot the real menus from a patched ROM in the OneBus emulator and log the APU writes."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'rombuilder'))
import emu as onebus_emu
from emu import OneBus
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import verify_song as V
B = dict(A=0x80, B=0x40, SEL=0x20, START=0x10, UP=8, DOWN=4)
def boot(rom, block):
    m = OneBus(bytes(rom))
    if block == 'cn':
        m.r41[0x0B] = 1; m.r41[7:11] = bytes([0x1C, 0x1D, 0x1E, 0x1F]); m.pc = m.read(0xFFFC) | m.read(0xFFFD) << 8
    elif block == 'en':
        m.r41[0x0B] = 4; m.r41[7:11] = bytes([0x3C, 0x3D, 0x3E, 0x3F]); m.pc = 0xFB7D
    else:
        m.r41[0x0B] = 4; m.r41[7:11] = bytes([0x34, 0x35, 0x36, 0x37]); m.pc = 0xE000
    m.apu = []; m.frame_apu = []
    ow = m.write
    def w(a, v):
        if 0x4000 <= a <= 0x4017: m.frame_apu.append((a, v))
        ow(a, v)
    m.write = w
    return m
def run(m, frames, pad=0):
    out = []
    for f in range(frames):
        m.pad = pad; m.frame_apu = []; m.run_frame(); out.append(m.frame_apu)
    return out
if __name__ == '__main__':
    rom = bytearray(open(sys.argv[1], 'rb').read())
    # 1. Chinese menu: does the real menu play the new song? compare with the harness stream (driver writes only)
    m = boot(rom, 'cn'); fr = run(m, 900)
    ref = V.apu_stream(rom, 'cn', 900)
    flat = lambda F: [w for f in F for w in f if w[0] not in (0x4009, 0x400D, 0x4014, 0x4016, 0x4017)]
    a = [w for w in flat(fr)]; b = flat(ref)
    # skip the menu's own start-up writes before sound_init (hw_init writes $4015)
    i0 = a.index((0x4015, 0x00), 1) if (0x4015, 0) in a[1:] else 0
    n = min(len(a) - i0, len(b), 3000)
    same = sum(1 for k in range(n) if a[i0 + k] == b[k])
    print('Chinese menu boot: %d APU writes compared with the harness stream, %d identical' % (n, same))
    # 2. cursor sound: press Down in the list, look at pulse-2 writes
    for _ in range(4): fr += run(m, 1)
    fr2 = run(m, 6, B['DOWN']) + run(m, 30)
    p2 = [(i, w) for i, f in enumerate(fr2) for w in f if 0x4004 <= w[0] <= 0x4007]
    print('Chinese cursor (Down): pulse-2 writes', ['%04X=%02X@%d' % (w[0], w[1], i) for i, w in p2[:14]])
    # 3. English menu: boot, press Down, look at the beep
    m = boot(rom, 'en'); run(m, 240); fr3 = run(m, 6, B['DOWN']) + run(m, 10)
    print('English beep (Down):', ['%04X=%02X' % w for f in fr3 for w in f if 0x4004 <= w[0] <= 0x4007])
    # 4. language select: boot the screen, check the chime and the song
    m = boot(rom, 'ls'); fr4 = run(m, 600)
    w4 = [w for f in fr4 for w in f]
    print('Language select: first APU writes', ['%04X=%02X' % w for w in w4[:8]])
    b4 = flat(V.apu_stream(rom, 'ls', 600))
    a4 = [w for w in w4 if w[0] not in (0x4009, 0x400D, 0x4014, 0x4016, 0x4017)]
    j = next(k for k in range(len(a4)) if a4[k:k + 5] == b4[:5])
    n = min(len(a4) - j, len(b4), 2000)
    print('Language select song: %d writes compared, %d identical (offset %d)' % (n, sum(1 for k in range(n) if a4[j + k] == b4[k]), j))
