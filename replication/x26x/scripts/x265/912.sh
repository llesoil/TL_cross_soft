#!/bin/sh

numb='913'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.0,1.4,1.6,0.4,0.9,0.3,0,1,4,35,210,3,24,30,4,4,65,18,2,1000,-1:-1,hex,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"