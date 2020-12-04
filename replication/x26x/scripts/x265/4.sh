#!/bin/bash

numb='5'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 10 --keyint 300 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.5,1.2,0.8,0.3,0.6,0.1,1,2,16,10,300,4,21,30,5,2,68,18,1,1000,-2:-2,umh,crop,slower,30,grain,"
csvLine+="$size,$time,$persec"
echo "$csvLine"