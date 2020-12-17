# External Tools

chmod -R 0755 $MODPATH/common/addon/External-Tools
$IS64BIT && [ -d $MODPATH/common/addon/External-Tools/tools/$ARCH ] && cp -af $MODPATH/common/addon/External-Tools/tools/$ARCH/* $MODPATH/common/addon/External-Tools/tools/$ARCH32
[ -d $MODPATH/common/addon/External-Tools/tools/other ] && cp -af $MODPATH/common/addon/External-Tools/tools/other/* $MODPATH/common/addon/External-Tools/tools/$ARCH32
export PATH=$MODPATH/common/addon/External-Tools/tools/$ARCH32:$PATH
for j in $(/data/adb/magisk/busybox --list); do
  [ -f $MODPATH/common/addon/External-Tools/tools/$ARCH32/$j ] && alias $j="$MODPATH/common/addon/External-Tools/tools/$ARCH32/$j"
done
