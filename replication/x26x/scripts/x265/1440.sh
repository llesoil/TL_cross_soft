#!/bin/sh

numb='1441'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 35 --keyint 270 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.1,1.4,0.4,0.4,0.8,0.4,1,2,12,35,270,4,30,30,5,3,66,18,2,1000,-1:-1,hex,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"