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
USER='meko'
SSH='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwovyCkVtYPV1h4Fbj2mJGcYIPX3gHbDBCEDj1SZVWzBsvh+4MifJBmAczaP9Gu/jaP8TuO/x7giXpQDo1QRFqpNwDw22XXvJbMXFHCYXrcvzwEhnNp5/PBYFafGneQ2iOuVe3l1op5uKX3tEUaSkHzEQq7eO6uixoTwoz3mlZ4U2jZ7D7Evmmq0gTOQr7Kz5z33vDeHJ+i1dboxR8aTbwZegzp/fRI+VGNtuUEwaNXBnLmlymqNJ2yT3t5FILxmiYilFystMxnYBF1Y5TBlYgboAoGH8k0ckn0Pp51p1XktHU29yTCA+qN7LhObeoeWJaqFh95NVP4VNAYk3SmoLCDv+xopizQs8IB4Zo6mgZserpsFhA/iFeWOEGcrCcjXHI5PtpswPeRDUyXzvXFwGHcN3GboZCjpHw735i8eJZ+GueDpzbjEXF9UTgGB6cz24YqSjYx8Kyru1EH1XMLSO16i8SEYw7U/f7ljh4VPw8KYOpr3pzDpn7i47tNaQ/YHzlYp1x/9pQpNEXCbzNvEODHlcF9LIdtrBpzSkIZLAavGJ0n4oSZ5ix2sM7XokzOpBefzws653CWwevz7/uNsi+wW1VKR4k0O90U7/2Wb48XRPZa0Y+fzElr+uT2ZhdQj8svdndeaRcXnB6RdYbgbnu+ux1atoxNRMY5NheWZOkqQ== Melvin@MEKO-Pro.local'


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
