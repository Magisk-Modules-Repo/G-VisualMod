<h1 align="center">G-Visual Mod</h1>

<div align="center">
  <img src="https://img.shields.io/badge/Version-v3.0.3-green.svg?longCache=true&style=popout-round"
  alt="Version" />
</div>

<div align="center">
 <strong>Customize your Android's Visual!</strong>
</div>

![](https://i.imgur.com/pZPi8qc.jpg)

## Compatibility
### Magisk Requirement
  - Magisk 20+
### API Requirement
  - Android Pie (9) and higher
  - Android Q (10) & Android R (11) for PillGesture
### ROM Requirement
  - AOSP and Custom ROMs
  - MIUI 12
  - OxygenOS
  - OneUI (weak reports)

## Known Issue
- Immersive mode and Pill Transparency wont work on OxygenOS!
- Immersive mode shows white pill on some apps in dark theme!
- UI Radius Mod wont work on MIUI 12!
- Not all rom support UI radius iconshape option! (Read at the bottom of this README!)

## What this module do
### UI Radius Mod
- Change UI Roundyness

### Pill Gesture Mods
- Change pill thickness and/or width
- Change pill color (DualTone & DualColor available)
- Change pill transparency (with Immersive mode enabled)
- Enable Immersive or Fullscreen mode

### Statusbar Mod
- Change statusbar height
- Fix MIUI bottom margin

### NotchKiller
- Enable NotchKiller (Fullscreen apps)

## How To Install
- Execute the zip using Magisk (No working guarantee on recovery)
- If you have some problem with vol keys please look at next section
- Choose mods you want to be installed by choosing vol key

## How To Install (Alternatives)
Rename the module zip depends on what you need.

You can combine multiple options per-mod.

Change UI radius
```
Usage:	[radius],[isr].zip
	radius:
	- Small					: rsmall
	- Medium				: rmedium
	- Large					: rlarge
	isr (iconshape fix)
	- Yes					: isr
```
Example: rlarge,isr.zip, that means modify UI radius to large and fix iconshape.


Change pill shape
```
Usage:	[template],[mode].zip
	template:
	- AOSP					: aosp
	- OxygenOS				: oos
	- MIUI					: miui
	- IOS					: ios
	
	mode:
	- Immersive				: imrs
	- Fullscreen			: full (DO NOT combine with any other options!)
```
Example: oos,imrs.zip, that means modify pill shape same as OxygenOS with immersive mode enabled.


Change pill color
```
Usage:	[color],[dualtone].zip
	color:
	Default AOSP's accents
	- Default (White'nblack): dflt
	- Amethyst				: amty
	- Aquamarine			: aqmr
	- Carbon				: crbn
	- Cinnamon				: cnmn
	- Green					: gren
	- Ocean					: ocea
	- Orchid				: orcd
	- Palette				: pltt
	- Purple				: prpl
	- Sand					: sand
	- Space					: spce
	- Tangerine				: tgrn
	
	OEMs accents
	- MIUI 12 Blue			: mibl
	- Pixel Blue			: pxbl
	- OnePlus Red			: oprd
	dualtone (Pill Gesture will slighty changes color between light and dark theme):
	- Yes					: dt
```
Example: tgrn,dt.zip, that means modify pill color to tangerine with dual tone enabled.


Change pill transparency
```
Usage:	[transparency].zip
	transparency:
	- 10%			: 10
	- 20%			: 20
	- 30%			: 30
	- 40%			: 40
	- 50%			: 50
	- 60%			: 60
	- 70%			: 70
	- 80%			: 80
	- 90%			: 90
```
Example: 70.zip, that means modify pill transparency to 70%.


Change statusbar height
```
Usage:	[height].zip
	height:
	- Medium			: hmedium
	- Large				: hlarge
	- XLarge			: hxlarge
```
Example: hlarge.zip, that means modify statusbar height to large.


Activate notchkiller
```
Usage:	[mode].zip
	mode:
	- Active		: nck
```
Example: nck.zip, that means activate notchkiller.

## Applying radius to all icon shapes
PLEASE READ!

NOT ALL ROM SUPPORT THIS!

You can try this option and check your iconshapes after.

Workarounds if iconshapes are missing

### 1st solution
Select NO on this option and see if iconshapes are overriding UIRadius.

### 2nd solution
1. Disable this module in magisk manager
2. Reboot
3. Set up your iconshapes, font, accent, etc and apply it
4. Install this module (you can restore other selected mods)
5. Pick radius and select YES on this option
Do not change styles to default, or you have to do this again!

If it still doesn't work, type #iconshapefix on telegram Support Group (@tzlounge), it will guide you to report to your rom maintainer.

## Credits
- <a href="https://github.com/Zackptg5">Zackptg5</a> for MMT-Ex template.
- <a href="https://github.com/topjohnwu">topjohnwu</a> for entire Magisk universe.
- <a href="https://github.com/skittles9823">skittles9823</a> for helping me.
- All the testers.

Also you should check <a href="https://github.com/DanGLES3">DanGLES3</a>'s <a href="https://github.com/Magisk-Modules-Repo/HideNavBar">Fullscreen/Immersive module</a>. Since our installation methods are really different, there could be some conflict if you combine this module especially the pill gesture background, because on how my module control the height of the keyboard bottom based on pill gesture height. Otherwise, his module is perfect if you want only fullscreen/immersive mode.

## Need to contact me?
- <a href="https://t.me/tzlounge">Support Group</a>.

## Changelog
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
