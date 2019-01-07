#!/bin/bash
#path of 'sasldb_final' file
#hrncir@example.com 123hesloMojeJe

srcFile=$1
#source server
host1="mail.source.cz"
#destination server
host2="mail.destination.cz"

while IFS=' ' read user1 password1
 do
        imapsync --host1 $host1 --user1 $user1 --password1 $password1 --host2 $host2 --user2 $user1 --password2 $password1 --noauthmd5 --subscribe #--debugmemory --nofoldersizes --nofoldersizesatend
   #echo "Test: User is $user and password is $password"
 done < "$srcFile"
