##########################################################################################
#
# Unity (Un)Install Utility Functions
# Adapted from topjohnwu's Magisk General Utility Functions
#
# Magisk util_functions is still used and will override any listed here
# They're present for system installs
#
##########################################################################################

###################
# Helper Functions
###################

ui_print() {
  $BOOTMODE && echo "$1" || echo -e "ui_print $1\nui_print" >> /proc/self/fd/$OUTFD
}

toupper() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

grep_cmdline() {
  local REGEX="s/^$1=//p"
  cat /proc/cmdline | tr '[:space:]' '\n' | sed -n "$REGEX" 2>/dev/null
}

grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  sed -n "$REGEX" $FILES 2>/dev/null | head -n 1
}

is_mounted() {
  grep -q " `readlink -f $1` " /proc/mounts 2>/dev/null
  return $?
}

abort() {
  cleanup -a "$1"
}

######################
# Environment Related
######################

setup_flashable() {
  # Preserve environment varibles
  OLD_PATH=$PATH
  ensure_bb
  $BOOTMODE && return
  if [ -z $OUTFD ] || readlink /proc/$$/fd/$OUTFD | grep -q /tmp; then
    # We will have to manually find out OUTFD
    for FD in `ls /proc/$$/fd`; do
      if readlink /proc/$$/fd/$FD | grep -q pipe; then
        if ps | grep -v grep | grep -q " 3 $FD "; then
          OUTFD=$FD
          break
        fi
      fi
    done
  fi
}

ensure_bb() {
  ARCH32=`getprop ro.product.cpu.abi | cut -c-3`
  [ -z $ARCH32 ] && ARCH32=`getprop ro.product.cpu.abi2 | cut -c-3`
  [ -z $ARCH32 ] && ARCH32=arm
  if [ -x $MAGISKTMP/busybox/busybox ]; then
    [ -z $BBDIR ] && BBDIR=$MAGISKTMP/busybox
  elif [ -x $TMPDIR/bin/busybox ]; then
    [ -z $BBDIR ] && BBDIR=$TMPDIR/bin
  else
    [ -z $BBDIR ] && BBDIR=$TMPDIR/bin
    mkdir -p $BBDIR 2>/dev/null
    cp -f $UF/tools/$ARCH32/busybox $BBDIR/busybox 2>/dev/null
    chmod 755 $BBDIR/busybox
    $BBDIR/busybox --install -s $BBDIR
  fi
  echo $PATH | grep -q "^$BBDIR" || export PATH=$BBDIR:$PATH
}

recovery_actions() {
  [ -d /system/apex ] && mount_apex
  # Make sure random don't get blocked
  mount -o bind /dev/urandom /dev/random
  # Unset library paths
  OLD_LD_LIB=$LD_LIBRARY_PATH
  OLD_LD_PRE=$LD_PRELOAD
  OLD_LD_CFG=$LD_CONFIG_FILE
  unset LD_LIBRARY_PATH
  unset LD_PRELOAD
  unset LD_CONFIG_FILE
  # Force our own busybox path to be in the front
  # and do not use anything in recovery's sbin
  export PATH=$BBDIR:/system/bin:/vendor/bin
}

recovery_cleanup() {
  ui_print "- Unmounting partitions"
  [ "$supersuimg" -o -d /su ] && umount /su 2>/dev/null
  [ -d /system/apex ] && umount_apex
  umount -l /system_root 2>/dev/null
  umount -l /system 2>/dev/null
  umount -l /vendor 2>/dev/null
  umount -l /dev/random 2>/dev/null
  [ -z $OLD_PATH ] || export PATH=$OLD_PATH
  [ -z $OLD_LD_LIB ] || export LD_LIBRARY_PATH=$OLD_LD_LIB
  [ -z $OLD_LD_PRE ] || export LD_PRELOAD=$OLD_LD_PRE
  [ -z $OLD_LD_CFG ] || export LD_CONFIG_FILE=$OLD_LD_CFG
}

