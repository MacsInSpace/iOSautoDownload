#!/bin/bash

URL="http://phobos.apple.com/version"
wd="/Users/localadmin/Desktop/iOS"

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
  #run downloader
  date
else
  echo "No change"
  date
fi

#done
#sleep 3600
exit 0
