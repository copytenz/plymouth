#!/bin/bash

################################################################################
# SCRIPT: 	plymouth-test.sh
#
# DESCRIPTION:	tests currently installed plymouth theme
#		Doesn't yet work as I would dream but still usefull
#
# USAGE: 	plymouth-test.sh 
#
# VERSION: 	0.1 
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


plymouthd --tty=`tty` --mode=boot --kernel-command-line="quit splash"
plymouth --ping && echo "plymouth is running" || echo "plymouth is NOT running" 
plymouth show-splash 
plymouth update --status="Hello" 

sleep 2 
# sudo plymouth update --status="This is a test..."; 

plymouth display-message --text="This is a test..."; 
sleep 3

plymouth display-message --text="This is a test 2..."; 
sleep 3

plymouth hide-message --text="This is a test..."; 
plymouth display-message --text="This is a test 3..."; 
sleep 3; 

plymouth quit
killall plymouthd
