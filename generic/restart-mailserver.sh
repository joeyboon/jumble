#!/bin/bash

#############################################################################
# VARIABLES
#############################################################################

yellow='\033[0;49;93m' # Yellow
green='\033[0;49;92m'  # Green
nc='\033[0m'           # No color

#############################################################################
# SYSTEM
#############################################################################

set -e            # stop the script on errors
set -u            # unset variables are an error
set -o pipefail   # piping a failed process into a successful one is an arror

#############################################################################
# SCRIPT
#############################################################################

echo
echo -e "${yellow}RESTARTING SOFTWARE${nc}"
echo

echo -e -n "Restarting Postfix..."
systemctl restart postfix
echo -e "\t\t[${green}OK${nc}]"

echo -e -n "Restarting Dovecot..."
systemctl restart dovecot
echo -e "\t\t[${green}OK${nc}]"

echo -e -n "Restarting Amavisd..."
systemctl restart amavis
echo -e "\t\t[${green}OK${nc}]"

echo -e -n "Restarting SpamAssassin..."
systemctl restart spamassassin
echo -e "\t[${green}OK${nc}]"

echo -e -n "Restarting Fail2Ban..."
systemctl restart fail2ban
echo -e "\t\t[${green}OK${nc}]"

echo -e -n "Restarting Apache..."
systemctl restart apache2
echo -e "\t\t[${green}OK${nc}]"

echo
echo "Done!"
echo

exit
