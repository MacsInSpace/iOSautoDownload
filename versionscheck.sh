#!/bin/bash
URL="http://phobos.apple.com/versions"
#while true; do

if [[ -f new_versions.xml ]]; then
  mv new_versions.xml old_versions.xml
fi

curl --proxy 10.xx.yy.zz:8080 -L -o new_versions.xml -s $URL > /dev/null 2>&1
diff ./new_versions.xml ./old_versions.xml > /dev/null

if [[ $? -ne 0 ]]; then
  #run downloader
  echo "It changed"
  #run downloader
  date
else
  echo "No change"
  date
fi

#done
exit
