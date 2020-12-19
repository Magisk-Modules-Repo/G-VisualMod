#!/system/bin/sh

##################
# Main functions #
##################

sp() {
	ui_print " "
	ui_print " "
}

pick_opt() {
	if [ $1 = multi ]; then
		ui_print "  "
		ui_print "  Vol [+] = Next, Vol [-] = Select"
		ui_print "  Select:"
		sp
		OPT=1
		while true; do
			ui_print "  $OPT"
			if chooseport 50; then
				OPT=$((OPT + 1))
			else 
				break
			fi
			[ $OPT -gt $2 ] && OPT=1
		done
		sp
	elif [ $1 = back ]; then
		ui_print "  "
		ui_print "  Press any vol button to go back"
		if chooseport 50; then
			eval $2
		else 
			eval $2
		fi
	elif [ $1 = yesno ]; then
		ui_print "  "
		ui_print "  Vol [+] = Yes, Vol [-] = No"
		ui_print "  Select:"
		sp
		if chooseport 50; then
			ui_print "-  Okay, will do  -"
			eval $2=true
		else
			ui_print "-  Okay, won't do  -"
		fi
	fi
}	

array() {
	while [ -n "$ARR" ]; do
		SRR=${ARR%%:*};
		eval $1
		ARR=${ARR#*:};
	done
	unset ARR SRR
}

build_apk() {
	sp
	ui_print "  Creating ${1} overlay..."
	aapt p -f -M ${OVDIR}/AndroidManifest.xml \
		-I /system/framework/framework-res.apk -S ${OVDIR}/res/ \
		-F ${OVDIR}/unsigned.apk

	if [ -s ${OVDIR}/unsigned.apk ]; then
		${ZIPPATH}/zipsigner ${OVDIR}/unsigned.apk ${OVDIR}/signed.apk
		cp -rf ${OVDIR}/signed.apk ${MODDIR}/${FAPK}.apk
		[ ! -s ${OVDIR}/signed.apk ] && cp -rf ${OVDIR}/unsigned.apk ${MODDIR}/${FAPK}.apk
		rm -rf ${OVDIR}/signed.apk ${OVDIR}/unsigned.apk
	else
		ui_print "  Overlay not created!"
		abort "  This is generally a rom incompatibility,"
	fi

	cp_ch -r ${MODDIR}/${FAPK}.apk ${STEPDIR}/${DAPK}

	if [ -s ${STEPDIR}/${DAPK}/${FAPK}.apk ]; then
		:
	else
		abort "  The overlay was not copied, please send logs to the developer."
	fi
	sp
	ui_print "  ${1} overlay created!"
}

pre_install() {
	rm -rf /data/resource-cache/overlays.list
	find /data/resource-cache/ -type f \( -name "*Gestural*" -o -name "*Gesture*" -o -name "*GUI*" -o -name "*GPill*" -o -name "*GStatus*" \) \
		-exec rm -rf {} \;
	ZIPPATH=${MODPATH}/common/addon
	set_perm ${ZIPPATH}/zipsigner 0 0 0755
	set_perm ${ZIPPATH}/zipsigner-3.0-dexed.jar 0 0 0644
}

define_string() {
	DFBK="DefaultBlack"
	DFWT="DefaultWhite"
	AMTY="Amethyst"
	AQMR="Aquamarine"
	CRBN="Carbon"
	CNMN="Cinnamon"
	GREN="Green"
	OCEA="Ocean"
	ORCD="Orchid"
	PLTT="Palette"
	PRPL="Purple"
	SAND="Sand"
	SPCE="Space"
	TGRN="Tangerine"
	MIBL="MIUI12"
	PXBL="PixelBlue"
	OPRD="OnePlusRed"
	SVRLY="Overlay"
}

older_install() {
	[ -d /data/adb/modules/gvisualmod ] && OLDMODULE=true

	if [ $OLDMODULE ]; then
		sp
		ui_print "  Module has been installed before!"
		ui_print "  "
		ui_print "  Restore previous selected option(s)?"
		ui_print "  (You can remove certain selected options later)"
		pick_opt yesno RESTORE
	fi

	if [ $RESTORE ]; then
		MLOOP=true
		eval "$(cat /data/adb/modules/gvisualmod/modlist.log)"
		case $TMPLT in
			AOSP) T=1; W=72;;
			OxygenOS) T=1; W=137;;
			MIUI) T=1.85; W=145;;
			IOS) T=2.5; W=160;;
		esac
		mods_check
		ui_print "  Press any vol button to go to main menu"
		chooseport 50
	fi
}

set_dir() {
	OVDIR=${MODDIR}/${1}
	VALDIR=${OVDIR}/res/values
	DRWDIR=${OVDIR}/res/drawable
}

#########################################
# Mount check (Thanks to @skittles9823) #
#########################################

is_mounted() {
	grep " $(readlink -f "$1") " /proc/mounts 2>/dev/null
	return $?
}

