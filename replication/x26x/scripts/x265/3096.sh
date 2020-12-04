#!/bin/sh

numb='3097'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.2,1.2,1.2,0.2,0.9,0.2,1,0,0,5,270,2,30,10,4,1,67,38,6,1000,-1:-1,dia,crop,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"