## About
http://seene.co/ auto-backup
## Usage
`./seene-backup.sh your_seene_nick`

Creates 'your_seene_nick' folder with last 500 of your public seenes. Images and depth maps.
(if you need more, try to change limit in script, but it might not work. I'm already thinking of a better way)

Each seene is stored in a subfolder named 

`<captured_at> <caption> (#hashtags, if any)`
## Automation
Suggest to create an automatic task to do this every day at 1am:
```
crontab -e
0 1 * * * cd /Users/your_user/Documents/seene-backup; ./seene-backup.sh your_self_seene_nick >seene-backup-self.log 2>&1
0 1 * * * cd /Users/your_user/Documents/seene-backup; ./seene-backup.sh your_wife_seene_nick >seene-backup-wife.log 2>&1
``` 
## Privates

Authorization part is not clear yet. Contact me if you need this.
```
. auth.sh #not included
./seene-backup-private.sh your_seene_nick
```

## Prerequisite
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
rualpe-ws:seene-backup paf$ ./seene-backup.sh paf
Resolving name to id
Getting index
Converting index to seenes.xls
Downloading
2015-03-20T07:33:30Z "Nice" #parking. Same spot (#parking)
######################################################################## 100,0%
######################################################################## 100,0%
2015-03-17T06:27:34Z Much as I hate food seenes..
######################################################################## 100,0%
##################################################                        70,7%^C
```

##Result files
```
rualpe-ws:seene-backup paf$ find paf
...
paf/2015-03-20T07:33:30Z "Nice" #parking. Same spot (#parking)
paf/2015-03-20T07:33:30Z "Nice" #parking. Same spot (#parking)/poster.jpg
paf/2015-03-20T07:33:30Z "Nice" #parking. Same spot (#parking)/scene.oemodel
rualpe-ws:seene-backup paf$ 
```
