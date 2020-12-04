#!/bin/bash

numb='2'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 0 --keyint 290 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.3,3.0,0.6,0.6,0.1,1,0,10,0,290,3,30,30,5,2,68,38,4,2000,-2:-2,dia,show,veryslow,0,grain,"
csvLine+="$size,$time,$persec"
echo "$csvLine"