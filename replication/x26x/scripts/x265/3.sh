#!/bin/bash

numb='4'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.3,1.1,3.4,0.6,0.9,0.2,2,0,2,0,260,2,20,10,3,4,68,48,5,1000,1:1,dia,crop,slow,10,grain,"
csvLine+="$size,$time,$persec"
echo "$csvLine"