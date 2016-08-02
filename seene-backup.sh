#!/bin/bash
# http://seene.co backuper
# Usage: ./seene-backup.sh your_seene_nick
# Author: Alexander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf/seene-backup

user=$1
if [ -z "$user" ]
then
	echo "Usage: $0 your_seen_nick"
	exit 1
fi

folder=$user

echo "Resolving name to id"
id=$(curl -s https://seene.co/api/seene/-/users/@$user|jq .id)

last=500
echo "Getting index of last $last seenes"
curl -# --create-dirs "https://seene.co/api/seene/-/users/$id/scenes?count=$last" -o "$folder/index.json"

echo "Converting index to seenes.xls"
cat "$folder/index.json"|sed 's/\\n/ /g'| jq -c -r '.scenes[] | (.captured_at+" "+.caption+if .links|length>0 then " ("+([.links | .[] | .target] | join(" "))+")" else "" end|.[0:200]) + "\t" + .poster_url + "\t" + .model_url'>"$folder/scenes.xls"

IFS=$'\t'

function download {
	url="$1"
	file="$2"

	curl --progress-bar --continue-at - --create-dirs $url -o "$file"
}

echo "Downloading last $last seenes (not ALL)"
cat "$folder/scenes.xls"|while read -r title poster_url model_url
do
	echo "$title"
	title=$(echo "$title"|sed 's/\//~/g')
	download "$poster_url" "$folder/$title/poster.jpg"
	download "$model_url" "$folder/$title/scene.oemodel"
done

echo "Done"
