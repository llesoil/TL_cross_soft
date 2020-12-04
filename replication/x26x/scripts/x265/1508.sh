#!/bin/sh

numb='1509'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 35 --keyint 300 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.6,1.2,3.6,0.3,0.7,0.1,1,1,4,35,300,3,23,30,4,0,69,28,2,1000,-1:-1,dia,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"