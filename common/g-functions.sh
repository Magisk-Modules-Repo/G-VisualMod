##########################################################################################
#
# G-Terminal Utility Functions
# by Gnonymous7 @ Telegram & xda-developers
#
##########################################################################################

# Use this only along with veez21's Terminal Utility Functions
# Inspired by didgeridoohan's MagiskHidePropsConf
# Inspired by skittles9823's QuickSwitch

#----------------------------------- MENU ENVIRONMENT -----------------------------------#
# Fancy opening (made to avoid header bug, that's why)
fancy_opening() {
	header
	echo -e "\n"
	NUM=1
	while [ $NUM -le 50 ]; do
		ProgressBar $NUM 50
		NUM=$((NUM+5))
		sleep 0.001
	done
}

# Header with title text in the middle
header() {
	midALG=${#1}
	midALG=$((MDLVAL-midALG))
	[ $((midALG%2)) -eq 0 ] || midALG=$((midALG-1))
	midALG=$((midALG/2))
	SP=$(printf %-${midALG}s " ")
	[ "$DEVMODE" ] || clear
	mod_display
	echo ""
	echo -e " Module Version: ${Y}${VER} (${REL})${N}"
	echo -e " by ${Y}${AUTHOR}${N}"
	echo ""
	printf "${C}=%.0s${N}"  $(seq "$MDLVAL")
	echo -e "\n${SP// / }$1"
	printf "${C}=%.0s${N}"  $(seq "$MDLVAL")
	unset midALG
}

# Content taken from an array
content() {
	echo -e "\n"
	case $3 in
		yn)
			eval lastCONT=\$"${2}"
			eval mainCONT=\$"${2/cont_/M_}"
			echo " Activate ${Y}${mainCONT}${N}?"
		;;
		t)
			eval lastCONT="${2}"
			eval mainCONT=\$"${2/cont_/M_}"
			eval currCONT=\$"${2/cont_/}"
			[ "$currCONT" ] && echo " Current ${Y}${mainCONT}${N} is ${G}${currCONT}${N}dp." || echo " Current ${Y}${mainCONT}${N} is not assigned."
		;;
		m)
			echo " $1"
			echo ""
			NUM=1
			lastCONT=$2
			eval CONT=\$"${2}"
			for i in $CONT; do
				unset ifMENU ifSELC ifDSEL contNAME selTXT leaderTXT
				eval ifMENU=\$M_"${i}"
				eval ifSELC=\$S_"${i}"
				eval ifDSEL=\$"${i}"
				if [ "$ifMENU" ]; then
					eval contNAME=\$M_"${i}"
					eval cont${NUM}=menu
					eval menu${NUM}=menu_"${i}"
				elif [ "$ifSELC" ]; then
					eval contNAME=\$S_"${i}"
					eval cont${NUM}=selection
					eval selection${NUM}="${i}"
				elif [ "$ifDSEL" ]; then
					eval contNAME=\$"${i}"
					eval cont${NUM}=deselection
					eval deselection${NUM}="${i}"
				fi
				eval contTYPE=\$cont${NUM}
				[ "$contNAME" ] || continue
				dispTXT="  ${G}${NUM}${N} - ${contNAME} "
				leftALG=${#dispTXT}
				leftALG=$((leftALG-14))
				if ! [ "$contTYPE" = "deselection" ]; then
					for j in $i; do
						eval "var=\$${j}"
						[ "$var" ] && selTXT=" [${V}selected${N}]" && leaderTXT="." && break
					done
				else
					leftALG=$((leftALG-14))
				fi
				rightALG=${#selTXT}
				[ "$rightALG" != 0 ] && rightALG=$((rightALG-15))
				freeSPACE=$((MDLVAL-leftALG-rightALG-1))
				echo -ne "$dispTXT"
				printf "${leaderTXT}%.0s"  $(seq $freeSPACE)
				echo -e "$selTXT"
				NUM=$((NUM+1))
			done
		;;
	esac
}

# Footer for extra information
footer() {
	echo ""
	mod_footer
	echo ""
}

# Define which user input type will be used and read the input
user_input() {
	inputTYPE=$1
	footer
	echo ""
	case $inputTYPE in
		m)
			echo -en " Enter your desired options: "
		;;
		yn)
			echo -en " Enter [${G}y${N}]es or [${G}n${N}]o: "
		;;
		t)
			echo -e " ${Y}Only enter ${G}number or options above${Y}"
			echo -e " Use [${G}.${Y}] dot for decimal${N}"
			echo -en " Enter value or options above: "
		;;
	esac
	
	unset INPUT
	echo -en "${G}"
	read -r INPUT
	echo -en "${N}"
}

