#!/bin/bash

### Copyright 2020 Michael F. Byrne, Robert M. Hyatt
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program. If not, see <https://www.gnu.org/licenses/>.

### open issue - still need to complete documentation what we are doing here

clear
set echo on
DATE=$(shell date +"%m%d%H%M")
et=0
startt=`date +%s`
export PATH=$PATH:.

### USER OPTIONS
#set -x verboose mode , useful for tracking down errors whe it does not run
db=0
#echo $db # 0 = false, cutechess debug is  debug is off, 1 turns debug on, useful for debugging script

base=20
incf=40  ##  base/incf = inc, e.g. base 60 /60 = 1 sec inc ; base 60 / 100 = .6 sec inc; base= 60/ 30 = 2 sec inc
##### examples
# base secs  /       60  60 60 60 60 60 60  120 120 120 120 120 120 120  300 300 300 300 300 300 300 300 300 300 300 300
# increment factor  120 100 60 30 20 10 12  120 100  80  60  40  20  10  300 150 120 100  75  60  50  40  30  20  10   5
# = inc secs         .5  .6  1  2  3  6  5    1 1.2  1.5  2   3   6  12    1   2 2.5   3   4   5   6 7.5  10  15  30  60

rounds=750 # total num of games will be ( num of engines * (num of engines -1) * rounds
concur=50 ## num of comcurrent games . threads * concur should ALWAYS be less than # of logical CPUS

### ENGINE options
engines=3 ## of engines
hash="128"
threads=1

#NET options
Y20="2020"
M7="07"
#D27="27"
D28="28"
D29="29"
NET1="0207"
NET2="2138"
NET3="0109"
#NET4="0928"
#20200728-1442
CMD1="Honey-XI-NN.exe"
ENG1="Ho-$NET1"
EVFILE1="./eval/$Y20$M7$D28-$NET1.bin"
echo "CMD1=$CMD1 ENG1=$ENG1 EVFILE1=$EVFILE1 "

CMD2="Honey-XI-NN.exe"
#ENG2="sf"
ENG2="Ho-$NET2"
EVFILE2="./eval/$Y20$M7$D28-$NET2.bin"
#EVFILE2="none"
echo "CMD2=$CMD2 ENG2=$ENG2 EVFILE2=$EVFILE2 "

CMD3="Honey-XI-NN.exe"
ENG3="Ho-$NET3"
EVFILE3="./eval/$Y20$M7$D29-$NET3.bin"
echo "CMD3=$CMD3 ENG3=$ENG3 EVFILE3=$EVFILE3 "

#CMD4="Honey-XI-NN.exe"
#ENG4="Ho-$NET4"
#EVFILE4="./eval/$Y20$M7$D27-$NET4.bin"
#echo "CMD4=$CMD4 ENG4=$ENG4 EVFILE4=$EVFILE4 "

#CMD5="Bluefish-XI-NN.exe"
#ENG5="Bf-$NET2"
#EVFILE5="./eval/20200726-$NET2.bin"

#CMD6="Honey-XI-NN.exe"
#ENG6="Ho-$NET2"
#EVFILE6="./eval/20200726-$NET2.bin"

###TOURNAMENT OPTIONS

format=epd ## pgn or epd, pgn is the default
ofile="c:/cluster.mfb/Popcnt-LP/books/DRSullivan500.epd"
#ofile="c:/cluster.mfb/Popcnt-LP/books/NBSC_30k_5mvs.epd"
order="sequential"  # option -> sequential or random
#order="random"
START=1             # Used with 'sequential' order only, START is the number of the first opening that will be played. The minimum value for START is 1 (default).
PLY=8               # The opening depth is limited to PLIES plies. If PLIES not set the opening depth is unlimited.
tournament_type="round-robin"  # guantlet knockout pyramid
POLICY="round"      # options:
                    #    'default'- which shifts for any new pair of players and also when the number of  opening repetitions is reached.
                    #    'encounter'- which uses a new  opening for any new pair of players
                    #    'round'- which  shifts only for a new round, all engines play the same opening each round
