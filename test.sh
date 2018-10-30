#!/usr/bin/env bash

if [ $# -eq 5 ] 
then
    echo 'THIS RECO RUNS 4 THREADS.  DO NOT RUN THIS SCRIPT MULTIPLE TIMES UNLESS YOU ARE SURE THE MACHINE YOU ARE ON HAS >8 CORES OR IT WILL SLOW THINGS DOWN!'
    echo 'Arguments: ' $1 $2 $3 $4 $5
else
    if [ $# -eq 6 ]
    then
        echo 'THIS RECO RUNS 4 THREADS.  DO NOT RUN THIS SCRIPT MULTIPLE TIMES UNLESS YOU ARE SURE THE MACHINE YOU ARE ON HAS >8 CORES OR IT WILL SLOW THINGS DOWN!'
        echo 'Arguments: ' $1 $2 $3 $4 $5 $6
    else
        echo "Please provide 5 arguments: PD Name, first 3 digits of run, last 3 digits of run, lumi start (4 digits), lumi end (4 digit format)"
        exit
    fi
fi

DATE=`date +%Y%m%d`
INDIRNAME="/eos/cms/store/t0streamer/Data/$1/000/$2/$3/"
OUTDIRNAME="/eos/cms/store/group/phys_heavyions/abaty/2018StreamerRECO"
mkdir "$OUTDIRNAME/$1"
mkdir "$OUTDIRNAME/$1/$2$3"
OUTDIRNAME="$OUTDIRNAME/$1/$2$3/"

mkdir logs
mkdir configs

for (( c=$4; c<=$5; c++ ))
do
   #padd lumi with 4 digits
   printf -v LUMI "%04d" $c
   INFILENAME="run$2$3_ls"$LUMI"_stream$1_StorageManager.dat"
   OUTFILENAME="$1_$2$3_"$LUMI"_$DATE"

   echo "Input directory: $INDIRNAME"
   echo "Input file name: $INFILENAME"
   echo "Output directory: $OUTDIRNAME"
   echo "Output file name: $OUTFILENAME.root"
   echo ""

   cp masterRECO.py configs/$OUTFILENAME.py
   sed -i -e s,SED_INPUT,$INDIRNAME$INFILENAME,g configs/$OUTFILENAME.py
   sed -i -e s,SED_OUTPUT,$OUTDIRNAME$OUTFILENAME.root,g configs/$OUTFILENAME.py
   if [ $# -eq 6 ]
   then
       sed -i -e s,"(-1)#nEvts,($6)",g configs/$OUTFILENAME.py
   fi


   cmsRun "configs/$OUTFILENAME.py" > logs/$OUTFILENAME.log 2>&1 &
   wait 
done


