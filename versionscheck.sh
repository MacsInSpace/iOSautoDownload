#!/bin/bash
#versions url
URL="http://phobos.apple.com/versions"
#working directory
#wd="/Users/localadmin/Desktop/iOS"
wd="/Users/Shared/.iOS"
Dd=/User/localadmin/Downloads
#temporary working directory
td="/tmp/.iOS"
#New file size check to make sure not 0kb
NewSize=`stat -r "$wd/new_versions.xml" | awk '{ print $8}'`
#Proxy:P0rt
PrX=10.xx.yy.zz:8080

if [ ! -d $wd ]; then
  mkdir -p $wd;
fi;
chmod -fR 777 $wd

if [ ! -d $td ]; then
  mkdir -p $td;
fi;
chmod -fR 777 $td

cd $wd

#while true; do
if [ ! -f new_versions.xml ]; then
  #curl --proxy $PrX -L -o .new_versions.xml -s $URL > /dev/null 2>&1;
  curl -L -o new_versions.xml -s $URL > /dev/null 2>&1
  
  if [ -s new_versions.xml ]; then
        echo 'is there. continuing'
     else
        exit 0
  fi
fi

if [ ! -f old_versions.xml ]; then
  mv new_versions.xml old_versions.xml
  exit 0
fi
#NOT WORKING FROM HERE DOWN
#add file size check to see if it has been updated.
diff ./new_versions.xml ./old_versions.xml > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
  echo "updated XML. proceeding."

#List iOS iPads
  cat ./new_versions.xml | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > ./iPadNew.txt
if [ ! -f iPadOld.txt ]; then
  mv iPadNew.txt iPadOld.txt
  exit 0
fi
diff iPadOld.txt iPadNew.txt | grep ">" | sed 's/^> //g' > iPadNewToDownload.txt
#read new links
iPadLinks=`cat iPadNewToDownload.txt`

#List iOS ATVs
  cat ./new_versions.xml | grep 'http' | grep 'ipsw' | grep 'ATV' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > ./ATVNew.txt
if [ ! -f ATVOld.txt ]; then
  mv ATVNew.txt ATVOld.txt
  exit 0
fi
diff ATVOld.txt ATVNew.txt | grep ">" | sed 's/^> //g' > ATVNewToDownload.txt
#read new links
ATVLinks=`cat ATVNewToDownload.txt`


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
  exit 0
fi
mv -R $td/*.ipsw $Dd/
#done
#sleep 3600
exit 0
