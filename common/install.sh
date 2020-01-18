MIUI=$(grep_prop "ro.miui.ui.version.*")
if [ $MIUI ]; then
	sp
	ui_print " MIUI Detected"
	ui_print " Only StatusBar Height Mod supported."
	sp
fi

# Path-to-install locator
while [ ! -d "$STEPDIR" ]; do
    setvars
    mkdir -p $STEPDIR
done

# Zipname Initiate
if [ $MIUI ]; then
	OIFS=$IFS; IFS=\|
	zp_sbh
	IFS=$OIFS
else
	OIFS=$IFS; IFS=\|
	zp_urm
	zp_sbh
	zp_nk
	zp_pg
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
			[ -z $URM ] && URM=true; URMM=true; URMVM=true
			[ -z $SBH ] && SBH=true; SBHM=true
			[ -z $NK ] && NK=false
			[ -z $PG ] && PG=True; PGIOS=true; PGIM=false
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

echo "The overlay will be copied to $STEPDIR..."

# Mods Aliasing
URMDIR=$MODPATH/mod/GVM-URM
SBHDIR=$MODPATH/mod/GVM-SBH
NKDIR=$MODPATH/mod/GVM-NK
PGDIR=$MODPATH/mod/GVM-PG

sp
ui_print "-  Copying files  -"
sp

# Copying Files
if $URM; then
	ui_print "-  UI Radius Mod Selected  -"
	if [ $URMM = true ] ; then
		ui_print "-  RoundyUI Medium Selected  -"
		cp_ch -r $URMDIR/GVM-URM_M.apk $STEPDIR/GVM-URM-1
		cp_ch -r $URMDIR/GVM-URM_M2.apk $STEPDIR/GVM-URM-2
	elif [ $URML = true ] ; then
		ui_print "-  RoundyUI Large Selected  -"
		cp_ch -r $URMDIR/GVM-URM_L.apk $STEPDIR/GVM-URM-1
		cp_ch -r $URMDIR/GVM-URM_L2.apk $STEPDIR/GVM-URM-2
	elif [ $URMR = true ] ; then
		ui_print "-  RectangUI Selected  -"
		cp_ch -r $URMDIR/GVM-URM_R.apk $STEPDIR/GVM-URM-1
		cp_ch -r $URMDIR/GVM-URM_R2.apk $STEPDIR/GVM-URM-2
		cp_ch -r $URMDIR/GVM-URM_R3.apk $STEPDIR/GVM-URM-3
	fi
	if [ $URMVM = true ] ; then
		ui_print "-  RoundyUI Medium Vol Selected  -"
		cp_ch -r $URMDIR/GVM-URM_M3.apk $STEPDIR/GVM-URM-3
	elif [ $URMVL = true ] ; then
		ui_print "-  RoundyUI Large Vol Selected  -"
		cp_ch -r $URMDIR/GVM-URM_L3.apk $STEPDIR/GVM-URM-3
	fi
	cp -r -f $URMDIR/Icon* $STEPDIR
fi

if $SBH; then
	ui_print "-  StatusBar Height Mod Selected  -"
	if [ $SBHM = true ] ; then
		ui_print "-  StatusBar Height Medium Selected  -"
		cp_ch -r $SBHDIR/GVM-SBH_M.apk $STEPDIR/GVM-SBH
	elif [ $SBHL = true ] ; then
		ui_print "-  StatusBar Height Large Selected  -"
		cp_ch -r $SBHDIR/GVM-SBH_L.apk $STEPDIR/GVM-SBH
	elif [ $SBHXL = true ] ; then
		ui_print "-  StatusBar Height eXtra Large Selected  -"
		cp_ch -r $SBHDIR/GVM-SBH_XL.apk $STEPDIR/GVM-SBH
	fi
fi

if $NK; then
	ui_print "-  NotchKiller Mod Selected  -"
	cp_ch -r $NKDIR/GVM-NK.apk $STEPDIR/GVM-NK
fi

if $PG; then
	ui_print "-  10's Pill Gesture Mod Selected  -"
	if [ $PGWD = true ]; then
		ui_print "-  Wide Mode Selected  -"
		if [ $PGIOS = true ]; then
			ui_print "-  Thicc Selected  -"
			cp_ch -r $PGDIR/GVM-PG-IOS.apk $STEPDIR/GVM-PG
			cp -r -f $PGDIR/TAL/Nav* $STEPDIR
		elif [ $PGNTH = true ] ; then
			ui_print "-  Not thicc or thin Selected  -"
			cp_ch -r $PGDIR/GVM-PG-NTH.apk $STEPDIR/GVM-PG
		elif [ $PGTH = true ] ; then
			ui_print "-  Thinn Selected  -"
			cp_ch -r $PGDIR/GVM-PG-THN.apk $STEPDIR/GVM-PG
		fi
		if [ $PGIM = true ]; then
			ui_print "-  Immersive Mode Selected  -"
			cp -r -f $PGDIR/HID/Nav* $STEPDIR
		fi
	elif [ $PGDOT = true ]; then
		ui_print "-  Dot Mode Selected  -"
		cp_ch -r $PGDIR/GVM-PG-DOT.apk $STEPDIR/GVM-PG
		cp -r -f $PGDIR/HID/Nav* $STEPDIR
	elif [ $PGINV = true ]; then
		ui_print "-  Invisible Mode Selected  -"
		cp_ch -r $PGDIR/GVM-PG-INV.apk $STEPDIR/GVM-PG
		cp -r -f $PGDIR/HID/Nav* $STEPDIR
	fi
fi

if [ "$API" == 29 ]; then
	:
else
	find $STEPDIR/GVM* -type f -name '*.apk' -exec mv {} $STEPDIR \;
fi

rm -rf $MODPATH/mod

if [ -z "$(ls -A $STEPDIR/GVM*)" ] ; then
	echo "The overlays was not copied, please send logs to the developer."
	exit 1
else
	:
fi

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
	sp
  	ui_print "  Press any vol button to complete installation."
	sp
  	if $VKSEL; then
      	ui_print "  Completing Installation...."
    else
      	ui_print "  Completing Installation...."
    fi
fi
