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

########### call scripts without "./" #######
######################## Call other scripts without "./" #######################
export PATH=.:$PATH
###############################################################################

################################################################################
#clear  #clear screen if desired
##  terminal screen countdown before,
##  if needed to pause while another tourney completes
secs=-1
while [ $secs -gt -1 ]; do
##  terminal screen countdown before proceeding
  echo -ne "  ...seconds remaining before kickoff:   $secs\033[0K\r"
  ##  terminal screen countdown before proceeding
  sleep 1
  : $((secs--))
done
########### end loop
echo "Settings ..."; echo ""
################################################################################

#############################  Collect timing date  ##########################
DATE=$( date +"%m%d%H%M")
dat=`date +"%D"`
nowt=`date +"%T"`
echo "Current date : time (GMT)"
echo "Date: $dat : $nowt"
echo ""
et=0
startt=`date +%s`
###############################################################################

############################## USER DEBUG OPTIONS ##############################
#set -x #verboose mode , useful for tracking down errors when it does not run
#db=1
#echo $db # 0 = false, cutechess debug is  debug is off, 1 turns debug on, useful for debugging script
###############################################################################

################################# Game Time Settings #####################################
#base=5
#incf=100
base=20
incf=50

##  base/incf = inc, e.g. base 60 /60 = 1 sec inc ;
#   base 60 / 100 = .6 sec inc; base= 60/ 30 = 2 sec inc
# examples:
# base secs  /           20 20 20 20 20             60  60  60 60 60 60
# increment factor      100 50 40 20 10            120 100  60 30 20 10
# = inc secs             .2 .4 .5  1  2             .5  .6   1  2  3  6
# base secs  /      120 120 120 120 120 120 120    300 300 300 300 300 300
# increment factor  120 100  80  60  50  40  30    150 120 100  75  60  50
# = inc secs          1 1.2  1.5  2 2.4   3   4      2 2.5   3   4   5   6
################################################################################

################################### Rounds #####################################
rounds=4
# total num of games will be ( num of engines * (num of engines -1) * rounds
concur=1 ## num of concurrent games . threads * concur should ALWAYS be less than # of logical CPUS

############################### ENGINE Options ################################
hash=16
threads=1
#threads2=2
DIR="./engines"
SYZYGY="option.SyzygyPath=/home/Al/cutechess/projects/cli/syzygy"
TB="/home/Al/cutechess/projects/cli/syzygy"
# NN options
NNE="UseNN"
NNER="true" # true or false
################################################################################

