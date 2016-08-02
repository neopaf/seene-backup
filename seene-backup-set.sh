#!/bin/bash
# http://seene.co backuper
# Usage: ./seene-backup.sh your_seene_nick
# Author: Alexander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf/seene-backup

#https://seene.co/a/QoUPEL/
user="$1"
id="$2"
set_title="$3"
if [ -z "$user" ]
then
	echo "Usage: $0 user id set_title"
	exit 1
fi

folder=$user

#https://seene.co/api/seene/-/albums/112/scenes?count=200

echo "$id $user $set_title"
last=500
echo "Getting index of last $last seenes"
folder="$user/$set_title"
curl -# --create-dirs "https://seene.co/api/seene/-/albums/$id/scenes?count=$last" -o "$folder/index.json"

echo "Converting index to seenes.xls"
cat "$folder/index.json"|sed 's/\\n/ /g'| jq -c -r '.scenes[] | [(.captured_at+" "+.caption+if .links|length>0 then " ("+([.links | .[] | .target] | join(" "))+")" else "" end|.[0:200]|sub("\\s+$";"")), .poster_url, .model_url, .short_code]|@tsv'>"$folder/scenes.xls"

IFS=$'\t'

function download {
	url="$1"
	file="$2"

	curl --progress-bar --continue-at - --create-dirs $url -o "$file"
}

echo "Preparing copy script for $last seenes (not ALL)"
rm -f $folder/cp.sh
rm -f $folder/cp.bat
echo "mkdir \"$set_title\"" >> $folder/cp.sh
echo "mkdir \"$set_title\"" >> $folder/cp.bat
echo "cd \"$set_title\"" >> $folder/cp.sh
echo "cd \"$set_title\"" >> $folder/cp.bat
cat "$folder/scenes.xls"|while read -r title poster_url model_url short_code
do
	echo "cp ../*$short_code* ." >> $folder/cp.sh
	echo "copy ..\*$short_code* ." >> $folder/cp.bat
done
echo see $folder/cp.sh
#exit 1
echo "Downloading last $last seenes (not ALL)"
cat "$folder/scenes.xls"|while read -r title poster_url model_url short_code
do
	echo "$title"
	title=$(echo "$title"|sed 's/\//~/g')
	download "$poster_url" "$folder/$title/poster.jpg"
	download "$model_url" "$folder/$title/scene.oemodel"
done

echo "Done"
