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
VEN=/system/vendor
[ -L /system/vendor ] && VEN=/vendor
if [ -f $VEN/build.prop ]; then BUILDS="/system/build.prop $VEN/build.prop"; else BUILDS="/system/build.prop"; fi
# Thanks Narsil/Sauron for the huge props list for various android systems
# Far easier to look there then ask users for their build.props
MIUI=$(grep "ro.miui.ui.version.*" $BUILDS)
if [ $MIUI ]; then
	ui_print " "
	ui_print " "
	ui_print " MIUI Detected"
	ui_print " Only StatusBar Height supported"
	ui_print " "
	ui_print " "
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
zo_pg() {
	case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
		*pgy*) PG=true;;
	esac
}

# Chooser Simplifier
c_urm() {
	if [ -z $URM ] || [ -z $URMM ] || [ -z $URML ]; then
     	ui_print "   ----- UI Radius Mod ------"
		ui_print " "
		ui_print "   Change your UI's corner radius."
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
				ui_print "   Pick variant for UI"
				ui_print " "
				ui_print "   Vol+ = Medium, Vol- = Large"
				if $VKSEL; then
					URMM=true
				else
					URML=true
				fi
				ui_print " "
				ui_print " "
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
    	ui_print " "
		ui_print " "
       	ui_print "   ------ StatusBar Height Mod ------"
		ui_print " "
		ui_print "   Make your statusbar taller (Notched display)."
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
			ui_print " - eXtra Large (Same height as classic 3 buttons navbar)"
			ui_print " "
			ui_print " "
			ui_print "   OK, now pick height:"
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
    	ui_print "   Override notch, always full screen in all appps."
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
c_pg() {
	if [ $API -lt "29" ]; then
	    PG=false
	else
		if [ -z $PG ]; then
			ui_print " "
			ui_print " "
			ui_print "   ----- 10's Pill Gesture -----"
			ui_print " "
			ui_print "   Widen your Android 10's pill gesture."
			ui_print " "
			ui_print " "
			ui_print "   Install 10's Pill Gesture?"
			ui_print " "
			ui_print "   Vol+ = Yes, Vol- = No"
			if $VKSEL; then
				PG=true
			    ui_print " "
			    ui_print " "
				ui_print "   Pick variant:"
				ui_print " "
				ui_print "   Vol+ = Thick and adjusted (IOS like position)"
				ui_print "   Vol- = Just wide and thin"
				if $VKSEL; then
					PGIOS=true
				else
					PGTH=true	
				fi
			else
				PG=false
			fi
		else
			ui_print "   Wide Gesture install method specified in zipname!"
		fi
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