debug_log() {
  $BOOTMODE && local LOG=/storage/emulated/0/$MODID-debug || local LOG=/data/media/0/$MODID-debug
  set +x
  echo -e "***---Device Info---***" > $LOG-tmp.log
  echo -e "\n---Props---\n" >> $LOG-tmp.log
  getprop >> $LOG-tmp.log
  if $MAGISK; then
    echo -e "\n\n***---Magisk Info---***" >> $LOG-tmp.log
    echo -e "\n---Magisk Version---\n\n$MAGISK_VER_CODE" >> $LOG-tmp.log
    echo -e "\n---Installed Modules---\n" >> $LOG-tmp.log
    ls $NVBASE/modules >> $LOG-tmp.log
    echo -e "\n---Last Magisk Log---\n" >> $LOG-tmp.log
    [ -d /cache ] && cat /cache/magisk.log >> $LOG-tmp.log || cat /data/cache/magisk.log >> $LOG-tmp.log
  fi
  echo -e "\n\n***---Unity Debug Info---***" >> $LOG-tmp.log
  echo -e "\n---Installed Files---\n" >> $LOG-tmp.log
  grep "^+* cp_ch" $LOG.log | sed 's/.* //g' >> $LOG-tmp.log
  sed -i "\|$TMPDIR/|d" $LOG-tmp.log
  echo -e "\n---Installed Boot Scripts---\n" >> $LOG-tmp.log
  grep "^+* install_script" $LOG.log | sed -e 's/.* //g' -e 's/^-.* //g' >> $LOG-tmp.log
  echo -e "\n---Installed Prop Files---\n" >> $LOG-tmp.log
  grep "^+* prop_process" $LOG.log | sed 's/.* //g' >> $LOG-tmp.log
  echo -e "\n---Shell & Unity Variables---\n" >> $LOG-tmp.log
  (set) >> $LOG-tmp.log
  echo -e "\n---(Un)Install Log---\n" >> $LOG-tmp.log
  echo "$(cat $LOG.log)" >> $LOG-tmp.log
  mv -f $LOG-tmp.log $LOG.log
}

cleanup() {
  [ "$1" == "-a" ] && local ERROR=true || local ERROR=false
  $ERROR && { ui_print "$2"; rm -rf $MODPATH $TMPDIR 2>/dev/null; }
  $BOOTMODE || recovery_cleanup
  if ! $ERROR; then
    $MAGISK && { rm -rf $MODPATH/common 2>/dev/null; rm -f $MODPATH/system/placeholder $MODPATH/customize.sh $MODPATH/README.md $MODPATH/.git* 2>/dev/null; }
    ui_print " "
    ui_print "    *******************************************"
    ui_print "    *    Unity by ahrion & zackptg5 @ XDA     *"
    ui_print "    *******************************************"
    ui_print " "
  fi
  $DEBUG && debug_log
  $ERROR && exit 1
  [ -d "$MODPATH/common/addon/Aroma-Installer" ] && { rm -rf $TMPDIR; sleep 3; reboot recovery; } || { rm -rf $TMPDIR; exit 0; }
}

