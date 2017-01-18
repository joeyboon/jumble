#!/bin/bash

#############################################################################
# Version 1.0 (19-01-2017)
#############################################################################

#############################################################################
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
# See https://github.com/sveeke/EasyDebianWebserver/blob/master/license.txt
# Source code on GitHub: https://github.com/sveeke/EasyDebianWebserver
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

#############################################################################
# SYSTEM
#############################################################################

# https://lobste.rs/c/4lfcnm (danielrheath)
#set -e # stop the script on errors
#set -u # unset variables are an error
#set -o pipefail # piping a failed process into a successful one is an arror


#############################################################################
# CHECKING REQUIREMENTS
#############################################################################

echo
echo
echo -e "${yellow}CHECKING REQUIREMENTS"

# Checking if script runs as root
echo -e -n "${white}Script is running as root..."
	if [ "$EUID" -ne 0 ]; then
        echo -e "\t\t\t\t\t${white}[${red}NO${white}]${nc}"
        echo
        echo -e "${red}************************************************************************"
		echo -e "${red}This script should be run as root. Use su root and run the script again."
		echo -e "${red}************************************************************************${nc}"
        echo
		exit
	fi
echo -e "\t\t\t\t\t${white}[${green}YES${white}]${nc}"

# Checking Debian version
echo -e -n "${white}Running Debian 8 or 9...${nc}"
	if [ -f /etc/debian_version ]; then
		DEBVER=$(cat /etc/debian_version | cut -d '.' -f 1 | cut -d '/' -f 1)

        if [ "$DEBVER" = "8" ] || [ "$DEBVER" = "jessie" ]; then
			echo -e "\t\t\t\t\t${white}[${green}YES${white}]${nc}"
			OS='8'
			sleep 2

		elif [ "$DEBVER" = "9" ] || [ "$DEBVER" = "stretch" ]; then
			echo -e "\t\t\t\t\t${white}[${green}YES${white}]${nc}"
			OS='9'
			sleep 2

		else
			echo -e "\t\t\t\t\t${white}[${red}NO${white}]${nc}"
			echo
			echo -e "${red}**********************************************************************"
			echo -e "${red}This script will only work on Debian 8 (Jessie) or Debian 9 (Stretch)."
			echo -e "${red}**********************************************************************${nc}"
			echo
			exit 1
        fi
	fi

# Checking internet connection
echo -e -n "${white}Connected to the internet...${nc}"
wget -q --tries=10 --timeout=20 --spider www.google.com
	if [[ $? -eq 0 ]]; then
        echo -e "\t\t\t\t\t${white}[${green}YES${white}]${nc}"
    else
        echo -e "\t\t\t\t\t${white}[${red}NO${white}]${nc}"
        echo
		echo -e "${red}**********************************************************************"
		echo -e "${red}Internet connection is required, please connect to the internet first."
		echo -e "${red}**********************************************************************${nc}"
        echo
        exit
	fi

sleep 1


#############################################################################
# USER CONFIGURATION
#############################################################################

echo
echo -e "${yellow}USER INPUT"
echo -e "${white}The script will gather some information from you.${nc}"

# Choose hostname
echo
read -p "$(echo -e "${white}Enter server's hostname:               		"${green})" HOSTNAME


#############################################################################
# CHANGE HOSTNAME
#############################################################################

echo
echo
echo -e "${yellow}CHANGING HOSTNAME"
echo -e -n "${white}Modifying /etc/hostname...${nc}"
echo "$HOSTNAME" > /etc/hostname
echo -e "\t\t\t\t\t${white}[${green}DONE${white}]${nc}"

sleep 1


#############################################################################
# REPLACE REPOSITORIES
#############################################################################

echo
echo
echo -e "${yellow}REPLACING REPOSITORIES"
echo -e -n "${white}Modifying sources.list...${nc}"

if [ "$OS" = "8" ]; then
	wget -q https://raw.githubusercontent.com/sveeke/EasyDebianWebserver/Release-1.1/resources/debian8-sources.list -O /etc/apt/sources.list --no-check-certificate
	echo -e "\t\t\t\t\t${white}[${green}DONE${white}]${nc}"

elif [ "$OS" = "9" ]; then
	wget -q https://raw.githubusercontent.com/sveeke/EasyDebianWebserver/Release-1.1/resources/debian9-sources.list -O /etc/apt/sources.list --no-check-certificate
	echo -e "\t\t\t\t\t${white}[${green}DONE${white}]${nc}"
fi

sleep 1


#############################################################################
# UPDATE OPERATING SYSTEM
#############################################################################

echo
echo

# Update the package list from the Debian repositories
echo -e "${yellow}UPDATING OPERATING SYSTEM"
echo -e "${white}Downloading package list from repositories... ${grey}"
apt update

# Upgrade operating system with new package list
echo
echo -e "${white}Downloading and installing new packages...${grey}"
apt -y upgrade

sleep 1


#############################################################################
# INSTALL NEW SOFTWARE
#############################################################################

echo
echo
echo -e "${yellow}INSTALLING SOFTWARE${grey}"

sleep 1
echo
echo

# Install packages for Debian 8 Jessie
if [ "$OS" = "8" ]; then
	apt-get -y install apt-transport-https ca-certificates unattended-upgrades ntp ufw sudo zip unzip sysstat curl

# Install packages for Debian 9 Stretch
elif [ "$OS" = "9" ]; then
	apt-get -y install apt-transport-https ca-certificates unattended-upgrades ntp ufw sudo zip unzip sysstat curl
fi

sleep 1


#############################################################################
# CONFIGURE UNATTENDED-UPGRADES
#############################################################################

echo
echo
echo -e "${yellow}CONFIGURING UNATTENDED-UPGRADES"
echo -e -n "${white}Activating unattended-upgrades...${nc}"
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /etc/apt/apt.conf.d/20auto-upgrades
echo -e "\t\t\t\t${white}[${green}DONE${white}]${nc}"

sleep 1

echo
echo
echo -e "Done!"
echo
