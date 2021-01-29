#------------------------------------ ID ENVIRONMENT ------------------------------------#
# Display on Header
mod_display() {
	echo -e "${W}    ___     _  _ __ ____ _  _  __  __      _  _  __ ____"
	echo -e "   / ${R}__${W})${R}___${W}/ )( (  / ${R}___${W}/ )( \\/ ${R}_${W}\\(  )    ( \\/ )/  (    \\"
	echo -e "${R}  ( (_ (___\\ \\/ /)(\\___ ) \\/ /    / (_/\\  / \\/ (  O ) D ("
	echo -e "${W}   \\___/    \\__/(__(____\\____\\_/\\_\\____/  \\_)(_/\\__(____/${N}"
}

# Put the longest string of mod_display
# Dont change var name
MDL="    ___     _  _ __ ____ _  _  __  __      _  _  __ ____ "

# Display on Footer
mod_footer() {
	var=$((MDLVAL/2))
	var=$((MDLVAL/2+1))
	printf "${C}- %.0s${N}"  $(seq $var)
	echo -e "\n Support group ${Y}@tzlounge${N} @Telegram or ${Y}Gnonymous7${N} @XDA for help."
	printf "${C}- %.0s${N}"  $(seq $var)
}

# Where to check updates
RELUPDWEB="https://raw.githubusercontent.com/Magisk-Modules-Repo/G-VisualMod/master/module.prop"

#--------------------------------- MENU TREE ENVIRONMENT --------------------------------#

M_URM="UI Radius"
	S_URM_S="Small (2)"
	S_URM_N="Normal (12)"
	S_URM_M="Medium (20)"
	S_URM_L="Large (32)"
	
	M_URM_C="Custom Radius"

	V_URM_S=2
	V_URM_N=12
	V_URM_M=20
	V_URM_L=32

M_SNM="StatusBar & Notification"

	M_SNM_SH="StatusBar Height"
		S_SNM_SH_M="Medium (34)"
		S_SNM_SH_L="Large (40)"
		S_SNM_SH_X="Extra Large (48)"
		M_SNM_SH_C="Custom Height"

		V_SNM_SH_M=34
		V_SNM_SH_L=40
		V_SNM_SH_X=48

	M_SNM_SP="StatusBar Padding"
		S_SNM_SP_B="Best value (5)"
		M_SNM_SP_C="Custom Padding"

		V_SNM_SP_B=5

	M_SNM_NK="NotchKiller"
		S_SNM_NK_Y="Activate"
		V_SNM_NK_Y="true"

	M_SNM_NP="Notification Side Padding"
		S_SNM_NP_B="Best value (32)"
		M_SNM_NP_C="Custom Padding"

		V_SNM_NP_B=32
		
	M_SNM_MS="MIUI StatusBar Bottom Padding Fix"
		S_SNM_MS_Y="Activate"
		V_SNM_MS_Y="true"

