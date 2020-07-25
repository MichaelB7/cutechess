#!/bin/bash

### Copyright 2020 Michael F. Byrne, Robert M. Hyatt
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

clear
echo " "
let secs=3*$elo_chk;
#secs=0  #for debug purposes
echo "waitng: $secs"
echo ""

while [ $secs -gt -1 ]; do
  echo -ne "  ...seconds remaining:   $secs\033[0K\r"
  sleep 1
  : $((secs--))
done

let chk=$checknum*19/20
echo "number of checks: "$chk
for i in `seq 1 $chk`;
do
  echo " "
  getelo.sh
  echo " "
  echo " ">>elota.txt
  getelo.sh>>elota.txt
  echo " "
  echo "loops/scheduled: $i/$chk"

#cp /Users/michaelbyrne/Dropbox/071920.pgn ~/Dropbox/Shared
#  echo " ">>~/Dropbox/elota.txt
  echo ""
  let secs=$elo_chk; echo "waiting: $elo_chk"
  while [ $secs -gt -1 ]; do
	  echo -ne "  ...seconds remaining:   $secs\033[0K\r"
	  sleep 1
	  : $((secs--))
  done

done

echo ""
echo ""
echo "done"
read  ### hack to keep the watcher.sh window open when it completes, otherwise it will close

#end