is_mounted_rw() {
	grep " $(readlink -f "$1") " /proc/mounts | grep " rw," 2>/dev/null
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

unmount_rw_stepdir() {
	if [ $OEM ]; then
		is_mounted_rw " /oem" && unmount_rw /oem
		is_mounted_rw " /oem/OP" && unmount_rw /oem/OP
	fi
}

###############################################
# Check overlay dir (Thanks to @skittles9823) #
###############################################

incompatibility_check() {
	OLDMIUI=$(grep_prop "ro.miui.ui.version.*")
	MIUI=$(grep_prop "ro.miui.ui.version.name*")
	OOS=$(grep_prop "ro.oxygen.version*")

	if [ $OLDMIUI ] && [ -z $MIUI ]; then
		sp
		ui_print "  Older MIUI detected!"
		abort "  Only supported on MIUI 12!"
	fi
	if [ $MIUI ]; then
		sp
		ui_print "  MIUI detected!"
		ui_print "  UI Radius mod not supported!"
		ui_print "  "
		ui_print "  Press any vol button to continue"
		chooseport 50
	fi
	if [ $OOS ]; then
		sp
		ui_print "  OxygenOS detected!"
		ui_print "  Immersive mode and Pill transparency not supported!"
		ui_print "  "
		ui_print "  Press any vol button to continue"
		chooseport 50
	fi

	if [ -d "/product/overlay" ]; then
		MAGISK_VER_CODE=$(grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | awk -F = '{ print $2 }')
		PRODUCT=true
		if [ $MAGISK_VER_CODE -ge "20000" ]; then
			STEPDIR=${MODPATH}/system/product/overlay
		else
			ui_print "  Magisk v20 is required for users on Android 10"
			abort "  Please update Magisk and try again."
		fi
	elif [ -d /oem/OP ];then
		OEM=true
		is_mounted " /oem" || mount /oem
		is_mounted_rw " /oem" || mount_rw /oem
		is_mounted " /oem/OP" || mount /oem/OP
		is_mounted_rw " /oem/OP" || mount_rw /oem/OP
		STEPDIR=/oem/OP/OPEN_US/overlay/framework
	else
		STEPDIR=${MODPATH}/system/vendor/overlay
	fi
}

#############
# Main Menu #
#############

main_menu() {
	[ $MLOOP ] && OPTLIM=8 || OPTLIM=4
	sp
	ui_print "  #############"
	ui_print "  # MAIN MENU #"
	ui_print "  #############"
	ui_print "  Here are the list of available mods:"
	ui_print "  "
	ui_print "  1. UI Radius"
	ui_print "  2. Pill Gesture"
	ui_print "  3. Statusbar"
	ui_print "  4. NotchKiller"
	if [ $MLOOP ];then
		ui_print "  "
		ui_print "  5. Continue install"
		ui_print "  6. Selected mod(s)"
		ui_print "  7. Remove selected mod(s)"
		ui_print "  8. Remove all selected mods"
	fi
	pick_opt multi $OPTLIM
	if [ $OPT = 1 ] && [ $MIUI ]; then
		sp
		ui_print "  UI Radius not supported on MIUI"
		pick_opt back main_menu
	fi
	if [ $OPT = 1 ]; then
		main_urm
		main_menu
	fi
	if [ $OPT = 2 ]; then
		main_pgm
		main_menu
	fi
	if [ $OPT = 3 ]; then
		main_sbm
		main_menu
	fi
	if [ $OPT = 4 ]; then
		main_nck
		main_menu
	fi
	if [ $OPT = 6 ]; then
		mods_check
		pick_opt back main_menu
	fi
	if [ $OPT = 7 ]; then
		mods_remove
		main_menu
	fi
	if [ $OPT = 8 ]; then
		mods_reset
		main_menu
	fi
}

main_loop() {
	while true; do
		mods_check
		sp
		ui_print "  Continue or go back?"
		ui_print "  Vol+ = Continue, Vol- = Go back"
		if chooseport 50; then
			break
		else
			main_menu
		fi
	done
}

mods_check() {
	sp
	ui_print "  Mod(s) selected:"
	ARR="SMR:SMT:SMW:SMTP:SMKBH:SMC:SMC1:SMC2:SMTRP:SMIMRS:SMFULL:SMH:SMMIUISM:SMNCK:"
	func() {
		[ "$SRR" ] &&  unset $OPN
	}
	array func
	[ $R ] && SMR="${RE} UI radius"
	if [ $SHPMAN ]; then
		if [ -z $TE ]; then
			SMT="${T}dp thickness"
		else
			SMT="${T}dp (${TE}) pill thickness"
		fi
		if [ -z $WE ]; then
			SMW="${W}dp width"
		else
			SMW="${W}dp (${WE}) pill width"
		fi
	fi
	[ $TMPLT ] && SMTP="${TMPLT} pill"
	[ $KBH ] && SMKBH="Reduced keyboard bottom height"
	[ $CLR ] && SMC="${CLR} color"
	[ $CLR1 ] && SMC1="${CLR1} color"
	[ $CLR2 ] && SMC2="${CLR2} color"
	[ $TRP ] && SMTRP="${STRP} transparency"
	[ $IMRS ] && SMIMRS="Immersive"
	[ $FULL ] && SMFULL="Fullscreen"
	[ $H ] && SMH="${HE} statusbar height"
	[ $MIUISM ] && SMMIUISM="MIUI bottom margin fix"
	[ $NCK ] && SMNCK="NotchKiller"
	ARR="${SMR}:${SMT}:${SMW}:${SMTP}:${SMKBH}:${SMC}:${SMC1}:${SMC2}:${SMTRP}:${SMIMRS}:${SMFULL}:${SMH}:${SMMIUISM}:${SMNCK}:"
	func() {
		[ "$SRR" ] && ui_print "-  $SRR selected  -"
	}
	array func
}

mods_remove() {
		ARR="${SMR}:${SMT}:${SMW}:${SMTP}:${SMKBH}:${SMC}:${SMC1}:${SMC2}:${SMTRP}:${SMIMRS}:${SMFULL}:${SMH}:${SMMIUISM}:${SMNCK}:"
		ui_print "  Select which mod to remove:"
		ui_print "  "
		NUM=1
		func() {
			if [ "$SRR" ]; then
				ui_print "  ${NUM}. ${SRR}"
				i=MD${NUM}=\"${SRR}\"
				eval $i
				NUM=$((NUM+1))
			fi
		}
		array func
		ui_print "  "
		ui_print "  ${NUM}. Back (Continue)"
		pick_opt multi $NUM
		i=MD${OPT}
		eval OPN=\"\$"${i}"\"
		if [ $OPT != $NUM ]; then
			case "${OPN}" in
				*radius*) unset R SMR ISR;;
				*thickness*) unset SHPMAN T SMT W SMW TMPLT SMTP;;
				*width*) unset SHPMAN T SMT W SMW TMPLT SMTP;;
				*keyboard*) unset KBH SMKBH;;
				*pill*) unset SHPMAN T SMT W SMW TMPLT SMTP;;
				*color*) unset CLR CLR1 CLR2 DLCR DLTN SMC SMC1 SMC2;;
				*transparency*) unset TRP SMTRP;;
				*Immersive*) unset IMRS SMIMRS;;
				*Fullscreen*) unset FULL SMFULL;;
				*height*) unset H SMH;;
				*margin*) unset MIUISM SMMIUISM;;
				*NotchKiller*) unset NCK SMNCK;;
			esac
		fi
		[ "$OPN" ] && [ $OPT != $NUM ] && ui_print "-  ${OPN} removed  -"
		unset OPN
		[ $OPT = $NUM ] || mods_remove
}

