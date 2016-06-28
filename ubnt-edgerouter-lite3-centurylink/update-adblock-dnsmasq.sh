#!/bin/bash

ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf"
temp_ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf.tmp"

# get two hosts files with 127.0.0.1 adress, extract out only ad blocking lists and write them to a temporary file
curl -s "http://hosts-file.net/ad_servers.txt" "http://www.malwaredomainlist.com/hostslist/hosts.txt" | grep -w ^127.0.0.1$'\(\t\| \)' | sed 's/^127.0.0.1\s\{1,\}//' > $temp_ad_file

# get another two hosts files with 0.0.0.0 adress, extract out only ad blocking lists, remove whitespace at the end of some lines and output it to temp
curl -s "http://winhelp2002.mvps.org/hosts.txt" "http://someonewhocares.org/hosts/zero/hosts" | grep -w ^0.0.0.0 | cut -c 9- | sed 's/\s\{1,\}.*//' >> $temp_ad_file

# remove the carriage return at the end of each line of the temporary file, and convert it into a Dnsmasq format
sed -i -e 's/\r$//; s:.*:address=/&/0\.0\.0\.0:' $temp_ad_file

# get another hosts file in Dnsmasq format, and add the contents to a temporary file
curl -s "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq&showintro=0&mimetype=plaintext&useip=0.0.0.0" >> $temp_ad_file

if [ -f "$temp_ad_file" ]
then
  # a pseudo whitelist
  sed -i -e '/spclient\.wg\.spotify\.com/d' $temp_ad_file

  # sort ad blocking list in the temp file and remove duplicate lines from it
  sort -o $temp_ad_file -t '/' -uk2 $temp_ad_file

  # uncomment the line below, and modify it to remove your favorite sites from the ad blocking list
  #sed -i -e '/www\.favoritesite\.com/d' $temp_ad_file

  mv $temp_ad_file $ad_file
else
  echo "Error building the ad list, please try again."
  exit
fi

/etc/init.d/dnsmasq force-reload
