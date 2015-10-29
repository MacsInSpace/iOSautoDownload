#!/bin/bash
if [ ! -d /Users/Shared/.iOS ]; then
mkdir -p /Users/Shared/.iOS;
fi;
chmod -fR 777 /Users/Shared/.iOS

URL="http://phobos.apple.com/versions"
wd="/Users/Shared/.iOS"
cd $wd

#while true; do
if [ ! -d .new_versions.xml ]; then
curl --proxy 10.xx.yy.zz:8080 -L -o .new_versions.xml -s $URL > /dev/null 2>&1;
fi;

#add file size check and try another proxy

if [[ -f .new_versions.xml ]]; then
  mv .new_versions.xml .old_versions.xml
fi

curl --proxy 10.xx.yy.zz:8080 -L -o .new_versions.xml -s $URL > /dev/null 2>&1
diff ./.new_versions.xml ./.old_versions.xml > /dev/null

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
exit