M_PGM="Pill Gesture"
	M_PGM_SH="Pill Gesture Shape"
		M_PGM_SH_TH="Pill Gesture Thickness"
			S_PGM_SH_TH_AO="1.0dp (AOSP & OxygenOS)"
			S_PGM_SH_TH_MI="1.85dp (MIUI 12)"
			S_PGM_SH_TH_IO="2.5dp (IOS)"
			S_PGM_SH_TH_U1="3.0dp (Dev pick)"
			M_PGM_SH_TH_C="Custom Thickness"
			
			V_PGM_SH_TH_AO=1
			V_PGM_SH_TH_MI=1.85
			V_PGM_SH_TH_IO=2.5
			V_PGM_SH_TH_U1=3

		M_PGM_SH_LE="Pill Gesture Length"
			M_PGM_SH_LE_P="Pill Gesture Length Portrait"
				S_PGM_SH_LE_P_AO="72dp (AOSP)"
				S_PGM_SH_LE_P_U1="100dp (Dev Pick)"
				S_PGM_SH_LE_P_OS="137dp (OxygenOS)"
				S_PGM_SH_LE_P_MI="145dp (MIUI 12)"
				S_PGM_SH_LE_P_IO="160dp (IOS)"
				S_PGM_SH_LE_P_U2="180dp (Dev Pick)"
				S_PGM_SH_LE_P_U3="200dp (What why?)"
				M_PGM_SH_LE_P_C="Custom Length"
				
				V_PGM_SH_LE_P_AO=72
				V_PGM_SH_LE_P_U1=100
				V_PGM_SH_LE_P_OS=137
				V_PGM_SH_LE_P_MI=145
				V_PGM_SH_LE_P_IO=160
				V_PGM_SH_LE_P_U2=180
				V_PGM_SH_LE_P_U3=200
				
			M_PGM_SH_LE_L="Pill Gesture Length Landscape"
				S_PGM_SH_LE_L_DF="145dp (Default)"
				M_PGM_SH_LE_L_C="Custom Length"
				
				V_PGM_SH_LE_L_DF=145
			
	M_PGM_CL="Pill Gesture Color"
		M_PGM_CL_LH="Pill Gesture Light Color"
			S_PGM_CL_LH_DFBK="Default Black"
			S_PGM_CL_LH_AMTY="Amethyst"
			S_PGM_CL_LH_AQMR="Aquamarine"
			S_PGM_CL_LH_CRBN="Carbon"
			S_PGM_CL_LH_CNMN="Cinnamon"
			S_PGM_CL_LH_OCEA="Ocean"
			S_PGM_CL_LH_ORCD="Orchid"
			S_PGM_CL_LH_PLTT="Palette"
			S_PGM_CL_LH_SAND="Sand"
			S_PGM_CL_LH_SPCE="Space"
			S_PGM_CL_LH_TGRN="Tangerine"
			S_PGM_CL_LH_CRED="Red"
			S_PGM_CL_LH_BRWN="Brown"
			S_PGM_CL_LH_ELYL="Yellow"
			S_PGM_CL_LH_ORNG="Orange"
			S_PGM_CL_LH_GREN="Green"
			S_PGM_CL_LH_CYAN="Cyan"
			S_PGM_CL_LH_BLUE="Blue"
			S_PGM_CL_LH_MGNT="Magenta"
			S_PGM_CL_LH_PRPL="Purple"
			S_PGM_CL_LH_HTPK="Hot Pink"
			S_PGM_CL_LH_CRMS="Crimson"
			S_PGM_CL_LH_BRMR="Bright Maroon"
			S_PGM_CL_LH_ROSE="Rose"
			S_PGM_CL_LH_SLMN="Salmon"
			S_PGM_CL_LH_CORL="Coral"
			S_PGM_CL_LH_ORRD="Orange Red"
			S_PGM_CL_LH_CCOA="Cocoa"
			S_PGM_CL_LH_GLDN="Golden"
			S_PGM_CL_LH_OLVE="Olive"
			S_PGM_CL_LH_LIME="Lime"
			S_PGM_CL_LH_SRGR="Spring Green"
			S_PGM_CL_LH_TRQS="Turquoise"
			S_PGM_CL_LH_INDG="Indigo"
			S_PGM_CL_LH_MIBL="MIUI 12"
			S_PGM_CL_LH_PXBL="Pixel Blue"
			S_PGM_CL_LH_OPRD="OnePlus Red"
			S_PGM_CL_LH_DSCR="Discord"
			S_PGM_CL_LH_SPGR="Spotify Green"
			S_PGM_CL_LH_TWTR="Twitter Blue"
			S_PGM_CL_LH_RZGR="Razer Green"
			S_PGM_CL_LH_REDT="Reddit"
			S_PGM_CL_LH_VNGR="Vine Green"
			
			V_PGM_CL_LH_DFBK="000000"
			V_PGM_CL_LH_AMTY="A03EFF"
			V_PGM_CL_LH_AQMR="23847D"
			V_PGM_CL_LH_CRBN="434E58"
			V_PGM_CL_LH_CNMN="AF6050"
			V_PGM_CL_LH_OCEA="0C80A7"
			V_PGM_CL_LH_ORCD="C42CC9"
			V_PGM_CL_LH_PLTT="c01668"
			V_PGM_CL_LH_SAND="795548"
			V_PGM_CL_LH_SPCE="47618A"
			V_PGM_CL_LH_TGRN="C85125"
			V_PGM_CL_LH_CRED="FF0000"
			V_PGM_CL_LH_BRWN="964B00"
			V_PGM_CL_LH_ELYL="FFFF00"
			V_PGM_CL_LH_ORNG="FFA500"
			V_PGM_CL_LH_GREN="84C188"
			V_PGM_CL_LH_CYAN="00FFFF"
			V_PGM_CL_LH_BLUE="0000FF"
			V_PGM_CL_LH_MGNT="FF00FF"
			V_PGM_CL_LH_PRPL="B5A9FC"
			V_PGM_CL_LH_HTPK="FF69B4"
			V_PGM_CL_LH_CRMS="dc143c"
			V_PGM_CL_LH_BRMR="C32148"
			V_PGM_CL_LH_ROSE="FF007F"
			V_PGM_CL_LH_SLMN="FA8072"
			V_PGM_CL_LH_CORL="FF7F50"
			V_PGM_CL_LH_ORRD="FF4500"
			V_PGM_CL_LH_CCOA="D2691E"
			V_PGM_CL_LH_GLDN="FFD700"
			V_PGM_CL_LH_OLVE="808000"
			V_PGM_CL_LH_LIME="BFFF00"
			V_PGM_CL_LH_SRGR="00FF7F"
			V_PGM_CL_LH_TRQS="40E0D0"
			V_PGM_CL_LH_INDG="6f00ff"
			V_PGM_CL_LH_MIBL="0D84FF"
			V_PGM_CL_LH_PXBL="1A73E8"
			V_PGM_CL_LH_OPRD="EB0028"
			V_PGM_CL_LH_DSCR="7289da"
			V_PGM_CL_LH_SPGR="1DB954"
			V_PGM_CL_LH_TWTR="1DA1F2"
			V_PGM_CL_LH_RZGR="00ff00"
			V_PGM_CL_LH_REDT="ff4500"
			V_PGM_CL_LH_VNGR="00b488"
			
		M_PGM_CL_DR="Pill Gesture Dark Color"
			S_PGM_CL_DR_DFWT="Default White"
			S_PGM_CL_DR_AMTY="$S_PGM_CL_LH_AMTY"
			S_PGM_CL_DR_AQMR="$S_PGM_CL_LH_AQMR"
			S_PGM_CL_DR_CRBN="$S_PGM_CL_LH_CRBN"
			S_PGM_CL_DR_CNMN="$S_PGM_CL_LH_CNMN"
			S_PGM_CL_DR_OCEA="$S_PGM_CL_LH_OCEA"
			S_PGM_CL_DR_ORCD="$S_PGM_CL_LH_ORCD"
			S_PGM_CL_DR_PLTT="$S_PGM_CL_LH_PLTT"
			S_PGM_CL_DR_SAND="$S_PGM_CL_LH_SAND"
			S_PGM_CL_DR_SPCE="$S_PGM_CL_LH_SPCE"
			S_PGM_CL_DR_TGRN="$S_PGM_CL_LH_TGRN"
			S_PGM_CL_DR_CRED="$S_PGM_CL_LH_CRED"
			S_PGM_CL_DR_BRWN="$S_PGM_CL_LH_BRWN"
			S_PGM_CL_DR_ELYL="$S_PGM_CL_LH_ELYL"
			S_PGM_CL_DR_ORNG="$S_PGM_CL_LH_ORNG"
			S_PGM_CL_DR_GREN="$S_PGM_CL_LH_GREN"
			S_PGM_CL_DR_CYAN="$S_PGM_CL_LH_CYAN"
			S_PGM_CL_DR_BLUE="$S_PGM_CL_LH_BLUE"
			S_PGM_CL_DR_MGNT="$S_PGM_CL_LH_MGNT"
			S_PGM_CL_DR_PRPL="$S_PGM_CL_LH_PRPL"
			S_PGM_CL_DR_HTPK="$S_PGM_CL_LH_HTPK"
			S_PGM_CL_DR_CRMS="$S_PGM_CL_LH_CRMS"
			S_PGM_CL_DR_BRMR="$S_PGM_CL_LH_BRMR"
			S_PGM_CL_DR_ROSE="$S_PGM_CL_LH_ROSE"
			S_PGM_CL_DR_SLMN="$S_PGM_CL_LH_SLMN"
			S_PGM_CL_DR_CORL="$S_PGM_CL_LH_CORL"
			S_PGM_CL_DR_ORRD="$S_PGM_CL_LH_ORRD"
			S_PGM_CL_DR_CCOA="$S_PGM_CL_LH_CCOA"
			S_PGM_CL_DR_GLDN="$S_PGM_CL_LH_GLDN"
			S_PGM_CL_DR_OLVE="$S_PGM_CL_LH_OLVE"
			S_PGM_CL_DR_LIME="$S_PGM_CL_LH_LIME"
			S_PGM_CL_DR_SRGR="$S_PGM_CL_LH_SRGR"
			S_PGM_CL_DR_TRQS="$S_PGM_CL_LH_TRQS"
			S_PGM_CL_DR_INDG="$S_PGM_CL_LH_INDG"
			S_PGM_CL_DR_MIBL="$S_PGM_CL_LH_MIBL"
			S_PGM_CL_DR_PXBL="$S_PGM_CL_LH_PXBL"
			S_PGM_CL_DR_OPRD="$S_PGM_CL_LH_OPRD"
			S_PGM_CL_DR_DSCR="$S_PGM_CL_LH_DSCR"
			S_PGM_CL_DR_SPGR="$S_PGM_CL_LH_SPGR"
			S_PGM_CL_DR_TWTR="$S_PGM_CL_LH_TWTR"
			S_PGM_CL_DR_RZGR="$S_PGM_CL_LH_RZGR"
			S_PGM_CL_DR_REDT="$S_PGM_CL_LH_REDT"
			S_PGM_CL_DR_VNGR="$S_PGM_CL_LH_VNGR"
			
			V_PGM_CL_DR_DFWT="FFFFFF"
			V_PGM_CL_DR_AMTY="BD78FF"
			V_PGM_CL_DR_AQMR="1AFFCB"
			V_PGM_CL_DR_CRBN="3DDCFF"
			V_PGM_CL_DR_CNMN="C3A6A2"
			V_PGM_CL_DR_OCEA="28BDD7"
			V_PGM_CL_DR_ORCD="E68AED"
			V_PGM_CL_DR_PLTT="ffb6d9"
			V_PGM_CL_DR_SAND="c8ac94"
			V_PGM_CL_DR_SPCE="99ACCC"
			V_PGM_CL_DR_TGRN="F19D7D"
			V_PGM_CL_DR_CRED="FF0000"
			V_PGM_CL_DR_BRWN="964B00"
			V_PGM_CL_DR_ELYL="FFFF00"
			V_PGM_CL_DR_ORNG="FFA500"
			V_PGM_CL_DR_GREN="84C188"
			V_PGM_CL_DR_CYAN="00FFFF"
			V_PGM_CL_DR_BLUE="0000FF"
			V_PGM_CL_DR_MGNT="FF00FF"
			V_PGM_CL_DR_PRPL="B5A9FC"
			V_PGM_CL_DR_HTPK="FF69B4"
			V_PGM_CL_DR_CRMS="dc143c"
			V_PGM_CL_DR_BRMR="C32148"
			V_PGM_CL_DR_ROSE="FF007F"
			V_PGM_CL_DR_SLMN="FA8072"
			V_PGM_CL_DR_CORL="FF7F50"
			V_PGM_CL_DR_ORRD="FF4500"
			V_PGM_CL_DR_CCOA="D2691E"
			V_PGM_CL_DR_GLDN="FFD700"
			V_PGM_CL_DR_OLVE="808000"
			V_PGM_CL_DR_LIME="BFFF00"
			V_PGM_CL_DR_SRGR="00FF7F"
			V_PGM_CL_DR_TRQS="40E0D0"
			V_PGM_CL_DR_INDG="6f00ff"
			V_PGM_CL_DR_MIBL="0D84FF"
			V_PGM_CL_DR_PXBL="1A73E8"
			V_PGM_CL_DR_OPRD="EB0028"
			V_PGM_CL_DR_DSCR="7289da"
			V_PGM_CL_DR_SPGR="1DB954"
			V_PGM_CL_DR_TWTR="1DA1F2"
			V_PGM_CL_DR_RZGR="00ff00"
			V_PGM_CL_DR_REDT="ff4500"
			V_PGM_CL_DR_VNGR="00b488"
			                  
	M_PGM_TR="Pill Gesture Transparency"
		S_PGM_TR_1="10%"      
		S_PGM_TR_2="20%"
		S_PGM_TR_3="30%"
		S_PGM_TR_4="40%"
		S_PGM_TR_5="50%"
		S_PGM_TR_6="60%"
		S_PGM_TR_7="70%"
		S_PGM_TR_8="80%"
		S_PGM_TR_9="90%"
		
		V_PGM_TR_1=E6      
		V_PGM_TR_2=CC
		V_PGM_TR_3=B3
		V_PGM_TR_4=99
		V_PGM_TR_5=80
		V_PGM_TR_6=66
		V_PGM_TR_7=4D
		V_PGM_TR_8=33
		V_PGM_TR_9=1A
		
	M_PGM_IM="Immersive Mode"
		S_PGM_IM_Y="Activate"
		V_PGM_IM_Y="true"
		
	M_PGM_FL="Fullscreen Mode"
		S_PGM_FL_Y="Activate"
		V_PGM_FL_Y="true"
		
	M_PGM_RK="Reduce bottom keyboard space"
		S_PGM_RK_Y="Activate"
		V_PGM_RK_Y="true"

