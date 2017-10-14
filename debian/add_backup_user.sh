#!/bin/bash

#############################################################################
# Version 0.1.0 (14-10-2017)
#############################################################################

#############################################################################
# Copyright 2017 Sebas Veeke. Released under the AGPLv3 license
# Source code on GitHub: https://github.com/sveeke/
#############################################################################


#############################################################################
# INTRODUCTION
#############################################################################

echo
echo
echo '################################################################'
echo '######################### INTRODUCTION #########################'
echo '################################################################'
echo
echo "With this script, you can add backup user accounts with limited" 
echo "capabilities to be used by automated backup scripts on servers."
echo "The user accounts will be limited with a restricted shell."

sleep 2

#############################################################################
# CHECKING REQUIREMENTS
#############################################################################

echo
echo
echo "1. CHECKING REQUIREMENTS"

# Checking if script runs as root
echo "Checking if script runs as root..."

if [ "$EUID" != 0 ]; then
    echo
    echo "************************************************************************"
	echo "This script should be run as root. Use su root and run the script again."
	echo "************************************************************************"
    echo
	exit 1
fi

# Checking Debian version
echo "Checking compatibility Debian version..."

if [ -f /etc/debian_version ]; then
    DEBVER=$(cat /etc/debian_version | cut -d '.' -f 1 | cut -d '/' -f 1)

    if [ "$DEBVER" = "8" ] || [ "$DEBVER" = "jessie" ]; then
        OS='8'

    elif [ "$DEBVER" = "9" ] || [ "$DEBVER" = "stretch" ]; then
        OS='9'

    else
        echo
        echo "**********************************************************************"
        echo "This script will only work on Debian 8 (Jessie) or Debian 9 (Stretch)."
        echo "**********************************************************************"
        echo
        exit 1
    fi
fi

# Checking if dependencies are installed
echo "Checking if dependencies are met..."

if [ "$(which pwgen)" != '/usr/bin/pwgen' ] && [ "$(which rssh)" != '/usr/bin/rssh' ]; then
    echo
    echo "***************************************************************"
    echo "Please install missing dependencies with apt install pwgen rssh"
    echo "***************************************************************"
    echo
    exit 1
fi

echo
echo "All good!"
    


#############################################################################
# USER INPUT
#############################################################################

echo
echo
echo "2. USER INPUT"
echo "The script will gather some information from you."
echo

# Choose username backup account, username can't be 'backup'
while true
    do
        read -r -p "Enter backup account username:                      " BACKUPUSER
            [ "$BACKUPUSER" != "backup" ] && break
            echo
            echo "****************************************************"
            echo "User 'backup' is a system account and can't be used."
            echo "****************************************************"
        echo
    done

# Add content of AuthorizedKeysFile
    echo
    read -r -p "Enter AuthorizedKeysFile's content:                 " SSH


#############################################################################
# SETTING UP BACKUP ACCOUNT
#############################################################################

echo
echo
echo "3. CREATE BACKUP ACCOUNT"

# Create backup account
echo "Generating random password"
PASS="$(pwgen 30 -n 1)"

# Hashing and salting password
echo "Hashing and salting new password"
HASH="$(openssl passwd -1 -salt $(openssl rand -base64 6) "$PASS")"

# Add user account with salted password to system
echo "Adding account to system"
useradd "$BACKUPUSER" -s /usr/bin/rssh -m -U -p "$HASH"

# Creating folders within the given backup account's home directory
echo "Creating backup folders..."
mkdir /home/"$BACKUPUSER"/backup

# Create SSH folder
echo "Creating SSH folder..."
mkdir /home/"$BACKUPUSER"/.ssh

# Add public key to AuthorizedKeysFile
echo "Adding public key..."
echo "$SSH" > /home/"$BACKUPUSER"/.ssh/authorized_keys

# Setting folder and file permissions
echo "Setting folder and file permissions..."
chown -R "$BACKUPUSER":"$BACKUPUSER" /home/"$BACKUPUSER"/.ssh
chmod 770 /home/"$BACKUPUSER"/backup
chmod 700 /home/"$BACKUPUSER"/.ssh
chmod 600 /home/"$BACKUPUSER"/.ssh/authorized_keys

echo
echo "All done!"
echo

exit 1