# Set same value to their parents
set_parent() {
	charOCR=$(echo "$1" | awk -F"_" '{print NF-1}')
	charOCR=$((charOCR+1))
	numOCR=1
	par=${1%_*}
	while [ $numOCR != $charOCR ]; do
		case $2 in
			setVAR)
				eval "$par"=true
			;;
			unsetVAR)
				unset "$par"
			;;
		esac
		par=${par%_*}
		numOCR=$((numOCR+1))
	done
}

# Takes value from non-empty variable in array and define new variable with true value
set_pick() {
	unset returnESCAPE
	case $inputTYPE in
		yn)
			case $INPUT in
				y|Y)
					eval "$lastCONT"=true
					PARENT="$lastCONT"
					set_parent "$PARENT" "setVAR"
				;;
				n|N)
					unset "$lastCONT"
					PARENT="$lastCONT"
					set_parent "$PARENT" "unsetVAR"
				;;
			esac
			return 1
		;;
		t)
			inputDEC=$(echo "$INPUT" | sed 's/\.//')
			case $inputDEC in
				''|*[!0-9]*)
					return 1
				;;
			esac
			case $INPUT in
				*.0*)
					eval INPUT=${INPUT%.*}
				;;
			esac
			eval CONT=\$"${lastCONT%_*}"
			for i in $CONT; do
				unset "$i"
			done
			lastPARENT="${lastCONT/cont_/}"
			set_parent "$lastPARENT" "unsetVAR"
			eval VAR=\${lastCONT/cont_/}
			eval "$VAR"="$INPUT"
			PARENT="${lastCONT/cont_/}"
			set_parent "$PARENT" "setVAR"
			return 0
		;;
	esac
	[ "$INPUT" -eq "$INPUT" ] 2> /dev/null || return 1
	lastNUM=$((NUM-1))
	! [ "$INPUT" -gt "$lastNUM" ] 2> /dev/null || return 1
	NUM=1
	eval contTYPE=\$cont"${INPUT}"
	case $contTYPE in
		menu)
			while [ $NUM -le $lastNUM ]; do
				eval targetNUM=\$menu${NUM}
				eval inputNUM=\$menu"${INPUT}"
				if [ "$targetNUM" = "$inputNUM" ] 2> /dev/null ; then
					eval "\$menu${NUM}"
					returnESCAPE=true
					break
				fi
				NUM=$((NUM+1))
			done
		;;
		selection)
			while [ $NUM -le $lastNUM ]; do
				eval var=\$selection${NUM}
				eval inputNUM=\$selection"${INPUT}"
				if [ "$var" = "$inputNUM" ] 2> /dev/null ; then
					eval var2="\$${lastCONT}"
					for i in $var2; do
						unset "$i"
					done
					eval "$inputNUM"=true
					PARENT="$inputNUM"
					set_parent "$PARENT" "setVAR"
					returnESCAPE=true
					break
				fi
				NUM=$((NUM+1))
			done
		;;
		deselection)
			while [ $NUM -le $lastNUM ]; do
				eval var=\$deselection${NUM}
				eval inputNUM=\$deselection"${INPUT}"
				if [ "$var" = "$inputNUM" ]; then
					PARENT=${var/D_/}
					unset "$PARENT"
					set_parent "$PARENT" "unsetVAR"
					eval var2=\$"${var/D_/cont_}"
					for i in $var2; do
						unset "$i"
					done
					returnESCAPE=true
					break
				fi
				NUM=$((NUM+1))
			done
		;;
	esac
	NUM=$((NUM+1))
	unset contTYPE
	[ $returnESCAPE ] && return 0 || return 1
}

# Function for yes and no input
input_yn() {
	case $INPUT in
		y|Y)
			$1
			return 0
		;;
		n|N)
			return 0
		;;
		*)
			invalid_input
			return 1
		;;
	esac
}

# Extra option other than content
extra_opt() {
	extraINPUT=${1}${MREADY}
	case $extraINPUT in
		*b*)
			echo -e "  ${G}b${N} - Back"
		;;
	esac
	case $extraINPUT in
		*e*)
			echo -e "  ${G}e${N} - Exit"
		;;
	esac
	case $extraINPUT in
		*c*)
			echo -e "  ${G}c${N} - Continue install"
		;;
	esac
	case $extraINPUT in
		*p*)
			echo -e "  ${G}p${N} - Preview selected mod(s)"
		;;
	esac
}

