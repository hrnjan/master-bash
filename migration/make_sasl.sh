#!/bin/bash

#soubor s databazi uzivatelu (/etc/sasldb2)
#db=$1
db=sasldb2
tmpFile='tmp_file'
outFile="sasldb"
password=1
user=2
domain=3
mult=4

rm -f $outFile
rm -f $tmpFile
# 
strings $db > $outFile
sed '1d' $outFile >> $tmpFile
cat $tmpFile >> testx
rm -f $outFile

array=()
for i in `cat $tmpFile`
do
        if [ "$i" = "userPassword" ]; then
                if [ ${#array[@]} -eq 3 ]; then
                        echo ${array[1]}"@"${array[2]}" "${array[0]} >> $outFile
                elif [ ${#array[@]} -ge 3  ]; then
                        val1=$((${#array[@]} -3))
                        val2=$((${#array[@]} -2))
                        val3=$((${#array[@]} -1))
                        echo ${array[$val2]}"@"${array[$val3]}" "${array[$val1]} >> $outFile
                fi
                array=()
        else
                array=(${array[@]} $i)
        fi

done

#remove tmp
rm -f $tmpFile
#sort results
sort $outFile >> $tmpFile
rm -f $outFile
# remove duplicates
uniq $tmpFile >> $outFile


#finish
rm -f $tmpFile

# get active mailboxes
dovecotFile="dovecot.passwd.new"
finalFile="sasldb_final"
rm -f $finalFile

count=`cat $dovecotFile | wc -l`
for i in $(eval echo "{1..$count}");
do
        line=`head -$i $dovecotFile | tail -1`
        email=`echo $line | cut -d: -f1`
done

rm -f $outFile
#sort $finalFile >> $outFile
rm -f $tmpFile
#cat $outFile >> $finalFile
#rm -f $outFile

