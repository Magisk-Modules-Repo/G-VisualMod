# Zipname Initiate
if [ $MIUI ]; then
	OIFS=$IFS; IFS=\|
	zo_sbh
	IFS=$OIFS
else
	OIFS=$IFS; IFS=\|
	zo_urm
	zo_sbh
	zo_nk
	zo_pg
	IFS=$OIFS
fi

# Mod Chooser
if [ $MIUI ]; then
	if [ -z $SBH ] ; then
		if [ -z $VKSEL ]; then
			ui_print "  ! Some options not specified in zipname!"
			ui_print "  Using defaults if not specified in zipname!"
			[ -z $SBH ] && SBH=true; SBHM=true
		else
			c_sbh
		fi
	else
	  ui_print "   Options specified in zipname!"
	fi
else
	if [ -z $URM ] || [ -z $SBH ] || [ -z $NK ] || [ -z $PG ]; then
		if [ -z $VKSEL ]; then
			ui_print "  ! Some options not specified in zipname!"
			ui_print "  Using defaults if not specified in zipname!"
			[ -z $URM ] && URM=true; URMM=true
			[ -z $SBH ] && SBH=true; SBHM=true
			[ -z $NK ] && NK=false
			[ -z $PG ] && PG=True; PGIOS=true
		else
			c_urm
			c_sbh
			c_nk
			c_pg
		fi
	else
	  ui_print "   Options specified in zipname!"
	fi
fi

ui_print " "
ui_print " "
ui_print "-  Preparing  -"
ui_print " "
ui_print " "

# Functions to check if dirs is mounted
is_mounted() {
	grep " `readlink -f $1` " /proc/mounts 2>/dev/null
	return $?
}

is_mounted_rw() {
	grep " `readlink -f $1` " /proc/mounts | grep " rw," 2>/dev/null
	return $?
}

mount_rw() {
	mount -o remount,rw $1
	DID_MOUNT_RW=$1
}

unmount_rw() {
	if [ "x$DID_MOUNT_RW" = "x$1" ]; then
		mount -o remount,ro $1
	fi
}

unmount_rw_stepdir(){
  if [ "$MOUNTPRODUCT" ]; then
    is_mounted_rw " /product" || unmount_rw /product
  elif [ "$OEM" ];then
    is_mounted_rw " /oem" && unmount_rw /oem
    is_mounted_rw " /oem/OP" && unmount_rw /oem/OP
  fi
}

setvars(){
	SUFFIX="/overlay/GVM"
	if [ -d "/product/overlay" ]; then
		PRODUCT=true
		# Yay, magisk supports bind mounting /product now
		MAGISK_VER_CODE=$(grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | awk -F = '{ print $2 }')
		if [ $MAGISK_VER_CODE -ge "20000" ]; then
			MOUNTPRODUCT=
			STEPDIR=$MODPATH/system/product$SUFFIX
		else
			if [ $(resetprop ro.build.version.sdk) -ge 29 ]; then
				echo "\nMagisk v20 is required for users on Android 10"
				echo "Please update Magisk and try again."
				exit 1
			fi
			MOUNTPRODUCT=true
			STEPDIR=/product$SUFFIX
			is_mounted " /product" || mount /product
			is_mounted_rw " /product" || mount_rw /product
		fi
	elif [ -d /oem/OP ];then
		OEM=true
		is_mounted " /oem" || mount /oem
		is_mounted_rw " /oem" || mount_rw /oem
		is_mounted " /oem/OP" || mount /oem/OP
		is_mounted_rw " /oem/OP" || mount_rw /oem/OP
		STEPDIR=/oem/OP/OPEN_US/overlay/framework
	else
		PRODUCT=; OEM=; MOUNTPRODUCT=
		STEPDIR=$MODPATH/system/vendor$SUFFIX
	fi
	if [ "$MOUNTPRODUCT" ]; then
		is_mounted " /product" || mount /product
		is_mounted_rw " /product" || mount_rw /product
	elif [ "$OEM" ];then
		is_mounted " /oem" || mount /oem
		is_mounted_rw " /oem" || mount_rw /oem
		is_mounted " /oem/OP" || mount /oem/OP
		is_mounted_rw " /oem/OP" || mount_rw /oem/OP
	fi
}

# Path-to-install locator
while [ ! -d "$STEPDIR" ]; do
    setvars
    mkdir -p $STEPDIR
done

OVPATH=${STEPDIR::-4}
echo "The overlay will be copied to $OVPATH..."


