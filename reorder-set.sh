#!/bin/bash
# http://seene.co backuper
# Usage: ./seene-backup.sh your_seene_nick
# Author: Alexander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf/seene-backup

user="$1"
id="$2"
set_title="$3"
if [ -z "$user" ]
then
	echo "Usage: $0 user id set_title"
	exit 1
fi

folder="$user/$set_title"

echo "Reordering..."
IFS="	"
cat "$folder/scenes.xls"|while read -r title poster_url model_url short_code
do
	echo "$title"
	title=$(echo "$title"|sed 's/\//~/g'|sed 's/[ \t]*$//')
	date=$(echo "$title"|sed 's/^\(....\)-\(..\)-\(..\).*/\1\2\3/')
	#echo "$short_code"
	mv "$folder/$title/poster.jpg" "$folder/gseene_${date}_${short_code}.jpg"
	mv "$folder/$title/scene.oemodel" "$folder/gseene_${date}_${short_code}.oemodel"
	if [ -f "$folder/jmseene_${date}_${short_code}.jpg" ]
	then
		echo 'already'
	else
		cat "$folder/gseene_${date}_${short_code}.jpg" separator "$folder/gseene_${date}_${short_code}.oemodel" > "$folder/jmseene_${date}_${short_code}.jpg"
		rm "$folder/gseene_${date}_${short_code}.jpg"
		rm "$folder/gseene_${date}_${short_code}.oemodel"
	fi
	rmdir "$folder/$title"
done

echo "Done"
