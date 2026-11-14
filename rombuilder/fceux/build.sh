#!/bin/sh
# Build a headless FCEUX (the real FCEUX core, from its own sources, plus headless.cpp) for the ROM checks:
#   sh rombuilder/fceux/build.sh            -> rombuilder/fceux/bin/fceux_headless
# Needs git, g++ and zlib (Linux, or MSYS2 / Cygwin on Windows).  FCEUX is fetched at a fixed commit into
# rombuilder/fceux/src/ (GPL-2.0-or-later, https://github.com/TASEmulators/fceux).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
COMMIT=ffc23f0889b51631e176e6316771c29fa69210f4
SRC="$HERE/src/fceux"
if [ ! -d "$SRC/.git" ]; then
  mkdir -p "$HERE/src"
  git clone --filter=blob:none https://github.com/TASEmulators/fceux.git "$SRC"
fi
git -C "$SRC" checkout -q "$COMMIT"
F="$SRC/src"
OBJ="$HERE/obj"; mkdir -p "$OBJ" "$HERE/bin"
CXXFLAGS="-O2 -w -fpermissive -DHAVE_ASPRINTF -DPUBLIC_RELEASE=1 -I$F -I$F/drivers"
# the core source list of FCEUX's own CMakeLists.txt (minus the GUI-side backtrace helper), the boards, and the
# zip / OPLL helpers the core links against
SOURCES=$(sed -n '/set(SRC_CORE/,/^)/p' "$F/CMakeLists.txt" | grep -o 'CMAKE_CURRENT_SOURCE_DIR}/[^ ]*\.cpp' \
          | sed 's|CMAKE_CURRENT_SOURCE_DIR}/||' | grep -v 'utils/backward.cpp')
SOURCES="$SOURCES utils/unzip.cpp utils/ioapi.cpp"
# fceu.cpp includes the SDL driver header only for a few declarations: compile a copy with driver.h instead
sed 's|#include "drivers/sdl/sdl.h"|#include "driver.h"\nextern int dendy; extern int pal_emulation; extern bool swapDuty;|' \
    "$F/fceu.cpp" > "$OBJ/fceu_headless.cpp"
pids=""; n=0
for s in $SOURCES; do
  [ "$s" = "fceu.cpp" ] && continue
  o="$OBJ/$(echo "$s" | tr '/' '_' | sed 's/\.cpp$/.o/')"
  if [ ! -f "$o" ] || [ "$F/$s" -nt "$o" ]; then g++ $CXXFLAGS -c "$F/$s" -o "$o" & n=$((n+1)); fi
  if [ $n -ge 8 ]; then wait; n=0; fi
done
wait
g++ $CXXFLAGS -c "$OBJ/fceu_headless.cpp" -o "$OBJ/fceu.o"
gcc -O2 -w -I"$F" -c "$F/boards/emu2413.c" -o "$OBJ/emu2413.o"
g++ $CXXFLAGS -c "$HERE/headless.cpp" -o "$OBJ/headless_main.o"
g++ -o "$HERE/bin/fceux_headless" "$OBJ"/*.o -lz -lpthread
echo "built $HERE/bin/fceux_headless (FCEUX $COMMIT)"
