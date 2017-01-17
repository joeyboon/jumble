#!/bin/bash

#############################################################################
# Version 1.0.0
#############################################################################

#############################################################################
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
#############################################################################

#############################################################################
# VARIABLES
#############################################################################

# COLOURS AND MARKUP
red='\033[0;31m'            # Red
green='\033[0;49;92m'       # Green
yellow='\033[0;49;93m'      # Yellow
white='\033[1;37m'          # White
grey='\033[1;49;30m'        # Grey
nc='\033[0m'                # No color

# USER ACCOUNT VARIABLES
USER='fkooman'
SSH='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/Ln06n7A0fOd4ofJCrG8hN46th9L3eLNjvFIq7KPGTkTFH0dFE8pNIPZj3mkwKIFSkuAr9nXKbOIEuOTYttk3DGAXcGsIluQVrDtTK6nx3t8lV2J2AwhHTQWJSVPqygGQXdeHmBdKRgwbyxZKFzq9qhi4KhEa83/FNlB/oU8kb8TsMIqSgI1qz+vCtnqd6p5/ak7nSoT7pJhCidClYifT3jvvOxCMEyjaO8Bl6jIw8EV2yOy4fx9viC79VdP9KB9ZBSSz9iRpmaJHcbUnrGFoFowkXNaSDK5dktYCbSNm5nNmpZIcMWEvoaVzeeZKY6VeGFRHR73o5KBjAmpVIe2l'


#############################################################################
# USER ACCOUNT CONFIGURATION
#############################################################################

# Username
echo
echo "Username: $USER"

# Password
while true
	do
		read -s -p "$(echo -e "${white}Enter password: ${nc}")" PASS
		echo
		read -s -p "$(echo -e "${white}Enter Password (again): ${nc}")" PASS2
			[ "$PASS" = "$PASS2" ] && break
			echo
			echo
			echo -e "${red}*********************************************"
			echo -e "${red}Your passwords don´t match, please try again."
			echo -e "${red}*********************************************"
        echo
	done


#############################################################################
# CREATE USER ACCOUNT
#############################################################################

# Hash password
HASH=$(openssl passwd -1 -salt temp $PASS)

# Add user account
echo "USER ACCOUNT"
echo "Creating user account..."
useradd $USER -s /bin/bash -m -U -p $HASH

# Create folders
echo "Creating SSH folder..."
mkdir /home/$USER/.ssh

# Add public key
echo "Adding public key..."
echo "$SSH" > /home/$USER/.ssh/authorized_keys

# Set permissions
echo "Setting folder and file permissions..."
chown $USER:$USER /home/$USER/.ssh
chown $USER:$USER /home/$USER/.ssh/authorized_keys
chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys

# Add user to sudoers
echo "Adding user account to sudoers file..."

echo "# User privilege specification
$USER   ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/$USER
echo
echo
echo "Done!"
echo
