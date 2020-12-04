#!/bin/bash

numb='3'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.5,1.2,5.0,0.4,0.8,0.2,1,1,12,40,220,1,30,0,4,4,63,38,4,1000,-1:-1,dia,show,fast,0,animation,"
csvLine+="$size,$time,$persec"
echo "$csvLine"