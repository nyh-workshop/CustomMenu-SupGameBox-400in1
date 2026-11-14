# music/ — your own MIDI songs and sound effects in the original Sup 400-in-1 menus

For the **custom multicart** (`make rom`) you only edit `custom/music/music.txt`: the English list gets the 400-in-1's own
driver and your song there (`rombuilder/README.md`, "Music"). This folder is the tool behind it, and it also changes the
music of the **original** menus (Chinese menu, language select) in a copy of the stripped image (or `ROM=` any image).

```
make midi-info SRC=song.mid                       # channels of a MIDI file and the default voice mapping
make music CN_SONG=a.mid CN_OPT="drums=simple" LS_SONG=b.mid CN_CURSOR=c.txt EN_BEEP=d.txt LS_CHIME=e.txt [OUT=my.bin] [WAV=1]
make music-preview SRC=song.mid [MENU=cn|ls] [OPTS="drums=simple"]   # build/music_preview/*.wav, nothing written
make music-export [WAV=1]                          # the original songs and effects -> music/export/ (NSF, raw, listings, WAV)
make music-test                                    # self-test: MIDI -> driver -> both menus (music/selftest.py)
```

`menu_music.py` converts a MIDI file into the menu sound driver's own format and writes it into a copy of the ROM. It can
also replace the three menu sound effects. Needs only Python 3; Pillow is not needed.

```
python3 music/menu_music.py info SONG.mid                      # what is in the MIDI file, and the default channel mapping

python3 music/menu_music.py build ROM.bin -o NEW.bin \
       --cn-song chinese_menu.mid  --cn-opt drums=simple \
       --ls-song language_select.mid \
       --cn-cursor cursor.txt  --en-beep beep.txt  --ls-chime chime.txt \
       --preview previews/                              # optional WAV previews
```

Every argument is optional, so you can replace just one thing. `ROM.bin` is the 512 KiB dump or a larger image with the same
first 512 KiB. The input file is never changed.

| Option | Replaces | Where it is heard |
|---|---|---|
| `--cn-song` | Chinese menu music | Chinese game list |
| `--ls-song` | language-select music | language select (the first screen) |
| `--cn-cursor` | sound effect #4 of the driver | moving the cursor in the Chinese list |
| `--en-beep` | `sfx_beep` (`$A28A`) | moving the cursor in the English list |
| `--ls-chime` | `langsel_click_sfx` (`$EA80`) | once, when the language select starts |

The original English menu has no music, so there is no `--en-song`. The custom multicart builder adds the driver to the
English list (`rombuilder/english_sound.py`); there the song comes from `custom/music/music.txt`.

## Preparing the MIDI

The NES has 4 voices: **pulse 1, pulse 2, triangle and noise**. Each plays one note at a time.

* **Choosing the source of each voice yourself.** Run `python3 music/menu_music.py info song.mid` first. It lists every track (`t0`, `t1`, …, in file
  order, as it numbers them) with its MIDI channel, note count, range and how many notes it plays at once, and prints the
  automatic choice as a ready-made options line, for example:
  ```
   track ch   notes  range      mean  poly  name / program
   t1    1    136     55-67     62.5  2     Melody prog 80
   t2    2    128     31-43     37.0  1      prog 33
   t3    3    64      62-67     64.8  2
   t4    10   392     36-49     40.5  3      (drums)
  Automatic mapping: p1 = t1, p2 = t3, tri = t2, noise = t4
    p1=t1 p2=t3 tri=t2 noise=t4 auto=0
  ```
  Edit that line to the tracks you want, e.g. `p1=t2 p2=t1 tri=t3 noise=t4 auto=0`. A value is a track `tN`, a MIDI
  channel `1`-`16`, several joined with `+` (`t2+t5`), or `0` for silence. With `auto=0` the voices you do not name stay
  silent; without it they get the automatic choice, from the tracks you have not used.
* **Automatic choice** (voices you do not name, `auto=1`): MIDI channel 10 goes to noise (drums). Of the busiest other
  channels the lowest goes to the triangle (bass), the busiest of the rest to pulse 1 (melody) and the next to pulse 2.
