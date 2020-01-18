##########################################################################################
#
# MMT Extended Config Script
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maximum android version for your mod
# Uncomment DYNLIB if you want libs installed to vendor for oreo+ and system for anything older
# Uncomment DEBUG if you want full debug logs (saved to /sdcard)
MINAPI=28
#MAXAPI=25
#DYNLIB=true
DEBUG=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
# Custom Logic
##########################################################################################

# Spaces
sp() {
	ui_print " "
	ui_print " "
}

# Zipname Simplifier
zp_urm() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*urmm*) URM=true; URMR=false; URMM=true; URML=false; URMVL=true ;;
		*urml*) URM=true; URMR=false; URMM=false; URML=true; URMVM=true ;;
		*urmr*) URM=true; URMR=true; URMM=false; URML=false;;
	esac
}
zp_sbh() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*sbhm*) SBH=true; SBHM=true; SBHL=false; SBHXL=false;;
		*sbhl*) SBH=true; SBHM=false; SBHL=true; SBHXL=false;;
		*sbhxl*) SBH=true; SBHM=false; SBHL=false; SBHXL=true;;
	esac
}
zp_nk() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*nky*) NK=true;;
	esac
}
zp_pg() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*pgios*) PG=true; PGIOS=true; PGIM=false;;
		*pgiosm*) PG=true; PGIOS=true; PGIM=false;;
		*pgnth*) PG=true; PGIOS=true; PGIM=false;;
		*pgnthm*) PG=true; PGIOS=true; PGIM=false;;
		*pgth*) PG=true; PGIOS=true; PGIM=false;;
		*pgthm*) PG=true; PGIOS=true; PGIM=false;;
		*pgdot*) PG=true; PGIOS=true; PGIM=false;;
		*pginv*) PG=true; PGIOS=true; PGIM=false;;
	esac
}

