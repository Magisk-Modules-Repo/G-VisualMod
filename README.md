<h1 align="center">G-Visual Mod</h1>

<div align="center">
  <img src="https://img.shields.io/badge/Version-v4.1-green.svg?longCache=true&style=popout-round"
  alt="Version" />
</div>

![](https://i.imgur.com/B5XZBfZ.png)

## Compatibility
  - Magisk 20+
  - Android Pie (9) and higher
  - Android Q (10) & Android R (11) for Pill Gesture Mod
  
## Known supported ROMs
  - AOSP and Custom ROMs
  - MIUI 12 and higher
  - OxygenOS
  - OneUI (weak reports)

## Known Issue
- Immersive mode and Pill Transparency wont work on OxygenOS!
- Immersive mode shows white pill on some apps in dark theme!

## What this module do
### UI Radius Mod
- Change UI Roundyness

### StatusBar & Notification Mod
- Change StatusBar height
- Change StatusBar padding
- Enable Fullscreen apps (Notchkiller)
- Change notification side padding
- MIUI StatusBar bottom padding fix

### Pill Gesture Mods
- Change pill thickness and/or width
- Change pill color
- Change pill transparency
- Immersive mode 
- Fullscreen mode
- Reduce bottom keyboard space

## How To Install
- Flash the zip using Magisk (No working guarantee on recovery)
- Install terminal emulator (There may be a problem with Termux)
- Install busybox (optional)
- Reboot
- Type [gvm] on your terminal (You might have to type [su] before [gvm])

## Credits
- <a href="https://github.com/Zackptg5">Zackptg5</a> for MMT-Ex template (old template).
- <a href="https://github.com/veez21">veez21</a> for Terminal Emulator Magisk Module template.
- <a href="https://github.com/RadekBledowski">RKBDI</a> for nospacing module.
- <a href="https://github.com/Didgeridoohan">Didgeridoohan</a> for script inspiration.
- <a href="https://github.com/topjohnwu">topjohnwu</a> for entire Magisk universe.
- <a href="https://github.com/skittles9823">skittles9823</a> for helping me.
- All the testers.

Also you should check <a href="https://github.com/DanGLES3">DanGLES3</a>'s <a href="https://github.com/Magisk-Modules-Repo/HideNavBar">Fullscreen/Immersive module</a>. Since our installation methods are really different, there could be some conflict if you combine this module especially the pill gesture background, because on how my module control the height of the keyboard bottom based on pill gesture height. Otherwise, his module is perfect if you want only fullscreen/immersive mode.

## Need to contact me?
- <a href="https://t.me/tzlounge">Support group on Telegram</a>.
- <a href="https://forum.xda-developers.com/t/module-g-visual-mod-systemlessy-customize-your-androids-visual.4225571/">Support thread on XDA</a>.

## Changelog
### v4.1
  - Fixed: Pill mods won't install
  - Added: Several default presets
  - Adjustment: Reduce bottom keyboard space no longer need additional module
  - Adjustment: Bottom margin pill
  - Some backend adjustments

### v4.0
  - Switch to terminal installation
  - UI Radius now support MIUI
  - Pill Gesture Length divided to Portrait and Landscape
  -	Added StatusBar padding
  - Added Notification side padding
  - Fix immersive on various dpi phones
  - Will always restore your last option
  - You can input custom values now hehe
  
### v3.1.1
  - Fixed: Pill color on MIUI 12.5
  - Bottom margin fix currently uncompatible on MIUI 12.5

### v3.1
  - Fixed: UI radius doesn't apply on some ROMs
  - Added: rounded pip (thx to DanGLES3 for pointing it out)
  - Added: additional UI radius configs
  - Added: lot of color options
  - Tiny cleanups
  
### v3.0.3
  - Fixed: color not changing on light mode (dark mode still buggy)
  - Fixed: rounded corner installation overlap
  
### v3.0.2
  - Fixed: random removed selection bug
  - Fixed: immersive issues

### v3.0.1
  - Move "keyboard bottom height" option to a single mod
  - Increase time on selection
  - Nicer gaps
  - Reduced confusion on installing

### v3.0 (changelogs also comes from my older PGM module)
  - Updated: MMT-Ex Template
  - Updated: Volume Key Selector (MMT-Ex Addon)
  - Android 11+ support
  - Completely rewrite script
  - Added: AAPT to build overlays
  - Added: color options
  - Added: DualTone mode
  - Added: DualColor mode
  - Added: transparency options
  - Added: 3dp thickness option
  - Added: 180dp and 200dp width options
  - Added: MIUI template
  - Added: pill width landscape option
  - Added: radius iconshape option (NOT ALL ROM SUPPORTED)
  - Added: main menu for ez manage mods
  - Added: mods checking to preview selected mods
  - Added: remove selected mods before install
  - Added: keyboard bottom bar height adjusted based on pill thickness
  - Fixed: Immersive on MIUI and AOSP
  - Fixed: Lag and heating issue (Possibly)
  - Fixed: bugs a lot

### v2.1.1
  - Fixed URM when QS icon shape changed
  - Fixed MIUI detector bug
  - Added Immersive option (10's Pill Gesture)
  - Added Invisible Mode (10's Pill Gesture)
  - Added Dot Mode (10's Pill Gesture)

### v2.0.1
  - Fix for Pie roms

### v2.0
  - Added 10's Pill Gesture mod (IOS adjusted)
  - Added support for Android 10
  - Brand new MMT-EX template thx to Zackptg5

### v1.5
  - Fixed overlays not installing
  - Fixed notification dot bug
  - Vol button improvement

### v1.4.2
  - Add UI Radius Mod volume capability

### v1.4
  - Cleanups
  - UI Radius Mod improvement on some dialogs
  - Fix UI Radius Mod forced installation
  - Update NotchKiller, thx to zigafide

### v1.3
  - Added NotchKiller
  - Fix UI Radius Mod forced installation

### v1.2
  - Bug fixes
  - Update tutorials
  - Cleanoops

### v1.0
  - Initial Release