* **Chords.** A voice plays one note at a time. When its source plays several at once, `pick_p1` / `pick_p2` / `pick_tri`
  say which one it keeps: `high` (default for the pulses), `low` (default for the triangle), `first` (the note held
  longest), `last` (the newest note), or a rank: `1` = highest, `2` = second highest, `-1` = lowest, `-2` = second lowest
  (where there is no note of that rank the voice rests). So one chord track can feed several voices:
  `p1=t1 pick_p1=1  p2=t1 pick_p2=2  tri=t1 pick_tri=-1`.
* **Range.** The pulses go down to C2 (MIDI 36), the triangle to C1 (MIDI 24). Notes outside are moved by octaves
  (`range=fold`, the default) or left out (`range=drop`). `transpose_p1` / `transpose_p2` / `transpose_tri` shift one voice
  by semitones (e.g. `transpose_tri=12` for a bass written low); the build log counts the notes moved or left out.
* **Tempo changes** are followed: times are converted to seconds first. The grid comes from the first tempo.
* **Drums:** GM drum notes map to noise sounds (kick, snare, toms, hi-hats, cymbals) with their own decay and volume.
  Drum notes not in the table get a default sound.

Options (`--cn-opt` / `--ls-opt`, repeat for each one):

| Key | Default | Meaning |
|---|---|---|
| `p1`, `p2`, `tri`, `noise` | auto | the voice's source: track `tN`, MIDI channel 1-16, `a+b`, or 0 (see above) |
| `transpose` | 0 | semitones for all melodic voices |
| `auto` | 1 | 1 = voices you do not name get the automatic choice; 0 = they stay silent |
| `pick_p1`, `pick_p2`, `pick_tri` | high, high, low | which note of a chord the voice keeps: `high`, `low`, `first`, `last`, or a rank `1`, `2`, … / `-1`, `-2`, … |
| `transpose_p1`, `transpose_p2`, `transpose_tri` | 0 | semitones for one voice (added to `transpose`) |
| `range` | fold | notes outside a voice's range: `fold` = moved by octaves, `drop` = left out |
| `vol`, `vol_p2`, `vol_noise` | 10, 8, 12 | top volume (1-15), scaled by note velocity |
| `duty1`, `duty2` | 2, 1 | pulse duty cycle: 0 = 12.5%, 1 = 25%, 2 = 50%, 3 = 75% |
| `decay` | 0 | pulse notes fade to silence over this many frames (driver envelope 1); 0 = notes sustain |
| `drums` | full | `simple` = one sound level for all hits, 2 bytes per hit instead of up to 6 |
| `ticks16` | auto | driver ticks per 16th note. Auto aims at about 2.4 frames per tick, like the original songs |
| `speed` | 1.0 | play faster (>1) or slower |
| `start`, `end` | - | use only this part of the MIDI, in seconds |
| `loop` | 1 | 1 = the song restarts after its end; 0 = it plays once |

**Space.** The tool reports how many bytes each voice takes, and stops with a message if the song does not fit.

| Menu | Room | Note |
|---|---|---|
| Chinese menu | 8 KiB (bank `$1C`, file 0x38000-0x39FFF) | |
| Language select | several separate areas: 475 + 986 + 826 + 777 + 749 + 386 + 145 bytes | **each voice must fit in one area** |

Typical cost is 2-4 bytes per note.

If a song is too big:
* use `drums=simple`;
* cut it with `end=`;
* simplify a busy voice in the MIDI.

The example 64-second four-voice song takes 2,934 bytes in the Chinese menu, and 1,910 bytes in the language select with `drums=simple`.

## Sound-effect files

Plain text, `key = value`, `#` starts a comment:

```
channel = pulse2        # pulse1, pulse2, triangle or noise
speed   = 2             # frames per step
duty    = 2             # pulse duty 0-3
sweep   = 08            # register 1 (hex). 08 = off; e.g. 8A slides the pitch up, 82 down
steps   = C6:12 E6:10 G6:8 C7:6      # NOTE:VOLUME per step; "-" = same pitch; noise: 0-15 instead of a note
length  = 0             # one-shots only: frames before the sound stops (default 12)
decay   = 0             # one-shots only: use the hardware volume decay (1-15) instead of a fixed volume
```

Note names: `C`, `C#`/`Db` … `B` plus an octave. `C6` is 1047 Hz. A raw 11-bit period can be given as `p1A2`.

