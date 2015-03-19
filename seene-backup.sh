#!/bin/bash -x
# http://seene.co backuper
# Author: Alexaander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf

user=$1
date=$(date +%Y-%m-%d)
id=$(curl -s http://seene.co/api/seene/-/users/@$user|jq .id)
curl -s http://seene.co/api/seene/-/users/$id/scenes?count=10000 > scenes.json

cat scenes.json|jq -c -r '.scenes[] | .captured_at+" "+.caption+if .links|length>0 then " ("+([.links | .[] | .target] | join(" "))+")" else "" end + "\t" + .poster_url + "\t" + .model_url'>scenes.xls

cat scenes.xls |while IFS=$'\t' read -r title poster_url model_url
do
	echo "$title"
	curl -sR --create-dirs $poster_url -o $date/"$title"/poster.jpg
	curl -sR --create-dirs $model_url -o $date/"$title"/scene.oemodel
done
