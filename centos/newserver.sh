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


#############################################################################
# UPDATE OPERATING SYSTEM
#############################################################################

echo
echo

# Update the operating system
echo -e "${yellow}UPDATING OPERATING SYSTEM"
yum -y update

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

# Install packages for CentOS 7
yum -y install nano wget zip unzip sysstat

sleep 1

echo
echo
echo -e "Done!"
echo
