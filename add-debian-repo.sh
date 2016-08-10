#!/bin/bash
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
# See https://github.com/sveeke/jumble/blob/master/license.txt
# Source code on GitHub: https://github.com/sveeke/jumble

## Colours & markup
red='\033[0;31m'            # Red
lred='\033[1;31m'           # Light red
purple='\033[1;35m'         # Purple
lpurple='\033[0;49;95m'     # Light purple
green='\033[0;32m'          # Green
lgreen='\033[0;49;92m'      # Light lgreen
yellow='\033[1;33m'         # Yellow
lyellow='\033[0;49;93m'     # Light yellow
orange='\033[0;33m'         # Orange
blue='\033[1;36m'           # Blue
white='\033[1;37m'          # White
grey='\033[1;49;30m'        # Grey
nc='\033[0m'                # No color

## REQUIREMENTS
echo
echo
echo -e "${lyellow}CHECKING REQUIREMENTS"

# Check if script runs as root
echo -e -n "${white}Script is running as root..."

if [ "$EUID" -ne 0 ]; then
        echo -e "\t\t\t\t\t${white}[${red}NO${white}]${nc}"
        echo
        echo -e "${red}************************************************************************
This script should be run as root. Use su root and run the script again.
************************************************************************${nc}"
        echo
        exit
fi

echo -e "\t\t\t\t\t${white}[${lgreen}YES${white}]${nc}"

# Check if OS is Debian 8
echo -e -n "${white}Checking version of Debian...${nc}"

VER=$(cat /etc/debian_version)
DEBVER=${VER:0:1}
OS=$(cat /etc/issue)
DIST=${OS::-6}
RELEASE=$(head -n 1 /etc/*-release)

if [[ $DEBVER != "8" ]]; then
        echo -e "\t\t\t\t\t${white}[${red}NO${white}]${nc}"
        echo
        echo -e "${red}**************************************************************************************************
This script can only run on Debian 8, you are running $DIST. 
Please install Debian 8 Jessie first.
**************************************************************************************************${nc}"
        echo
        exit
fi

echo -e "\t\t\t\t\t${white}[${lgreen}OK${white}]${nc}"

sleep 1

## REPLACE REPOSITORIES
echo
echo
echo -e "${lyellow}REPLACING REPOSITORIES"
echo -e -n "${white}Modifying sources.list...${nc}"

echo "
# Standard repositories
deb http://httpredir.debian.org/debian jessie main contrib
deb-src http://httpredir.debian.org/debian jessie main contrib
deb http://httpredir.debian.org/debian jessie-updates main contrib
deb-src http://httpredir.debian.org/debian jessie-updates main contrib

# Security repositories
deb http://security.debian.org/ jessie/updates main contrib
deb-src http://security.debian.org/ jessie/updates main contrib

# Backport repositories
deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list

echo -e "\t\t\t\t\t${white}[${lgreen}DONE${white}]${nc}"
echo
echo
