#!/bin/sh

numb='2220'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 30 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.5,1.0,4.8,0.3,0.7,0.4,0,0,14,30,250,0,27,10,3,1,67,38,4,1000,1:1,hex,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"