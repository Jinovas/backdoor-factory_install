#!/bin/bash

#1i
. /opt/ownsec/ITSEC-Install-Scripts-ORIG/001.functions/all-scripts.sh

GITREPO=https://github.com/secretsquirrel/the-backdoor-factory
BRANCH=master
GITREPOROOT=/opt/ITSEC/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory/secretsquirrel/the-backdoor-factory
GITCONFDIR=/opt/ITSEC/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory/secretsquirrel/the-backdoor-factory/.git
GITCLONEDIR=/opt/ITSEC/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory/secretsquirrel
EXECUTEABLE1=backdoor.py
EXECUTEABLE2=backdoor-factory
#ph1b
DSKTPFLS=/opt/ownsec/ITSEC-Install-Scripts-ORIG/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory
DSKTPFLSDEST=/home/$USER/.local/share/applications/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory
DSKTPFL=backdoorfactory.desktop
APTLSTDIR=/opt/ownsec/ITSEC-Install-Scripts-ORIG/9.Maintain-Access/1.OS-Backdoors/0.MultiOS-Backdoor/the-backdoor-factory
#hd6cv

echo "${bold}
 ____  ____  _____ 
| __ )|  _ \|  ___|
|  _ \| | | | |_   
| |_) | |_| |  _|  
|____/|____/|_|    
           
UPDATE
${normal}"

GITUPTODATE
if git checkout $BRANCH &&
git fetch origin $BRANCH &&
[ `git rev-list HEAD...origin/$BRANCH --count` != 0 ] &&
git merge origin/$BRANCH
then
    
GITCLONEFUNC
sudo rm -f /usr/local/bin/$EXECUTEABLE2
sudo updatedb
sudo ldconfig
GITRESET
GITSBMDLINIT

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

CHMODXEX1
sudo ln -s $GITREPOROOT/$EXECUTEABLE1 /usr/local/bin/$EXECUTEABLE2

#333d
CPDESKTFL


echo "${bold}
UPDATED
${normal}"

else

echo "${bold}
UP TO DATE
${normal}"
	
fi



