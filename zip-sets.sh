#!/bin/bash
# http://seene.co backuper
# Usage: ./seene-backup.sh your_seene_nick
# Author: Alexander Petrossian (PAF) <alexander.petrossian+seene.backup@gmail.com>
# Repo: https://github.com/neopaf/seene-backup

#https://seene.co/u/WayMJA/sets/
user="$1"
if [ -z "$user" ]
then
	echo "Usage: $0 user"
	exit 1
fi

folder=$user

cd "$folder"
cat "sets.xls"|while read -r id title
do
echo "$title"
zip -mrp0 "$title.zip" "$title"
done
echo "Done"
