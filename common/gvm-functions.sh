#----------------------------------- MENU ENVIRONMENT -----------------------------------#
# Main Menu
menu_MAIN() {
	while true; do
		[ $continueCALL ] && break
		mod_ready cont_MAIN
		header "Main Menu"
		content "Here are the list of available mods:" "cont_MAIN" "m"
		echo ""
		extra_opt e
		user_input m
		set_pick && continue
		extra_input && break
	done
}

# Default Menu
menu_super() {
	while true; do
		[ $continueCALL ] && break
		mod_ready "$3"
		header "$1"
		content "$2" "$3" "$4"
		[ $4 != "yn" ] && echo ""
		[ $4 != "yn" ] && extra_opt be
		user_input "$4"
		set_pick && continue 
		if [ $inputTYPE = yn ]; then
			input_yn && break || continue
		fi
		extra_input && break
	done
}

# Menu Tree
menu_URM() {
	menu_super "$M_URM" "Pick Radius" "cont_URM" "m"
}
menu_URM_C() {
	menu_super "$M_URM_C" "Type Radius" "cont_URM_C" "t"
}
menu_SNM() {
	menu_super "$M_SNM" "Pick Option" "cont_SNM" "m"
}
menu_SNM_SH() {
	menu_super "$M_SNM_SH" "Pick Height" "cont_SNM_SH" "m"
}
menu_SNM_SH_C() {
	menu_super "$M_SNM_SH_C" "Type Height" "cont_SNM_SH_C" "t"
}
menu_SNM_SP() {
	menu_super "$M_SNM_SP" "Pick Padding" "cont_SNM_SP" "m"
}
menu_SNM_SP_C() {
	menu_super "$M_SNM_SP_C" "Type Padding" "cont_SNM_SP_C" "t"
}
menu_SNM_NK() {
	menu_super "$M_SNM_NK" "Activation" "cont_SNM_NK" "yn"
}
menu_SNM_NP() {
	menu_super "$M_SNM_NP" "Pick Padding" "cont_SNM_NP" "m"
}
menu_SNM_NP_C() {
	menu_super "$M_SNM_NP_C" "Type Padding" "cont_SNM_NP_C" "t"
}
menu_SNM_MS() {
	[ -z $MIUI ] && echo -e "\n ${Y}MIUI only${N}" && sleep 2 && return
	menu_super "$M_SNM_MS" "Activation" "cont_SNM_MS" "yn"
}
menu_PGM() {
	menu_super "$M_PGM" "Pick Option" "cont_PGM" "m"
}
menu_PGM_SH() {
	menu_super "$M_PGM_SH" "Pick Option" "cont_PGM_SH" "m"
	if [ $PGM_SH ]; then
		unset PGM_FL PGM_FL_Y
	fi
}
menu_PGM_SH_TH() {
	menu_super "$M_PGM_SH_TH" "Pick Thickness" "cont_PGM_SH_TH" m
}
menu_PGM_SH_TH_C() {
	menu_super "$M_PGM_SH_TH_C" "Type Thickness" "cont_PGM_SH_TH_C" t
}
menu_PGM_SH_LE() {
	menu_super "$M_PGM_SH_LE" "Pick Option" "cont_PGM_SH_LE" m
}
menu_PGM_SH_LE_P() {
	menu_super "$M_PGM_SH_LE_P" "Pick Length" "cont_PGM_SH_LE_P" m
}
menu_PGM_SH_LE_P_C() {
	menu_super "$M_PGM_SH_LE_P_C" "Type Length" "cont_PGM_SH_LE_P_C" t
}
menu_PGM_SH_LE_L() {
	menu_super "$M_PGM_SH_LE_L" "Pick Length" "cont_PGM_SH_LE_L" m
}
menu_PGM_SH_LE_L_C() {
	menu_super "$M_PGM_SH_LE_L_C" "Type Length" "cont_PGM_SH_LE_L_C" t
}
menu_PGM_CL() {
	menu_super "$M_PGM_CL" "Pick Option" "cont_PGM_CL" m
	if [ $PGM_CL ]; then
		unset PGM_FL PGM_FL_Y
	fi
}
menu_PGM_CL_LH() {
	menu_super "$M_PGM_CL_LH" "Pick Light Color" "cont_PGM_CL_LH" m
}
menu_PGM_CL() {
	menu_super "$M_PGM_CL" "Pick Option" "cont_PGM_CL" m
}
menu_PGM_CL_DR() {
	menu_super "$M_PGM_CL_DR" "Pick Dark Color" "cont_PGM_CL_DR" m
}
menu_PGM_TR() {
	menu_super "$M_PGM_TR" "Pick Transparency" "cont_PGM_TR" m
	if [ $PGM_TR ]; then
		unset PGM_FL PGM_FL_Y
	fi
}
menu_PGM_IM() {
	menu_super "$M_PGM_IM" "Activation" "cont_PGM_IM" yn
	if [ $PGM_IM ]; then
		unset PGM_FL PGM_FL_Y
	fi
}
menu_PGM_FL() {
	menu_super "$M_PGM_FL" "Activation" "cont_PGM_FL" yn
	if [ $PGM_FL ]; then
		for i in $PGMNONFULL; do
			var=${i/cont_/}
			unset $var
			PARENT="$var"
			set_parent "$PARENT" "unsetVAR"
			eval var=\$${i}
			for j in $var; do
				unset $j
			done
		done
		PARENT="PGM_FL"
		set_parent "$PARENT" "setVAR"
	fi
}

