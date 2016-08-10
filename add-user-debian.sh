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
read -p "$(echo "Enter your username: ")" USER
while true
	do
		read -s -p "$(echo "Enter your password: ")" PASS
        echo
		read -s -p "$(echo "Enter your Password (again): ")" PASS2
		[ "$PASS" = "$PASS2" ] && break
        echo
        echo
        echo "*********************************************"
		echo "Your passwords don´t match, please try again."
        echo "*********************************************"
        echo
	done
echo
echo
read -p "$(echo -e "Enter your AuthorizedKeysFile: ")" SSH


## Accounts & SSH
echo
echo

HASH=$(openssl passwd -1 -salt temp $PASS)

echo "USER ACCOUNT"
echo "Creating user account..."
        useradd $USER -s /bin/bash -m -U -p $HASH

echo "Creating SSH folder..."
        mkdir /home/$USER/.ssh

echo "Adding public key..."
    echo "$SSH" > /home/$USER/.ssh/authorized_keys

echo "Setting folder and file permissions..."
        chown $USER:$USER /home/$USER/.ssh
        chown $USER:$USER /home/$USER/.ssh/authorized_keys
        chmod 700 /home/$USER/.ssh
        chmod 600 /home/$USER/.ssh/authorized_keys

echo "Adding user account to sudoers file..."
echo "
# User privilege specification
$USER   ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo
echo
