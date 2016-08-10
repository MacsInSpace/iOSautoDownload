#!/bin/bash
#versions url
URL="http://phobos.apple.com/versions"
#working directory
#wd="/Users/localadmin/Desktop/iOS"
wd="/Users/Shared/.iOS"
#Save directory
#Sd="/Volumes/Data/ServiceData/%%%%%/iOS/"
#final directory (for sorting with Hazel https://www.noodlesoft.com/ when not using ^Sd^)
Dd=/Users/ladmin/Downloads
#temporary working directory
td="/var/tmp/.iOS"
#Proxy:P0rt
export http_proxy=http://10.xx.yy.zz:8080
export https_proxy=$http_proxy
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$http_proxy


#Awesome function for curl retries from http://stackoverflow.com/questions/8350942/how-to-re-run-the-curl-command-automatically-when-the-error-occurs
#credit to https://github.com/phs

function with_backoff {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${TIMEOUT-1}
  local attempt=0
  local exitCode=0

  while (( $attempt < $max_attempts ))
  do
    set +e
    "$@"
    exitCode=$?
    set -e

    if [[ $exitCode == 0 ]]
    then
      break
    fi

    echo "Failure! Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "You've failed me for the last time! ($@)" 1>&2
  fi

  return $exitCode
}



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
  curl -L -o old_versions.xml -s $URL --connect-timeout 20 2>&1;
  exit 0
  else
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
if [ -f 1.xml ]; then 
rm 1.xml 
fi
if [ -f 2.xml ]; then 
rm 2.xml 
fi
if [ -f diff.xml ]; then
rm diff.xml
fi
if [ -f iPadNewToDownload.xml ]; then
rm iPadNewToDownload.txt
fi
if [ -f ATVNewToDownload.xml ]; then
rm ATVNewToDownload.txt
fi
if [ -f iPhoneNewToDownload.xml ]; then
rm iPhoneNewToDownload.txt
fi
if [ -f iPodNewToDownload.xml ]; then
rm iPodNewToDownload.txt
fi
#if [ -f 2.xml ]; then
#rm iwatchNewToDownload.txt
#fi
mv new_versions.xml old_versions.xml

#Move to tepmorary directory to download. If we loose power, we dont want half downloaded files taking up space.
#My site always looses power
cd $td

#download links list
#move ipsw's to folder for auto sorting with Hazel https://www.noodlesoft.com/

for url in $iPadLinks; do
with_backoff curl -O "$url" -s --connect-timeout 20 2>&1
file=`echo ${url##*/}`
mv $td/$file $Dd/
chmod 777 $Dd/$file
done

for url in $ATVLinks; do
with_backoff curl -O "$url" -s --connect-timeout 20 2>&1
file=`echo ${url##*/}`
mv $td/$file $Dd/
chmod 777 $Dd/$file
done

#for url in $iPodLinks; do
#with_backoff curl -O "$url" -s --connect-timeout 20 2>&1
#file=`echo ${url##*/}`
#mv $td/$file $Dd/
#chmod 777 $Dd/$file
#done

#for url in $iPhoneLinks; do
#with_backoff curl -O "$url" -s --connect-timeout 20 2>&1
#file=`echo ${url##*/}`
#mv $td/$file $Dd/
#chmod 777 $Dd/$file
#done

#for url in $iwatchLinks; do
#with_backoff curl -O "$url" -s --connect-timeout 20 2>&1
#file=`echo ${url##*/}`
#mv $td/$file $Dd/
#chmod 777 $Dd/$file
#done


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

exit 0