menu_PGM_RK() {
	[ $MIUI ] && echo -e "\n ${Y}No need for MIUI${N}" && sleep 2 && return
	menu_super "$M_PGM_RK" "Activation" "cont_PGM_RK" yn
}


#---------------------------------- INSTALL ENVIRONMENT ---------------------------------#
# Where is the apk dir
apk_dir() {
	APKDIR=$MODLOC/${1}
	VALDIR=${APKDIR}/res/values
	DRWDIR=${APKDIR}/res/drawable
}

# Create apk
# (taken-edited from skittles9823's QuickSwitch)
create_apk() {
	aapt p -f -M ${APKDIR}/AndroidManifest.xml \
		-I /system/framework/framework-res.apk -S ${APKDIR}/res/ \
		-F ${GVMEXT}/unsigned.apk >> "$LOG" 2>&1

	if [ -s ${GVMEXT}/unsigned.apk ]; then
		cd ${GVMEXT}
		zipsigner ${GVMEXT}/unsigned.apk ${GVMEXT}/signed.apk
		cd ~
		cp -rf ${GVMEXT}/signed.apk ${GVMEXT}/${FAPK}.apk
		[ ! -s ${GVMEXT}/signed.apk ] && cp -rf ${GVMEXT}/unsigned.apk ${GVMEXT}/${FAPK}.apk
		rm -rf ${GVMEXT}/signed.apk ${GVMEXT}/unsigned.apk
	else
		log_handler "  ${1} overlay not created."
		exitERROR=true && exit 1
	fi
	[ "$API" -ge 29 ] && COPYAPK=${STEPDIR}/${DAPK} || COPYAPK=${STEPDIR}
	mkdir -p ${COPYAPK}
	cp -rf ${GVMEXT}/${FAPK}.apk ${COPYAPK}
	rm -rf ${GVMEXT}/*.apk
	if ! [ -s ${COPYAPK}/${FAPK}.apk ]; then
		log_handler "  ${1} overlay was not copied."
		exitERROR=true && exit 1
	fi
}

#---------------------------------- BACKEND ENVIRONMENT ---------------------------------#
# Cleanup
cleanup() {
	rm -rf ${GVMEXT}/temp
	rm -rf ${GVMEXT}/mods
	unmount_rw_stepdir
}

# Check overlay dir
# (taken-edited from skittles9823's QuickSwitch)
set_overlaydir() {
	MAGISK_VER_CODE=$(grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | awk -F = '{ print $2 }')
	if [ "$API" -ge 29 ]; then
	case "$(getprop ro.product.brand) $(getprop ro.product.manufacturer)" in
		*samsung*) if [ ! -d /product/overlay ]; then
					STEPDIR=${MODDIR}/system/vendor/overlay
				else
					STEPDIR=${MODDIR}/system/product/overlay
				fi;;
		*) PRODUCT=true
			if [ $MAGISK_VER_CODE -ge "20000" ]; then
				STEPDIR=${MODDIR}/system/product/overlay
			else
				log_print " ${R}Magisk v20${N} is required for users on Android 10"
				log_print " Please update Magisk and try again."
				sleep 3
				exit_error
			fi;;
	esac
	else
		if [ -d /oem/OP ]; then
			OEM=true
			is_mounted " /oem" || mount /oem
			is_mounted_rw " /oem" || mount_rw /oem
			is_mounted " /oem/OP" || mount /oem/OP
			is_mounted_rw " /oem/OP" || mount_rw /oem/OP
			STEPDIR=${MODDIR}/oem/OP/OPEN_US/overlay/framework
		else
			STEPDIR=${MODDIR}/system/vendor/overlay
		fi
	fi
	
	if [ "$OEM" ];then
		is_mounted " /oem" || mount /oem
		is_mounted_rw " /oem" || mount_rw /oem
		is_mounted " /oem/OP" || mount /oem/OP
		is_mounted_rw " /oem/OP" || mount_rw /oem/OP
	fi
}

# Check value in container
value_check() {
	for i in $1; do
			eval var=\$${i}
			if [ ${var} ]; then
				case $i in
					*_C)
						eval $2=\$${i}
						break
					;;
				esac
				var=V_${i}
				eval $2=\$${var}
				break
			fi
		done
}

# MIUI Special install method
miui_method() {
	unset LOCALTHEME
	mkdir -p $MODDIR/system/media/theme/default
	[ -f $GVMEXT/$1 ] && LOCALTHEME=true && THEMEDIR=$GVMEXT/$1 || THEMEDIR=/system/media/theme/default/$1
	[ -f $GVMEXT/${1}_last ] && THEMEDIR=$GVMEXT/$1
	if [ -f $THEMEDIR ]; then
		if ! [ -d $GVMEXT/temp/${1}stage ]; then
			mkdir -p $GVMEXT/temp/${1}stage
			cp -rf $THEMEDIR $GVMEXT/temp/${1}stage
			cd $GVMEXT/temp/${1}stage
			unzip $1
			cd ~
			[ $LOCALTHEME ] || cp -rf $GVMEXT/temp/${1}stage/$1 $GVMEXT/$1
			rm -rf $GVMEXT/temp/${1}stage/$1
		fi
		sed -i '$d' $GVMEXT/temp/${1}stage/theme_values.xml
		tail -n +3 $APKDIR/theme_values.xml >> $GVMEXT/temp/${1}stage/theme_values.xml
	else
		if ! [ -d $GVMEXT/temp/${1}stage ]; then
			mkdir -p $GVMEXT/temp/${1}stage
			[ -f $GVMEXT/${1}_last ] || touch $GVMEXT/${1}_last
			cp -rf $APKDIR/theme_values.xml $GVMEXT/temp/${1}stage/theme_values.xml
		else
			sed -i '$d' $GVMEXT/temp/${1}stage/theme_values.xml
			tail -n +3 $APKDIR/theme_values.xml >> $GVMEXT/temp/${1}stage/theme_values.xml
		fi
	fi
}

miui_method_pack() {
	if [ -d $GVMEXT/temp ]; then
		ARR="
		com.android.systemui
		framework-res
		"
		for i in $ARR; do
			! [ -d $GVMEXT/temp/${i}stage ] && continue
			mkdir -p $GVMEXT/temp/${i}stage/nightmode
			cp -rf $GVMEXT/temp/${i}stage/theme_values.xml $GVMEXT/temp/${i}stage/nightmode/theme_values.xml
			cd $GVMEXT/temp/${i}stage
			zip -Arq $i nightmode/ theme_values.xml 
			cd ~
			cp -rf $GVMEXT/temp/${i}stage/$i $MODDIR/system/media/theme/default/$i
		done
	fi
}

# UI Radius script
urm_script() {
	for i in $cont_URM; do
		eval var=\$${i}
		if [ ${var} ]; then
			case $i in
				*_C)
					eval rad=\$${i}
					break
				;;
			esac
			var=V_${i}
			eval rad=\$${var}
			break
		fi
	done
	
	INFIX=Android
	apk_dir Android
	DAPK=${PREFIX}${INFIX}
	FAPK=${PREFIX}${INFIX}${SVRLY}
	ARR="
	config
	dimens
	dimens-material
	"
	for i in $ARR; do
		sed -i "s/<val>/$rad/" ${VALDIR}/${i}.xml
	done
	create_apk "UIRadius Android"

	if [ -z $MIUI ]; then
		INFIX=SystemUI
		apk_dir SystemUI
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}Overlay
		sed -i "s/<val>/$rad/" ${VALDIR}/dimens.xml
		[ $API -ge 29 ] && find ${DRWDIR} ! -name 'rounded_ripple.xml' -type f -exec rm -f {} +
		create_apk "UIRadius SystemUI"
	else
		apk_dir SystemUI_MIUI
		sed -i "s/<val>/$rad/" ${APKDIR}/theme_values.xml
		miui_method com.android.systemui
	fi
	if [ $ISR ]; then
		PREFIX=IconShape
		ARR="
		Cylinder
		Heart
		Hexagon
		Leaf
		Mallow
		Pebble
		RoundedHexagon
		RoundedRect
		Square
		Squircle
		TaperedRect
		Teardrop
		Vessel
		"
		for i in $ARR; do
			DAPK=${PREFIX}${i}
			FAPK=${PREFIX}${i}Overlay
			apk_dir "IconShape/${i}"
			sed -i "s/<vapi>/$API/" ${APKDIR}/AndroidManifest.xml
			sed -i "s/<vcde>/$ACODE/" ${APKDIR}/AndroidManifest.xml
			create_apk "${PREFIX} ${i}"
			[ -d /system/product/overlay/${DAPK} ] || rm -rf ${STEPDIR:?}/${DAPK}
		done
	fi
}

# StatusBar & Notification script
snm_script() {
	if [ $SNM_SH ]; then
		PREFIX="G-StatusBar"
		value_check "$cont_SNM_SH" hgt
		if [ -z $MIUI ]; then
			apk_dir SBar_Height
			INFIX=Height
			DAPK=${PREFIX}${INFIX}
			FAPK=${PREFIX}${INFIX}Overlay
			sed -i "s/<val>/$hgt/" ${VALDIR}/dimens.xml
			create_apk "Statusbar Height"
		else
			apk_dir SBar_Height_MIUI
			sed -i "s/<val>/$hgt/" ${APKDIR}/theme_values.xml
			miui_method framework-res
		fi
	fi
	if [ $SNM_SP ]; then
		value_check "$cont_SNM_SP" pad
		if [ -z $MIUI ]; then
			apk_dir SBar_Padding
			INFIX=Padding
			DAPK=${PREFIX}${INFIX}
			FAPK=${PREFIX}${INFIX}Overlay
			sed -i "s/<val>/$pad/" ${VALDIR}/dimens.xml
			create_apk "Statusbar Padding"
		else
			apk_dir SBar_Padding_MIUI
			[ $API -ge 30 ] && var="_" || unset var
			sed -i "s/<var>/$var/" ${APKDIR}/theme_values.xml
			sed -i "s/<val>/$pad/" ${APKDIR}/theme_values.xml
			miui_method com.android.systemui
		fi
	fi
	if [ $SNM_NK ]; then
		apk_dir NotchKiller
		INFIX=NotchKiller
		DAPK=DisplayCutoutEmulation${INFIX}
		FAPK=DisplayCutoutEmulation${INFIX}Overlay
		sed -i "s/<vapi>/$API/" ${APKDIR}/AndroidManifest.xml
		sed -i "s/<vcde>/$ACODE/" ${APKDIR}/AndroidManifest.xml
		create_apk "G-SBar&Notification NotchKiller"
	fi
	if [ $SNM_NP ]; then
		PREFIX="G-Notification"
		value_check "$cont_SNM_NP" pad
		if [ -z $MIUI ]; then
			apk_dir Notification_Padding
			INFIX=Padding
			DAPK=${PREFIX}${INFIX}
			FAPK=${PREFIX}${INFIX}Overlay
			pad2=$(echo "scale=1;$pad + 8" | bc)
			sed -i "s/<val>/$pad/" ${VALDIR}/dimens.xml
			sed -i "s/<val2>/$pad2/" ${VALDIR}/dimens.xml
			create_apk "Notification Padding"
		else
			apk_dir Notification_Padding_MIUI
			sed -i "s/<val>/$pad/" ${APKDIR}/theme_values.xml
			miui_method com.android.systemui
		fi
	fi
	if [ $SNM_MS ]; then
		if [ $API -gt "29" ]; then
			var=status
			val=-1.1
		else
			var=notch_status
			val=-3
		fi
		apk_dir MIUI_Sbar_Bot_Pad_Fix
		sed -i "s/<var>/$var/" ${APKDIR}/theme_values.xml
		sed -i "s/<val>/$val/" ${APKDIR}/theme_values.xml
		miui_method com.android.systemui
	fi
}

# Pill Gesture script
pgm_script() {
	if [ $PGM_SH_TH ] || [ $PGM_SH_LE_P ] || [ $PGM_SH_LE_L ]; then
		apk_dir Shape
		INFIX=Shape
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}Overlay
		if [ $PGM_SH_TH ]; then
			value_check "$cont_PGM_SH_TH" thc
			if [ $thc ]; then
				thc2=$(echo "$thc + 4" | bc)
				thc3=$(echo "scale=1;$thc2 * 2 + 6" | bc)
				case $thc3 in
					*.*)
						case $thc3 in
							*0)
								eval thc3=${thc3%0*}
							;;
						esac
					;;
				esac
				sed -i "s/<val>/$thc/" ${VALDIR}/dimens.xml
				sed -i "s/<val2>/$thc2/" ${VALDIR}/dimens.xml
			fi
		else
			sed -i "/<val>/d" ${VALDIR}/dimens.xml
			sed -i "/<val2>/d" ${VALDIR}/dimens.xml
		fi
		if [ $PGM_SH_LE_P ]; then
			value_check "$cont_PGM_SH_LE_P" lenp
			sed -i "s/<val3>/$lenp/" ${VALDIR}/dimens.xml
		else
			sed -i "/<val3>/d" ${VALDIR}/dimens.xml
		fi
		if [ $PGM_SH_LE_L ]; then
			value_check "$cont_PGM_SH_LE_L" lenl
			sed -i "s/<val>/$lenl/" ${APKDIR}/res/values-land/dimens.xml
		else
			rm -rf ${APKDIR}/res/values-land
		fi
		create_apk "Pill Shape"
	fi
	if [ -z $MIUI ]; then
		apk_dir "Config/AOSP"
		PREFIX="NavigationBarModeGestural"
	else
		apk_dir "Config/MIUI"
		INFIX=Config
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}Overlay
	fi

	DEF1=16
	DEF2=48
	DEF3=32
	
	if [ $PGM_FL ]; then
		SVAL1=0
		SVAL2=0
		SVAL3=20
	fi

	if [ $PGM_IM ]; then
		if [ -z $MIUI ]; then
			SVAL1=0.1
			if [ $thc3 ]; then
				[ $PGM_RK ] && SVAL2=$thc3 || SVAL2=$DEF2
			else
				[ $PGM_RK ] && SVAL2=$DEF1 || SVAL2=$DEF2
			fi
			[ $thc3 ] && SVAL3=$(echo "$thc3 + 16" | bc) || SVAL3=$DEF3
		else
			SVAL1=0.1
			if [ $API -gt "10" ]; then
				SVAL2=16
			else
				[ $thc3 ] && SVAL2=$thc3
			fi
		fi
	elif [ $thc3 ]; then
		SVAL1=$thc3
		[ $MIUI ] || [ $PGM_RK ] && SVAL2=$thc3 || SVAL2=$DEF2
		SVAL3=$(echo "$thc3 + 16" | bc)
	elif [ $PGM_RK ]; then
		SVAL1=$DEF1
		SVAL2=$DEF1
		SVAL3=$DEF3
	fi
	
	if [ $PGM_RK ]; then
		if grep 'ro.com.google.ime.kb_pad_port_b' /data/adb/modules/rboard-themes_addon/system.prop /data/adb/modules/gboardnavbar/system.prop; then
			:
		else
			# Originally from RKBDI's nospacing)
			mv -f /data/adb/modules/$ID/nospacing.prop /data/adb/modules/$ID/system.prop
		fi
	fi
	
	if [ $MIUI ]; then
		if [ $PGM_FL ] || [ -z $SVAL2 ]; then
			sed -i "5,6d" ${VALDIR}/dimens.xml
		fi
	fi
	
	if [ $SVAL1 ]; then
		sed -i "s/<val>/$SVAL1/" ${VALDIR}/dimens.xml
		sed -i "s/<val2>/$SVAL2/" ${VALDIR}/dimens.xml
		if [ -z $MIUI ]; then
			ARR="
			values-sw600dp
			values-sw720dp
			values-sw900dp
			"
			for i in $ARR; do
				sed -i "s/<val>/$SVAL1/" ${APKDIR}/res/${i}/dimens.xml
			done
			sed -i "s/<val3>/$SVAL3/" ${VALDIR}/dimens.xml
			sed -i "s/<vapi>/$API/" ${APKDIR}/AndroidManifest.xml
			sed -i "s/<vcde>/$ACODE/" ${APKDIR}/AndroidManifest.xml
			DAPK=${PREFIX}
			FAPK=${PREFIX}Overlay
			sed -i "s/<valc>/24/" ${VALDIR}/config.xml
			sed -i "s/<vals>/gestural/" ${APKDIR}/AndroidManifest.xml
			create_apk Config
			ARR="
			NarrowBack
			WideBack
			ExtraWideBack
			"
			for i in $ARR; do
				DAPK=${PREFIX}${i}
				FAPK=${PREFIX}Overlay${i}
				case $i in
					Narrow*)
						SVAL2=18
						SVALS2="gestural_narrow_back"
						CHNG="24"
						CHNG1="gestural"
						WTH="$SVAL2"
						WTH1="$SVALS2"
					;;
					Wide*)
						SVAL3=32
						SVALS3="gestural_wide_back"
						CHNG="$SVAL2"
						CHNG1="$SVALS2"
						WTH="$SVAL3"
						WTH1="$SVALS3"
					;;
					Extra*)
						SVAL4=40
						SVALS4="gestural_extra_wide_back"
						CHNG="$SVAL3"
						CHNG1="$SVALS3"
						WTH="$SVAL4"
						WTH1="$SVALS4"
					;;
				esac
				sed -i "s/$CHNG/$WTH/" ${VALDIR}/config.xml
				sed -i "s/$CHNG1/$WTH1/" ${APKDIR}/AndroidManifest.xml
				create_apk Config
			done
		else
			create_apk Config
			mkdir -p ${MODDIR}/system/vendor/overlay
			apk_dir MIUI
			sed -i "s/<vapi>/$API/" ${APKDIR}/AndroidManifest.xml
			sed -i "s/<vcde>/$ACODE/" ${APKDIR}/AndroidManifest.xml
			ARR="
			values
			values-440dpi-v4
			values-xhdpi-v4
			values-xxhdpi-v4
			values-xxxhdpi-v4
			"
			for i in $ARR; do
				sed -i "s/<val>/$SVAL1/" ${APKDIR}/res/${i}/dimens.xml
			done
			DAPK=GestureLine
			FAPK=GestureLineOverlay
			create_apk GestureLine
			mv -f ${STEPDIR}/${DAPK}/GestureLineOverlay.apk ${MODDIR}/system/vendor/overlay/GestureLineOverlay.apk
			rm -rf ${STEPDIR}/${DAPK}
		fi
	fi

	if [ $PGM_CL_LH ] || [ $PGM_CL_DR ] || [ $PGM_TR ] ; then
		apk_dir Color
		INFIX=Color
		DAPK=${PREFIX}${INFIX}
		FAPK=${PREFIX}${INFIX}Overlay
		value_check "$cont_PGM_CL_LH" lcl
		value_check "$cont_PGM_CL_DR" dcl
		if [ -z $PGM_TR ]; then
			ltr=EB
			dtr=99
		else
			value_check "$cont_PGM_TR" tr
			ltr=$tr
			dtr=$tr
		fi
		if [ -z $lcl ]; then
			lcl=FFFFFF
		fi
		if [ -z $dcl ]; then
			dcl=000000
		fi
		unset var
		[ -z $MIUI ] && var="bar_home_" || [ $API -ge 30 ] && var="bar_home_"
		sed -i "s/<var>/$var/" ${VALDIR}/colors.xml
		sed -i "s/<lclr>/$lcl/" ${VALDIR}/colors.xml
		sed -i "s/<ltrp>/$ltr/" ${VALDIR}/colors.xml
		sed -i "s/<dclr>/$dcl/" ${VALDIR}/colors.xml
		sed -i "s/<dtrp>/$dtr/" ${VALDIR}/colors.xml
		create_apk "Pill Color"
	fi
}
