#!/bin/bash
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
# See https://github.com/sveeke/jumble/blob/master/license.txt
# Source code on GitHub: https://github.com/sveeke/jumble


## REQUIREMENTS
echo
echo
echo "CHECKING REQUIREMENTS"

# Check if script runs as root
echo "Script is running as root..."

if [ "$EUID" -ne 0 ]; then
        echo "[NO]"
        echo
        echo "************************************************************************
This script should be run as root. Use su root and run the script again.
************************************************************************"
        echo
        exit
fi

# Check if OS is Debian 8
echo "Checking version of Debian..."

VER=$(cat /etc/debian_version)
DEBVER=${VER:0:1}
OS=$(cat /etc/issue)
DIST=${OS::-6}
RELEASE=$(head -n 1 /etc/*-release)

if [[ $DEBVER != "8" ]]; then
        echo "[NO]"
        echo
        echo "**************************************************************************************************
This script can only run on Debian 8, you are running $DIST. 
Please install Debian 8 Jessie first.
**************************************************************************************************${nc}"
        echo
        exit
fi

sleep 1


## USER CONFIGURATION ##
echo
echo "USER INPUT"
echo "The script will gather some information from you."
echo
read -p "$(echo "Enter the user you want to delete: ")" USER

# Delete user, group, files and home folder
deluser --remove-home $USER

# Delete user from the sudoers file (not yet in script)

echo
echo
