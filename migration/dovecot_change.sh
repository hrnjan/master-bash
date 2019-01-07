#!/bin/bash
base="dxxxx"
end=".masterinter.net"
file=$1
file = ./dovecot.passwd
count=`cat $file | wc -l`

rm -f ./dovecot.passwd.new
#echo $server_count
for i in $(eval echo "{1..$count}");
do
        line=`head -$i $file| tail -1`
        base=`echo $line | cut -d: -f1-8`
        dir=`echo $line | cut -d: -f6`
        echo $base":maildir:"$dir/.maildir >> dovecot.passwd.new
        mkdir -p $dir/.maildir
        group=`echo $dir | cut -d/ -f 4`
        user=`grep "$dir:" /etc/passwd | cut -d: -f1`

        #echo $user

        # email folder
        chown $user:$group -R $dir
        #global folder
        folder=`echo $dir | cut -d/ -f1-4`
        folder2=`echo $dir | cut -d/ -f1-7`
        chown $group:$group $folder $folder/data $folder/data/email $folder2

done
