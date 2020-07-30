#!/bin/bash

### Copyright 2020 by Michael F. Byrne, Robert M. Hyatt
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <https://www.gnu.org/licenses/>.


fc=$fc
et=$et

echo "PGN File: $pgn"
echo "Time Control: $tcd"
echo "Games: $games"
echo "Threads: $threads"
echo "Hash: $hash"
echo ""

dat=`date +"%D"`
echo "Current date : time (EDST)"

runt=`date +%s`
nowt=`date +"%T"`
echo "Date: $dat : $nowt"

let endt=$end-$startt
let runt=$runt-$startt
echo ""

ttime=$ttime
echo "$fc"
printf '     Run -> Time: %dh:%dm:%ds\n' $(($runt/3600)) $(($runt%3600/60)) $(($runt%60))
echo ""

### Bayeselo is called to output results. "egrep" and "sed are used to modify/control the output text displayed on the screen or sent to text files
### The script code below was derived directly from Robert Hyatt's original "get elo" script - a great example on how to modify text output at the terminal level.
### Thereare lots of little ticks being used here.  Replace with "bayeselo  <<eof" to see how output would look like without any modifcation.
bayeselo  <<eof | egrep -i "\-|[0-9]|a-z|" |sed -e 's/ResultSet-EloRating>ResultSet-EloRating>//g'|sed -e '1,3d;$d' |sed -e 's/ResultSet>ResultSet>ResultSet-EloRating>3500//g' |sed -e 's/ResultSet-EloRating>//g' |sed -e 's/0.95//g' |sed -e 's/00:00:00,00//g'| sed -e 's/ResultSet>//g' |sed -e 's/This is free software, and you are welcome to redistribute it//g'| sed -e 's/under the terms and conditions of the GNU General Public License//g'  | sed 's/\.$//' | sed '/\/\//d'|  sed '/^$/d' |sed -e '/[0-9] game(s) loaded/d' | sed '/---/G'  | sed '/draw/G'

readpgn $pgn
elo
offset 3500
confidence 0.95
mm 0 1
ratings
echo
echo LOS:
los
echo
x
eof
#exit;                        # should never be needed

#end
### offset 3500              elo offset , elo 3500 wil be avaeerage
### confidence 0.95
### mm 0 1                   "mm 01" is recommned for when engines play both sides - white and black
### ratings
### echo
### echo LOS:
### los                      los= likelihood of superioity
### echo
### x                        exit bayeselo