# Check value from extra_opt
extra_input() {
	case $extraINPUT in
		*b*)
			case $extraINPUT in
				b)
					case $INPUT in
						b|B)
							return 0
						;;
						*)
							invalid_input
							return 1
						;;
					esac
				;;
				*)
					case $INPUT in
						b|B)
							return 0
						;;
					esac
				;;
			esac
		;;
	esac
	case $extraINPUT in
		*e*)
			case $extraINPUT in
				e)
					case $INPUT in
						e|E)
							exit_mod
						;;
						*)
							invalid_input
							return 1
						;;
					esac
				;;
				*)
					case $INPUT in
						e|E)
							exit_mod
						;;
					esac
				;;
			esac
		;;
	esac
	case $extraINPUT in
		*c*)
			case $INPUT in
				c)
					case $INPUT in
						c|C)
							continueCALL=true
							return 1
						;;
						*)
							invalid_input
							return 1
						;;
					esac
				;;
				*)
					case $INPUT in
						c|C)
							continueCALL=true
							return 1
						;;
					esac
				;;
			esac
		;;
	esac
	case $extraINPUT in
		*p*)
			case $INPUT in
				p|P)
					mod_preview
					return 1
				;;
				*)
					invalid_input
					return 1
				;;
			esac
		;;
	esac
	invalid_input
	return 1
}

# Invalid Input based on user_input
invalid_input() {
	echo ""
	case $inputTYPE in
		m)
			invMSG="Only pick from the options above!"
		;;
		yn)
			invMSG="Only enter [${G}y${N}] for yes or [${G}n${N}] for no!"
		;;
		t)
			invMSG="Only enter ${G}number${N} or options above!"
		;;
	esac
	echo -e " ${R}Invalid input${N}. $invMSG"
	unset invMSG
	sleep 2
}


#---------------------------------- BACKEND ENVIRONMENT ---------------------------------#
# Main menu loop
main_loop() {
	while true; do
		mod_confirm
		[ "$CONFIRM" ] && break
		unset continueCALL
		menu_MAIN
	done
}

# Pre-Install check
pre_restore() {
	eval $(cat "$BACKUP")
	sleep 1
}

# Check selected mod and apply string for content
mod_check() {
	unset modEXIST
	for i in $SELECTEDMOD; do
		unset "$i"
	done
	for i in $MODLIST; do
		eval j=\$"${i}"
		for k in $j; do
			eval l=\$"${k}"
			if [ "$l" ]; then
				eval optNAME=\$"${i/cont_/M_}"
				case $k in
					*_C)
						eval "optPICK=\"Custom \"\$${k}\"dp\""
					;;
					*)
						eval optPICK=\$S_"${k}"
					;;
				esac
				eval "${i/cont_/D_}=\"${optNAME} - ${Y}${optPICK}${N}\""
				break
			fi
		done
	done 
	for i in $SELECTEDMOD; do
		eval var=\$"${i/D_/}"
		[ "$var" ] && modEXIST=true
	done
}

# Check if eligible to install
mod_ready() {
	unset MREADY
	eval var="\$${1}"
	for i in $var; do
		eval var2=\$"${i}"
		if [ "$var2" ]; then
			eval "${1/cont_/}"=true
			break
		fi
	done
	for i in $SELECTEDMOD; do
		eval var=\$"${i/D_/}"
		[ "$var" ] && MREADY=cp && break
	done
}

# Preview selected mods
mod_preview() {
	while true; do
        [ $continueCALL ] && break
		unset MREADY
		mod_check
		header "Preview selected mod(s)"
		if [ $modEXIST ]; then
			content "Mod(s) selected:" "SELECTEDMOD" "m"
			echo ""
			echo -e "  ${G}r${N} - Reset all selected mods"
			extra_opt bec
			echo ""
			echo -e " ${Y}Enter mod number if you want to ${R}deselect${Y} the mod${N}"
			user_input m
			set_pick && continue
		else
			echo -e "\n"
			echo -e " ${R}No mods selected.${N}"
			echo ""
			extra_opt be
			user_input m
		fi
		case $INPUT in
			r|R) 
				mod_reset_confirm
				continue
			;;
		esac
		extra_input && break
	done
}

# Confirm mod before install
mod_confirm() {
	while true; do
		unset CONFIRM MREADY
		mod_check
		header "Confirm selected mod(s)"
		content "Mod(s) selected:" "SELECTEDMOD" "m"
		echo -e " ${Y}Are you sure?${N}"
		user_input yn
		input_yn "eval CONFIRM=true" && break
	done
}

# Prompt confirm on resetting all mod
mod_reset_confirm() {
	while true; do
		header "Reset all mod(s)"
		echo -e "\n"
		echo -e " ${Y}Are you sure?${N}"
		user_input yn
		input_yn mod_reset && break
	done
}

