#!/bin/bash
# Copyright 2016 Sebas Veeke. Released under the AGPLv3 license
# See https://github.com/sveeke/EasyDebianWebserver/blob/master/license.txt
# Source code on GitHub: https://github.com/sveeke/EasyDebianWebserver

### This script will backup folders and MySQL databases. You can modify it to include more folders or change the backup retention. If you want to change the time or frequency you should use crontab -e.
## USER VARIABLES
BACKUP_PATH_FILES='/home/robot/backup/files'
BACKUP_PATH_SQL='/home/robot/backup/databases'
BACKUP_FOLDERS='/var/www/html/. /etc/apache2 /etc/ssl /etc/php5' # To add more folders, place the folder path you want to add between the quotation marks below. Make sure the folders are seperated with a space. If you also want to include hidden files, add '/.' to the location.
BACKUP_SQL='/var/lib/mysql/.' # This is the default folder where databases are stored.
RETENTION='14' # Backup retention in number of days

## Set default file permissions
umask 007

## Backup folders
tar -cpzf $BACKUP_PATH_FILES/backup-daily-$( date '+%Y-%m-%d_%H-%M-%S' ).tar.gz $BACKUP_FOLDERS

## Backup MySQL databases
# Note: in order to minimize the risk of getting inconsistencies because of pending transactions, apache2 and MySQL will be stopped temporary.
service apache2 stop
sleep 10
service mysql stop
sleep 5
tar -cpzf $BACKUP_PATH_SQL/backup-daily-$( date '+%Y-%m-%d_%H-%M-%S' ).tar.gz $BACKUP_SQL
service mysql start
sleep 5
service apache2 start

## Set backup ownership
chown robot:root /home/robot/backup/files/*
chown robot:root /home/robot/backup/databases/*

## Delete backups older than the RETENTION parameter
find $BACKUP_PATH_FILES/backup-daily* -mtime +$RETENTION -type f -delete
find $BACKUP_PATH_SQL/backup-daily* -mtime +$RETENTION -type f -delete

### Note: to restore backups use 'tar -xpzf /path/to/backup.tar.gz -C /path/to/place/backup'