* **`--cn-cursor` plays every step.** It uses the driver's own sound-effect format:
  * up to 255 bytes;
  * a silent step is added at the end;
  * all 43 table entries are pointed at the new effect, since the menu only plays #4.

  While the effect plays, the music on that channel is held back. Afterwards the music takes the channel back but keeps the
  effect's pitch until its next note on that channel; the original sound did the same. Put the effect on a voice your song
  uses lightly (pulse 2 by default).
* **`--en-beep` and `--ls-chime` are one-shots.** Only the first step is used: the menu writes 4 register values and the
  sound chip's length counter (`length`) or sweep ends it.
  * The English beep is always on pulse 2.
  * The chime can use any channel; its routine is rewritten in place.

## What the tool changes in the ROM

| What | Chinese menu | Language select |
|---|---|---|
| Song table (song 0 = 4 tracks, record pointer) | `$EFB9`, `$EFBF` | `$FDFD`, `$FE03` |
| Track records + 4 tracks | bank `$1C` 0x38000- (the dormant old driver there is overwritten) | old song area 0x6FE05-0x6FFDF and free `$FF` areas in 0x68000-0x6BFFF |
| Patch code (loop hook + AD fix), 51 bytes | 0x3F726 (`$F726`) | 0x6B46A (`$B46A`) |
| `sound_tick` → `JMP` patch code (if `loop=1`) | 0x3E34A | 0x6EF26 |
| AD handler → `JMP` fix | 0x3E8BF | 0x6F49B |
| Sound effects | table 0x3ED69, effect at 0x3EDBF | - |
| English beep values | 0x7A28B, 0x7A290, 0x7A295, 0x7A29A | |
| Chime routine | | 0x6EA80-0x6EA9F |

**Two additions to the original driver:**
* **AD fix.** A track's position counter is one byte, so a track is split into blocks of up to 250 commands with the
  driver's `AD` command. The original `AD` handler has a bug when its argument is not 0: it overwrites `$D1`, the high byte
  of the pointer it is still reading through, and then reads from zero page. The fix reloads the pointer. The original
  songs are short and never reached this code.
* **Loop hook.** The driver's loop command (`B0`) can't jump back across blocks. With `loop=1`, `sound_tick` instead runs a
  small hook that restarts the song when all 4 tracks have reached their end. This adds a 1-frame gap.

Everything else is the original driver. The credit string `音效制作：王超` and its checksum are untouched.

## How it was checked

All checks used the example files in `examples/`, built into the 512 KiB dump:

* **Every note matches.** Running the driver on the built ROM, every note matches the MIDI after mono reduction, with the
  right pitch class and start time (a constant +1 to 1.5 frames from the driver's header read):
  * Chinese menu, 64-second song: pulse 1 120/120, pulse 2 32/32, triangle 128/128, noise 256/256;
  * language select: 30/30, 32/32, 64/64.

  The songs restart after their length (3,850 vs 3,848 frames; 1,282 vs 1,280).
* **The real menus play it.** Booting the menus from the built ROM in the OneBus emulator, the APU writes are identical to the
  driver run: Chinese menu 3,000/3,000 writes; language select 2,000/2,000 writes, chime included. That proves bank `$1C` is
  mapped where the driver reads it. Pressing Down plays the new cursor effect (Chinese) and the new beep (English).
* **Nothing else changes.** The Chinese menu screen is pixel-identical to the original. A beep-only build changes exactly
  the 4 beep bytes.
* **The other options work.** `loop=0` stops after the last note, `decay=` fades the notes, and a song that is too big is refused.
* **Not run on the handheld.** Your real-hardware image applies the opcode bit swap to a few instructions. The patch code here
  is plain 6502 like the rest of the menu code, but test in EmuVT/FCEUX and then on the handheld before relying on it.

The previews (`--preview`) come from the same driver run, played through a simple APU model. They are good for checking notes
and timing, not exact tone.

## Files

* `menu_music.py`: the tool.
* `sndlib.py`: the driver player / APU renderer (needed for `--preview` and the checks; it uses the OneBus model
  `../rombuilder/emu.py` and `../tools/op6502.py`).
* `selftest.py`: `make music-test` (the checks below, plus the English-list copy of the driver against the original).
* `examples/`: two test MIDI files (an arrangement of *Ode to Joy*: format 1 with a conductor track and chords; format 0 at
  90 BPM) and the three effect files used above.
* `checks/verify_song.py ROM CN.mid LS.mid`: note-by-note comparison.
* `checks/menu_emu_check.py ROM`: boots the real menus and compares their APU writes.