############################### NUMBER OF ENGINES #############################
engine=( 1 2 3 4 5 )  ## I always forget to update otherwise
engines=${#engine[@]}
#echo $engines
################################################################################

######################### Various ENGINE & ID SETTINGS #########################
Y20="2020";Y21="2021"

M01="01"; M02="02"; M03="03"; M04="04"; M05="05"; M06="06"
M07="07"; M08="08";  M09="09"; M10="10"; M11="11"; M12="12"

D01="01"; D02="02"; D03="03"; D04="04"; D05="05"; D06="06"; D07="07"
D08="08"; D09="09"; D10="10"; D11="11"; D12="12"; D13="13"; D14="14"
D15="15"; D16="16"; D17="17"; D18="18"; D19="19"; D20="20"; D21="21"
D22="22"; D23="23"; D24="24"; D25="25"; D26="26"; D27="27"; D28="28"
D29="29"; D30="30"; D31="31"

NET1="1802"
NET2="1802"
NET3="1802"
NET4="1802"
NET5=""
NET6=""
#nets available 20200806-1802.bin 20200808-1351.bin

CMD1="./Stockfish-XI-r4"
ENG1="Stockfish-XI-r4-$NET1"
EVFILE1="/home/Al/cutechess/projects/cli/eval/$Y20$M08$D06-$NET1.bin"
echo "CMD1=$CMD1 ENG1=$ENG1 EVFILE1=$EVFILE1 "

CMD2="./Black-Diamond-XI-r4"
ENG2="BlackDiamond-XI-r4-$NET2"
EVFILE2="/home/Al/cutechess/projects/cli/eval/$Y20$M08$D06-$NET2.bin"
echo "CMD2=$CMD2 ENG2=$ENG2 EVFILE2=$EVFILE2 "

CMD3="./Bluefish-XI-r4"
ENG3="Bluefish-XI-r4-$NET3"
EVFILE3="/home/Al/cutechess/projects/cli/eval/$Y20$M08$D06-$NET3.bin"
echo "CMD3=$CMD3 ENG3=$ENG3 EVFILE3=$EVFILE3 "

CMD4="./Honey-XI-r4"
ENG4="Honey-XI-r4-$NET4"
EVFILE4="/home/Al/cutechess/projects/cli/eval/$Y20$M08$D06-$NET4.bin"
echo "CMD4=$CMD4 ENG4=$ENG4 EVFILE4=$EVFILE4 "

CMD5="./Stockfish-XI-r4"
ENG5="Stockfish-XI-r4-Classical"
EVFILE5=""
echo "CMD5=$CMD5 ENG5=$ENG5 EVFILE5=$EVFILE5 "

#CMD6="./Stockfish"
#ENG6="DV-Stockfish-Dev"
#EVFILE6=""
#echo "CMD6=$CMD6 ENG6=$ENG6 EVFILE6=$EVFILE6 "

###############################################################################

############################### TOURNAMENT OPTIONS #############################
######################## Opening Files & Settings ##############################
format=epd ## pgn or epd, pgn is the default
#ofile="c:/cluster.mfb/Popcnt-LP/books/DrSullivan500.epd"
# 500 position file with more balanced lines

ofile="/home/Al/cutechess/projects/cli/openings/NBSC_30k_5mvs.epd"
# 30000 position file is very unbalanced - favors white

#order="sequential"  # option -> sequential or random
order="sequential"
START=1             # Used with 'sequential' order only, START is the number of the first opening that will be played. The minimum value for START is 1 (default).
PLY=8               # The opening depth is limited to PLIES plies. If PLIES not set the opening depth is unlimited.

tournament_type="round-robin"  # round-robin guantlet knockout pyramid

POLICY="round"      # options:
                    #    'default'- which shifts for any new pair of players and also when the number of  opening repetitions is reached.
                    #    'encounter'- which uses a new  opening for any new pair of players
                    #    'round'- which  shifts only for a new round, all engines play the same opening each round
#POLICY="default"
################################################################################

######################## DO NOT TOUCH - For Debug Purpose ######################
## Debug test - set at row 26
if [[ $db = 1 ]]
then
  DEBUG="-debug"
else
  DEBUG=""
fi
echo $DEBUG
################################################################################

####################  Number of Cutechess Runs Back-to-Back ####################
### "2" call cutechese twice & doubles the games
cute_runs=2
################################################################################

################################### PGN File ###################################
####### Only change to manually set pgn file ###
pgn="./pgn/$DATE.pgn";
echo "PGN File: $pgn" >> $pgn; #echo ""
echo " " >> elo.txt
################################################################################

########### DO NOT TOUCH - Hack to obtain fp decimal from BASE #################
#  hack to use floating point(fp) in bash (bc not available/working in Git basb),
#  but it does screw up the Atom auto color, needed for calc of increment :
#  inc= base/100 or if base is 10 seconds , 10/100=0.1 etc.
inc=$(printf %.3f "$(((10**3 * base)/$incf))e-3"); #echo $inc
## "$(printf %.1f "$((()/1))e-1" ## hack to fix auto color in atom
################################################################################

################ DO NOT TOUCH - AUTO CALCULATED FROM ABOVE #####################
###### Used to calculate total games schedule and estimate total runtime ######
let engfact=($engines-1) ; #echo $engfact
let games=($rounds*$engines*$engfact*$cute_runs) ; echo "Games: $games" ; #echo ""        # for both random and sequential book
let engchk=$engines
let checknum=($rounds*4)/$concur
let checknum=($checknum*$engchk)
let msInc=($base*1000*136)/$incf
let msBase=($base*1000)*2
let gmtime=($msBase+$msInc)/1000   ;#echo "gt "$gmtime
let ttime=($games*$gmtime)/$concur+25 #; echo $ttime
let ttime=($ttime*833)/1000 #;echo $ttime
#echo $ttime
secs=$ttime

#convert seconds to hours and minutes
fc=$(printf 'Projected-> Time: %dh:%dm:%ds' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)));
echo $fc ; #echo ""
let elo_chk=($ttime/$checknum); #echo $elo_chk
TC="$base+$inc"
echo $TC
tcd="Time Control-> base+inc: $base+$inc"; echo ""
echo $tcd
################################################################################

################ Pass variables to the other scripts ###########################
export checknum elo_chk engchk engines et fc games hash pgn secs startt tcd threads ttime
################################################################################

# hack to stop processing here and keep window open,
# unhash, also unhash rows 42 and 42 - for debugging

########################### Start Watcher Script ##############################
#start watcher.sh ## spawns off the watcher script which reports on progress on a periodic basis#
read # hack used for testing - stops processing
echo "Start running the chess match ..."
################################################################################

# read #  hack to stop processing here and keep window open
# unhash, also unhash rows 42 and 42 0 for debugging
################################################################################
# 1st cute chess run random book
########### Manually Update ####################################################

