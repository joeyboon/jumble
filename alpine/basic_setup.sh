#!/bin/sh

#############################################################################
# Version 1.0.0
#############################################################################

#############################################################################
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
#############################################################################

#############################################################################
# Update and upgrade operating system
#############################################################################

apk update
apk upgrade

#############################################################################
# Installing packages
#############################################################################

apk add ca-certificates libressl nano sudo curl openssh man man-pages bash bash-doc bash-completion util-linux pciutils usbutils coreutils binutils findutils grep
update-ca-certificates

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
USER='seve'
PASS='yourpasswordhere'
SSH='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC27sbzqdZEVDh382UDNfENjuUdxcHOJHavWZBg44Rw5jvGtvigIxPS2dQpBwPGLRuduK3VO9ZMM8O4qqHGN/NR+p3XhH3G9drw19hxchiqwbEGdJi6NE9nUU833RnS8TJijLvMBm9JcrXrvkesQGUhr5gs+A4JkWCHrGaOLLZutCCQu4/pYyNnJnT/bf1Oa2CrXo2QazFWffU6daTF1VnRGCxXoXVoUT6+aGO2hye1WLOSMSTirrYWAfZCwlPM54gq71zGRqDh1fEx4L9aqMUvc1KV6/Gnj92QVUhRq/lcfd/jJ/LMzsosLincyp+run+mPDtedjc+OF/xPLDSz4+5'


#############################################################################
# USER ACCOUNT CONFIGURATION
#############################################################################

# Username
echo
echo "Username: $USER"


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