#POLICY="default"
DIR="c:/cluster.mfb/Popcnt-LP"
SYZYGY="option.SyzygyPath=c:/syzygy"

## Debug test - set at row 26
if [ $db == 1 ]
then
  DEBUG="-debug"
else
  DEBUG=""
fi


pgn="c:/cluster.mfb/pgn/$DATE.pgn";
#pgn="c:/cluster.mfb/pgn/07280411.pgn"
#pgn="c:/cluster.mfb/pgn/test.pgn"
echo $pgn

### hack to use floating point(fp) in bash (bc not available/working in Git basb), but it does screw up the Atom auto color, needed for calc of increment : inc= base/100 or if base is 10 seconds , 10/100=0.1 etc.
inc=$(printf %.2f "$(((10**3 * base)/$incf))e-3"); #echo $inc
## "$(printf %.1f "$((()/1))e-1" ## hack to fix auto color in atom


let engfat=($engines-1) ; echo $engfat
let games=($rounds*$engines*$engfat) ; echo $games
let engchk=$engines
let checknum=($rounds*4)/$concur
let checknum=($checknum*$engchk/2)
let msInc=($base*1000*136)/$incf
let msBase=($base*1000)*2
let gmtime=($msBase+$msInc)/1000   ;echo "gt "$gmtime
let ttime=($games*$gmtime)/$concur+25 #; echo $ttime
let ttime=($ttime*4)/5 #;echo $ttime
echo $ttime
secs=$ttime
fc=$(printf 'Projected-> Time: %dh:%dm:%ds' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))) ;
echo $fc

let elo_chk=($ttime/$checknum); echo $elo_chk

TC="$base+$inc"
echo $TC
tcd="base+inc: $base+$inc"
echo $tcd

###
export checknum elo_chk engchk engines et fc games hash pgn secs startt tcd threads ttime ## to pass variables to the two other scripts
start watcher.sh ## spawns off the watcher script which reports on progress on a periodic basis#
#read # hack used for testing - stops processing

#read hack to stop processing and keep window open
cutechess-cli $DEBUG -repeat -rounds $rounds -games 2 -tournament $tournament_type -tb c:/syzygy -tbpieces 6 -resign movecount=1 score=700 twosided=true -draw movenumber=40 movecount=10 score=2 -concurrency $concur -openings file=$ofile format=$format order=$order plies=$PLY start=$START policy=$POLICY -engine dir=$DIR name=$ENG1 cmd=$CMD1 option.EvalFile=$EVFILE1 -engine dir=$DIR name=$ENG2 cmd=$CMD2 option.EvalFile=$EVFILE2 -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 -each  tc=$TC proto=uci option.Threads=$threads option.Hash=$hash $SYZYGY -pgnout $pgn 2>/dev/null
#  -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 -engine dir=$DIR name=$ENG4 cmd=$CMD4 option.EvalFile=$EVFILE4 -engine dir=$DIR name=$ENG5 cmd=$CMD5 option.EvalFile=$EVFILE5 -engine dir=$DIR name=$ENG6 cmd=$CMD6 option.EvalFile=$EVFILE6

### wrap-up
echo "Press the 'enter' key for a summary of results"
#read #deactivate for multiple scripts
#clear
end=`date +%s`
let endt=$end-$startt
echo ""
echo "#########################################################################################################"
echo "###                                              Summary                                              ###"
echo "#########################################################################################################"
echo ""
getelo.sh
echo ""
echo "#########################################################################################################"
echo "###                                                End                                                ###"
echo "#########################################################################################################"
echo ""
echo ""
echo " " >> c:/Users/MichaelB7/Dropbox/elo.txt
getelo.sh >> getelo.sh >> c:/Users/MichaelB7/Dropbox/elo.txt
cp $pgn c:/Users/MichaelB7/Dropbox

#end