# Reset all mod
mod_reset() {
	for i in $MODLIST; do
		j=${i/cont_/}
		unset "$j"
		PARENT="$j"
		set_parent "$PARENT" "unsetVAR"
		eval j=\$"${i}"
		for k in $j; do
			unset "$k"
		done
	done
	for i in $SELECTEDMOD; do
		unset "$i"
	done
}

# Mount check
# (taken from skittles9823's QuickSwitch)
is_mounted_rw() {
	grep " $(readlink -f "$1") " /proc/mounts | grep " rw," 2>/dev/null
	return $?
}

mount_rw() {
	mount -o remount,rw "$1"
	DID_MOUNT_RW=$1
}

unmount_rw() {
	if [ "x$DID_MOUNT_RW" = "x$1" ]; then
		mount -o remount,ro "$1"
	fi
}

unmount_rw_stepdir() {
	if [ "$OEM" ]; then
		is_mounted_rw " /oem" && unmount_rw /oem
		is_mounted_rw " /oem/OP" && unmount_rw /oem/OP
	fi
}

# Print to log
# (taken-edited from didgeridoohan's MagiskHidePropsConf)
log_handler() {
	echo "" >> "$LOG" 2>&1
	echo -e "$1" >> "$LOG" 2>&1
}

# Print to log and screen
# (taken-edited from didgeridoohan's MagiskHidePropsConf)
log_print() {
	echo -e "$1"
	log_handler "$1"
}

# Check whether an update is available
# (taken-edited from didgeridoohan's MagiskHidePropsConf)
module_update() {
	header "Preparing"
	echo ""
	echo ""
	test_connection || return 1
	RELUPDLOC=${GVMEXT}/module.prop
	wget -q -T 10 -O $RELUPDLOC $RELUPDWEB  >> "$LOG" 2>&1 & e_spinner " Checking update"
	RELUPD=$(grep_prop versionCode "${GVMEXT}"/module.prop)
	if [ -s "$RELUPDLOC" ]; then
		if [ "$REL" -lt "$RELUPD" ]; then
			log_print " - ${Y}Newer version of the module available!${N}"
		else
			log_print " - ${G}No update available.${N}"
		fi
	elif [ -f "$RELUPDLOC" ]; then
		rm -f "$RELUPDLOC"
		log_print " - ${R}Error${N}. Can't fetch update!"
		log_print " - File is empty."
	else
		log_print " - ${R}Error${N}. Update not fetched!"
	fi 
	sleep 1
}

# Storing selected mods
store_mod() {
	> $BACKUP
	for i in $MODLIST; do
		eval j=\$"${i}"
		for k in $j; do
			eval l=\$"${k}"
			if [ "$l" ]; then
				eval echo -e $k="$l" >> "$BACKUP" 2>&1
				var=${i/cont_/}
				eval echo -e $var=true >> "$BACKUP" 2>&1
				charOCR=$(echo "$var" | awk -F"_" '{print NF-1}')
				charOCR=$((charOCR+1))
				numOCR=1
				par=${var%_*}
				while [ $numOCR != $charOCR ]; do
					eval echo -e $par=true >> "$BACKUP" 2>&1
					par=${par%_*}
					numOCR=$((numOCR+1))
				done
			fi
		done
	done
}

# Saving logs and exit
exit_mod() {
	header "Have a great day :)"
	echo ""
	echo ""
	cleanup
	save_logs
	echo " Logs are saved to:"
	echo -e " ${Y}${LOCALLOG}${N}"
	echo ""
	log_print " Mod stopped."
	exit 0
}

# Saving logs and exit error
exit_error() {
	header "Something wrong"
	echo ""
	echo ""
	echo -e " ${C}U${N}${R}h${N} ${G}o${N}${Y}h${N}."
	log_handler "Something wrong"
	echo ""
	cleanup
	save_logs
	echo " Logs are saved to:"
	echo -e " ${Y}${LOCALLOG}${N}"
	echo ""
	log_print " Mod stopped."
	exit 0
}

# FInished installation
exit_finish() {
	header "Installation Completed"
	echo ""
	echo ""
	echo -e " Please ${Y}reboot${N} for changes to take effect."
	cleanup
	save_logs
	echo " Logs are saved to:"
	echo -e " ${Y}${LOCALLOG}${N}"
	echo ""
	log_print " Mod stopped."
	exit 0
}

# Save logs locally
save_logs() {
	for i in $LOGTOSAVE; do
		eval j="\$${i}"
		if [ "$j" ]; then
			log_handler "${i}=${j}"
    	fi
	done
	cp -af "$LOG" "$LOCALLOG"
	cp -af "$VERLOG" "$LOCALLOG"
	cd $LOCALLOG
	zip -Aq ${ID}logs ${ID}.log ${ID}-verbose.log
	rm -rf ${ID}.log ${ID}-verbose.log
}