mods_reset() {
	sp
	ui_print "  Resetting..." 
	unset MLOOP R SMR SHPMAN T SMT W SMW TMPLT SMTP KBH SMKBH CLR CLR1 CLR2 SMC SMC1 SMC2 TRP SMTRP IMRS SMIMRS FULL SMFULL H SMH MIUISM SMMIUISM NCK SMNCK
}

############
# Main URM #
############

urm_zip() {
	OIFS=$IFS; IFS=\|
	case $(basename $ZIPFILE | tr '[:upper:]' '[:lower:]') in
		*rsmall*) R=2;;
		*rmedium*) R=20;;
		*rlarge*) R=32;;
	esac
	IFS=$OIFS
}

main_urm() {
	sp
	ui_print "  ###################"
	ui_print "  # G-UI RADIUS MOD #"
	ui_print "  ###################"
	ui_print "  Pick radius"
	ui_print "  "
	ui_print "  1. Small (Almost square)"
	ui_print "  2. Medium"
	ui_print "  3. Large"
	ui_print "  "
	ui_print "  4. Back (continue)"
	pick_opt multi 4
	case $OPT in
		1) R=2; RE=Small;;
		2) R=20; RE=Medium;;
		3) R=32; RE=Large;;
    esac
	[ $R ] && ui_print "-  ${RE} radius selected  -" && MLOOP=true
	if [ -z $MIUI ] && [ $R ]; then
		unset ISR
		sp
		ui_print "  Applying radius to all icon shapes"
		ui_print "  PLEASE READ!"
		ui_print "  NOT ALL ROM SUPPORT THIS!"
		ui_print "  Take a screenshot if you want"
		ui_print "  "
		ui_print "  You can try this option and check your iconshapes after"
		ui_print "  "
		ui_print "  Workaround if iconshapes are missing:"
		ui_print "  1st solution:"
		ui_print "  Select NO on this option"
		ui_print "  and see if iconshapes are overriding UIRadius"
		ui_print "  "
		ui_print "  2nd solution:"
		ui_print "  1. Disable this module in magisk manager"
		ui_print "  2. Reboot"
		ui_print "  3. Set up your iconshapes, font, accent, etc and apply it"
		ui_print "  4. Install this module (you can restore other selected mods)"
		ui_print "	5. Pick radius and select YES on this option"
		ui_print "  Do not change styles to default, or you have to do this again"
		ui_print "  "
		ui_print "  If it still doesn't work:"
		ui_print "  Type #iconshapefix on telegram Support Group (@tzlounge)"
		ui_print "  It will guide you to report to your rom maintainer"
		ui_print "  "
		ui_print "  (Tested fine on RevengeOS A11)"
		ui_print "  (Should've worked on Ressurection Remix)"
		ui_print "  (Workaround successfull on crDroid A11)"
		ui_print "  "
		ui_print "  Apply radius to all icon shapes?"
		pick_opt yesno ISR
	fi
}

urm_script() {
	INFIX=Android
	set_dir Android
	DAPK=${PREFIX}${INFIX}
	FAPK=${PREFIX}${INFIX}${SVRLY}
	ARR="config:dimens:dimens-material:"
	func () {
		sed -i "s|<val>|$R|" ${VALDIR}/${SRR}.xml
	}
	array func
	build_apk UIRadiusAndroid

	INFIX=SystemUI
	set_dir SystemUI
	DAPK=${PREFIX}${INFIX}
	FAPK=${PREFIX}${INFIX}${SVRLY}
	sed -i "s|<val>|$R|" ${VALDIR}/dimens.xml
	[ $API -ge 29 ] && find ${DRWDIR} ! -name 'rounded_ripple.xml' -type f -exec rm -f {} +
	build_apk UIRadiusSystemUI
	
	if [ $ISR ]; then
		PREFIX=IconShape
		ARR="Cylinder:Heart:Hexagon:Leaf:Mallow:Pebble:RoundedHexagon:RoundedRect:Square:Squircle:TaperedRect:Teardrop:Vessel:"
		func() {
			DAPK=${PREFIX}${SRR}
			FAPK=${PREFIX}${SRR}${SVRLY}
			set_dir "IconShape/${SRR}"
			sed -i "s|<vapi>|$API|" ${OVDIR}/AndroidManifest.xml
			sed -i "s|<vcde>|$ACODE|" ${OVDIR}/AndroidManifest.xml
			build_apk ${PREFIX}${SRR}
			[ -d /system/product/overlay/${DAPK} ] || rm -rf ${STEPDIR:?}/${DAPK}
		}
		array func
	fi
}

