#!/bin/bash

# This script let you add users and their certificates.
# Created by Sebas Veeke. Use it as you see fit.

# USER INPUT
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

# Accounts & SSH
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
echo "Done!"
echo
