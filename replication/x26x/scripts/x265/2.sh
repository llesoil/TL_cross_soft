#!/bin/bash

numb='3'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.5,1.4,2.8,0.6,0.6,0.3,0,2,2,30,290,2,24,10,5,4,65,48,1,2000,-2:-2,dia,show,ultrafast,30,grain,"
csvLine+="$size,$time,$persec"
echo "$csvLine"