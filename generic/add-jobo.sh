#!/bin/bash

#############################################################################
# Version 1.0.1
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
USER='jobo'
SSH='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTmR1BP/BjZ52iDZDMvJ4kQ03KDyLpLDhBlvX003WUo2bwY2vLXC9Tl2KnKFl4nQ4It6CRqoABicWeJw2ac5G8dt6Q9dxiUUWH3PZyjwsIP8gsPkhu97bVrBgEDRe8Aygs/k81YRD9IeqLrWGFX5mKHJCzf4iLBCZdcNfgvWc7JxX6CjQasPcAqjx1Nfsn+os/M1sMKMNFfA2hRDPS3b88OLrIDPBkaLkjaPbEB/xSP3jLnWt/DnvNN8oNYmsm9SC8XZF8sXgg1izWFDM/Fz22V4lK7BF+RxpQIwNpKmZNTrIiyBZdlbkDUAKtOYOotrEC8HzrKYDhKSGbxjhEtVDCG0X4BZcd7ot0fzTRlLIlHRJtbWhSZoL/pBErmPEWSLQmG6JqvoaL7turXCZqZ1HE8GmJPEKu0RDdCraX3P6bJodQ/KDDLkUXrOzV64PgoErP4NdcDTklVsZSI/XcZeutVFYRa+++xfFEuhGz5ynQFUsEhslms3BeSfnT6doO0GklC9rFWN7/qSpKwrAq2wCmIjnyhdcaQNonbeSMrpdYz9CHpI9S7O7YRd3nPvWR6QwglJM0iT3je/Ee4KCgz5uExTyPaih/9B79/GIQmOOb4B4aMhbM1OaC++JaesYbzdk2WfwfdXbTCuEDgsQ+3b6un2H/FEsq3veL3TgbyFlCwQ=='


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