find_block() {
  for BLOCK in "$@"; do
    DEVICE=`find /dev/block -type l -iname $BLOCK | head -n 1` 2>/dev/null
    if [ ! -z $DEVICE ]; then
      readlink -f $DEVICE
      return 0
    fi
  done
  # Fallback by parsing sysfs uevents
  for uevent in /sys/dev/block/*/uevent; do
    local DEVNAME=`grep_prop DEVNAME $uevent`
    local PARTNAME=`grep_prop PARTNAME $uevent`
    for BLOCK in "$@"; do
      if [ "`toupper $BLOCK`" = "`toupper $PARTNAME`" ]; then
        echo /dev/block/$DEVNAME
        return 0
      fi
    done
  done
  return 1
}

# mount_name <partname> <mountpoint> <flag>
mount_name() {
  local PART=$1
  local POINT=$2
  local FLAG=$3
  [ -L $POINT ] && rm -f $POINT
  mkdir -p $POINT 2>/dev/null
  is_mounted $POINT && return
  ui_print "- Mounting $POINT"
  # First try mounting with fstab
  mount $FLAG $POINT 2>/dev/null
  if ! is_mounted $POINT; then
    local BLOCK=`find_block $PART`
    mount $FLAG $BLOCK $POINT
  fi
  is_mounted $POINT || abort "! Cannot mount $POINT"
}

mount_ro_ensure() {
  # We handle ro partitions only in recovery if magisk
  $BOOTMODE && return
  local PART=$1$SLOT
  local POINT=/$1
  $MAGISK && mount_name $PART $POINT '-o ro' || mount_name $PART $POINT '-o rw'
  is_mounted $POINT || abort "! Cannot mount $POINT"
}

mount_partitions() {
  # Check A/B slot
  SLOT=`grep_cmdline androidboot.slot_suffix`
  if [ -z $SLOT ]; then
    SLOT=`grep_cmdline androidboot.slot`
    [ -z $SLOT ] || SLOT=_${SLOT}
  fi
  [ -z $SLOT ] || ui_print "- Current boot slot: $SLOT"

  # Mount ro partitions
  mount_ro_ensure system
  if [ -f /system/init.rc ]; then
    SYSTEM_ROOT=true
    [ -L /system_root ] && rm -f /system_root
    mkdir /system_root 2>/dev/null
    mount --move /system /system_root
    mount -o bind /system_root/system /system
  else
    grep -qE '/dev/root|/system_root' /proc/mounts && SYSTEM_ROOT=true || SYSTEM_ROOT=false
  fi
  [ -L /system/vendor ] && mount_ro_ensure vendor
  $SYSTEM_ROOT && ui_print "- Device is system-as-root"

  # Persist partitions for module install in recovery
  if $MAGISK && ! $BOOTMODE && [ ! -z $PERSISTDIR ]; then
    # Try to mount persist
    PERSISTDIR=/persist
    mount_name persist /persist
    if ! is_mounted /persist; then
      # Fallback to cache
      mount_name cache /cache
      is_mounted /cache && PERSISTDIR=/cache || PERSISTDIR=
    fi
  fi
}

api_level_arch_detect() {
  API=`grep_prop ro.build.version.sdk`
  ABI=`grep_prop ro.product.cpu.abi | cut -c-3`
  ABI2=`grep_prop ro.product.cpu.abi2 | cut -c-3`
  ABILONG=`grep_prop ro.product.cpu.abi`

  ARCH=arm
  ARCH32=arm
  IS64BIT=false
  if [ "$ABI" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
  if [ "$ABI2" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
  if [ "$ABILONG" = "arm64-v8a" ]; then ARCH=arm64; ARCH32=arm; IS64BIT=true; fi;
  if [ "$ABILONG" = "x86_64" ]; then ARCH=x64; ARCH32=x86; IS64BIT=true; fi;
}

supersuimg_mount() {
  supersuimg=$(ls /cache/su.img /data/su.img 2>/dev/null)
  if [ "$supersuimg" ]; then
    if ! is_mounted /su; then
      ui_print "- Mounting /su"
      [ -d /su ] || mkdir /su 2>/dev/null
      mount -t ext4 -o rw,noatime $supersuimg /su 2>/dev/null
      for i in 0 1 2 3 4 5 6 7; do
        is_mounted /su && break
        local loop=/dev/block/loop$i
        mknod $loop b 7 $i
        losetup $loop $supersuimg
        mount -t ext4 -o loop $loop /su 2>/dev/null
      done
    fi
  fi
}

mount_apex() {
  [ -e /apex/* ] && return 0
  # Mount apex files so dynamic linked stuff works
  [ -L /apex ] && rm -f /apex
  # Apex files present - needs to extract and mount the payload imgs
  if [ -f "/system/apex/com.android.runtime.release.apex" ]; then
    local j=0
    [ -e /dev/block/loop1 ] && local minorx=$(ls -l /dev/block/loop1 | awk '{print $6}') || local minorx=1
    for i in /system/apex/*.apex; do
      local DEST="/apex/$(basename $i | sed 's/.apex$//')"
      [ "$DEST" == "/apex/com.android.runtime.release" ] && DEST="/apex/com.android.runtime"
      mkdir -p $DEST
      unzip -qo $i apex_payload.img -d /apex
      mv -f /apex/apex_payload.img $DEST.img
      while [ $j -lt 100 ]; do
        local loop=/dev/loop$j
        mknod $loop b 7 $((j * minorx)) 2>/dev/null
        losetup $loop $DEST.img 2>/dev/null
        j=$((j + 1))
        losetup $loop | grep -q $DEST.img && break
      done;
      uloop="$uloop $((j - 1))"
      mount -t ext4 -o loop,noatime,ro $loop $DEST || return 1
    done
  # Already extracted payload imgs present, just mount the folders
  elif [ -d "/system/apex/com.android.runtime.release" ]; then
    for i in /system/apex/*; do
      local DEST="/apex/$(basename $i)"
      [ "$DEST" == "/apex/com.android.runtime.release" ] && DEST="/apex/com.android.runtime"
      mkdir -p $DEST
      mount -o bind,ro $i $DEST
    done
  fi
  touch /apex/unity
}

umount_apex() {
  [ -f /apex/unity -o -f /apex/magtmp ] || return 0
  for i in /apex/*; do
    umount -l $i 2>/dev/null
  done
  if [ -f "/system/apex/com.android.runtime.release.apex" ]; then
    for i in $uloop; do
      local loop=/dev/loop$i
      losetup -d $loop 2>/dev/null || break
    done
  fi
  rm -rf /apex
}

device_check() {
  local PROP=$(echo "$1" | tr '[:upper:]' '[:lower:]') i
  for i in /system_root /system $VEN /odm /product; do
    if [ -f $i/build.prop ]; then
      for j in "ro.product.device" "ro.build.product" "ro.product.vendor.device" "ro.vendor.product.device"; do
        [ "$(sed -n "s/^$j=//p" $i/build.prop 2>/dev/null | head -n 1 | tr '[:upper:]' '[:lower:]')" == "$PROP" ] && return 0
      done
    fi
  done
  return 1
}

api_check() {
  local OPT=`getopt -o nx -- "$@"` TAPI=$2
  eval set -- "$OPT"
  while true; do
    case "$1" in
      -n) [ $API -lt $TAPI ] && abort "! Your system API of $API is less than the minimum api of $2! Aborting!"; shift;;
      -x) [ $API -gt $TAPI ] && abort "! Your system API of $API is greater than the maximum api of $2! Aborting!"; shift;;
      --) shift; break;;
    esac
  done
}

set_vars() {
  echo $PATH | grep -q "^$UF/tools/$ARCH32" || export PATH=$UF/tools/$ARCH32:$PATH
  SYS=/system; VEN=/system/vendor; SHEBANG="#!/system/bin/sh"
  [ $API -lt 26 ] && DYNLIB=false
  $DYNLIB && { LIBPATCH="\/vendor"; LIBDIR=$VEN; } || { LIBPATCH="\/system"; LIBDIR=/system; }
  [ -z MAGISK ] && MAGISK=true
  if $MAGISK; then
    if $BOOTMODE; then
      ORIGDIR="$MAGISKTMP/mirror"
      if $SYSTEM_ROOT && [ ! -L /system/vendor ]; then
        ORIGVEN=$ORIGDIR/system_root/system/vendor
      else
        ORIGVEN=$ORIGDIR/vendor
      fi
    fi
    MOD_VER="$NVBASE/modules/$MODID/module.prop"; INFO="$NVBASE/modules/.core/$MODID-files"; PROP=$MODPATH/system.prop; UNITY="$MODPATH"
    local ROOTTYPE="MagiskSU"
  else
    UNITY=""
    [ -d /system/addon.d ] && INFO=/system/addon.d/$MODID-files || INFO=/system/etc/$MODID-files
    [ -L /system/vendor ] && VEN=/vendor
    # Determine system boot script type
    supersuimg_mount
    MOD_VER="/system/etc/$MODID-module.prop"; NVBASE=/system/etc/init.d; ROOTTYPE="Rootless/other root"
    if [ "$supersuimg" ] || [ -d /su ]; then
      SHEBANG="#!/su/bin/sush"; ROOTTYPE="Systemless SuperSU"; NVBASE=/su/su.d
    elif [ -e "$(find /data /cache -name supersu_is_here | head -n1)" ]; then
      SHEBANG="#!/su/bin/sush"; ROOTTYPE="Systemless SuperSU"
      NVBASE=$(dirname `find /data /cache -name supersu_is_here | head -n1` 2>/dev/null)/su.d
    elif [ -d /system/su ] || [ -f /system/xbin/daemonsu ] || [ -f /system/xbin/sugote ]; then
      NVBASE=/system/su.d; ROOTTYPE="System SuperSU"
    elif [ -f /system/xbin/su ]; then
      [ "$(grep "SuperSU" /system/xbin/su)" ] && { NVBASE=/system/su.d; ROOTTYPE="System SuperSU"; } || ROOTTYPE="LineageOS SU"
    fi
    PROP=$NVBASE/$MODID-props
  fi
  ui_print "- $ROOTTYPE detected"
}

#################
# Module Related
#################

set_perm() {
  chown $2:$3 $1 || return 1
  chmod $4 $1 || return 1
  local CON=$5
  [ -z $CON ] && local CON=u:object_r:system_file:s0
  chcon $CON $1 || return 1
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f -o -type l 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}

mktouch() {
  mkdir -p ${1%/*} 2>/dev/null
  [ -z $2 ] && touch $1 || echo $2 > $1
  chmod 644 $1
}

run_addons() {
  local OPT=`getopt -o mhiuv -- "$@"` NAME PNAME
  eval set -- "$OPT"
  while true; do
    case "$1" in
      -m) NAME=main; shift;;
      -h) NAME=preinstall; PNAME="Preinstall"; shift;;
      -i) NAME=install; PNAME="Install"; shift;;
      -u) NAME=uninstall; PNAME="Uninstall"; shift;;
      -v) NAME=postuninstall; PNAME="Postuninstall"; shift;;
      --) shift; break;;
    esac
  done
  if [ "$(ls -A $MODPATH/common/addon/*/$NAME.sh 2>/dev/null)" ]; then
    [ -z $PNAME ] || { ui_print " "; ui_print "- Running $PNAME Addons -"; }
    for i in $MODPATH/common/addon/*/$NAME.sh; do
      ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/$NAME.sh|\1|")..."
      . $i
    done
    [ -z $PNAME ] || { ui_print " "; ui_print "- `echo $PNAME`ing (cont) -"; }
  fi
}

cp_ch() {
  local OPT=`getopt -o inr -- "$@"` BAK=true UBAK=true REST=true FOL=false
  eval set -- "$OPT"
  while true; do
    case "$1" in
      -i) UBAK=false; REST=false; shift;;
      -n) UBAK=false; shift;;
      -r) FOL=true; shift;;
      --) shift; break;;
    esac
  done
  local SRC="$1" DEST="$2" OFILES="$1"
  $FOL && local OFILES=$(find $SRC -type f 2>/dev/null)
  [ -z $3 ] && PERM=0644 || PERM=$3
  case "$DEST" in
    $TMPDIR/*|$MODULEROOT/*|$NVBASE/modules/$MODID/*) BAK=false;;
  esac
  for OFILE in ${OFILES}; do
    if $FOL; then
      if [ "$(basename $SRC)" == "$(basename $DEST)" ]; then
        local FILE=$(echo $OFILE | sed "s|$SRC|$DEST|")
      else
        local FILE=$(echo $OFILE | sed "s|$SRC|$DEST/$(basename $SRC)|")
      fi
    else
      [ -d "$DEST" ] && local FILE="$DEST/$(basename $SRC)" || local FILE="$DEST"
    fi
    if $BAK; then
      if $UBAK && $REST; then
        [ ! "$(grep "$FILE$" $INFO 2>/dev/null)" ] && echo "$FILE" >> $INFO
        [ -f "$FILE" -a ! -f "$FILE~" ] && { mv -f $FILE $FILE~; echo "$FILE~" >> $INFO; }
      elif ! $UBAK && $REST; then
        [ ! "$(grep "$FILE$" $INFO 2>/dev/null)" ] && echo "$FILE" >> $INFO
      elif ! $UBAK && ! $REST; then
        [ ! "$(grep "$FILE\NORESTORE$" $INFO 2>/dev/null)" ] && echo "$FILE\NORESTORE" >> $INFO
      fi
    fi
    install -D -m $PERM "$OFILE" "$FILE"
    case $FILE in
      */vendor/*.apk) chcon u:object_r:vendor_app_file:s0 $FILE;;
      */vendor/etc/*) chcon u:object_r:vendor_configs_file:s0 $FILE;;
      */vendor/*) chcon u:object_r:vendor_file:s0 $FILE;;
      */system/*) chcon u:object_r:system_file:s0 $FILE;;
    esac
  done
}

patch_script() {
  [ -L /system/vendor ] && local VEN=/vendor
  sed -i -e "1i $SHEBANG" -e "1i SYS=/system" -e "1i VEN=$VEN" $1
  local i; for i in "MAGISK" "LIBDIR" "MODID" "NVBASE" "INFO"; do
    sed -i "4i $i=$(eval echo \$$i)" $1
  done
  $MAGISK && sed -i -e "s|\$MODPATH|$NVBASE/modules/$MODID|g" $1 || sed -i -e "s|\$MODPATH||g" $1
}

install_script() {
  case "$1" in
    -l) shift; $MAGISK && local INPATH=$NVBASE/service.d; local EXT="-ls";;
    -p) shift; $MAGISK && local INPATH=$NVBASE/post-fs-data.d; local EXT="";;
    *) local $MAGISK && local INPATH=$(dirname $2); local EXT="";;
  esac
  patch_script "$1"
  if $MAGISK; then
    case $(basename $1) in
      post-fs-data.sh|service.sh) cp_ch -i $1 $MODPATH/$(basename $1);;
      *) cp_ch -i $1 $INPATH/$(basename $1) 0755;;
    esac
  else
    cp_ch -n $1 $NVBASE/$MODID-$(basename $1 | sed 's/.sh$//')$EXT 0700
  fi
}

prop_process() {
  sed -i -e "/^#/d" -e "/^ *$/d" $1
  if $MAGISK; then
    [ -f $PROP ] || mktouch $PROP
  else
    [ -f $PROP ] || mktouch $PROP "$SHEBANG"
    sed -ri "s|^(.*)=(.*)|setprop \1 \2|g" $1
  fi
  while read LINE; do
    echo "$LINE" >> $PROP
  done < $1
  $MAGISK || chmod 0700 $PROP
}

#######
# Main
#######

unity_install() {
  ui_print "- Installing"

  # Remove remnants
  $MAGISK && [ -f $INFO ] && remove_files $INFO

  # Preinstall Addons
  run_addons -h

  # Make info file
  rm -f $INFO
  mktouch $INFO

  # Run user install script
  [ -f "$MODPATH/common/unity_install.sh" ] && . $MODPATH/common/unity_install.sh

  # Install Addons
  run_addons -i

  ui_print "   Installing for $ARCH SDK $API device..."

  # Remove comments from files and place them, add blank line to end if not already present
  for i in $MODPATH/common/system.prop $MODPATH/common/service.sh $MODPATH/common/post-fs-data.sh $MODPATH/common/sepolicy.rule; do
    [ -f $i ] && { sed -i -e "/^#/d" -e "/^ *$/d" $i; [ "$(tail -1 $i)" ] && echo "" >> $i; } || continue
    case $(basename $i) in
      "service.sh") install_script -l $i;;
      "post-fs-data.sh") install_script -p $i;;
      "system.prop") prop_process $i; $MAGISK || echo $PROP >> $INFO;;
    esac
  done
  sed -i "s/<MODID>/$MODID/" $MODPATH/uninstall.sh

  # Handle replace folders
  for TARGET in $REPLACE; do
    $MAGISK && mktouch $MODPATH$TARGET/.replace || rm -rf $TARGET
  done

  # Sepolicy
  if $MAGISK && [ -f $MODPATH/common/sepolicy.rule -a -e $PERSISTDIR ]; then
    ui_print "- Installing custom sepolicy patch"
    PERSISTMOD=$PERSISTDIR/magisk/$MODID
    mkdir -p $PERSISTMOD
    cp -af $MODPATH/common/sepolicy.rule $PERSISTMOD/sepolicy.rule
  elif [ -s $MODPATH/common/sepolicy.rule ]; then
    # TO DO: No more live sepolicy patching for rootless - Patch boot img directly?
    [ "$NVBASE" == "/system/etc/init.d" ] && echo -n "magiskpolicy --live" >> $MODPATH/common/service.sh || echo -n "supolicy --live" >> $MODPATH/common/service.sh
    while read LINE; do
      case $LINE in
        \"*\") echo -n " $LINE" >> $MODPATH/common/service.sh;;
        \"*) echo -n " $LINE\"" >> $MODPATH/common/service.sh;;
        *\") echo -n " \"$LINE" >> $MODPATH/common/service.sh;;
        *) echo -n " \"$LINE\"" >> $MODPATH/common/service.sh;;
      esac
    done < $MODPATH/common/sepolicy.rule
  fi

  # Install files
  $IS64BIT || rm -rf $MODPATH/system/lib64 $MODPATH/system/vendor/lib64
  [ -d "/system/priv-app" ] || mv -f $MODPATH/system/priv-app $MODPATH/system/app 2>/dev/null
  [ -d "/system/xbin" ] || mv -f $MODPATH/system/xbin $MODPATH/system/bin 2>/dev/null
  if $DYNLIB; then
    for FILE in $(find $MODPATH/system/lib*/* -maxdepth 0 -type d 2>/dev/null | sed -e "s|$MODPATH/system/lib.*/modules||" -e "s|$MODPATH/system/||"); do
      mkdir -p $(dirname $MODPATH/system/vendor/$FILE)
      mv -f $MODPATH/system/$FILE $MODPATH/system/vendor/$FILE
    done
  fi
  if ! $MAGISK; then
    cp_ch -r $MODPATH/system /system
    cp_ch -n $TMPDIR/module.prop $MOD_VER
    # Install rom backup script
    if [ "$INFO" == "/system/addon.d/$MODID-files" ]; then
      ui_print "   Installing addon.d backup script..."
      sed -i "s/MODID=.*/MODID=$MODID/" $UF/addon.sh
      cp_ch -n $UF/addon.sh /system/addon.d/98-$MODID-unity.sh 0755
    fi
  fi

  # Update info for magisk manager
  $MAGISK && $BOOTMODE && { rm -f $NVBASE/modules/$MODID/remove; mktouch $NVBASE/modules/$MODID/update; cp_ch -n $MODPATH/module.prop $NVBASE/modules/$MODID/module.prop; }
  
  if [ "$NVBASE" == "/system/etc/init.d" ] && [ "$(ls -A $MODPATH/common/*.sh 2>/dev/null)" ]; then
    ui_print " "
    ui_print "   ! This root method has no boot script support !"
    ui_print "   ! You will need to add init.d support !"
  fi

  # Remove info file if not needed
  [ -s $INFO ] || rm -f $INFO

  # Set permissions
  ui_print " "
  ui_print "- Setting Permissions"
  $MAGISK && set_perm_recursive $MODPATH 0 0 0755 0644
  set_permissions
}

