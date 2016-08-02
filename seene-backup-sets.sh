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
mkdir -p $folder

echo "Getting album lists"
curl -s "https://seene.co/u/$user/sets/">/tmp/sets.html
grep bootstrap /tmp/sets.html|sed 's/[)];$//'|sed 's/.*bootstrap[(]//'>$folder/sets.json
#cat $user/sets.json|jq '.resources.user_albums.data|.[]|"\(.id)\t\(if(.description)then .title+" ("+.description+")" else .title end)"' -r>$folder/sets.xls
cat $user/sets.json|jq '.resources.user_albums.data|.[]|[.id, if(.description)then .title+" ("+.description+")" else .title end]|@tsv' -r|tr '/' '-' >$folder/sets.xls
IFS="	"
cat "$folder/sets.xls"|while read -r id title
do
echo "$title"
./seene-backup-set.sh $user $id "$title"
done
echo "Done"
