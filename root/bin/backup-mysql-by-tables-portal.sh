#!/bin/bash
#
# MYSQL Backup Script by tables
#

#####
# Configuration 
#
#directory=$(date +"%Y-%m-%d")
directory="$dbname"$(date +%Y-%m-%d-%H-%M-%S)
user=$1
path=$2
dbname="$3"
old=$(date --date="183 days ago" "+%Y-%m-%d")
day=$(date +"%Y-%m-%d")


#####
# Script
#
echo "mySQL Backup Script"

# test connection to mysql
TESTCON=`echo "SELECT 1=1" | mysql 2>&1`
if [[ $TESTCON == *"Access denied"* ]]; then
echo "Connection to mysql failed"
exit 1
fi

# create destination directory
mkdir -p $path
mkdir -p $path/$directory

echo "MySQL backup by tables:"

# dump by tables
echo ""
echo "=> Dumping individual tables"

#for a in `echo "show databases" | mysql | grep -v Database | grep -v information_schema`;
#do
	$mkdir -p $path/$day/$directory
	echo "-> Dumping database: $dbname"
	
	for i in `echo "use $dbname;show tables" | mysql $dbname | grep -v Tables_in_`;
	do
		echo " * Dumping table: $i"
	#	echo "mysqldump --add-drop-table --allow-keywords -R -q -a -c $dbname $i > $path/$directory/$i.sql"
	        mysqldump --add-drop-table --allow-keywords -R -q -a -c $dbname $i > $path/$directory/$i.sql
	done
#done

# make archive file
echo "=> Archiving Files"

# make zip
origin_path=`pwd`
#echo "cd $path; rm -rf "$directory.zip"; zip -r $directory $directory; mv $directory* $day/;cd $origin_path"
cd $path; rm -rf "$directory.zip"; zip -r $directory $directory; mv $directory* $day/;cd $origin_path

# delete directory and old files
echo "=> Delete directory"
rm -rf $path/$day/$directory
echo "=> Delete archve from $old"
#rm -rf $path/$old*
rm -rf $path/$directory

chmod og+rx $path/$day
chown $user:$user -R $path/$day

# done
echo "=> Done"
