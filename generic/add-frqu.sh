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
USER='frqu'
SSH='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRAdzQMOcNqDjawtlWMh40ns9OuS6fi4ru282lXT2OTVPmkesSKIYOBv42DdyCB6vvqsAGQZXNQGDlAmV2F8Ok12ay+698F3nt7xY88pn0bihE6B5sTbvCXFAMd/O2N6tz3YrX9a1IfuIVm8/DLfBT1nLJiySLRLP243hsQJVW2BNU7FjS3B9qgWxcQmhWmqjjYi4nYcrFNmVwqBArQ6PZ61zs3UA3C+QM+5jLGKUylAkQILwzw4hzVLhALa8vPd2246jb5hKG4q4dm9Mfcuh4OCaY1mJ1YPzAouvWw5aXqwmJUOt7ewO1SqemQtm/P2DvowYWGUwRfjkJIRpXA0Di01Vi+6qlVNXA+JoqdyB4ou63WIRm8TD37qSPWqMRgi9Bz0wWnyhh+f8mDBXcfOoJfMyPSj+fgY6NJnSweWGFNn7Vd9aeWEre8AAR3JeMjQby59+AX8i6vsB5LJjRTRHCTdpsyaukKURpHPKqFPSTDlthSE/71nSvJnsGEZs/CNJ/XMyFIhhJXgvhkS6mLwV6ubRw46xJkwMovwZLu2S6kebAMNJYoPqMKvDlpDF8PsooqfTo3JVDUZ2shaUMlv/AGCL9cE+GGcE4TrIkbTJNKH/i4iDA9TXbDqsjGBrfWkLnhLXN1/UMhB56nWfBc7QrzvjNd+PMsmCtkqq4qPMQWw=='


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
