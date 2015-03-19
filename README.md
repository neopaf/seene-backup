# seene-backup
auto-backup of http://seene.co/ data

Usage:
./seene-backup your_user_nick
Creates folder with current date and all your seenes.

Each seene is stored in a folder named 
<captured_at> <caption> (#hashtags, if any)

Prerequisity:
http://stedolan.github.io/jq/
in your path.

Tested on my Mac.
Should be easily ported to Windows.
