#!/bin/bash
#versions url
URL="http://phobos.apple.com/versions"
#working directory
#wd="/Users/localadmin/Desktop/iOS"
wd="/Users/Shared/.iOS"
Dd=/User/localadmin/Downloads
#temporary working directory
td="/tmp/.iOS"
#Proxy:P0rt
PrX=10.xx.yy.zz:8080

#create working and temporaary directories if not there already
if [ ! -d $wd ]; then
  mkdir -p $wd;
fi;
chmod -fR 777 $wd

if [ ! -d $td ]; then
  mkdir -p $td;
fi;
chmod -fR 777 $td

cd $wd

#check for new versions 
if [ ! -f old_versions.xml ]; then
  #curl --proxy $PrX -L -o .new_versions.xml -s $URL > /dev/null 2>&1;
  curl -L -o old_versions.xml -s $URL --connect-timeout 20 2>&1;
  exit 0
  else
  #curl --proxy $PrX -L -o .new_versions.xml -s $URL > /dev/null 2>&1;
  curl -L -o new_versions.xml -s $URL --connect-timeout 20 2>&1;
fi


#add file size check to see if it has been updated.
diff ./new_versions.xml ./old_versions.xml > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
  echo "updated XML. proceeding."

#List iOS iPads
xmllint --c14n old_versions.xml > 1.xml
xmllint --c14n new_versions.xml > 2.xml
diff 1.xml 2.xml > diff.xml
if [[ $? -ne 0 ]]; then
  echo "updated XML. proceeding."

#List iOS iPads
  cat ./diff.xml | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 3 | cut -d '<' -f 1 > iPadNewToDownload.txt
#read new links
iPadLinks=`cat iPadNewToDownload.txt`
#List iOS ATVs
  cat ./diff.xml | grep 'http' | grep 'ipsw' | grep 'ATV' | sort -u | cut -d '>' -f 3 | cut -d '<' -f 1 > ATVNewToDownload.txt
#read new links
ATVLinks=`cat ATVNewToDownload.txt`

#cleanup diffs
rm 1.xml 
rm 2.xml
rm diff.xml
rm iPadNewToDownload.txt
rm ATVNewToDownload.txt

cd $td

#download links list
for url in $iPadLinks; do
#if curl --fail -L --proxy $PrX "$url"; then
if curl --fail -L "$url"; then
    echo success # …(success)
else
    #curl --fail -L --proxy $PrX "$url" # …(failure)
    curl --fail -L "$url" # …(failure)
fi

done
sleep 10
for url in $ATVLinks; do
#if curl --fail -L --proxy $PrX "$url"; then
if curl --fail -L "$url"; then
    echo success # …(success)
else
    #curl --fail -L --proxy $PrX "$url" # …(failure)
    curl --fail -L "$url" # …(failure)
fi
done
else
  echo "No change"
  date
  fi
else
  echo "No change"
  date
  exit 0
fi


mv -R $td/*.ipsw $Dd/
#done
#sleep 3600
exit 0
