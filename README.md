<h1 align="center">G-Visual Mod</h1>

<div align="center">
  <strong>Various visual mods for Android.
</div>

## What's Inside?
- UI Radius Mod
  - Change your UI radius.
- StatusBar Height Mod
  - Change your StatusBar Height like having a notch.
- NotchKiller
  - Override notch, always full screen.
  
  How to activate NotchKiller mod:
  - Go to developer option
  - Search Display Cutout
  - Choose NotchKiller
  - Done!
  
## Compatibility
- Magisk 18.0 +
- Tested on Android 9.0 (Pie), Android 8.x (Oreo) can try and report to me.
- AOSP based rom, OEM Rom that is not based on AOSP (e.g MIUI oreo) will not work!

Reports (Based on tester):
- MIUI Pie (Xiaomi) work! (SBH)
- OxygenOS (OnePlus) work!
- OneUI (Samsung) work!

## Screenshots
- On my <a href="https://t.me/tzupdates">Channel</a>.

## How To Install
- Execute the zip using Magisk.
- You will be prompted to test vol keys to choose options later. (If you have some problem with vol keys please look at next section)
- Choose mods you want to be installed by choosing vol key.
- Done.

## How To Install (Alternatives)
- Rename the module zip depends on what you need:

  UI Radius Mod, urm[radius].zip
  - Radius: r(RectangUI), m(Medium), l(Large)

  StatusBar Mod, sbh[height].zip
  - Height: m(Medium), l(Large), xl(eXtra Large)

  NotchKiller, nk[opt].zip
  - Options: y(Yes), n(No)
  
Or...

- Manual Installation:
  - Extract the module.zip;
  - Copy overlay that you need from apk folder to /system/vendor/overlay,
  - CHMOD 664.

## How To Uninstall (PLEASE READ TO AVOID BOOTLOOP CHANCES)
- Reinstall my module.

Or...

- If you stuck on bootloop:
  - Go to your recovery,
  - Clear Cache and Dalvik
  - Go to file manager,
  - Go to /data/resource-cache,
  - Delete overlay.list;
  - Done.
  - If still bootloop, just force restart by holding power button.

## Changelog
- v1.5
  - Fixed overlays not installing,
  - Fixed notification dot bug,
  - Vol button improvement.
- v1.4
  - Cleanups,
  - UI Radius Mod improvement on some dialogs,
  - Fix UI Radius Mod force installation,
  - Added NotchKiller, thx to <a href="https://github.com/zigafide">zigafide</a>.
- v1.2
  - Bug fixes,
  - Update tutorials,
  - Cleanoops,
- v1.1
  - Hotfixes,
  - Change SBH30 to 34.
- v1.0
  - Initial Release.

## Credits
- <a href="https://github.com/Zackptg5">Zackptg5</a> for Unity template.
- <a href="https://github.com/JohnFawkes">JohnFawkes</a> for helping me.
- <a href="https://github.com/topjohnwu">topjohnwu</a> for entire Magisk universe.
- Me for first time using linux and doing this all coding stuff lol.
- Telegram friends.
- Allah SWT for letting me do this in my part of lifetime.

## Need to contact me?
- My <a href="https://t.me/Gnonymous7">Telegram</a>.
