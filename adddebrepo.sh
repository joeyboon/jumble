#!/bin/bash

## REPLACE REPOSITORIES
echo
echo
echo -e "REPLACING REPOSITORIES"
echo -e -n "Modifying sources.list...${nc}"

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

echo -e "\t\t\t\t\t[DONE]"
