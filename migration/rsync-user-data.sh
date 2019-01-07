#!/bin/bash
#IP address of source server
SRC="$1"

EXCLUDE="--exclude /email --exclude /logs --exclude /mod-tmp --exclude /tmp"

IONICE="--rsync-path='ionice -c 3 nice -n 12 rsync'"

for user in `/usr/local/mgr5/sbin/mgrctl -m ispmgr user | cut -d' ' -f1 | cut -d'=' -f2`; do
  rsync -a --delete --update $EXCLUDE root@$SRC:/var/www/$user/data/ /var/www/$user/data/
done
