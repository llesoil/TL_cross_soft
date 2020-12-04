#!/bin/sh

numb='926'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 50 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.2,2.0,0.5,0.7,0.7,3,0,2,50,270,2,28,40,5,3,68,18,2,1000,-1:-1,dia,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"