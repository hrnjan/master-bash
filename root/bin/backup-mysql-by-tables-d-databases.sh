#!/bin/bash
#
# MySQL Backup by tables
#

#####
# Configuration 
#
directory=$(date +%Y-%m-%d-%H-%M-%S)
old=$(date --date="7 days ago" "+%Y-%m-%d")
day=$(date +"%Y-%m-%d")
user=$1
path=$2
dbs="$3"


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

echo "MySQL backup by tables:"

# cp ibdata* ib_log*
#echo "=> Backup ib* files"
#find /var/lib/mysql -iname "ibdata*" -exec cp '{}' $path/$directory/ ';'
#find /var/lib/mysql -iname "ib_logfile*" -exec cp '{}' $path/$directory/ ';'

# dump entire DB 
#       x
# dump by tables
echo ""
echo "=> Dumping individual tables"

for a in `echo "show databases" | mysql | grep -v Database | grep -v information_schema | grep $dbs | grep -v roundcube | grep -v servis_roundcube`;
do
	mkdir -p $path/$day/$a$directory
	echo "-> Dumping database: $a"
	
	for i in `echo "use $a;show tables" | mysql $a | grep -v Tables_in_`;
	do
		echo " * Dumping table: $i"
		mysqldump --add-drop-table --allow-keywords -R -q -a -c $a $i > $path/$day/$a$directory/$i.sql
	done
                origin_path=`pwd`
                # make archive file && clean dirs/orfans
                echo "=> Archiving Files"
                cd $path/$day; rm -rf "$a$directory.zip"; zip -r $a$directory $a$directory; cd $origin_path
                echo "=> Delete directory"
                rm -rf $path/$day/$a$directory
                echo "=> Delete archve from $old"
                rm -rf $path/$old*
done

chmod og+rx $path
chown $user:$user -R $path

# done
echo "=> Done"
