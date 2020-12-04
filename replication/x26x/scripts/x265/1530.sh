#!/bin/sh

numb='1531'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.2,1.4,2.2,0.4,0.7,0.4,0,1,10,5,300,1,26,20,3,1,61,38,5,2000,-2:-2,dia,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"