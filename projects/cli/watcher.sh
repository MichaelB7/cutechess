#!/bin/bash
#set-x  - for debugging script
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


echo
let secs=$elo_chk*2                                                              ## 3 time more time for the inital loop
#secs=0                                                                          ## unhash tag to debug and avoid wait
echo ""

while [ $secs -gt -1 ]; do                                                       ## Initial loop has a litte more time to allow time for overruns
  echo -ne "  ...seconds remaining:   $secs\033[0K\r"                            ##  terminal screen countdown before proceeding
  sleep 1
  : $((secs--))
done
clear
let chk=$checknum*81/100
let chk=$checknum
let chkr=$checknum
let chk=$chk
#echo "loops: $chk"                                                              ## to debug, the loop count is the number of updates
for i in `seq 1 $chk`;                                                           ## loop to check current results
do
  echo " "                                                                       ## terminal screen
  getelo.sh                                                                      ## terminal screen
  echo " "                                                                       ## terminal screen
  echo " " >> C:/Users/MichaelB7/Dropbox/elo.txt                                 ## push results to dropbox for remote vieiwng
  getelo.sh >> getelo.sh >> C:/Users/MichaelB7/Dropbox/elo.txt                   ## push results to dropbox for remote vieiwng
  echo " " >> C:/Users/MichaelB7/Dropbox/elo.txt                                 ## push results to dropbox for remote vieiwng
  echo " "                                                                       ## terminal screen
  cp $pgn C:/Users/MichaelB7/Dropbox                                             ## push results to dropbox for remote vieiwng
  echo "loops/scheduled: $i/$chkr"                                               ## terminal screen
  echo "loops/scheduled: $i/$chkr" >> C:/Users/MichaelB7/Dropbox/elo.txt         ## dropbox
  echo ""                                                                        ## terminal screen
  echo " " >> C:/Users/MichaelB7/Dropbox/elo.txt                                 ## dropbox
  let secs=$elo_chk; echo "waiting: $elo_chk"                                    ## countdown in seconds for the next update
  while [ $secs -gt -1 ]; do
	  echo -ne "  ...seconds remaining:   $secs\033[0K\r"                          ## terminal screen countdown
	  sleep 1
	  : $((secs--))
  done
clear                                                                            ## clears the terminal, hash tag out to debug
done

echo ""                                                                          ## output to terminal screen
echo ""                                                                          ## "" ""  to terminal screen
echo "done"                                                                      ## "" ""  to terminal screen
read                                                                             ## hack, un hashtag to keep terminal open upon completion, for debugginh
exit


#end
