#!/bin/bash

numb='5'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 45 --keyint 290 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.0,1.1,2.2,0.4,0.6,0.3,3,1,14,45,290,0,21,30,3,4,63,18,5,2000,-2:-2,umh,crop,fast,0,grain,"
csvLine+="$size,$time,$persec"
echo "$csvLine"