#! /bin/bash
echo "getting xml template"
#UUiD=`uuidgen`
#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions --connect-timeout 10 2>&1 > /tmp/iOS.ipsw.CheckOld.txt

curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions --connect-timeout 20 2>&1 > /tmp/iOS.ipsw.CheckNew.txt
Size=`stat -r /tmp/iOS.ipsw.CheckNew.txt | awk '{ print $8}'`


if [ $Size -eq 0 ]
then
    echo "iOS.ipsw.CheckNew.txt has no data. trying a new proxy."
    curl -L --proxy 10.xxx.yyy.zzz:8080:8080 -s http://phobos.apple.com/versions --connect-timeout 20 2>&1 > /tmp/iOS.ipsw.CheckNew.txt
    Size=`stat -r /tmp/iOS.ipsw.CheckNew.txt | awk '{ print $8}'`

            if [ $Size -eq 0 ]
            then
            exit 1
            fi
else
echo "got xml template"
fi
mv /tmp/iOS.ipsw.CheckNew.txt /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt
osascript -e "tell application \"Folx GO+\" to activate" &
sleep 1
osascript -e "tell application \"Finder\" to set visible of process \"Folx GO+\" to false" &

#################################iPAD##################################################################
#needed for first run to get a template

#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPad.ipsw.CheckOld.txt

#get links from site for difference check
#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPad.ipsw.CheckNew.txt
echo "comparing ipad template"

cat /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt | grep 'http' | grep 'ipsw' | grep 'iPad' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPad.ipsw.CheckNew.txt

#print any new links that appear to a file. 1 link per line.
diff /Users/localadmin/Downloads/iPad.ipsw.CheckOld.txt /Users/localadmin/Downloads/iPad.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/iPad.ipsw.ToDownload.txt
cd /Users/localadmin/Downloads

#read new links
Links=`cat /Users/localadmin/Downloads/iPad.ipsw.ToDownload.txt`

#cleanup
rm /Users/localadmin/Downloads/iPad.ipsw.CheckOld.txt
rm /Users/localadmin/Downloads/iPad.ipsw.ToDownload.txt
mv /Users/localadmin/Downloads/iPad.ipsw.CheckNew.txt iPad.ipsw.CheckOld.txt

#queue for download
for url in $Links; do
osascript -e "tell application \"Folx GO+\" to open location \"$url\"" &
done
sleep 10
osascript -e "tell application \"Finder\" to set visible of process \"Folx GO+\" to false" &

#################################ATV##################################################################
#needed for first run to get a template

#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'AppleTV' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/AppleTV.ipsw.CheckOld.txt

#get links from site for difference check
#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'AppleTV' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/AppleTV.ipsw.CheckNew.txt
echo "comparing atv template"

cat /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt | grep 'http' | grep 'ipsw' | grep 'AppleTV' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/AppleTV.ipsw.CheckNew.txt



#print any new links that appear to a file. 1 link per line.
diff /Users/localadmin/Downloads/AppleTV.ipsw.CheckOld.txt /Users/localadmin/Downloads/AppleTV.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/AppleTV.ipsw.ToDownload.txt
cd /Users/localadmin/Downloads

#read new links
Links=`cat /Users/localadmin/Downloads/AppleTV.ipsw.ToDownload.txt`

#cleanup
rm /Users/localadmin/Downloads/AppleTV.ipsw.CheckOld.txt
rm /Users/localadmin/Downloads/AppleTV.ipsw.ToDownload.txt
mv /Users/localadmin/Downloads/AppleTV.ipsw.CheckNew.txt AppleTV.ipsw.CheckOld.txt

#queue for download
for url in $Links; do
osascript -e "tell application \"Folx GO+\" to open location \"$url\"" &
done
sleep 10
osascript -e "tell application \"Finder\" to set visible of process \"Folx GO+\" to false" &

#################################iPhone##################################################################
#needed for first run to get a template

#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPhone' | sort -u | grep -v 'iPad' | grep -v 'iPod' | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPhone.ipsw.CheckOld.txt

#get links from site for difference check
#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPhone' | sort -u | grep -v 'iPad' | grep -v 'iPod' | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPhone.ipsw.CheckNew.txt
echo "comparing iphone template"
cat /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt | grep 'http' | grep 'ipsw' | grep 'iPhone' | sort -u | grep -v 'iPad' | grep -v 'iPod' | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPhone.ipsw.CheckNew.txt

#print any new links that appear to a file. 1 link per line.
diff /Users/localadmin/Downloads/iPhone.ipsw.CheckOld.txt /Users/localadmin/Downloads/iPhone.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/iPhone.ipsw.ToDownload.txt
cd /Users/localadmin/Downloads

#read new links
Links=`cat /Users/localadmin/Downloads/iPhone.ipsw.ToDownload.txt`

#cleanup
rm /Users/localadmin/Downloads/iPhone.ipsw.CheckOld.txt
rm /Users/localadmin/Downloads/iPhone.ipsw.ToDownload.txt
mv /Users/localadmin/Downloads/iPhone.ipsw.CheckNew.txt iPhone.ipsw.CheckOld.txt

#queue for download
for url in $Links; do
osascript -e "tell application \"Folx GO+\" to open location \"$url\"" &
done
sleep 10
osascript -e "tell application \"Finder\" to set visible of process \"Folx GO+\" to false" &

#################################iPOD##################################################################
#needed for first run to get a template

#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPod' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPod.ipsw.CheckOld.txt

#get links from site for difference check
#curl -L --proxy 10.xxx.yyy.zzz:8080 -s http://phobos.apple.com/versions  2>&1 | grep 'http' | grep 'ipsw' | grep 'iPod' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPod.ipsw.CheckNew.txt
echo "comparing ipod template"
cat /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt | grep 'http' | grep 'ipsw' | grep 'iPod' | sort -u | cut -d '>' -f 2 | cut -d '<' -f 1 > /Users/localadmin/Downloads/iPod.ipsw.CheckNew.txt


#print any new links that appear to a file. 1 link per line.
diff /Users/localadmin/Downloads/iPod.ipsw.CheckOld.txt /Users/localadmin/Downloads/iPod.ipsw.CheckNew.txt | grep ">" | sed 's/^> //g' > /Users/localadmin/Downloads/iPod.ipsw.ToDownload.txt
cd /Users/localadmin/Downloads

#read new links
Links=`cat /Users/localadmin/Downloads/iPod.ipsw.ToDownload.txt`

#cleanup
rm /Users/localadmin/Downloads/iPod.ipsw.CheckOld.txt
rm /Users/localadmin/Downloads/iPod.ipsw.ToDownload.txt
mv /Users/localadmin/Downloads/iPod.ipsw.CheckNew.txt iPod.ipsw.CheckOld.txt

#queue for download
for url in $Links; do
osascript -e "tell application \"Folx GO+\" to open location \"$url\"" &
done
sleep 10
#rm /Users/localadmin/Downloads/iOS.ipsw.CheckNew.txt

osascript -e "tell application \"Finder\" to set visible of process \"Folx GO+\" to false" &
chmod -R 777 /Users/localadmin/Downloads

exit 0