remove_files() {
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ] || [ "$(echo -n $LINE | tail -c 9)" == "NORESTORE" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $1
  rm -f $1
}

unity_uninstall() {
  ui_print " "
  ui_print "- Uninstalling"

  # Uninstall Addons
  run_addons -u

  # Remove files
  if [ -f $INFO ]; then
    remove_files $INFO
  elif ! $MAGISK; then
    abort "   ! Mod not detected !"
  fi

  # Run user install script
  [ -f "$MODPATH/common/unity_uninstall.sh" ] && . $MODPATH/common/unity_uninstall.sh
  
  if $MAGISK; then
    rm -rf $NVBASE/modules_update/$MODID 2>/dev/null
    $BOOTMODE && { [ -d $NVBASE/modules/$MODID ] && touch $NVBASE/modules/$MODID/remove; } || rm -rf $MODPATH
  fi

  # Postuninstall Addons
  run_addons -v
}

unity_upgrade() {
  [ -f "$MODPATH/common/unity_upgrade.sh" ] && . $MODPATH/common/unity_upgrade.sh
  unity_uninstall
  mkdir -p $MODPATH
  unzip -o "$ZIPFILE" -x 'META-INF/*' 'common/unityfiles/*' -d $MODPATH >&2
  unity_install
}

unity_main() {
  #Debug
  if $DEBUG; then
    ui_print " "
    ui_print "- Debug mode"
    if $BOOTMODE; then
      ui_print "  Debug log will be written to: /storage/emulated/0/$MODID-debug.log"
      exec 2>/storage/emulated/0/$MODID-debug.log
    else
      ui_print "  Debug log will be written to: /data/media/0/$MODID-debug.log"
      exec 2>/data/media/0/$MODID-debug.log
    fi
    set -x
  fi

  $MAGISK && ! $BOOTMODE && [ -d /system/apex ] && mount_apex

  # Check for min/max api version
  if [ "$API" ]; then
    [ "$MINAPI" ] && api_check -n $MINAPI
    [ "$MAXAPI" ] && api_check -x $MAXAPI
  fi

  # Extract files - done this way so we can mount apex before chcon is called from set_perm
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" -x 'META-INF/*' 'common/unityfiles/*' -d $MODPATH >&2

  # Set variables
  set_vars

  # Add blank line to end of all files if needbe
  for i in $(find $MODPATH -type f -name "*.sh" -o -name "*.prop"); do
    [ "$(tail -1 "$i")" ] && echo "" >> "$i"
  done

  # Main addons
  [ -f "$MODPATH/common/addon.tar.xz" ] && tar -xf $MODPATH/common/addon.tar.xz -C $MODPATH/common 2>/dev/null
  run_addons -m

  # Load user vars/function
  unity_custom

  # Determine mod installation status
  ui_print " "
  [ -z $INSTATUS ] && INSTATUS=0
  case $INSTATUS in
    0) unity_install;;
    1) unity_uninstall;;
    2) ui_print "Older version detected! Upgrading!"; unity_upgrade;;
  esac

  # Complete (un)install
  cleanup
}

# Detect whether in boot mode
[ -z $BOOTMODE ] && BOOTMODE=false
$BOOTMODE || ps | grep zygote | grep -qv grep && BOOTMODE=true
$BOOTMODE || ps -A 2>/dev/null | grep zygote | grep -qv grep && BOOTMODE=true

DEBUG=false; DYNLIB=false
OIFS=$IFS; IFS=\|;
case "$ZIPFILE" in
  *debug*) DEBUG=true;;
esac
IFS=$OIFS

[ "$(grep_prop id $TMPDIR/module.prop)" == "UnityTemplate" ] && { ui_print "! Unity Template is not a separate module !"; abort "! This template is for devs only !"; }
chmod -R 755 $UF/tools
