SKIPUNZIP=1

# Script inspired by skittles9823's QuickSwitch

# Mod display
ui_print "    ___     _  _ __ ____ _  _  __  __      _  _  __ ____ "
ui_print "   / __)___/ )( (  / ___/ )( \\/ _\\(  )    ( \\/ )/  (    \\"
ui_print "  ( (_ (___\\ \\/ /)(\\___ ) \\/ /    / (_/\\  / \\/ (  O ) D ("
ui_print "   \\___/    \\__/(__(____\\____\\_/\\_\\____/  \\_)(_/\\__(____/"
ui_print " "

set -x

# API minimum
if [ $API -lt "28" ]; then
  abort "  G-Visual Mod only work on Android Pie 9+ only"
fi

# OS used
MIUI=$(grep_prop ro.miui.ui.version.name)
OOS=$(grep_prop ro.oxygen.version*)
# OS incompatiblity
if [ $MIUI ]; then
	MIUIVERCODE=$(echo $MIUI | sed 's/[^0-9]*//g')
	[ $MIUIVERCODE -ge 12 ] || abort "  Only supported on MIUI 12 and higher!"
fi

# Extract needed module and its permissions
ui_print "Extracting module..."
unzip -o $ZIPFILE mods/* system/* common/* module.prop uninstall.sh mod-util.sh gvm -d ${MODPATH} >&2
chmod +x ${MODPATH}/common/addon/*
chmod +x ${MODPATH}/common/addon/aapt/*

# Define bin location
[ -d /system/xbin ] && BINPATH=xbin || BINPATH=bin
mkdir -p ${MODPATH}/system/${BINPATH}
mv -f ${MODPATH}/gvm ${MODPATH}/system/${BINPATH}/gvm

# Make sure no leftover
rm -rf /data/adb/gvisualmod/mods
rm -rf /data/adb/gvisualmod/module.prop
rm -rf /data/resource-cache/overlays.list
find /data/resource-cache/ -type f \( -name *Gestural* -o -name *Gesture* -o -name *G-* \) \
	-exec rm -rf {} \;

# Define which AAPT to use
[ "$(${MODPATH}/common/addon/aapt/aaptx86 v)" ] && AAPT=aaptx86
[ "$(${MODPATH}/common/addon/aapt/aapt v)" ] && AAPT=aapt
[ "$(${MODPATH}/common/addon/aapt/aapt64 v)" ] && AAPT=aapt64
cp -af ${MODPATH}/common/addon/aapt/${AAPT} ${MODPATH}/system/${BINPATH}/aapt
cp -af ${MODPATH}/common/addon/zip ${MODPATH}/system/${BINPATH}/zip
cp -af ${MODPATH}/common/addon/zipsigner ${MODPATH}/system/${BINPATH}/zipsigner
cp -af ${MODPATH}/common/addon/zipsigner-3.0-dexed.jar ${MODPATH}/system/${BINPATH}/zipsigner-3.0-dexed.jar

rm -rf "${MODPATH}/common/addon"

NOTICE="
- Usage:
\n>>>>>>>> Install terminal emulator
\n>>>>>>>> Install busybox (optional)
\n>>>>>>>> Reboot
\n>>>>>>>> Type [gvm] on your terminal
\n>>>>>>>> (You might have to type [su] before [gvm])
\n>>>>>>>> (There may be a problem with Termux)
"
echo -e $NOTICE

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm ${MODPATH}/system/${BINPATH}/aapt 0 2000 0755
set_perm ${MODPATH}/system/${BINPATH}/gvm 0 2000 0777
set_perm ${MODPATH}/system/${BINPATH}/zip 0 0 0755
set_perm ${MODPATH}/system/${BINPATH}/zipsigner 0 0 0755
set_perm ${MODPATH}/system/${BINPATH}/zipsigner-3.0-dexed.jar 0 0 0644
