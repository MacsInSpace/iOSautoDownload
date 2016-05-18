#!/bin/bash
#versions url
URL="http://phobos.apple.com/versions"
#working directory
#wd="/Users/localadmin/Desktop/iOS"
wd="/Users/Shared/.iOS"
Dd=/User/ladmin/Downloads
#temporary working directory
td="/tmp/.iOS"
#Proxy:P0rt
PrX=10.xx.yy.zz:8080

#create working and temporary directories if not there already
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
diff new_versions.xml old_versions.xml > /dev/null 2>&1;

if [[ $? -ne 0 ]]; then
  echo "updated XML. proceeding."

#Used in testing to remove ispws for download
#sed -i '' "/_9.3.2_/d" old_versions.xml

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
#List iOS iPhones
  cat ./diff.xml | grep 'http' | grep 'ipsw' | grep 'iPhone' | sort -u | cut -d '>' -f 3 | cut -d '<' -f 1 > iPhoneNewToDownload.txt
#read new links
iPhoneLinks=`cat iPhoneNewToDownload.txt`
#List iOS iPod
  cat ./diff.xml | grep 'http' | grep 'ipsw' | grep 'iPod' | sort -u | cut -d '>' -f 3 | cut -d '<' -f 1 > iPodNewToDownload.txt
#read new links
iPodLinks=`cat iPodNewToDownload.txt`
#List iOS watch
#  cat ./diff.xml | grep 'http' | grep 'ipsw' | grep 'watch' | sort -u | cut -d '>' -f 3 | cut -d '<' -f 1 > iwatchNewToDownload.txt
#read new links
#iwatchLinks=`cat iwatchNewToDownload.txt`



#cleanup diffs and xml
rm 1.xml 
rm 2.xml
rm diff.xml
rm iPadNewToDownload.txt
rm ATVNewToDownload.txt
rm iPhoneNewToDownload.txt
rm iPodNewToDownload.txt
#rm iwatchNewToDownload.txt
mv new_versions.xml old_versions.xml

#Move to tepmorary directory to download. If we loose power, we dont want half downloaded files taking up space.
#My site always looses power
cd $td

#download links list
for url in $iPadLinks; do
export ec=200; while [ $ec == 200 ]; do /usr/bin/curl -O -C - "$url"; export ec=$?; done
done

for url in $ATVLinks; do
export ec=200; while [ $ec == 200 ]; do /usr/bin/curl -O -C - "$url"; export ec=$?; done
done

#for url in $iPodLinks; do
#export ec=200; while [ $ec == 200 ]; do /usr/bin/curl -O -C - "$url"; export ec=$?; done
#done

#for url in $iPhoneLinks; do
#export ec=200; while [ $ec == 200 ]; do /usr/bin/curl -O -C - "$url"; export ec=$?; done
#done

#for url in $iwatchLinks; do
#export ec=200; while [ $ec == 200 ]; do /usr/bin/curl -O -C - "$url"; export ec=$?; done
#done

#move ipsw's to folder for auto sorting with Hazel https://www.noodlesoft.com/
mv -R $td/*.ipsw $Dd/

else
  echo "No change"
  date
  exit 0
  fi
else
  echo "No change"
  date
  exit 0
fi


#done
#sleep 3600
exit 0