############
# Main PGM #
############

pgm_zip() {
	OIFS=$IFS; IFS=\|
	case $(basename $ZIPFILE | tr '[:upper:]' '[:lower:]') in
		*aosp*) T=1; W=72;;
		*oos*) T=1.5; W=110;;
		*miui*) T=1.5; W=160;;
		*ios*) T=2.5; W=160;;
		*full*) FULL=true;;
		*imrs*) IMRS=true;;
		*kbh*) KBH=true;;
		*dflt*) CLR1=$DFBK; CLR2=$DFWT;;
		*amty*) [ $CLR ] && CLR2=$AMTY || CLR1=$AMTY;;
		*aqmr*) [ $CLR ] && CLR2=$AQMR || CLR1=$AQMR;;
		*crbn*) [ $CLR ] && CLR2=$CRBN || CLR1=$CRBN;;
		*cnmn*) [ $CLR ] && CLR2=$CNMN || CLR1=$CNMN;;
		*gren*) [ $CLR ] && CLR2=$GREN || CLR1=$GREN;;
		*ocea*) [ $CLR ] && CLR2=$OCEA || CLR1=$OCEA;;
		*orcd*) [ $CLR ] && CLR2=$ORCD || CLR1=$ORCD;;
		*pltt*) [ $CLR ] && CLR2=$PLTT || CLR1=$PLTT;;
		*prpl*) [ $CLR ] && CLR2=$PRPL || CLR1=$PRPL;;
		*sand*) [ $CLR ] && CLR2=$SAND || CLR1=$SAND;;
		*spce*) [ $CLR ] && CLR2=$SPCE || CLR1=$SPCE;;
		*tgrn*) [ $CLR ] && CLR2=$TGRN || CLR1=$TGRN;;
		*mibl*) [ $CLR ] && CLR2=$MIBL || CLR1=$MIBL;;
		*pxbl*) [ $CLR ] && CLR2=$PXBL || CLR1=$PXBL;;
		*oprd*) [ $CLR ] && CLR2=$OPRD || CLR1=$OPRD;;
		*dt*) DLTN=true;;
		*10*) TRP=E6; IMRS=true;;
		*20*) TRP=CC; IMRS=true;;
		*30*) TRP=B3; IMRS=true;;
		*40*) TRP=99; IMRS=true;;
		*50*) TRP=80; IMRS=true;;
		*60*) TRP=66; IMRS=true;;
		*70*) TRP=4D; IMRS=true;;
		*80*) TRP=33; IMRS=true;;
		*90*) TRP=1A; IMRS=true;;
	esac
	IFS=$OIFS
}

main_pgm() {
	sp
	ui_print "  #######################"
	ui_print "  # G-PILL GESTURE MODS #"
	ui_print "  #######################"
	ui_print "  Here are the list of available mods:"
	ui_print "  "
	ui_print "  1. Change shape"
	ui_print "  2. Change color"
	ui_print "  3. Change transparency"
	ui_print "  4. Enable immersive or fullscreen mode"
	ui_print "  5. Reduce keyboard bottom height"
	ui_print "  "
	ui_print "  6. Back (continue)"
	pick_opt multi 6
	if [ $OPT = 1 ] && [ -z "$FULL" ]; then
		main_shape
		main_pgm
	elif [ $OPT = 1 ] && [ "$FULL" ]; then
		fs_picked shape main_shape
	fi
	if [ $OPT = 2 ] && [ -z "$FULL" ]; then
		main_color
		main_pgm
	elif [ $OPT = 2 ] && [ "$FULL" ]; then
		fs_picked color main_color
	fi
	if [ $OPT = 3 ] && [ $OOS ]; then
		sp
		ui_print "  Transparency not supported on OxygenOS!"
		pick_opt back main_pgm
	fi
	if [ $OPT = 3 ] && [ -z "$FULL" ]; then
		main_transparency
		main_pgm
	elif [ $OPT = 3 ] && [ "$FULL" ]; then
		fs_picked transparency main_transparency
	fi
	if [ $OPT = 4 ]; then
		main_mode
		main_pgm
	fi
	if [ $OPT = 5 ]; then
		main_kbh
		main_pgm
	fi
}

fs_picked() {
	ui_print "  You selected fullscreen mode before,"
	ui_print "  why would you change the ${1}?"
	ui_print "  or"
	ui_print "  Do you want to unselect fullscreen mode"
	ui_print "  and continue?"
	ui_print "  Vol+ = Yes, Vol- = No"
	sp
	if chooseport 50; then
		ui_print "-  Fullscreen unselected  -"
		sp
		unset FULL MLOOP
		eval $2
		main_pgm
	else
		main_pgm
	fi
}

main_shape() {
	ui_print "  ################"
	ui_print "  # CHANGE SHAPE #"
	ui_print "  ################"
	ui_print "  Customize manually or pick a template"
	ui_print "  "
	ui_print "  1. Manual Mode"
	ui_print "  2. AOSP Pill"
	ui_print "  3. OxygenOS Pill"
	ui_print "  4. MIUI Pill"
	ui_print "  5. IOS Pill"
	ui_print "  "
	ui_print "  6. Back (continue)"
	pick_opt multi 6
	if [ $OPT = 1 ]; then
		shape_manual && SHPMAN=true && unset TMPLT
	else
		[ $OPT -ne 6 ] && unset SHPMAN TE WE
		case $OPT in
			2) T=1; W=72; TMPLT=AOSP;;
			3) T=1; W=137; TMPLT=OxygenOS;;
			4) T=1.85; W=145; TMPLT=MIUI;;
			5) T=2.5; W=160; TMPLT=IOS;;
		esac
	fi
	[ $TMPLT ] && ui_print "-  ${TMPLT} pill selected  -"
	if [ $W ]; then
		sp
		ui_print "  Apply width to landscape mode too?"
		pick_opt yesno LAND
	fi
	[ $T ] && [ $W ] && MLOOP=true
}

