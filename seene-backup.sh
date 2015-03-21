#!/bin/bash
# http://seene.co backuper
# Usage: ./seene-backup.sh your_seene_nick
# Author: Alexander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf/seene-backup

user=$1
folder=$user

echo "Resolving name to id"
id=$(curl -s http://seene.co/api/seene/-/users/@$user|jq .id)

echo "Getting index"
curl -s http://seene.co/api/seene/-/users/$id/scenes?count=500 > scenes.json

echo "Converting index to seenes.xls"
cat scenes.json|sed 's/\\n/ /g'| jq -c -r '.scenes[] | .captured_at+" "+.caption+if .links|length>0 then " ("+([.links | .[] | .target] | join(" "))+")" else "" end + "\t" + .poster_url + "\t" + .model_url'>scenes.xls

IFS=$'\t'

function download {
	url="$1"
	file="$2"

	curl --progress-bar --continue-at - --create-dirs $url -o "$file"
}

echo "Downloading"
cat scenes.xls|while read -r title poster_url model_url
do
	echo "$title"
	download "$poster_url" "$folder/$title/poster.jpg"
	download "$model_url" "$folder/$title/scene.oemodel"
done

echo "Done"
