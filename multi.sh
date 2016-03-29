#!/bin/bash

img () {
ls *img
}

bin () { 
ls *bin
}

system () {
ls *sparsechunk*
}

mbn () {
ls *mbn
}


create () {

if [[ $(bin) == gpt.bin* ]]; then
	echo "funciona"
	echo "fastboot flash partition gpt.bin" >> fastboot.sh
else
	echo "no funciono"
fi

if [[ $(img) == *motoboot.img* ]]; then
	echo "funciona"
	echo "fastboot flash motoboot motoboot.img" >> fastboot.sh
else
	echo "no funciono"
fi

if [[ $(img) == *bootloader.img* ]]; then
	echo "funciona"
	echo "fastboot flash motoboot motoboot.img" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(bin) == *logo.bin* ]]; then
	echo "funciona"
	echo "fastboot flash logo logo.bin" >> fastboot.sh
else
	echo "no funciono"
fi

if [[ $(img) == boot.img* ]]; then
	echo "funciona"
	echo "fastboot flash boot boot.img" >> fastboot.sh
else
	echo "no funciono"
fi

if [[ $(img) == *recovery.img* ]]; then
	echo "funciona"
	echo "fastboot flash motoboot motoboot.img" >> fastboot.sh
else
	echo "no funciono"
fi

if [[ $(system) == *sparsechunk.0* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.0" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.1* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.1" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.2* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.2" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.3* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.3" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.4* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.4" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.5* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.5" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.6* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.6" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.7* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.7" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.8* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.8" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(system) == *sparsechunk.9* ]]; then
	echo "funciona"
	echo "fastboot flash system system.img_sparsechunk.9" >> fastboot.sh
else
	echo "no existe"
fi

if [[ $(bin) == *NON-HLOS.bin* ]]; then
	echo "funciona"
	echo "fastboot flash modem NON-HLOS.bin" >> fastboot.sh
	echo "fastboot erase modemst1" >> fastboot.sh
	echo "fastboot erase modemst2" >>fastboot.sh
else
	echo "no funciono"
fi

if [[ $(mbn) == fsg.mbn ]]; then
	echo "funciona"
	echo "fastboot flash fsg fsg.mbn" >> fastboot.sh
else
	echo "no funciono"
fi

echo "fastboot erase cache" >> fastboot.sh
echo "fastboot erase userdata" >> fastboot.sh

dir="$(dirname "$0")"
. $dir/fastboot.sh
rm fastboot.sh
}

create