# Chooser Simplifier
c_urm() {
	if [ -z $URM ] || [ -z $URMM ] || [ -z $URML ]; then
		sp
     	ui_print "   ----- UI Radius Mod ------"
		ui_print " "
		ui_print "   Change your UI's corner radius."
		sp
		ui_print "   Install UI Radius Mod?"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		if $VKSEL; then
			sp
			ui_print "   Install RoundyUI or RectangUI?"
			ui_print " "
			ui_print "   Vol+ = RoundyUI, Vol- = RectangUI"
			URM=true
			if $VKSEL; then
				sp
				ui_print "   Pick variant for UI"
				ui_print " "
				ui_print "   Vol+ = Medium, Vol- = Large"
				if $VKSEL; then
					URMM=true
				else
					URML=true
				fi
				sp
				ui_print "   Pick variant for Vol.bar"
				ui_print " "
				ui_print "   Vol+ = Medium, Vol- = Large"
				if $VKSEL; then
					URMVM=true
				else
					URMVL=true
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
		sp
       	ui_print "   ------ StatusBar Height Mod ------"
		ui_print " "
		ui_print "   Make your statusbar taller (Notched display)."
		sp
		ui_print "   Install StatusBar Height Mod?"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		if $VKSEL; then
			sp
			ui_print "   Size list:"
			ui_print " - Medium (Comfort looking)"
			ui_print " - Large (Match your lockscreen statusbar)"
			ui_print " - eXtra Large (Same height as classic 3 buttons navbar)"
			sp
			ui_print "   OK, now pick height:"
			ui_print " "
			ui_print "   Vol+ = Medium, Vol- = Other sizes"
			SBH=true
			if $VKSEL; then
				SBHM=true				
			else
				sp
				ui_print "   Pick remaining heights:"
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
		sp
  		ui_print "   ----- NotchKiller Mod -----"
   		ui_print " "
    	ui_print "   Override notch, always full screen in all apps."
		sp
   		ui_print "   Install NotchKiller Mod?"
    	ui_print " "
    	ui_print "   Vol+ = Yes, Vol- = No"
       	if $VKSEL; then
       		NK=true
       	else
       	    NK=false
       	fi
    else
        ui_print "   NotchKiller Mod install method specified in zipname!"
	fi
}
c_pg() {
	if [ $API -lt "29" ]; then
	    PG=false
	else
		if [ -z $PG ]; then
			sp
			ui_print "   ----- 10's Pill Gesture Mod -----"
			ui_print " "
			ui_print "   Change your Android 10's pill gesture looks."
			sp
			ui_print "   Install 10's Pill Gesture Mod?"
			ui_print " "
			ui_print "   Vol+ = Yes, Vol- = No"
			if $VKSEL; then
				PG=true
				sp
				ui_print "   Mode list:"
				ui_print " - Wide mode (Thickness and Immersive option available)"
				ui_print " - Dot mode (Cute immersive dot)"
				ui_print " - Invinsible mode (Hidden + Immersive)"
				sp
				ui_print "   Choose modes:"
				ui_print " "
				ui_print "   Vol+ = Wide mode, Vol- = Other modes"
				if $VKSEL; then
					PGWD=true
					sp
					ui_print "   Thickness list:"
					ui_print " - Thicc (IOS looks + position)"
					ui_print " - Not thicc or thin (OOS looks)"
					ui_print " - Thinn (Original thickness)"
					sp
					ui_print "   Pick thickness:"
					ui_print " "
					ui_print "   Vol+ = Thicc, Vol- = Other sizes"
					ui_print "   "
					if $VKSEL; then
						PGIOS=true
					else
						sp
						ui_print "   Pick remaining thickness:"
						ui_print " "
						ui_print "   Vol+ = Not thicc or thin, Vol- = Thinn"
						ui_print "   "
						if $VKSEL; then
							PGNTH=true
						else
							PGTH=true	
						fi	
					fi
					sp
					ui_print "   Activate Immersive mode?"
					ui_print " "
					ui_print "   Vol+ = Yes, Vol- = No"
					if $VKSEL; then
						PGIM=true
					else
						PGIM=false	
					fi
				else
					sp
					ui_print "   Pick remaining modes:"
					ui_print " "
					ui_print "   Vol+ = Dot mode, Vol- = Invinsible mode"
					if $VKSEL; then
						PGDOT=true
					else
						PGINV=false	
					fi
				fi

			else
				PG=false
			fi
		else
			ui_print "   10's Pill Gesture Mod install method specified in zipname!"
		fi
	fi
}

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
	if [ -d "/product/overlay" ]; then
		PRODUCT=true
		# Yay, magisk supports bind mounting /product now
		MAGISK_VER_CODE=$(grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | awk -F = '{ print $2 }')
		if [ $MAGISK_VER_CODE -ge "20000" ]; then
			MOUNTPRODUCT=
			STEPDIR=$MODPATH/system/product/overlay
		else
			if [ $(resetprop ro.build.version.sdk) -ge 29 ]; then
				echo "Magisk v20 is required for users on Android 10"
				echo "Please update Magisk and try again."
				exit 1
			fi
			MOUNTPRODUCT=true
			STEPDIR=/product/overlay
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
		STEPDIR=$MODPATH/system/vendor/overlay
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

set_permissions() {
  : # Remove this if adding to this function

  # Note that all files/folders in magisk module directory have the $MODPATH prefix - keep this prefix on all of your files/folders
  # Some examples:
  
  # For directories (includes files in them):
  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  
  # set_perm_recursive $MODPATH/system/lib 0 0 0755 0644
  # set_perm_recursive $MODPATH/system/vendor/lib/soundfx 0 0 0755 0644

  # For files (not in directories taken care of above)
  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  
  # set_perm $MODPATH/system/lib/libart.so 0 0 0644
  # set_perm /data/local/tmp/file.txt 0 0 644
}

# Custom Variables for Install AND Uninstall - Keep everything within this function - runs before uninstall/install
custom() {
  : # Remove this if adding to this function
}

# Custom Functions for Install AND Uninstall - You can put them here

##########################################################################################
# MMT Extended Logic - Don't modify anything after this
##########################################################################################

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