shape_manual() {
	ui_print "  #############"
	ui_print "  # Thickness #"
	ui_print "  #############"
	ui_print "  How thick?"
	ui_print "  "
	ui_print "  1. 1.0dp (AOSP & OxygenOS)"
	ui_print "  2. 1.85dp (MIUI 12)"
	ui_print "  3. 2.5dp (IOS)"
	ui_print "  4. 3.0dp"
	pick_opt multi 4
	case $OPT in
		1) T=1; TE="AOSP & OxygenOS";;
		2) T=1.85; TE="MIUI 12";;
		3) T=2.5; TE="IOS";;
		4) T=3;;
    esac
	if [ -z "$TE" ]; then
		ui_print "-  ${T}dp thickness selected  -"
	else
		ui_print "-  ${T}dp (${TE}) thickness selected  -"
	fi
	
	sp
	ui_print "  #########"
	ui_print "  # Width #"
	ui_print "  #########"
	ui_print "  How wide?"
	ui_print "  "
	ui_print "  1. 72dp (AOSP)"
	ui_print "  2. 100dp"
	ui_print "  3. 137dp (OxygenOS)"
	ui_print "  4. 145dp (MIUI 12)"
	ui_print "  5. 160dp (IOS)"
	ui_print "  6. 180dp"
	ui_print "  7. 200dp"
	pick_opt multi 7
	case $OPT in
		1) W=72; WE="AOSP";;
		2) W=100;;
		3) W=137; WE="OxygenOS";;
		4) W=145; WE="MIUI";;
		5) W=160; WE="IOS";;
		6) W=180;;
		7) W=200;;
    esac
	if [ -z "$WE" ]; then
		ui_print "-  ${W}dp width selected  -"
	else
		ui_print "-  ${W}dp (${WE}) width selected  -"
	fi
}

main_color() {
	CLRC="a"
	ui_print "  ################"
	ui_print "  # CHANGE COLOR #"
	ui_print "  ################"
	color_list
	ui_print "  16. DualColor (choose twice)"
	ui_print "  "
	ui_print "  17. Back (continue)"
	pick_opt multi 17
	[ $OPT -ne 17 ] && color_pick
	[ $CLR ] && ui_print "-  ${CLR} selected  -"
	sp
	if [ $OPT = 16 ]; then
		DLCR=true
		DLTN=true
		CLRC="light theme"
		color_list
		ui_print "  16. DefaultBlack"
		pick_opt multi 16
		color_pick
		[ $OPT = 16 ] && CLR=$DFBK
		CLR1=$CLR
		ui_print "-  ${CLR1} selected  -"
		sp
		
		CLRC="dark theme"
		color_list
		ui_print "  16. DefaultWhite"
		pick_opt multi 16
		color_pick
		[ $OPT = 16 ] && CLR=$DFWT
		CLR2=$CLR
		ui_print "-  ${CLR2} selected  -"
		unset CLR
	fi
	
	if [ $OPT -le 12 ] && [ -z $DLTN ]; then
		sp
		ui_print "  #############"
		ui_print "  # DUAL TONE #"
		ui_print "  #############"
		ui_print "  Pill gesture will slighty changes color-"
		ui_print "  between light and dark theme (adaptive)"
		ui_print "  Enable DualTone mode?"
		pick_opt yesno DLTN
	fi
	[ $CLR ] && MLOOP=true || [ $DLCR ] && MLOOP=true
}

color_list () {
	ui_print "  Pick ${CLRC} color"
	ui_print "  "
	ui_print "  1. ${AMTY}"
	ui_print "  2. ${AQMR}"
	ui_print "  3. ${CRBN}"
	ui_print "  4. ${CNMN}"
	ui_print "  5. ${GREN}"
	ui_print "  6. ${OCEA}"
	ui_print "  7. ${ORCD}"
	ui_print "  8. ${PLTT}"
	ui_print "  9. ${PRPL}"
	ui_print "  10. ${SAND}"
	ui_print "  11. ${SPCE}"
	ui_print "  12. ${TGRN}"
	ui_print "  13. ${MIBL} (No DualTone)"
	ui_print "  14. ${PXBL} (No DualTone)"
	ui_print "  15. ${OPRD} (No DualTone)"
}

color_pick() {
	case $OPT in
		1) CLR=$DFBK;;
		1) CLR=$DFWT;;
		1) CLR=$AMTY;;
		2) CLR=$AQMR;;
		3) CLR=$CRBN;;
		4) CLR=$CNMN;;
		5) CLR=$GREN;;
		6) CLR=$OCEA;;
		7) CLR=$ORCD;;
		8) CLR=$PLTT;;
		9) CLR=$PRPL;;
		10) CLR=$SAND;;
		11) CLR=$SPCE;;
		12) CLR=$TGRN;;
		13) CLR=$MIBL;;
		14) CLR=$PXBL;;
		15) CLR=$OPRD;;
	esac
}

