#!/bin/bash

URL="http://phobos.apple.com/version"
wd="/Users/localadmin/Desktop/iOS"
NewSize=`stat -r "$wd/new_versions.xml" | awk '{ print $8}'`

#wd="/Users/Shared/.iOS"

if [ ! -d $wd ]; then
  mkdir -p $wd;
fi;

chmod -fR 777 $wd

cd $wd

#while true; do
if [ ! -d new_versions.xml ]; then
  #curl --proxy 10.xx.yy.zz:8080 -L -o .new_versions.xml -s $URL > /dev/null 2>&1;
  curl -L -o new_versions.xml -s $URL > /dev/null 2>&1;
  if [ $Size -eq 0 ]
            then
            exit 1
            fi
  exit 0
fi;

#if [[ -f .new_versions.xml ]]; then
 # mv .new_versions.xml .old_versions.xml
#fi

if [[ -f new_versions.xml ]]; then
  mv new_versions.xml old_versions.xml
fi

#curl --proxy 10.xx.yy.zz:8080 -L -o .new_versions.xml -s $URL > /dev/null 2>&1
curl -L -o new_versions.xml -s $URL > /dev/null 2>&1;
#curl -L -o ./.new_versions.xml -s $URL > /dev/null 2>&1;
diff ./new_versions.xml ./old_versions.xml > /dev/null
#diff ./.new_versions.xml ./.old_versions.xml > /dev/null 2>&1;

#add file size check and try another proxy

if [[ $? -ne 0 ]]; then
  echo "It changed"
#List iOS iPads
  cat ./new_versions.xml | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > ./iPadNew.txt
#List iOS ATVs
  cat ./new_versions.xml | grep 'http' | grep 'ipsw' | grep 'ATV' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > ./ATVNew.txt

diff /Users/localadmin/Downloads/AppleTV.ipsw.CheckOld.txt /Users/localadmin/Downloads/AppleTV.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/AppleTV.ipsw.ToDownload.txt


#print any new links that appear to a file. 1 link per line.
diff /Users/localadmin/Downloads/iPad.ipsw.CheckOld.txt /Users/localadmin/Downloads/iPad.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/iPad.ipsw.ToDownload.txt
cd /Users/localadmin/Downloads







else
  echo "No change"
  date
fi

#done
#sleep 3600
exit 0
