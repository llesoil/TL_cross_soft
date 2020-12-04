#!/bin/sh

numb='1945'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 25 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.2,0.2,0.6,0.6,0.1,3,0,14,25,280,1,23,10,3,4,67,48,2,1000,-1:-1,dia,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"