./cutechess-cli $DEBUG -repeat -rounds $rounds -games 2 -tournament $tournament_type -resign movecount=1 score=700 twosided=true -draw movenumber=40 movecount=10 score=2 -concurrency $concur -openings file=$ofile format=$format order=$order plies=$PLY start=$START policy=$POLICY  -ratinginterval 10  -engine dir=$DIR name=$ENG1 cmd=$CMD1 option.EvalFile=$EVFILE1 option.$NNE=$NNER option.Threads=$threads -engine dir=$DIR name=$ENG2 cmd=$CMD2 option.EvalFile=$EVFILE2 option.$NNE=$NNER -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 option.$NNE=$NNER  -engine dir=$DIR name=$ENG4 cmd=$CMD4 option.EvalFile=$EVFILE4 option.$NNE=$NNER -engine dir=$DIR name=$ENG5 cmd=$CMD5 -engine dir=$DIR name=$ENG6 cmd=$CMD6  option.Threads=$threads -each tc=$TC proto=uci  option.Hash=$hash $SYZYGY -pgnout $pgn 2>/dev/null


# -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG4 cmd=$CMD4 option.EvalFile=$EVFILE4 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG5 cmd=$CMD5 option.EvalFile=$EVFILE5 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG6 cmd=$CMD6  ## example with no NN
#c:/cluster.mfb/Popcnt-LP/080120.txt - you also hard code GN if needed

################################ NOTE ###############################
# &> redirects ALL output to /dev/null , &>log.text to debug
#####################################################################

################################################################################
########################## Alternative Random Setup ############################
#ofile="c:/cluster.mfb/Popcnt-LP/books/DrSullivan500.epd"
# 500 position file with more balanced lines
#order="random"  # option -> sequential or random
#2nd pass with random book
#cutechess-cli $DEBUG -repeat -rounds $rounds -games 2 -tournament $tournament_type  -tb c:/syzygy -tbpieces 6 -resign movecount=1 score=700 twosided=true -draw movenumber=40 movecount=10 score=2 -concurrency $concur -openings file=$ofile format=$format order=$order plies=$PLY start=$START policy=$POLICY  -engine dir=$DIR name=$ENG1 cmd=$CMD1 option.EvalFile=$EVFILE1 option.$NNE=$NNER -engine dir=$DIR name=$ENG2 cmd=$CMD2 option.EvalFile=$EVFILE2 option.$NNE=$NNER -each tc=$TC proto=uci option.Threads=$threads option.Hash=$hash $SYZYGY -pgnout $pgn 2>/dev/null
################################################################################
################################################################################

################################################################################
################ 2nd Pass-Sequential Setup with different book #################
# 500 position file with more balanced lines
ofile="/home/Al/cutechess/projects/cli/openings/DrSullivan500.epd"
#order="sequential"  # option -> sequential or random
order="random"
#2nd pass with sequential book
./cutechess-cli $DEBUG -repeat -rounds $rounds -games 2 -tournament $tournament_type -resign movecount=1 score=700 twosided=true -draw movenumber=40 movecount=10 score=2 -concurrency $concur -openings file=$ofile format=$format order=$order plies=$PLY start=$START policy=$POLICY  -ratinginterval 10  -engine dir=$DIR name=$ENG1 cmd=$CMD1 option.EvalFile=$EVFILE1 option.$NNE=$NNER option.Threads=$threads -engine dir=$DIR name=$ENG2 cmd=$CMD2 option.EvalFile=$EVFILE2 option.$NNE=$NNER -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 option.$NNE=$NNER  -engine dir=$DIR name=$ENG4 cmd=$CMD4 option.EvalFile=$EVFILE4 option.$NNE=$NNER -engine dir=$DIR name=$ENG5 cmd=$CMD5 -engine dir=$DIR name=$ENG6 cmd=$CMD6  option.Threads=$threads -each tc=$TC proto=uci  option.Hash=$hash $SYZYGY -pgnout $pgn 2>/dev/null

# -engine dir=$DIR name=$ENG3 cmd=$CMD3 option.EvalFile=$EVFILE3 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG4 cmd=$CMD4 option.EvalFile=$EVFILE4 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG5 cmd=$CMD5 option.EvalFile=$EVFILE5 option.$NNE=$NNER
# -engine dir=$DIR name=$ENG6 cmd=$CMD6  ## example with no NN

################################################################################
################################################################################

#################### Additional Options if desired #############################
#echo "Press the 'enter' key for a summary of results if read is set"
#read #deactivate for multiple scripts

#clear unhash for clear screen
################################################################################

################################### Wrap Up ####################################
################################ DO NOT TOUCH ##################################
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
echo " " >> elo.txt
getelo.sh >> elo.txt
#cp $pgn c:/Users/MichaelB7/Dropbox
################################################################################
################################################################################
#end
