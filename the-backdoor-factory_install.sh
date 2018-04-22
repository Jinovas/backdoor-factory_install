#!/bin/bash -i

## /secretsquirrel/the-backdoor-factory Factory Setup - XFCE, 16.04

######################## CONFIG_MAIN - START ########################

sudo chown -R $USER:$USER /opt

GITREPO=https://github.com/secretsquirrel/the-backdoor-factory
BRANCH=master
GITREPOROOT=/opt/ITSEC/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory/secretsquirrel/the-backdoor-factory
GITCLONEDIR=/opt/ITSEC/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory/secretsquirrel
EXECUTEABLE1=backdoor.py
EXECUTEABLE2=backdoor-factory
BINDIR=/usr/local/bin
DSKTPFLS=/opt/ownsec/ITSEC-Install-Scripts-ORIG/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory
DSKTPFLSDEST=/home/$USER/.local/share/applications/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory
DSKTPFL=backdoorfactory.desktop
#ph1a
######################## CONFIG_MAIN - END ########################

######################## MISC - START ########################
# color
bold=$(tput bold)
normal=$(tput sgr0)
CYAN='\e[0;36m'
GREEN='\e[0;32m'
WHITE='\e[0;37m'
RED='\e[0;31m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
ORANGE='\e[38;5;166m'

# git clone 
GITCLONEFUNC () {
mkdir -p $GITCLONEDIR
cd $GITCLONEDIR
git clone -b $BRANCH $GITREPO
cd $GITREPOROOT
}
# END git clone 

# init submodules
GITSBMDLINIT () {
	git submodule init
	git submodule update --recursive
	sudo updatedb && sudo ldconfig
}
# END init submodules

# chmod bin
CHMODXEX1  () {
chmod +x $GITREPOROOT/$EXECUTEABLE1
}
CHMODXEX2  () {
chmod +x $GITREPOROOT/$EXECUTEABLE2
}

# symlink bin
SYMLINKEX2TO1  () {
sudo rm -f $BINDIR/$EXECUTEABLE2
sudo ln -s $GITREPOROOT/$EXECUTEABLE1 $BINDIR/$EXECUTEABLE2
}

WRTEDSKTPFLS () {
mkdir -p $DSKTPFLSDEST

echo '
[Desktop Entry]
Name=the_backkdoor-factory
Encoding=UTF-8
Exec=sudo sh -c " backkdoor-factory;${SHELL:-bash}"
StartupNotify=false
Terminal=true
Type=Application
Categories=9.Maintain-Access;1.OS-Backdoors;0.MultiOS-Backdoor;' > $DSKTPFLSDEST/$DSKTPFL
}

BANNER () {

echo "${bold}
 ____  ____  _____ 
| __ )|  _ \|  ___|
|  _ \| | | | |_   
| |_) | |_| |  _|  
|____/|____/|_|    
           
INSTALL secretsquirrel/the-backdoor-factory
${normal}"
}

INSTDEPS () {

LIBS_DEPS="libtool
libcurl4-openssl-dev
"

PYTHON_DEPS="python
python-capstone
python-pefile
"
### DEPS:

OTHER_DEPS="autoconf
curl
"

sudo apt-get update
sudo apt-get upgrade

echo $LIBS_DEPS | while read libsdeps
do
   sudo apt-get install -y $libsdeps
done

echo $PYTHON_DEPS | while read pythondeps
do
   sudo apt-get install -y $pythondeps
done

echo $OTHER_DEPS | while read otherdeps
do
   sudo apt-get install -y $otherdeps
done

sudo udpatedb
sudo ldconfig
### DEPS END
}

INSTALLROUTINE1 () {
 cd osslsigncode
    ./autogen.sh
    ./configure
	make
	make install
    cd ..	

	uname -a | grep -i "armv" &> /dev/null
        if [ $? -ne 0 ]; then
                echo "[*] installing appack for onionduke"
		echo "[*] installing dependences"
		sudo apt-get install libc6-dev-i386
                cd ./aPLib/example/
                gcc -c -I../lib/elf -m32 -Wall -O2 -s -o appack.o appack.c -v 
                gcc -m32 -Wall -O2 -s -o appack appack.o ../lib/elf/aplib.a -v 
                sudo cp ./appack /usr/bin/appack        
        else
                echo "[!!!!] Arm not supported for aPLib"
	fi
}
######################## MISC - END ########################

which backdoor-factory > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

echo "${bold} the-backdoor-factory is installed! Skip installation!${normal}"

else
echo "${bold} the-backdoor-factory  is not installed! Installing!${normal}"

BANNER

echo -e " ${bold} ... install apt-get deps${normal}"
INSTDEPS

echo -e " ${bold} ... git clone${normal}"
GITCLONEFUNC
echo -e " ${bold} ... submodule init${normal}"
GITSBMDLINIT

echo -e " ${bold} ... install routine 1${normal}"
INSTALLROUTINE1

echo -e " ${bold} ... chmod+x exec${normal}"
CHMODXEX1
echo -e " ${bold} ... symlink exec${normal}"
SYMLINKEX2TO1

echo -e " ${bold} ... copy xfce .desktop files${normal}"
WRTEDSKTPFLS

echo -e " $YELLOW ${bold} secretsquirrel/the-backdoor-factory backdoor factory installation COMPLETE :)${normal}"

fi

