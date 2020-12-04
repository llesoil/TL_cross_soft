#!/bin/sh

numb='2642'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 40 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.6,1.3,4.2,0.3,0.6,0.1,2,1,14,40,200,1,27,30,4,4,61,18,6,1000,1:1,dia,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"