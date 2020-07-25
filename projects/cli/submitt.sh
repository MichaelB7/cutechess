#!/bin/bash

### Copyright 2020 by Michael F. Byrne, Robert M. Hyatt (original author
### of the "Watcher", "Submit" and "GetELo" scripts used in testing by the
### chess engine Crafty authors).

### Although signifciantly modified since used with Crafty, the main concept
### has remained unchanged. Run an automated chess match via a script which
### calls a match porgram while sultaneouly calling otehrs scripts to report
### back teh resultsand have the scripts report back to the user on a peridioc
### basis in a meaningful summary view so that the user can easily decipher
### the test results while remote from the actual servers running the match.
### This scropt was desigend specially to work with the cutechess-client match
### program  The oriinal scripst authored by Robery Hyatt worked with his own
### proprietayry program which he called "Match"

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
set echo on
DATE=$(shell date +"%y%m%d%H%M-")
et=0
startt=`date +%s`
export PATH=$PATH:.

### USER OPTIONS
base=60
ROUNDS=2000  # total num of games will be ( num of engines * (num of engines -1) * rounds
CONCUR=25   ## reflects num of comcurrent games . should be less than # of logical CPUS
NUMENG=2    # num of engines

### ENGINE options
ENG2="1134"
ENGCMD1="Stockfish-XI-NN.exe"
EVFILE1="./eval/20200723-1134.bin"

ENG1="2344"
ENGCMD2="Stockfish-XI-NN.exe"
EVFILE2="./eval/20200724-2344.bin"

###TOURNAMENT OPTIONS
### common options -each
DIR="c:/cluster.mfb/Popcnt-LP"
HASH=256
SYZYGY="option.SyzygyPath=c:/syzygy"
THREADS=2

DB="-debug"
OFILE="C:/cluster.mfb/Popcnt-LP/books/NBSC_30k_5mvs.epd"
#OFILE="C:/cluster.mfb/Popcnt-LP/books/DRSullivan500.epd"
ORDER="random"   # other option -> sequential
TOUR="round-robin"
ENGINES=2  ## of engines



pgn="c:/cluster.mfb/pgn/$DATE$ENG1$ENG2.pgn";
#pgn="c:/cluster.mfb/pgn/test.pgn"
echo $pgn

### hack to use floating point(fp) in bash (bc not available/working in Git basb), but it does screw up the Atom auto color, needed for calc of increment : inc= base/100 or if base is 10 seconds , 10/100=0.1 etc.
inc=$(printf %.2f "$(((10**3 * base)/100))e-3"); #echo $inc
## "$(printf %.2f "$((()/1))e-3"


let ENGFAT=$ENGINES-1
let games_planned=($ROUNDS*$NUMENG*$ENGFAT)

let checknum=($ROUNDS*3)/$CONCUR
let gmtime=($base*4) #;echo $base
let ttime=($ROUNDS*2*$gmtime)/$CONCUR #; echo $ttime
let ttime=($ttime*4)/5 #;echo $ttime
echo $ttime
#let ttime=($ttime*4)/5 #;echo $ttime
secs=$ttime
fc=$(printf 'Projected-> Time: %dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))) ;
let elo_chk=($ttime/$checknum); echo $elo_chk
echo $elo_chk
TC="$base+$inc"
echo $TC
tcd="base+inc: $base+$inc"
echo $tcd
export checknum elo_chk et fc games_planned HASH pgn secs startt tcd THREADS ttime  ## to pass variables to the two other scripts

start watcher.sh  ## spawns off the watcher script which reports on progress on a periodic basis
#read # hack used for testing - stops processing



#read hack to stop processing and keep window open
cutechess-cli   -repeat -rounds $ROUNDS -games 2 -tournament $TOUR -tb c:/syzygy -tbpieces 6 -resign movecount=1 score=700 twosided=true -draw movenumber=40 movecount=10 score=2 -concurrency $CONCUR -openings file=$OFILE format=epd order=$ORDER plies=16 -engine name=$ENG1 cmd=$ENGCMD1 dir=$DIR  option.EvalFile=$EVFILE1 -engine name=$ENG2 dir=$DIR cmd=$ENGCMD2 option.EvalFile=$EVFILE2 -each tc=$TC proto=uci option.Threads=$THREADS  option.Hash=$HASH $SYZYGY -pgnout $pgn 2>/dev/null
###-engine name=$ENG3 cmd=$ENGCMD3 dir=$DIR option.EvalFile=$EVFILE3 \
###-engine name=$ENG4 cmd=$ENGCMD4 dir=$DIR option.EvalFile=$EVFILE4 \
###-engine name=$ENG5 cmd=$ENGCMD5 dir=$DIR option.EvalFile=$EVFILE5 \
###-engine name=$ENG6 cmd=$ENGCMD6 dir=$DIR option.EvalFile=$EVFILE6 \
###-engine name=$ENG7 cmd=$ENGCMD7 dir=$DIR option.EvalFile=$EVFILE7 \
###-engine name=$ENG8 cmd=$ENGCMD8 dir=$DIR option.EvalFile=$EVFILE8 \

### wrap-up
end=`date +%s`
let endt=$end-$startt
echo ""
echo "$fc"
et=$(printf 'Total->  RunTime: %dh:%dm:%ds\n' $(($endt/3600)) $(($endt%3600/60)) $(($endt%60)))
echo "$et"
