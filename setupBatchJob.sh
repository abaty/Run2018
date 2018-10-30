#!/usr/bin/env bash

if [ $# -eq 4 ] 
then
    echo 'THIS RECO RUNS 4 THREADS.  DO NOT RUN THIS SCRIPT MULTIPLE TIMES UNLESS YOU ARE SURE THE MACHINE YOU ARE ON HAS >8 CORES OR IT WILL SLOW THINGS DOWN!'
    echo 'Arguments: ' $1 $2 $3 $4
else
    if [ $# -eq 5 ]
    then
        echo 'THIS RECO RUNS 4 THREADS.  DO NOT RUN THIS SCRIPT MULTIPLE TIMES UNLESS YOU ARE SURE THE MACHINE YOU ARE ON HAS >8 CORES OR IT WILL SLOW THINGS DOWN!'
        echo 'Arguments: ' $1 $2 $3 $4 $5
    else
        echo "Please provide 4 (5) arguments: PD Name, runnumber, lumi start, lumi end, optional: number of events per lumi (default is all in lumi)"
        exit
    fi
fi


DATE=`date +%Y%m%d`
if [ $# -eq 4 ] 
then
     NEWDIR="$1_$2_$3_$4_$DATE"
else 
     NEWDIR="$1_$2_$3_$4_"$DATE"_$5"
fi
 

mkdir $NEWDIR
mkdir $NEWDIR/error
mkdir $NEWDIR/log
mkdir $NEWDIR/output

cp masterRECO.py $NEWDIR 
cp batch_submit.condor $NEWDIR
cp processStreamers_Batch.sh $NEWDIR
 
FIRSTHALFRUN="${2:0:3}"
SECONDHALFRUN="${2:3:3}"
echo $FIRSTHALFRUN
echo $SECONDHALFRUN

sed -i -e s,SED_NJOBS,$(($4-$3+1)),g $NEWDIR/batch_submit.condor
sed -i -e s,SED_ARGS,"$1 $FIRSTHALFRUN $SECONDHALFRUN $3 "'$(ProcId)'" $5",g $NEWDIR/batch_submit.condor
