# MIUI Exception
if [ -f $VEN/build.prop ]; then
	BUILDS="/system/build.prop $VEN/build.prop";
else
	BUILDS="/system/build.prop";
fi
MIUI=$(grep "ro.miui.ui.version.*" $BUILDS)
if [ $MIUI ]; then
	ui_print " "
	ui_print " "
	ui_print " MIUI Detected"
	ui_print " Only SBH supported"
	ui_print " "
	ui_print " "
else
	MIUI=
fi

# Zipname Simplifier
zo_urm() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*urmm*) URM=true; URMR=false; URMM=true; URML=false;;
		*urml*) URM=true; URMR=false; URMM=false; URML=true;;
		*urmr*) URM=true; URMR=true; URMM=false; URML=false;;
	esac
}
zo_sbh() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*sbhm*) SBH=true; SBHM=true; SBHL=false; SBHXL=false;;
		*sbhl*) SBH=true; SBHM=false; SBHL=true; SBHXL=false;;
		*sbhxl*) SBH=true; SBHM=false; SBHL=false; SBHXL=true;;
	esac
}
zo_nk() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*nky*) NK=true;;
	esac
}
zo_wg() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*wgy*) WG=true;;
	esac
}

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
	zo_wg
	IFS=$OIFS
fi

# Chooser Simplifier
c_urm() {
	if [ -z $URM ] || [ -z $URMM ] || [ -z $URML ]; then
     	ui_print "   ----- UI Radius Mod ------"
		ui_print " "
		ui_print "   Change your UI radius."
		ui_print " "
		ui_print " "
		ui_print "   Install UI Radius Mod?"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		if $VKSEL; then
			ui_print " "
			ui_print " "
			ui_print "   Install RoundyUI or RectangUI?"
			ui_print " "
			ui_print "   Vol+ = RoundyUI, Vol- = RectangUI"
			URM=true
			if $VKSEL; then
				ui_print " "
				ui_print " "
				ui_print "   Pick radius"
				ui_print " "
				ui_print "   Vol+ = Medium, Vol- = Large"
				URMR=false
				if $VKSEL; then
					URMM=true
				else
					URML=true
				fi
			else
				URMR=true
			fi
		else
			URM=false
		fi
	else
		ui_print "   UI Radius Mod install method specified in zipname!"
	fi
}
c_sbh() {
	if [ -z $SBH ] || [ -z $SBHM ] || [ -z $SBHL ] || [ -z $SBHXL ]; then
    	ui_print " "
		ui_print " "
       	ui_print "   ------ StatusBar Height Mod ------"
		ui_print " "
		ui_print "   Change your StatusBar Height like having a notch."
		ui_print " "
		ui_print " "
		ui_print "   Install StatusBar Height Mod?"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		if $VKSEL; then
			ui_print " "
			ui_print " "
			ui_print "   Size list:"
			ui_print " - Medium (Comfort looking)"
			ui_print " - Large (Match your lockscreen statusbar)"
			ui_print " - eXtra Large (Same height as your navbar)"
			ui_print " "
			ui_print " "
			ui_print "   Read above then pick height:"
			ui_print " "
			ui_print "   Vol+ = Medium, Vol- = Other sizes"
			SBH=true
			if $VKSEL; then
				SBHM=true				
			else
			    ui_print " "
			    ui_print " "
				ui_print "   Pick remaining height:"
				ui_print " "
				ui_print "   Vol+ = Large, Vol- = eXtra Large"
				if $VKSEL; then
					SBHL=true
				else
					SBHXL=true	
				fi
			fi
		else
			SBH=false
		fi
	else
     	ui_print "   StatusBar Height Mod install method specified in zipname!"
	fi
}
c_nk() {
	if [ -z $NK ]; then
    	ui_print " "
		ui_print " "
  		ui_print "   ----- NotchKiller -----"
   		ui_print " "
    	ui_print "   Override notch, always full screen."
 	    ui_print " "
    	ui_print " "
   		ui_print "   Install NotchKiller?"
    	ui_print " "
    	ui_print "   Vol+ = Yes, Vol- = No"
       	if $VKSEL; then
       		NK=true
       	else
       	    NK=false
       	fi
    else
        ui_print "   NotchKiller install method specified in zipname!"
	fi
}
c_wg() {
	if [ $API -lt "29" ]; then
	    WG=false
	else
		if [ -z $WG ]; then
			ui_print " "
			ui_print " "
			ui_print "   ----- Wide Gesture -----"
			ui_print " "
			ui_print "   Resize home gesture like an Iphone"
			ui_print " "
			ui_print " "
			ui_print "   Install Wide Gesture?"
			ui_print " "
			ui_print "   Vol+ = Yes, Vol- = No"
			if $VKSEL; then
				WG=true
			else
				WG=false
			fi
		else
			ui_print "   Wide Gesture install method specified in zipname!"
		fi
	fi
}

