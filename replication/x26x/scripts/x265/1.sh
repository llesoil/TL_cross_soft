#!/bin/bash

numb='2'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.6,1.1,2.8,0.5,0.8,0.7,1,0,4,10,240,4,29,0,4,2,60,28,3,2000,1:1,dia,show,faster,10,animation,"
csvLine+="$size,$time,$persec"
echo "$csvLine"