light_color() {
	case $SRR in
		"$DFWT") LCLR="FFFFFF";;
		"$AMTY") LCLR="BD78FF";;
		"$AQMR") LCLR="1AFFCB";;
		"$CRBN") LCLR="3DDCFF";;
		"$CNMN") LCLR="C3A6A2";;
		"$GREN") LCLR="84C188";;
		"$OCEA") LCLR="28BDD7";;
		"$ORCD") LCLR="E68AED";;
		"$PLTT") LCLR="ffb6d9";;
		"$PRPL") LCLR="B5A9FC";;
		"$SAND") LCLR="c8ac94";;
		"$SPCE") LCLR="99ACCC";;
		"$TGRN") LCLR="F19D7D";;
		"$MIBL") LCLR="0D84FF";;
		"$PXBL") LCLR="1A73E8";;
		"$OPRD") LCLR="EB0028";;
	esac
}

dark_color() {
	case $SRR in
		"$DFBK") DCLR="000000";;
		"$AMTY") DCLR="A03EFF";;
		"$AQMR") DCLR="23847D";;
		"$CRBN") DCLR="434E58";;
		"$CNMN") DCLR="AF6050";;
		"$GREN") DCLR="1B873B";;
		"$OCEA") DCLR="0C80A7";;
		"$ORCD") DCLR="C42CC9";;
		"$PLTT") DCLR="c01668";;
		"$PRPL") DCLR="725AFF";;
		"$SAND") DCLR="795548";;
		"$SPCE") DCLR="47618A";;
		"$TGRN") DCLR="C85125";;
		"$MIBL") DCLR="0D84FF";;
		"$PXBL") DCLR="1A73E8";;
		"$OPRD") DCLR="EB0028";;
	esac
}

main_transparency() {
	ui_print "  ################"
	ui_print "  # TRANSPARENCY #"
	ui_print "  ################"
	ui_print "  Applying this will have IMMERSIVE MODE enabled!"
	ui_print "  How transparent?"
	ui_print "  "
	ui_print "  1. 10%"
	ui_print "  2. 20%"
	ui_print "  3. 30%"
	ui_print "  4. 40%"
	ui_print "  5. 50%"
	ui_print "  6. 60%"
	ui_print "  7. 70%"
	ui_print "  8. 80%"
	ui_print "  9. 90%"
	ui_print "  "
	ui_print "  10. Back (continue)"
	pick_opt multi 10
	if [ $OPT -ne 10 ]; then
		case $OPT in
			1) TRP=E6; STRP="10%";;
			2) TRP=CC; STRP="20%";;
			3) TRP=B3; STRP="30%";;
			4) TRP=99; STRP="40%";;
			5) TRP=80; STRP="50%";;
			6) TRP=66; STRP="60%";;
			7) TRP=4D; STRP="70%";;
			8) TRP=33; STRP="80%";;
			9) TRP=1A; STRP="90%";;
		esac
		[ $STRP ] && ui_print "-  ${STRP} transparency selected  -"
	fi
	[ $TRP ] && IMRS=true && MLOOP=true
}

main_mode() {
	ui_print "  #################"
	ui_print "  # ACTIVATE MODE #"
	ui_print "  #################"
	ui_print "  Pick a mode"
	ui_print "  "
	ui_print "  1. Immersive mode"
	ui_print "  2. Fullscreen mode"
	ui_print "  "
	ui_print "  3. Back (continue)"
	pick_opt multi 3
	if [ $OPT = 1 ] && [ $OOS ]; then
		sp
		ui_print "  Immersive mode not supported on OxygenOS"
		pick_opt back
	fi
	case $OPT in
		1) IMRS=true; AMODE=Immersive;;
		2) FULL=true; AMODE=Fullscreen;;
	esac
	[ $OPT -ne 3 ] && ui_print "-  ${AMODE} mode selected  -"
	[ $IMRS ] || [ $FULL ] && MLOOP=true
}

main_kbh() {
	ui_print "  Do you want to reduce keyboard bottom height?"
	ui_print "  NOTICE: Height are based on pill thickness"
	sp
	pick_opt yesno KBH
	[ $KBH ] && MLOOP=true
}

