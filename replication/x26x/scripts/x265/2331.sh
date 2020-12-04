#!/bin/sh

numb='2332'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 5 --keyint 220 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.5,1.2,5.0,0.6,0.7,0.7,2,2,8,5,220,3,28,10,4,2,61,38,6,1000,-1:-1,hex,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"