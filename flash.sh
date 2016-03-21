#!/bin/bash

bldred='\e[1;31m' # BoldRed
red='\e[7;31m'    # Red
txtgrn='\e[0;32m' # Green
txtrst='\e[0m'    # Text Reset
bldcyn='\e[1;36m' # Cyan
bld='\e[1;1m'     # Bold
sub='\e[1;7m'
mk='\e[0;9m'      # Subrayado
window='\e[4;36m' # Window

CHECKFB="$(command -v fastboot)"
verified='Verificando Archivos'
flash='Flashing'
succed='Completado Correctamente'
error=''$bldred'ERROR! - ABORTING!'$txtrst''

msg='	Se esta verificando que ningun archivo este dañado mediante la comprobacion de las sumas MD5.' 
msg2='	Esto es para evitar errores que puedan causar algun brickeo o hardbrick'
msg3='	Si algun archivo esta dañado se detendra automaticamente el script!.'

##
## Variables
##


boot() {
if [ -f boot.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo -e "FAIL!"
fi
}

recovery() {
if [ -f recovery.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!" 
fi
}

motoboot() {
if [ -f motoboot.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!" 
fi
}

system0() {
if [ -f system.img_sparsechunk.0 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

system1() {
if [ -f system.img_sparsechunk.1 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

system2() {
if [ -f system.img_sparsechunk.2 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

system3() {
if [ -f system.img_sparsechunk.3 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

logo() {
if [ -f logo.bin ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

gpt() {
if [ -f gpt.bin ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

fsg() {
if [ -f fsg.mbn ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}

## Fails
GOTOFAILM() {
	echo " "
	echo -e "       ""${red}ERROR: Sumas No coinciden " "--" "ABORTING!${txtrst}"
	echo " "
	echo -e "${bldred}################## $error ${bldred}##################${txtrst}"
exit
}

GOTOFAIL() {
	echo " "
	echo -e "       ""${red}ERROR: Faltan Archivos" "--" "ABORTING!${txtrst}"
	echo " "
	echo -e "${bldred}################## $error ${bldred}##################${txtrst}"
exit
}

GOTOADBN() {
	echo " "
	echo -e "       ""${red}ERROR: No estan instaladas adb y/o fastboot" "--" "ABORTING!${txtrst}"
	echo " "
exit
}

GOTOFLASH() {
clear
echo -e "${txtgrn}################# $flash #################${txtrst}"
adb devices
fastboot devices >> logcat.txt
fastboot flash partition gpt.bin >> logcat.txt
fastboot flash motoboot motoboot.img >> logcat.txt
fastboot flash logo logo.bin >> logcat.txt
fastboot flash boot boot.img >> logcat.txt
fastboot flash recovery recovery.img >> logcat.txt
fastboot flash system system.img_sparsechunk.0 >> logcat.txt
fastboot flash system system.img_sparsechunk.1 >> logcat.txt
fastboot flash system system.img_sparsechunk.2 >> logcat.txt
fastboot flash system system.img_sparsechunk.3 >> logcat.txt
fastboot flash modem NON-HLOS.bin >> logcat.txt
fastboot erase modemst1 >> logcat.txt
fastboot erase modemst2 >> logcat.txt
fastboot flash fsg fsg.mbn >> logcat.txt
fastboot erase cache >> logcat.txt
fastboot erase userdata >> logcat.txt
}

## Actions
GOTOMD5 () {

# Recovery
obj='Recovery.img'
recoverymd5 () {
img='recovery'
echo "a65a392f40bea955c647c07f7d66a132"  "$img"".img" > $img.img.md5sum
ok="$(md5sum -c $img.img.md5sum)"
rm $img.img.md5sum
echo "$ok"
sleep 1s
}

if [[ $(recoverymd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##''                    '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##''                    '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo ""

# Boot
obj='Boot.img'
bootmd5 () {
img='boot'
echo "663a3f10ea3f409482d09b07e3c96a07"  "$img"".img" > $img.img.md5sum
ok="$(md5sum -c $img.img.md5sum)"
rm $img.img.md5sum
echo "$ok"
sleep 1s
}

if [[ $(bootmd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'####''                  '''${txtrst}'][20%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'####''                  '''${txtrst}'][20%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo ""

# Motoboot
obj='Motoboot.img'
motobootmd5 () {
img='motoboot'
echo "50fa4c2ef75bc4f8238d22ab176b9183"  "$img"".img" > $img.img.md5sum
ok="$(md5sum -c $img.img.md5sum)"
rm $img.img.md5sum
echo "$ok"
sleep 1s
}

if [[ $(motobootmd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'######''                '''${txtrst}'][30%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide]'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'######''                '''${txtrst}'][30%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo ""

# NON-HLOS
obj='NON-HLOS.bin'
NONmd5 () {
bin='NON-HLOS'
echo "c55d125d6c102b5342894f1357f8a0ab"  "$bin"".bin" > $bin.bin.md5sum
ok="$(md5sum -c $bin.bin.md5sum)"
rm $bin.bin.md5sum
echo "$ok"
sleep 1s
}

if [[ $(NONmd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'########''              '''${txtrst}'][40%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide]'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'########''              '''${txtrst}'][40%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo ""

# Logo
obj='Logo.bin'
logomd5 () {
bin='logo'
echo "1c958756245ce98d8809d9950dfb919f"  "$bin"".bin" > $bin.bin.md5sum
ok="$(md5sum -c $bin.bin.md5sum)"
rm $bin.bin.md5sum
echo "$ok"
sleep 1s
}

if [[ $(logomd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##########''            '''${txtrst}'][50%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##########''            '''${txtrst}'][50%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# GPT
obj='gpt.bin'
gptmd5 () {
bin='gpt'
echo "d2a24891c7f34b85f7d8e91a6bec218b"  "$bin"".bin" > $bin.bin.md5sum
ok="$(md5sum -c $bin.bin.md5sum)"
rm $bin.bin.md5sum
echo "$ok"
sleep 1s
}

if [[ $(gptmd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'############''          '''${txtrst}'][60%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'############''          '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# FSG
obj='fsg.mbn'
fsgmd5 () {
mbn='fsg'
echo "fe1a07f8bfdf85c2451d96c0dcbd7339"  "$mbn"".mbn" > $mbn.mbn.md5sum
ok="$(md5sum -c $mbn.mbn.md5sum)"
rm $mbn.mbn.md5sum
echo "$ok"
sleep 1s
}

if [[ $(fsgmd5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##############''        '''${txtrst}'][70%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##############''        '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# system0
obj='system.img_sparsechunk.0'
system0md5 () {
system='system.img_sparsechunk.0'
echo "a2795f04f473f7f34073d5c7eb80b06b"  "$system" > $system.md5sum
ok="$(md5sum -c $system.md5sum)"
rm $system.md5sum
echo "$ok"
sleep 1s
}

if [[ $(system0md5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'################''      '''${txtrst}'][80%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'################''      '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# system1
obj='system.img_sparsechunk.1'
system1md5 () {
system='system.img_sparsechunk.1'
echo "82c084ae16d6e928ff552f0d23db3a19"  "$system" > $system.md5sum
ok="$(md5sum -c $system.md5sum)"
rm $system.md5sum
echo "$ok"
sleep 1s
}

if [[ $(system1md5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##################''    '''${txtrst}'][90%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'##################''    '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# system2
obj='system.img_sparsechunk.2'
system2md5 () {
system='system.img_sparsechunk.2'
echo "70469948a8a90ce73a8bad2051577571"  "$system" > $system.md5sum
ok="$(md5sum -c $system.md5sum)"
rm $system.md5sum
echo "$ok"
sleep 1s
}

if [[ $(system2md5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'####################''  '''${txtrst}'][95%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'####################''  '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "

# system3
obj='system.img_sparsechunk.3'
system3md5 () {
system='system.img_sparsechunk.3'
echo "29ef84890b67964a462039688c591708"  "$system" > $system.md5sum
ok="$(md5sum -c $system.md5sum)"
rm $system.md5sum
echo "$ok"
sleep 1s
}

if [[ $(system3md5) == *"La suma coincide" ]]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "	
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'######################'${txtrst}'][100%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
	echo ""
else
	clear
	echo "$msg"
	echo "$msg2"
	echo "$msg3"
	echo ""
	echo -ne '	''['${txtgrn}'######################'${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "
echo -e '	'"${txtgrn}############### $succed ###############${txtrst}"
echo " "

}

##
## Verified files
##

GOTOVERIFIED() {
echo " "
echo -e "${txtgrn}################# $verified #################${txtrst}"

#Boot
if [ "$(boot)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando boot              [ ${bldred}$(boot)${txtrst} ]"
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando boot.img          [ $(boot) ]"
sleep 1s

#recovery
echo " "
if [ "$(recovery)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando recovery.img      [ ${bldred}$(recovery)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando recovery.img      [ $(recovery) ]"
sleep 1s

#motoboot
echo " "
if [ "$(motoboot)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando motoboot          [ ${bldred}$(motoboot)${txtrst} ]"
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando motoboot          [ $(motoboot) ]"
sleep 1s

#system0
echo " "
if [ "$(system0)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando system.0          [ ${bldred}$(system0)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando system.0          [ $(system0) ]"
sleep 1s

#system1
echo " "
if [ "$(system1)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando system.1          [ ${bldred}$(system1)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando system.1          [ $(system1) ]"
sleep 1s

#system2
echo " "
if [ "$(system2)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando system.2          [ ${bldred}$(system2)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando system.2          [ $(system2) ]"
sleep 1s

#system3
echo " "
if [ "$(system3)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando system.3          [ ${bldred}$(system3)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando system.3          [ $(system3) ]"
sleep 1s

#logo
echo " "
if [ "$(logo)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando logo              [ ${bldred}$(logo)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando logo              [ $(logo) ]"
sleep 1s

#gpt
echo " "
if [ "$(gpt)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando gpt               [ ${bldred}$(gpt)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
fi
echo "     ""Comprobando gpt               [ $(gpt) ]"
sleep 1s

#fsg
echo " "
if [ "$(fsg)" == "FAIL!" ]; then
		echo " "
		echo -e "     ""Comprobando fsg               [ ${bldred}$(fsg)${txtrst} ]" 
		GOTOFAIL
else
	echo " "
	echo "     ""Comprobando fsg               [ $(fsg) ]"
fi
echo " "
echo -e "${txtgrn}############### $succed ###############${txtrst}"
echo " "
}

##
## Pasos
##


if [ ! $CHECKFB ]; then
	echo
	echo "               ""No esta instalado ADB y/o fastboot"
	echo "               ""Primero debe instalar esas herramientas"
	GOTOADBN
else
	echo " "
fi


#start
echo
echo -e "    ""${window}*********************************************************************${txtrst}"
echo -e "    ""${window}**${txtrst}""                     ""MOTOROLA FLASHER""                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""PROCESO""             ""current: paso 1""                   ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""          ""1.- Verificacion de archivos""                           ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""2.- Comprobar sumas de verificacion""                    ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""3.- Flasheo""                                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""presione cualquier tecla para inciar el paso 1""        ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}*********************************************************************${txtrst}"
echo
read -n1 any_key
clear
GOTOVERIFIED
echo "paso 1 completado; presione cualquier tecla para continuar"
read -n1 any_key

#verifiedmd5
clear
echo
echo -e "    ""${window}*********************************************************************${txtrst}"
echo -e "    ""${window}**${txtrst}""                     ""MOTOROLA FLASHER""                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""PROCESO""             ""current: paso 2""                   ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""          ""1.- ${mk}Verificacion de archivos${txtrst}""                           ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""2.- Comprobar sumas de verificacion""                    ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""3.- Flasheo""                                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""presione cualquier tecla para inciar el paso 2""        ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}*********************************************************************${txtrst}"
echo
read -n1 any_key
clear
GOTOMD5
echo "paso 2 completado; presione cualquier tecla para continuar"
read -n1 any_key

##flash
clear
echo
echo -e "    ""${window}*********************************************************************${txtrst}"
echo -e "    ""${window}**${txtrst}""                     ""MOTOROLA FLASHER""                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""PROCESO""             ""current: paso 2""                   ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""          ""1.- ${mk}Verificacion de archivos${txtrst}""                           ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""2.- ${mk}Comprobar sumas de verificacion${txtrst}""                    ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""3.- Flasheo""                                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""presione cualquier tecla para inciar el paso 3""        ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}*********************************************************************${txtrst}"
echo
read -n1 any_key
clear
GOTOFLASH
echo "paso 3 completado; presione cualquier tecla para continuar"
read -n1 any_key

#success
clear
echo
echo -e "    ""${window}*********************************************************************${txtrst}"
echo -e "    ""${window}**${txtrst}""                     ""MOTOROLA FLASHER""                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""PROCESO""             ""current: paso 2""                   ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""          ""1.- ${mk}Verificacion de archivos${txtrst}""                           ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""2.- ${mk}Comprobar sumas de verificacion${txtrst}""                    ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""   	""3.- ${mk}Flasheo${txtrst}""                                            ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""           ""presione cualquier tecla para salir""                   ""${window}**${txtrst}"
echo -e "    ""${window}**${txtrst}""                                                                 ""${window}**${txtrst}"
echo -e "    ""${window}*********************************************************************${txtrst}"
echo
read -n1 any_key 




