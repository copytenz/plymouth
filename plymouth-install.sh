#!/bin/bash

################################################################################
# SCRIPT: 	plymouth-install.sh
#
# DESCRIPTION:	Installs plymouth theme from the current folder
#		NOTE, the script:
# 		* assumes that the system is using alternatives
# 		* assumes that ".plymouth" file is named as theme folder 
#
# USAGE: 	plymouth-install.sh [themeFolder]
# 		if themeFolder is not set, the scripts asks for it and checks that
#		  such subfolder exists in the current one and some othes according
#		  to hardcode
#
# VERSION: 	1.0 
# VERSION DATE:	2018-01-20
# CHANGE BY:	4e
# CHANGES:	* new script
################################################################################


# Check if I am root - then I am krut, otherwise re-run this script as root
 if [ $(whoami) == "root" ];then
	 echo "Running install-plymouth.sh as root" 
 else
	echo "The script is started without root priveledges, trying to restart it with sudo"
	sudo $(which bash) $0
	exit
 fi


# variable for theme name, so that one don't need to enter it everytime he wants to install new one
# if set as parameter 1 to the script - use it as theme name 
# not the best example of code, but if such subfolder exists in your space than treat this as bad luck
[ -z $1 ] && read -p "Enter theme name: " themeName || themeName=$1

echo "The name of theme is $themeName"
echo ""

sourcePath=""
while true; do
	echo "Checking if the theme folder exists.. "
	[ -d "/usr/share/plymouth/themes/$themeName" ] && sourcePath="/usr/share/plymouth/themes" || echo "Folder /usr/share/plymouth/themes/$themeName doesn't exist"	
	[ -d "./$themeName" ] &&  sourcePath="." || echo "Folder ./$themeName doesn't exist"	
	[ -d "./themes/$themeName" ] && sourcePath="./themes" || echo "Folder ./themes/$themeName doesn't exist"	
	[ -d "/opt/plymouth/themes/$themeName" ] && sourcePath="/opt/plymouth/themes" || echo "Folder /opt/plymouth/themes/$themeName doesn't exist"	
	
	if [ ! "$sourcePath" == "" ]; then
		cd $sourcePath
		break
	fi

	read -p "Enter theme name. Please ensure that folder with such name exists in the current directory: " themeName
done

 if [ ! $(pwd) == "/usr/share/plymouth/themes" ]; then	
	cp -r  "./$themeName" "/usr/share/plymouth/themes/"
	chgrp users "/usr/share/plymouth/themes/$themeName"
	chmod u+rwX,g+rwX "/usr/share/plymouth/themes/$themeName"
	cd /usr/share/plymouth/themes
 fi

echo ""
echo "I'm currently in: $(pwd)"
echo "going to install theme: $themeName"
echo "Ready to update alternatives.."
echo ""
read -p "Just a stop on my way.." anykey
	
update-alternatives --install "/usr/share/plymouth/themes/default.plymouth" "default.plymouth" "/usr/share/plymouth/themes/$themeName/$themeName.plymouth" 200
update-alternatives --config default.plymouth

update-initramfs -u
