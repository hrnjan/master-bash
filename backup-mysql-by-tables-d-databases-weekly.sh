#!/bin/bash
#
# Configuration 
#
directory=$(date +%Y-%m-%d-%H-%M-%S)
path="/var/www/backup/mydock"
old=$(date --date="7 days ago" "+%Y-%m-%d")
day=$(date +"%Y-%m-%d")
limit=$(date --date="92 days ago" "+%Y-%m-%d")
user=$1

#####
# Script
#
echo "mySQL Backup Script"

mkdir -p $path/weekly/
mv $path/$old $path/weekly/

echo "=> Delete directory older than:  $path/weekly/$limit"
find $path/* -type d -ctime +92 | xargs rm -rf

chown $user:$user -R $path/weekly
# done
echo "=> Done"
