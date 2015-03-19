## About
http://seene.co/ auto-backup
## Usage
`./seene-backup.sh your_seene_nick`

Creates folder with current date and all your seenes.

Each seene is stored in a folder named 

`<captured_at> <caption> (#hashtags, if any)`
## Automation

```
crontab -e
0 1 * * * cd /Users/your_user/Documents/seene-backup; ./seene-backup.sh your_seene_nick >seene-backup.log 2>&1
``` 
Suggest to create a cronjob
## Prerequisity
jq binary in your path, http://stedolan.github.io/jq/
## Disclaimer
Tested on my Mac.
Should be easily ported to Windows.

Yours truly,
Alexander Petrossian (PAF), Moscow, Russia
##Useful links
###SeeneLib library for Processing
If you'll decide someday to see what you've got, so far the best is

https://github.com/BenVanCitters/SeeneLib---Processing-Library
###Small JavaScript model renderer (no texture)
https://github.com/detunized/seene-viewer
##Thanks
To Creators of Seene app.
To jq author.
##Sample output
```
macMini:seene-backup paf$ ./seene-backup.sh paf
+ user=paf
++ date +%Y-%m-%d
+ date=2015-03-20
++ curl -s http://seene.co/api/seene/-/users/@paf
++ jq .id
+ id=411418
+ curl -s 'http://seene.co/api/seene/-/users/411418/scenes?count=10000'
+ cat scenes.json
+ jq -c -r '.scenes[] | .captured_at+" "+.caption+if .links|length>0 then " ("+([.links | .[] | .target] | join(" "))+")" else "" end + "\t" + .poster_url + "\t" + .model_url'
+ cat scenes.xls
+ IFS='	'
+ read -r title poster_url model_url
+ echo '2015-03-17T06:27:34Z Much as I hate food seenes..'
2015-03-17T06:27:34Z Much as I hate food seenes..
+ curl -sR --create-dirs https://d2qkfprjkxv2r7.cloudfront.net/uploads/scene/poster/33da7053-a0f8-4146-9e65-aeaf4deba60e/poster.jpg -o '2015-03-20/2015-03-17T06:27:34Z Much as I hate food seenes../poster.jpg'
+ curl -sR --create-dirs https://d3lftec466i2s1.cloudfront.net/uploads/scene/model/33da7053-a0f8-4146-9e65-aeaf4deba60e/scene.oemodel -o '2015-03-20/2015-03-17T06:27:34Z Much as I hate food seenes../scene.oemodel'
```

##Result files
```
-rw-r--r--+ 1 paf  staff  796914 17 мар 09:27 ./2015-03-20/2015-03-17T06:27:34Z Much as I hate food seenes../poster.jpg
-rw-r--r--+ 1 paf  staff  230444 17 мар 09:27 ./2015-03-20/2015-03-17T06:27:34Z Much as I hate food seenes../scene.oemodel
```