pgm_script() {
	if [ $T ] && [ $W ]; then
		INFIX=Shape
		set_dir Shape
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}${SVRLY}
		case $T in
			1) T2=6; T3=16;;
			*85) T2=7; T3=19;;
			2*) T2=9; T3=24;;
			3) T2=10; T3=26;;
		esac
		sed -i "s|<val2>|$T2|" ${VALDIR}/dimens.xml
		sed -i "s|<val>|$T|" ${VALDIR}/dimens.xml
		sed -i "s|<val3>|$W|" ${VALDIR}/dimens.xml
		[ $LAND ] && cp_ch -r ${VALDIR}/dimens.xml ${OVDIR}/res/values-land
		build_apk Shape
	fi
	
	if [ $CLR ] || [ $TRP ] || [ $DLCR ]; then
		set_dir Color
		INFIX=Color
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}${SVRLY}
		ARR="$CLR:$CLR1:$CLR2:"
		ATT=1
		func() {
			if [ $SRR ]; then
				if [ $ATT = 1 ]; then
					light_color
					dark_color
				elif [ $ATT = 2 ]; then
					dark_color
				elif [ $ATT = 3 ]; then
					light_color
				fi
			fi
			ATT=$((ATT+1))
		}
		array func

		if [ -z $TRP ]; then
			LTRP=EB
			DTRP=99
		else
			LTRP=$TRP
			DTRP=$TRP
		fi
		
		[ -z $LCLR ] && [ -z $DCLR ] && DLTN=true
		[ -z $LCLR ] && LCLR="FFFFFF"
		[ -z $DCLR ] && DCLR="000000"
		[ -z $DLTN ] && DCLR=$LCLR
		[ -z $MIUI ] && VAR="bar_home_"
		ARR="<var>|$VAR:<lclr>|$LCLR:<dclr>|$DCLR:<ltrp>|$LTRP:<dtrp>|$DTRP:"
		func() {
			sed -i "s|${SRR}|" ${VALDIR}/colors.xml
		}
		array func
		build_apk Color
	fi

	if [ -z $MIUI ]; then
		if [ $PRODUCT ] || [ $OEM ]; then
			:
		else
			ui_print "  I'm not sure it'll work in current OS..."
		fi
		set_dir "/Config/AOSP"
		PREFIX="NavigationBarModeGestural"
	else
		set_dir "/Config/MIUI"
		DAPK=${PREFIX}${SCNFG}
		FAPK=${PREFIX}${SCNFG}${SVRLY}
	fi

	DEF1=16
	DEF2=48
	DEF3=32
	
	if [ $FULL ]; then
		SVAL1=0
		SVAL2=0
		SVAL3=20
	fi

	if [ $IMRS ]; then
		if [ -z $MIUI ]; then
			SVAL1=0
			if [ $T3 ]; then
				[ $KBH ] && SVAL2=$T3 || SVAL2=$DEF2
			else
				[ $KBH ] && SVAL2=$DEF1 || SVAL2=$DEF2
			fi
			[ $T3 ] && SVAL3=$(($T3+16)) || SVAL3=$DEF3
		else
			SVAL1=0.1
			[ $T3 ] && SVAL2=$T3
		fi
	elif [ $T3 ]; then
		SVAL1=$T3
		[ $MIUI ] || [ $KBH ] && SVAL2=$T3 || SVAL2=$DEF2
		SVAL3=$(($T3+16))
	elif [ $KBH ]; then
		SVAL1=$DEF1
		SVAL2=$DEF1
		SVAL3=$DEF3
	fi
	
	if [ $MIUI ]; then
		if [ $FULL ] || [ -z $SVAL2 ]; then
			sed -i "5,6d" ${VALDIR}/dimens.xml
		fi
	fi
	
	if [ $SVAL1 ]; then
		sed -i "s|<val>|$SVAL1|" ${VALDIR}/dimens.xml
		sed -i "s|<val2>|$SVAL2|" ${VALDIR}/dimens.xml
		if [ -z $MIUI ]; then
			sed -i "s|<val3>|$SVAL3|" ${VALDIR}/dimens.xml
			sed -i "s|<vapi>|$API|" ${OVDIR}/AndroidManifest.xml
			sed -i "s|<vcde>|$ACODE|" ${OVDIR}/AndroidManifest.xml
			[ $API -ge 30 ] && ARR=":" || ARR=":NarrowBack:WideBack:ExtraWideBack:"
			func() {
				DAPK=${PREFIX}${SRR}
				FAPK=${PREFIX}${SVRLY}${SRR}
				[ -z $SSR ] && SVAL1=24 && CHNG="<valc>" && WTH="$SVAL1" && SVALS1="gestural" && CHNG1="<vals>" && WTH1="$SVALS1"
				case $SRR in
					Narrow*) SVAL2=18; CHNG="$SVAL1"; WTH="$SVAL2"; SVALS2="gestural_narrow_back"; CHNG1="$SVALS1"; WTH1="$SVALS2";;
					Wide*) SVAL3=32; CHNG="$SVAL2"; WTH="$SVAL3"; SVALS3="gestural_wide_back"; CHNG1="$SVALS2"; WTH1="$SVALS3";;
					Extra*) SVAL4=40; CHNG="$SVAL3"; WTH="$SVAL4"; SVALS4="gestural_extra_wide_back"; CHNG1="$SVALS3"; WTH1="$SVALS4";;
				esac
				sed -i "s|$CHNG|$WTH|" ${VALDIR}/config.xml
				sed -i "s|$CHNG1|$WTH1|" ${OVDIR}/AndroidManifest.xml
				build_apk Config
			}
			array func
		else
			build_apk Config
			ui_print "  Copying special files for MIUI..."
			case $SVAL1 in
				0) GLO=FULL;;
				*1) GLO=IMRS;;
				24) GLO=24;;
				26) GLO=26;;
			esac
			mv ${MODDIR}/MIUI/*$GLO.apk ${MODDIR}/MIUI/GestureLineOverlay.apk
			cp_ch -r ${MODDIR}/MIUI/*Overlay.apk ${MODPATH}/system/vendor/overlay
			ui_print "  Files copied..."
		fi
	fi
}

imrs_notice() {
	if [ -z $CLR ] && [ -z $CLR1 ] && [ -z $CLR2 ] && [ $IMRS ] || [ $CLR1 != $DFBK ] && [ $CLR2 != $DFWT ] && [ $IMRS ]; then
		sp
		ui_print "  NOTICE on immersive mode only!"
		ui_print "  Some rom might shows false color"
		ui_print "  e.g. white pill on light theme"
		ui_print "  To fix this:"
		ui_print "  - Install the module again (restore if needed)"
		ui_print "  - Change pill color > choose DualColor"
		ui_print "  - Select DefaultBlack & DefaultWhite"
		ui_print "  - Done"
		ui_print "  "
		ui_print "  Press any vol to continue"
		chooseport 50
	fi
}

############
# Main SBM #
############

sbm_zip() {
	OIFS=$IFS; IFS=\|
	case $(basename $ZIPFILE | tr '[:upper:]' '[:lower:]') in
		*hmedium*) R=34;;
		*hlarge*) R=40;;
		*hxlarge*) R=48;;
	esac
	IFS=$OIFS
}

main_sbm() {
	if [ $MIUI ] && [ -z $MIUISM ]; then
		sp
		ui_print "  ########################"
		ui_print "  # G-STATUSBAR MIUI FIX #"
		ui_print "  ########################"
		ui_print "  Apply bottom margin fix?"
		pick_opt yesno MIUISM
	fi
	sp
	ui_print "  ##########################"
	ui_print "  # G-STATUSBAR HEIGHT MOD #"
	ui_print "  ##########################"
	ui_print "  Pick height"
	ui_print "  "
	ui_print "  1. Medium"
	ui_print "  2. Large"
	ui_print "  3. XLarge"
	ui_print "  "
	ui_print "  4. Back (continue)"
	pick_opt multi 4
	case $OPT in
		1) H=34; HE=Medium;;
		2) H=40; HE=Large;;
		3) H=48; HE=XLarge;;
	esac
	[ $HE ] && ui_print "-  ${HE} height selected  -"
	[ $MIUISM ] && MLOOP=true
	[ $H ] && MLOOP=true
}

sbm_script() {
	if [ -z $MIUI ]; then
		set_dir Height
		INFIX=Height
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}${SVRLY}
		sed -i "s|<val>|$H|" ${VALDIR}/dimens.xml
		build_apk StatusbarHeight
	else
		ui_print "  Copying special files for MIUI..."
		set_dir HeightMIUI
		[ -f /system/media/theme/default/framework-res ] && ui_print "  Overwriting default theme..."
		cp_ch -r ${OVDIR}/framework-res_$H ${MODPATH}/system/media/theme/default
		mv ${MODPATH}/system/media/theme/default/framework-res_$H ${MODPATH}/system/media/theme/default/framework-res
		if [ $MIUISM ]; then
			[ -f /system/media/theme/default/com.android.systemui ] && ui_print "  Overwriting default theme..."
			cp_ch -r ${OVDIR}/com.android.systemui ${MODPATH}/system/media/theme/default
		fi
		ui_print "  Files copied..."
	fi
}

############
# Main NCK #
############

nck_zip() {
	OIFS=$IFS; IFS=\|
	case $(basename $ZIPFILE | tr '[:upper:]' '[:lower:]') in
		*nck*) NCK=true;;
	esac
	IFS=$OIFS
}

main_nck() {
	sp
	ui_print "  #################"
	ui_print "  # G-NotchKiller #"
	ui_print "  #################"
	ui_print "  "
	ui_print "  Apply NotchKiller?"
	pick_opt yesno NCK
	[ $NCK ] && ui_print "-  NotchKiller selected  -" && MLOOP=true
}

nck_script() {
	set_dir NotchKiller
	INFIX=NotchKiller
	DAPK=${PREFIX}${INFIX}
	FAPK=${PREFIX}${INFIX}${SVRLY}
	sed -i "s|<vapi>|$API|" ${OVDIR}/AndroidManifest.xml
	sed -i "s|<vcde>|$ACODE|" ${OVDIR}/AndroidManifest.xml
	build_apk NotchKiller
}

incompatibility_check
pre_install
define_string
urm_zip
pgm_zip
sbm_zip

##############
# User input #
##############
if [ -z $R ] || [ -z $T ] && [ -z $W ] || [ -z $CLR1 ] || [ -z $CLR2 ] || [ -z $TRP ] || [ -z $IMRS ] || [ -z $FULL ] || [ -z $H ] || [ -z $MIUISM ] || [ -z $NCK ] ; then
	sp
	sp
	sp
	sp
	sp
	sp
	sp
	ui_print "  Welcome to..."
	ui_print "    ___     _  _ __ ____ _  _  __  __      _  _  __ ____ "
	ui_print "   / __)___/ )( (  / ___/ )( \\/ _\\(  )    ( \\/ )/  (    \\"
	ui_print "  ( (_ (___\\ \\/ /)(\\___ ) \\/ /    / (_/\\  / \\/ (  O ) D ("
	ui_print "   \\___/    \\__/(__(____\\____\\_/\\_\\____/  \\_)(_/\\__(____/"
	older_install
	main_menu
	main_loop
else
	ui_print "  Options specified in zipname!"
fi


#####################
# Creating Overlays #
#####################
sp
ui_print "  Overlays will be copied to ${STEPDIR}"

[ $API = 29 ] && ACODE=10
[ $API = 30 ] && ACODE=11

if [ $R ]; then
	MODSEL=URM
	MODDIR=${MODPATH}/mods/${MODSEL}
	PREFIX="G-UIRadius"
	urm_script
fi

if [ $T ] && [ $W ] || [ $KBH ] || [ $CLR ] || [ $DLCR ] || [ $TRP ] || [ $IMRS ] || [ $FULL ]; then
	MODSEL=PGM
	MODDIR=${MODPATH}/mods/${MODSEL}
	PREFIX="G-PillGesture"
	pgm_script
	imrs_notice
fi

if [ $H ] || [ $MIUISM ]; then
	MODSEL=SBM
	MODDIR=${MODPATH}/mods/${MODSEL}
	PREFIX="G-Statusbar"
	sbm_script
fi

if [ $NCK ]; then
	MODSEL=NCK
	MODDIR=${MODPATH}/mods/${MODSEL}
	PREFIX="DisplayCutoutEmulation"
	nck_script
fi

#############
# Finishing #
#############
ARR="R:RE:ISR:SHPMAN:TE:T:WE:W:LAND:TMPLT:KBH:CLR:CLR1:CLR2:DLCR:DLTN:TRP:STRP:IMRS:FULL:H:HE:MIUISM:NCK:"
func() {
	if [ $SRR ]; then
		eval i=\"\$$SRR\"
		if [ $i ]; then
			j=${SRR}"="${i}
			echo -e "\n${j}" >> $MODPATH/modlist.log
		fi
	fi
}
array func

rm -rf $MODPATH/mods
sp
ui_print "  Done..."
unmount_rw_stepdir
