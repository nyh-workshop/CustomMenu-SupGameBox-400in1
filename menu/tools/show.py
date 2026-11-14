import sys, re
lo, hi = int(sys.argv[2],16), int(sys.argv[3],16)
for l in open(sys.argv[1]):
    m = re.search(r'; ([0-9A-F]{4})', l)
    a = int(m.group(1),16) if m else None
    if a is not None: show = lo <= a < hi
    if (a is not None and show) or (a is None and 'show' in dir() and show):
        print(l.rstrip()[:62])
