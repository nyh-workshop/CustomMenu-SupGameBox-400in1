"""Compare two binaries; print the first differences.  Works on Windows too.
Usage: cmpbin.py built.bin original.bin [file_offset_of_byte0_hex [cpu_addr_of_byte0_hex]]"""
import sys
a, b = (open(p, 'rb').read() for p in sys.argv[1:3])
fbase = int(sys.argv[3], 16) if len(sys.argv) > 3 else 0
cbase = int(sys.argv[4], 16) if len(sys.argv) > 4 else 0
diff = [i for i in range(min(len(a), len(b))) if a[i] != b[i]]
if len(a) == len(b) and not diff:
    print('identical (%d bytes)' % len(a)); sys.exit(0)
print('sizes %d / %d, %d differing bytes' % (len(a), len(b), len(diff)))
for i in diff[:16]:
    print('  file 0x%05X (CPU $%04X): built %02X  original %02X' % (fbase + i, (cbase + i) & 0xFFFF, a[i], b[i]))
sys.exit(1)