# Containers
cont_MAIN="
URM
SNM
PGM
"

cont_URM="
URM_S
URM_N
URM_M
URM_L
URM_C
"


cont_SNM="
SNM_SH
SNM_SP
SNM_NK
SNM_NP
SNM_MS
"
	cont_SNM_SH="
	SNM_SH_M
	SNM_SH_L
	SNM_SH_X
	SNM_SH_C
	"

	cont_SNM_SP="
	SNM_SP_B
	SNM_SP_C
	"

	cont_SNM_NK="SNM_NK_Y"

	cont_SNM_NP="
	SNM_NP_B
	SNM_NP_C
	"
	cont_SNM_MS="SNM_MS_Y"

cont_PGM="
PGM_SH
PGM_CL
PGM_TR
PGM_IM
PGM_FL
PGM_RK
"
	cont_PGM_SH="
	PGM_SH_TH
	PGM_SH_LE
	"
		cont_PGM_SH_TH="
		PGM_SH_TH_AO
		PGM_SH_TH_MI
		PGM_SH_TH_IO
		PGM_SH_TH_U1
		PGM_SH_TH_C
		"
		
		cont_PGM_SH_LE="
		PGM_SH_LE_P
		PGM_SH_LE_L
		"
			cont_PGM_SH_LE_P="
			PGM_SH_LE_P_AO
			PGM_SH_LE_P_U1
			PGM_SH_LE_P_OS
			PGM_SH_LE_P_MI
			PGM_SH_LE_P_IO
			PGM_SH_LE_P_U2
			PGM_SH_LE_P_U3
			PGM_SH_LE_P_C
			"
			
			cont_PGM_SH_LE_L="
			PGM_SH_LE_L_DF
			PGM_SH_LE_L_C
			"
			
	cont_PGM_CL="
	PGM_CL_LH
	PGM_CL_DR
	"
		cont_PGM_CL_LH="
		PGM_CL_LH_DFBK
		PGM_CL_LH_AMTY
		PGM_CL_LH_AQMR
		PGM_CL_LH_CRBN
		PGM_CL_LH_CNMN
		PGM_CL_LH_OCEA
		PGM_CL_LH_ORCD
		PGM_CL_LH_PLTT
		PGM_CL_LH_SAND
		PGM_CL_LH_SPCE
		PGM_CL_LH_TGRN
		PGM_CL_LH_CRED
		PGM_CL_LH_BRWN
		PGM_CL_LH_ELYL
		PGM_CL_LH_ORNG
		PGM_CL_LH_GREN
		PGM_CL_LH_CYAN
		PGM_CL_LH_BLUE
		PGM_CL_LH_MGNT
		PGM_CL_LH_PRPL
		PGM_CL_LH_HTPK
		PGM_CL_LH_CRMS
		PGM_CL_LH_BRMR
		PGM_CL_LH_ROSE
		PGM_CL_LH_SLMN
		PGM_CL_LH_CORL
		PGM_CL_LH_ORRD
		PGM_CL_LH_CCOA
		PGM_CL_LH_GLDN
		PGM_CL_LH_OLVE
		PGM_CL_LH_LIME
		PGM_CL_LH_SRGR
		PGM_CL_LH_TRQS
		PGM_CL_LH_INDG
		PGM_CL_LH_MIBL
		PGM_CL_LH_PXBL
		PGM_CL_LH_OPRD
		PGM_CL_LH_DSCR
		PGM_CL_LH_SPGR
		PGM_CL_LH_TWTR
		PGM_CL_LH_RZGR
		PGM_CL_LH_REDT
		PGM_CL_LH_VNGR
		"
		
		cont_PGM_CL_DR="
		PGM_CL_DR_DFWT
		PGM_CL_DR_AMTY
		PGM_CL_DR_AQMR
		PGM_CL_DR_CRBN
		PGM_CL_DR_CNMN
		PGM_CL_DR_OCEA
		PGM_CL_DR_ORCD
		PGM_CL_DR_PLTT
		PGM_CL_DR_SAND
		PGM_CL_DR_SPCE
		PGM_CL_DR_TGRN
		PGM_CL_DR_CRED
		PGM_CL_DR_BRWN
		PGM_CL_DR_ELYL
		PGM_CL_DR_ORNG
		PGM_CL_DR_GREN
		PGM_CL_DR_CYAN
		PGM_CL_DR_BLUE
		PGM_CL_DR_MGNT
		PGM_CL_DR_PRPL
		PGM_CL_DR_HTPK
		PGM_CL_DR_CRMS
		PGM_CL_DR_BRMR
		PGM_CL_DR_ROSE
		PGM_CL_DR_SLMN
		PGM_CL_DR_CORL
		PGM_CL_DR_ORRD
		PGM_CL_DR_CCOA
		PGM_CL_DR_GLDN
		PGM_CL_DR_OLVE
		PGM_CL_DR_LIME
		PGM_CL_DR_SRGR
		PGM_CL_DR_TRQS
		PGM_CL_DR_INDG
		PGM_CL_DR_MIBL
		PGM_CL_DR_PXBL
		PGM_CL_DR_OPRD
		PGM_CL_DR_DSCR
		PGM_CL_DR_SPGR
		PGM_CL_DR_TWTR
		PGM_CL_DR_RZGR
		PGM_CL_DR_REDT
		PGM_CL_DR_VNGR
		"
	
	cont_PGM_TR="
	PGM_TR_1
	PGM_TR_2
	PGM_TR_3
	PGM_TR_4
	PGM_TR_5
	PGM_TR_6
	PGM_TR_7
	PGM_TR_8
	PGM_TR_9
	"
	cont_PGM_IM="PGM_IM_Y"
	cont_PGM_FL="PGM_FL_Y"
	cont_PGM_RK="PGM_RK_Y"

