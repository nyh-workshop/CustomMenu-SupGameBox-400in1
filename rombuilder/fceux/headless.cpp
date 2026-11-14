// Headless driver for the FCEUX core (FCEUX is GPL-2.0-or-later; this file is linked with it and is under the same
// licence).  rombuilder/fceux/build.sh fetches FCEUX at a fixed commit and builds its core with this file - no SDL / Qt.
//   fceux_headless ROM.nes FRAMES [--press F0-F1:BUTTONS]... [--shot F:out.ppm]... [--nt F:out.bin]... [--ram F:out.bin]...
// BUTTONS: any of A B SELECT START UP DOWN LEFT RIGHT joined with '+'.  Pad 1 only.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <string>
#include <vector>
#include "types.h"
#include "fceu.h"
#include "driver.h"
#include "git.h"
#include "ppu.h"
#include "emufile.h"

int dendy = 0, pal_emulation = 0; bool swapDuty = false;
bool turbo = false;
int closeFinishedMovie = 0;
static uint8 pal[256][3];

void FCEUD_SetPalette(uint8 i, uint8 r, uint8 g, uint8 b) { pal[i][0] = r; pal[i][1] = g; pal[i][2] = b; }
void FCEUD_GetPalette(uint8 i, uint8 *r, uint8 *g, uint8 *b) { *r = pal[i][0]; *g = pal[i][1]; *b = pal[i][2]; }
void FCEUD_PrintError(const char *s) { fprintf(stderr, "fceux error: %s\n", s); }
void FCEUD_Message(const char *s) { fprintf(stderr, "fceux: %s", s); }
FILE *FCEUD_UTF8fopen(const char *fn, const char *mode) { return fopen(fn, mode); }
EMUFILE_FILE *FCEUD_UTF8_fstream(const char *n, const char *m) {
    std::string mode = m; if (mode.find('b') == std::string::npos) mode += "b";
    EMUFILE_FILE *f = new EMUFILE_FILE(n, mode.c_str());
    if (f->fail()) { delete f; return 0; } return f; }
FCEUFILE *FCEUD_OpenArchiveIndex(ArchiveScanRecord &, std::string &, int) { return 0; }
FCEUFILE *FCEUD_OpenArchiveIndex(ArchiveScanRecord &, std::string &, int, int *) { return 0; }
FCEUFILE *FCEUD_OpenArchive(ArchiveScanRecord &, std::string &, std::string *) { return 0; }
FCEUFILE *FCEUD_OpenArchive(ArchiveScanRecord &, std::string &, std::string *, int *) { return 0; }
ArchiveScanRecord FCEUD_ScanArchive(std::string) { return ArchiveScanRecord(); }
const char *FCEUD_GetCompilerString() { return "g++"; }
int FCEUD_SendData(void *, uint32) { return 0; }
int FCEUD_RecvData(void *, uint32) { return 0; }
void FCEUD_NetplayText(uint8 *) {}
void FCEUD_NetworkClose(void) {}
void FCEUD_SoundToggle(void) {}
void FCEUD_SoundVolumeAdjust(int) {}
void FCEUD_SaveStateAs(void) {}
void FCEUD_LoadStateFrom(void) {}
void FCEUD_SetInput(bool, bool, ESI, ESI, ESIFC) {}
void FCEUD_MovieRecordTo(void) {}
void FCEUD_MovieReplayFrom(void) {}
void FCEUD_LuaRunFrom(void) {}
bool FCEUD_ShouldDrawInputAids() { return false; }
void FCEUD_OnCloseGame(void) {}
void FCEUD_AviRecordTo(void) {}
void FCEUD_AviStop(void) {}
void FCEUD_SetEmulationSpeed(int) {}
void FCEUD_TurboOn(void) {}
void FCEUD_TurboOff(void) {}
void FCEUD_TurboToggle(void) {}
int FCEUD_ShowStatusIcon(void) { return 0; }
void FCEUD_ToggleStatusIcon(void) {}
void FCEUD_HideMenuToggle(void) {}
void FCEUD_CmdOpen(void) {}
void FCEUD_DebugBreakpoint(int) {}
void FCEUD_TraceInstruction(uint8 *, int) {}
void FCEUD_FlushTrace() {}
void FCEUD_UpdateNTView(int, bool) {}
void FCEUD_UpdatePPUView(int, int) {}
bool FCEUD_PauseAfterPlayback() { return false; }
void FCEUD_VideoChanged() {}
bool FCEUD_AviEnableHUDrecording() { return false; }
void FCEUD_AviDisableHUDrecording() {}
bool FCEUD_AviDisableMovieMessages() { return true; }
bool FCEUD_AviIsRecording() { return false; }
void FCEUD_AviRecordFrame() {}
void FCEUI_UseInputPreset(int) {}
const char *FCEUD_GetFrontendName() { return "headless"; }