# Chooser
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
	if [ -z $URM ] || [ -z $SBH ] || [ -z $NK ] || [ -z $WG ]; then
		if [ -z $VKSEL ]; then
			ui_print "  ! Some options not specified in zipname!"
			ui_print "  Using defaults if not specified in zipname!"
			[ -z $URM ] && URM=true; URMM=true
			[ -z $SBH ] && SBH=true; SBHM=true
			[ -z $NK ] && NK=false
			[ -z $WG ] && WG=True
		else
			c_urm
			c_sbh
			c_nk
			c_wg
		fi
	else
	  ui_print "   Options specified in zipname!"
	fi

ui_print " "
ui_print " "
ui_print "-  Preparing  -"
ui_print " "
ui_print " "

OVRINST=$VEN/overlay
if [ -d $OVRINST ]; then
	ui_print " "
	ui_print " "
	ui_print "	Overlay folder located!"
	ui_print " "
	ui_print " "
else
	ui_print " "
	ui_print " "
	ui_print "	Overlay folder missing, creating..."
	ui_print " "
	ui_print " "
	mkdir $VEN/overlay
fi

ui_print " "
ui_print " "
ui_print "-  Installing  -"
ui_print " "
ui_print " "

if $URM; then
	ui_print "-  UI Radius Mod Selected  -"
	aapt p -f -v -M ${OVERLAYDIR}/AndroidManifest.xml \
                -I /system/framework/framework-res.apk -S ${OVERLAYDIR}/overlay/ \
                -F ${MODDIR}/unsigned.apk &>$MODDIR/logs/aapt.log

if $URM; then
	ui_print "-  UI Radius Mod Selected  -"
	if $URMM; then
		ui_print "-  RoundyUI Medium Selected  -"
		cp -f $TMPDIR/apk/URM_M.apk $TMPDIR/system/vendor/overlay
		cp -f $TMPDIR/apk/URM_M2.apk $TMPDIR/system/vendor/overlay
		cp -f $TMPDIR/apk/URM_M3.apk $TMPDIR/system/vendor/overlay
	elif $URML; then
		ui_print "-  RoundyUI Large Selected  -"
		cp -f $TMPDIR/apk/URM_L.apk $TMPDIR/system/vendor/overlay
		cp -f $TMPDIR/apk/URM_L2.apk $TMPDIR/system/vendor/overlay
		cp -f $TMPDIR/apk/URM_L3.apk $TMPDIR/system/vendor/overlay
	elif $URMR; then
    	ui_print "-  RectangUI Selected  -"
    	cp -f $TMPDIR/apk/URM_R.apk $TMPDIR/system/vendor/overlay
    	cp -f $TMPDIR/apk/URM_R2.apk $TMPDIR/system/vendor/overlay
    	cp -f $TMPDIR/apk/URM_R3.apk $TMPDIR/system/vendor/overlay
    fi
fi


if $SBH; then
	ui_print "-  StatusBar Height Selected  -"
	if $SBHM; then
		ui_print "-  StatusBar Height Medium Selected  -"
		cp -f $TMPDIR/apk/SBH_M.apk $TMPDIR/system/vendor/overlay
	elif $SBHL; then
		ui_print "-  StatusBar Height Large Selected  -"
		cp -f $TMPDIR/apk/SBH_L.apk $TMPDIR/system/vendor/overlay
	elif $SBHXL; then
		ui_print "-  StatusBar Height eXtra Large Selected  -"
		cp -f $TMPDIR/apk/SBH_XL.apk $TMPDIR/system/vendor/overlay
	fi
fi

if $NK; then
	ui_print "-  NotchKiller Selected  -"
	cp -r -f $TMPDIR/apk/DisplayCutoutEmulationZigafide $TMPDIR/system/vendor/overlay
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
  	if $VKSEL; then
      	ui_print "  Completing Installation...."
    else
      	ui_print "  Completing Installation...."
    fi
fi