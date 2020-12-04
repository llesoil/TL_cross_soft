#!/bin/sh

numb='2250'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 5.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 25 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.4,1.0,5.0,0.5,0.8,0.1,3,0,2,25,270,3,25,10,5,0,65,48,4,1000,-2:-2,hex,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"