static void save_ppm(const char *path, uint8 *xb) {
    FILE *f = fopen(path, "wb"); fprintf(f, "P6\n256 240\n255\n");
    for (int i = 0; i < 256 * 240; i++) fwrite(pal[xb[i]], 1, 3, f);
    fclose(f);
}

static uint32 parse_buttons(const char *s) {
    uint32 v = 0; std::string t = s; size_t p = 0;
    while (p <= t.size()) {
        size_t q = t.find('+', p); if (q == std::string::npos) q = t.size();
        std::string b = t.substr(p, q - p);
        if (b == "A") v |= 1; else if (b == "B") v |= 2; else if (b == "SELECT") v |= 4; else if (b == "START") v |= 8;
        else if (b == "UP") v |= 16; else if (b == "DOWN") v |= 32; else if (b == "LEFT") v |= 64; else if (b == "RIGHT") v |= 128;
        p = q + 1;
    }
    return v;
}

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: %s ROM.nes FRAMES [--press F0-F1:BUTTONS] [--shot F:out.ppm] [--nt F:out.bin] [--ram F:out.bin]\n", argv[0]); return 2; }
    struct Press { int a, b; uint32 v; }; std::vector<Press> presses;
    struct Dump { int f; int kind; std::string path; }; std::vector<Dump> dumps;
    for (int i = 3; i + 1 < argc; i += 2) {
        std::string k = argv[i], v = argv[i + 1];
        if (k == "--press") { int a, b; char btn[128]; if (sscanf(v.c_str(), "%d-%d:%127s", &a, &b, btn) == 3) presses.push_back({a, b, parse_buttons(btn)}); }
        else { int f; size_t c = v.find(':'); f = atoi(v.substr(0, c).c_str());
               dumps.push_back({f, k == "--shot" ? 0 : k == "--nt" ? 1 : 2, v.substr(c + 1)}); }
    }
    if (!FCEUI_Initialize()) { fprintf(stderr, "init failed\n"); return 1; }
    FCEUI_SetBaseDirectory(".");
    FCEUI_SetVidSystem(0);
    FCEUGI *gi = FCEUI_LoadGame(argv[1], 1, true);
    if (!gi) { fprintf(stderr, "could not load %s\n", argv[1]); return 1; }
    static uint32 joy = 0;
    FCEUI_SetInput(0, SI_GAMEPAD, &joy, 0);
    FCEUI_SetInput(1, SI_GAMEPAD, &joy, 0);
    int frames = atoi(argv[2]);
    for (int fr = 0; fr < frames; fr++) {
        joy = 0;
        for (auto &p : presses) if (fr >= p.a && fr <= p.b) joy |= p.v;
        uint8 *gfx = 0; int32 *snd = 0; int32 ssize = 0;
        FCEUI_Emulate(&gfx, &snd, &ssize, 0);
        for (auto &d : dumps) if (d.f == fr) {
            if (d.kind == 0) save_ppm(d.path.c_str(), gfx);
            else if (d.kind == 1) { FILE *f = fopen(d.path.c_str(), "wb"); for (int k = 0; k < 4; k++) fwrite(vnapage[k], 1, 0x400, f); fclose(f); }
            else { FILE *f = fopen(d.path.c_str(), "wb"); fwrite(RAM, 1, 0x800, f); fclose(f); }
        }
    }
    FCEUI_CloseGame();
    return 0;
}

// ---- more driver-side symbols the core references ----
#include <chrono>
int eoptions = 0;
int KillFCEUXonFrame = 0;
bool paldeemphswap = 0;
bool fceu_file_exists(const char *p) { FILE *f = fopen(p, "rb"); if (f) { fclose(f); return true; } return false; }
u32 ModernDeemphColorMap(const u8 *src, const u8 *, int) { return 0; }
uint64 FCEUD_GetTime() { return std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
uint64 FCEUD_GetTimeFreq() { return 1000000; }
void RefreshThrottleFPS() {}
bool FCEUI_AviEnableHUDrecording() { return false; }
bool FCEUI_AviDisableMovieMessages() { return true; }
bool FCEUI_AviIsRecording() { return false; }
void FCEUI_AviVideoUpdate(const unsigned char *) {}
unsigned int *GetKeyboard() { static unsigned int k[256]; return k; }
void GetMouseData(unsigned int (&d)[3]) { d[0] = d[1] = d[2] = 0; }
