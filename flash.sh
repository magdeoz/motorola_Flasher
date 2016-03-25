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
version='1.6'
CHECKFB="$(command -v fastboot)"
verified='Verificando Archivos'
flash='Flashing'
succed='Completado Correctamente'
error=''$bldred'ERROR! - ABORTING!'$txtrst''

msg='	Se esta verificando que ningun archivo este dañado mediante la comprobacion de las sumas MD5.' 
msg2='	Esto es para evitar errores que puedan causar algun brickeo o hardbrick'
msg3='	Si algun archivo esta dañado se detendra automaticamente el script!.'

info () {
if [ -f factory_version_info_cfc.txt ]; then
	echo " "
	echo -e "    ""${window}*********************************************************************************${txtrst}"
	cat -b factory_version_info_cfc.txt
	echo -e "    ""${window}*********************************************************************************${txtrst}"
	echo "                      ""presione cualquier tecla para continuar"
	read -n1 any_key							
	clear	
else
	echo "           ""No se encontro informacion del Firmware!"
fi
}


## Fails
GOTOFAILM() {
	echo " "
	echo -e "       ""${red}ERROR: Sumas No coinciden " "--" "ABORTING!${txtrst}"
	echo " "
	echo -e "	""${bldred}################## $error ${bldred}##################${txtrst}"
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

GOTOFAILV() {
	echo " "
	echo -e "           ""${red}ERROR: No se encontro el archivo" "--" "ABORTING!${txtrst}"
	echo " "
	echo -e "	""${bldred}################## $error ${bldred}##################${txtrst}"
exit
}

GOTOFLASH() {
clear
echo -e "${txtgrn}################# $flash #################${txtrst}"
	echo 'Detectando dispositivo...'
		adb devices
	echo "Reiniciando en modo bootloader"
		adb reboot bootloader
	echo "Detectando dsipositivo"
		fastboot devices
	echo "Inciciano proceso"
	echo "Presione cualquier tecla para continuar"
		read -n1 any_key 
	echo "flasheando tabla de pariciones"
		fastboot flash partition gpt.bin
	echo "Flasheando bootloader "
		fastboot flash motoboot motoboot.img
	echo "Flasheando logo..."
		fastboot flash logo logo.bin
	echo "Flasheando kernel..."
		fastboot flash boot boot.img
	echo "flasheando recovery"
		fastboot flash recovery recovery.img
	echo "Flasheando sistema (1/4)"
		fastboot flash system system.img_sparsechunk.0
	echo "Flasheando sistema (2/4)"
		fastboot flash system system.img_sparsechunk.1
	echo "Flasheando sistema (3/4)"
		fastboot flash system system.img_sparsechunk.2
	echo "Flasheando sistema (4/4)"
		fastboot flash system system.img_sparsechunk.3
	echo "Flasheando Modem"
		fastboot flash modem NON-HLOS.bin
		fastboot erase modemst1
		fastboot erase modemst2
		fastboot flash fsg fsg.mbn
	echo "Limpiando cache"
		fastboot erase cache
	echo "Borrando Datos"
		fastboot erase userdata
	echo " "
	echo -e "${txtgrn}############### $succed ###############${txtrst}"
	echo " "
GOTOMENU
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
	echo -ne '	''['${txtgrn}'######''                '''${txtrst}'][30%]['${bldcyn}''$obj''${txtrst}': '${bld}'La suma coincide'${txtrst}']\r'
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
	echo -ne '	''['${txtgrn}'############''          '''${txtrst}'][60%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
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
	echo -ne '	''['${txtgrn}'##############''        '''${txtrst}'][70%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
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
	echo -ne '	''['${txtgrn}'################''      '''${txtrst}'][80%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
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
	echo -ne '	''['${txtgrn}'##################''    '''${txtrst}'][90%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
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
	echo -ne '	''['${txtgrn}'######################'${txtrst}'][100%]['${bldcyn}''$obj''${txtrst}': '${bldred}'La suma NO coincide'${txtrst}']\r'
	echo ""
	GOTOFAILM
	exit
fi

echo " "
echo -e '	'"${txtgrn}############### $succed ###############${txtrst}"
echo " "
sleep 3s
clear
GOTOMENU
}

##
## Verified files
##

GOTOVERIFIED() {
boot() {
if [ -f boot.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo -e "FAIL!"
fi
}

obj='boot.img'
#Boot
if [ "$(boot)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##''                    '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bldred}'Falta el archivo1!'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##''                    '''${txtrst}'][10%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


recovery() {
if [ -f recovery.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo -e "FAIL!"
fi
}
obj='recovery.img'
#recovery
if [ "$(recovery)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'####''                  '''${txtrst}'][20%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'####''                  '''${txtrst}'][20%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


motoboot() {
if [ -f motoboot.img ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!" 
fi
}
obj='motoboot.img'
#motoboot
if [ "$(motoboot)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'######''                '''${txtrst}'][30%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el Archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'######''                '''${txtrst}'][30%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


system0() {
if [ -f system.img_sparsechunk.0 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='system.img_sparsechunk.0'
#system0
if [ "$(system0)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'########''              '''${txtrst}'][40%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el Archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'########''              '''${txtrst}'][40%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


system1() {
if [ -f system.img_sparsechunk.1 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='system.img_sparsechunk.1'
#system1
if [ "$(system1)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##########''            '''${txtrst}'][50%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##########''            '''${txtrst}'][50%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


system2() {
if [ -f system.img_sparsechunk.2 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='system.img_sparsechunk.2'
#system2
if [ "$(system2)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'############''          '''${txtrst}'][60%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'############''          '''${txtrst}'][60%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi

system3() {
if [ -f system.img_sparsechunk.3 ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='system.img_sparsechunk.3'
#system3
if [ "$(system3)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##############''        '''${txtrst}'][70%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##############''        '''${txtrst}'][70%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi

logo() {
if [ -f logo.bin ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='logo'
#logo
if [ "$(logo)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'################''      '''${txtrst}'][80%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'################''      '''${txtrst}'][80%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi


gpt() {
if [ -f gpt.bin ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='gpt.bin'
#logo
if [ "$(gpt)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##################''    '''${txtrst}'][90%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'##################''    '''${txtrst}'][90%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi

fsg() {
if [ -f fsg.mbn ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='fsg.mbn'
#logo
if [ "$(fsg)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'####################''  '''${txtrst}'][95%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'####################''  '''${txtrst}'][95%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi

NON() {
if [ -f NON-HLOS.bin ]; then
	echo -e "${txtgrn}OK${txtrst}"
else
	echo "FAIL!"
fi
}
obj='NON-HLOS.bin'
#non-hlos
if [ "$(NON)" == "FAIL!" ]; then
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'######################'${txtrst}'][100%]['${bldcyn}''$obj''${txtrst}': '${bld}'Falta el archivo'${txtrst}']\r'
	echo ""
	GOTOFAILV
	exit
else
	clear
	echo " "
	echo -e '	'"${txtgrn}################# $verified #################${txtrst}"
	echo " "
	echo -ne '	''['${txtgrn}'######################'${txtrst}'][100%]['${bldcyn}''$obj''${txtrst}': '${bld}'El Archivo existe'${txtrst}']\r'
	echo " "
	echo " "
	sleep 1s
fi

echo " "
echo -e '	'"${txtgrn}############### $succed ###############${txtrst}"
echo " "
sleep 3s
clear
GOTOMENU
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

info

GOTOMENU () {
	clear
	echo -e "    ""${window}|*******************************************|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""                                       ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""      ""${bld}MOTO FLASHER - Version $(echo "$version")${txtrst}""       ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""                                       ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""  ""Please select your option:""           ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""  ""1. Flash Rom""                         ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""  ""2. Check MD5sum""                      ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""  ""3. Verified Files""                    ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""  ""Q/q - Exit Script""                    ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*|${txtrst}""                                       ""${window}|*|${txtrst}"
	echo -e "    ""${window}|*******************************************|${txtrst}"
	echo " "
	echo -e "    ""${bldcyn}Option: ${txtrst}"
	read OPT
	if [[ ! $OPT == "1" ]]; then
		if [[ ! $OPT == "2" ]]; then
			if [[ ! $OPT == "3" ]]; then
				if [[ ! $OPT == q ]]; then
					if [[ ! $OPT == Q ]]; then
					
					clear
					echo -e "    ""${window}|*******************************************|${txtrst}"
					echo -e "    ""${window}|*|${txtrst}""                                       ""${window}|*|${txtrst}"
					echo -e "    ""${window}|*|${txtrst}""      ""${bld}MOTO FLASHER - Version $(echo "$version")${txtrst}""       ""${window}|*|${txtrst}"
					echo -e "    ""${window}|*|${txtrst}""                                       ""${window}|*|${txtrst}"
					echo -e "    ""${window}|*******************************************|${txtrst}"
					echo " "
					echo -e "    ""${bldred}Invalid Input: Please try again!${txtrst}"
					sleep 2s
					GOTOMENU
					fi
				fi
			fi
		fi
	fi
	case $OPT in
	1) GOTOFLASH ;;
	2) GOTOMD5 ;;
	3) GOTOVERIFIED ;;
	Q) clear; echo "Goodbye"; read; clear; exit;;
	q) clear; echo "Goodbye"; read; clear; exit;;
	esac
}
GOTOMENU