# Mods Aliasing
URMDIR=$MODPATH/mod/GVM-URM
SBHDIR=$MODPATH/mod/GVM-SBH
NKDIR=$MODPATH/mod/GVM-NK
PGDIR=$MODPATH/mod/GVM-PG

ui_print " "
ui_print " "
ui_print "-  Copying files  -"
ui_print " "
ui_print " "

# Copying Files
if $URM; then
	ui_print "-  UI Radius Mod Selected  -"
	mkdir -p $STEPDIR/GVM-URM-1
	mkdir -p $STEPDIR/GVM-URM-2
	mkdir -p $STEPDIR/GVM-URM-3
	if [ $URMM = true ] ; then
		ui_print "-  RoundyUI Medium Selected  -"
		cp -f $URMDIR/GVM-URM_M.apk $STEPDIR/GVM-URM-1
		cp -f $URMDIR/GVM-URM_M2.apk $STEPDIR/GVM-URM-2
	elif [ $URML = true ] ; then
		ui_print "-  RoundyUI Large Selected  -"
		cp -f $URMDIR/GVM-URM_L.apk $STEPDIR/GVM-URM-1
		cp -f $URMDIR/GVM-URM_L2.apk $STEPDIR/GVM-URM-2
	elif [ $URMR = true ] ; then
		ui_print "-  RectangUI Selected  -"
		cp -f $URMDIR/GVM-URM_R.apk $STEPDIR/GVM-URM-1
		cp -f $URMDIR/GVM-URM_R2.apk $STEPDIR/GVM-URM-2
		cp -f $URMDIR/GVM-URM_R3.apk $STEPDIR/GVM-URM-3
	fi
	if [ $URMVM = true ] ; then
		ui_print "-  RoundyUI Medium Vol Selected  -"
		cp -f $URMDIR/GVM-URM_M3.apk $STEPDIR/GVM-URM-3
	elif [ $URMVL = true ] ; then
		ui_print "-  RoundyUI Large Vol Selected  -"
		cp -f $URMDIR/GVM-URM_L3.apk $STEPDIR/GVM-URM-3
	fi
fi

if $SBH; then
	ui_print "-  StatusBar Height Selected  -"
	mkdir -p $STEPDIR/GVM-SBH
	if [ $SBHM = true ] ; then
		ui_print "-  StatusBar Height Medium Selected  -"
		cp -f $SBHDIR/GVM-SBH_M.apk $STEPDIR/GVM-SBH
	elif [ $SBHL = true ] ; then
		ui_print "-  StatusBar Height Large Selected  -"
		cp -f $SBHDIR/GVM-SBH_L.apk $STEPDIR/GVM-SBH
	elif [ $SBHXL = true ] ; then
		ui_print "-  StatusBar Height eXtra Large Selected  -"
		cp -f $SBHDIR/GVM-SBH_XL.apk $STEPDIR/GVM-SBH
	fi
fi

if $NK; then
	ui_print "-  NotchKiller Selected  -"
	mkdir -p $STEPDIR/GVM-NK
	cp -r -f $NKDIR/GVM-NK.apk $STEPDIR/GVM-NK
fi

if $PG; then
	ui_print "-  Wide Gesture Selected  -"
	mkdir -p $STEPDIR/GVM-PG
	if [ $PGIOS = true ]; then
		cp -r -f $PGDIR/GVM-PG.apk $STEPDIR/GVM-PG
		cp -r -f $PGDIR/Nav* $STEPDIR
	elif [ $PGTH = true ] ; then
		cp -r -f $PGDIR/GVM-PG-TH.apk $STEPDIR/GVM-PG
	fi
fi

if [ -z "$(ls -A $STEPDIR)" ] ; then
	echo "The overlays was not copied, please send logs to the developer."
	exit 1
else
	:
fi

if [ "$API" == 29 ]; then
	mv $STEPDIR/* $OVPATH
	rm -rf $STEPDIR
else
	find $STEPDIR -type f -name '*.apk' -exec mv -t $OVPATH {} +
	rm -rf $STEPDIR
fi


rm -rf $MODPATH/mod

unmount_rw_stepdir

if $NK; then
   	ui_print " "
   	ui_print "   PLEASE READ."
  	ui_print " "
 	ui_print "   How to activate NotchKiller mod:"
   	ui_print " - Go to developer option"
    ui_print " - Search Display Cutout"
    ui_print " - Choose NotchKiller"
    ui_print " - Done!"
    ui_print " "
  	ui_print " "
  	ui_print "  Press any vol button to complete installation."
	ui_print " "
	ui_print " "
  	if $VKSEL; then
      	ui_print "  Completing Installation...."
    else
      	ui_print "  Completing Installation...."
    fi
fi
