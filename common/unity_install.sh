OIFS=$IFS; IFS=\|
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *rui20*) RUI=true; RUI20=true; RUI32=false;;
	*rui32*) RUI=true; RUI20=false; RUI32=true;;
  *rec*) RUI=false; RUI20=false; RUI32=false;;
esac
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *sbh30*) SBH=true; SBH30=true; SBH40=false; SBH48=false;;
  *sbh40*) SBH=true; SBH30=false; SBH40=true; SBH48=false;;
	*sbh48*) SBH=true; SBH30=false; SBH40=false; SBH48=true;;
	*nsbh*) SBH=false; SBH30=false; SBH40=false; SBH48=false;;
esac
IFS=$OIFS



ui_print " "
if [ -z $RUI ] || [ -z $SBH ]; then
  if [ -z $VKSEL ]; then
    ui_print "  ! Some options not specified in zipname!"
    ui_print "  Using defaults if not specified in zipname!"
    [ -z $RUI ] && RUI=true; RUI20=true
    [ -z $SBH ] && SBH=true; SBH30=true
  else
    if [ -z $RUI ] || [ -z $RUI20 ] || [ -z $RUI32 ]; then
			ui_print " "
			ui_print " "
			ui_print "   Install RoundyUI, RectangUI?"
			ui_print " "
			ui_print "   Vol+ = RoundyUI, Vol- = RectangUI"
			if $VKSEL; then
				RUI=true
			else
  			RUI=false
			fi
		else
      ui_print "   UI install method specified in zipname!"
    fi
		if $RUI && ([ -z $RUI20 ] || [ -z $RUI32 ]); then
			ui_print " "
			ui_print " "
			ui_print "   Pick radius"
			ui_print " "
			ui_print "   Vol+ = 20dp, Vol- = 32dp"
			if $VKSEL; then
				RUI20=true
			else
				RUI32=true
			fi
		else
      ui_print "   UI install method specified in zipname!"
    fi
		if [ -z $SBH ] || [ -z $SBH30 ] || [ -z $SBH40 ] || [ -z $SBH48 ]; then
			ui_print " "
			ui_print " "
			ui_print "   Install Status Bar Height (notch)?"
			ui_print " "
			ui_print "   Vol+ = yes, Vol- = no"
			if $VKSEL; then
				ui_print " "
				ui_print " "
				ui_print "   Size list:"
				ui_print " - 30dp (Comfort looking)"
				ui_print " - 40dp (Match your lockscreen statusbar)"
				ui_print " - 48dp (Same height as your navbar)"
				ui_print " "
				ui_print " "
				ui_print "   Read above then pick height:"
				ui_print " "
				ui_print "   Vol+ = 30dp, Vol- = other sizes"
				if $VKSEL; then
					SBH=true
					SBH30=true
					SBH40=false
					SBH48=false					
				else
					ui_print "   Pick remaining height:"
					ui_print " "
					ui_print "   Vol+ = 40dp, Vol- = 48dp"
					if $VKSEL; then
						SBH=true
						SBH30=false
						SBH40=true
						SBH48=false	
					else
						SBH=true
						SBH30=false
						SBH40=false
						SBH48=true	
					fi
				fi
			fi
		else
      ui_print "   Statusbar height install method specified in zipname!"
    fi
	fi
else
  ui_print "   Options specified in zipname!"
fi

ui_print " "
ui_print " "
ui_print "-  Installing  -"


if $RUI; then
	ui_print "-  RoundyUI Selected  -"
	if $RUI20; then
		ui_print "-  RoundyUI 20dp Selected  -"
		cp -f $TMPDIR/apk/RoundyUI20.apk $TMPDIR/system/vendor/overlay
	elif $RUI32; then
		ui_print "-  RoundyUI 32dp Selected  -"
		cp -f $TMPDIR/apk/RoundyUI32.apk $TMPDIR/system/vendor/overlay
	fi
else
		ui_print "-  RectangUI Selected  -"
	cp -f $TMPDIR/apk/RoundyUI2.apk $TMPDIR/system/vendor/overlay
fi

if $SBH; then
	ui_print "-  StatusBar Height Selected  -"
	if $SBH30; then
		ui_print "-  StatusBar Height 30dp Selected  -"
		cp -f $TMPDIR/apk/StatusBarHeight30.apk $TMPDIR/system/vendor/overlay
	elif $SBH40; then
		ui_print "-  StatusBar Height 40dp Selected  -"
		cp -f $TMPDIR/apk/StatusBarHeight40.apk $TMPDIR/system/vendor/overlay
	elif $SBH48; then
		ui_print "-  StatusBar Height 48dp Selected  -"
		cp -f $TMPDIR/apk/StatusBarHeight48.apk $TMPDIR/system/vendor/overlay
	fi
fi

ui_print " "
ui_print " "
ui_print "-  Done  -"
