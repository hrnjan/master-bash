#!/bin/bash
#Bash script for probing DNS records for domains from list (ISPmanager list in this example)
#It creates data structure under '/var/www/$user/data/dns_backup/' directory
display_help() {
    echo "  Script for DNS record probing"
    echo "  Usage: $0 [-h] [-u user] [-d days]" >&2
    echo
    echo "   -u, --user         MANDATORY: Username (owner)"
    echo "   -d, --days           Delete older DNS dumps than x days (default: 3)"
    echo "   -h, --help           Show this help"
    echo
    exit 1
}

while :
do
    case "$1" in
      -d | --days)
          if [ $# -ne 0 ]; then
            old_days="3"
          fi
          shift 2
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      -u | --user)
          user=$2
           shift
           ;;

      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1
          ;;
      *)  # No more options
          break
          ;;
    esac
done

#vars
webdomains=`/usr/local/mgr5/sbin/mgrctl -m ispmgr webdomain | cut -d'=' -f2 | cut -d' ' -f1`
maildomain=`/usr/local/mgr5/sbin/mgrctl -m ispmgr emaildomain | cut -d'=' -f5 | cut -d' ' -f1`
#search for maildomains also and deduplicate
domains=`echo $webdomains$maildomains | sort | uniq`
old=$(date --date="$old_days days ago" "+%Y-%m-%d")
day=$(date +"%Y-%m-%d")
path="/var/www/$user/data/dns_backup/"

#check if mandatory variable $user exists
if [[ -z $user ]];
then
    echo "  Missing mandatory argument: -u USERNAME "
    display_help
    exit 1
fi

#check if system user exists
if id "$user" >/dev/null 2>&1; then

#create datename directory 
echo "Creating data structure under $user"
mkdir -p $path$day
cd $path$day

for i in $domains; do
echo "dig +nocmd $i any +multiline +noall +answer"
dig +nocmd $i any +multiline +noall +answer > $i
done

chown $user:$user -R $path
rm -rf $path$old
else
echo "  System user $user doesn't exists"
echo ""
display_help
exit 1
fi