#--------------------------------- BACKEND ENVIRONMENT ----------------------------------#
# List of container which has selection type content
MODLIST="
cont_URM
cont_SNM_SH
cont_SNM_SP
cont_SNM_NK
cont_SNM_NP
cont_SNM_MS
cont_PGM_SH_TH
cont_PGM_SH_LE_P
cont_PGM_SH_LE_L
cont_PGM_CL_LH
cont_PGM_CL_DR
cont_PGM_TR
cont_PGM_IM
cont_PGM_FL
cont_PGM_RK
"

PGMNONFULL="
cont_PGM_SH_TH
cont_PGM_SH_LE_P
cont_PGM_SH_LE_L
cont_PGM_CL_LH
cont_PGM_CL_DR
cont_PGM_TR
cont_PGM_IM
"

# Define selected string
SELECTEDMOD="
D_URM
D_SNM_SH
D_SNM_SP
D_SNM_NK
D_SNM_NP
D_SNM_MS
D_PGM_SH_TH
D_PGM_SH_LE_P
D_PGM_SH_LE_L
D_PGM_CL_LH
D_PGM_CL_DR
D_PGM_TR
D_PGM_IM
D_PGM_FL
D_PGM_RK
"

# Log to save
LOGTOSAVE="
MODTITLE
VER
REL
BRAND
MODEL
DEVICE
ROM
API
MIUI
MIUIVERCODE
OOS
_bb
BINPATH
D_URM
D_SNM_SH
D_SNM_SP
D_SNM_NK
D_SNM_NP
D_SNM_MS
D_PGM_SH_TH
D_PGM_SH_LE_P
D_PGM_SH_LE_L
D_PGM_CL_LH
D_PGM_CL_DR
D_PGM_TR
D_PGM_IM
D_PGM_FL
D_PGM_RK
"
































