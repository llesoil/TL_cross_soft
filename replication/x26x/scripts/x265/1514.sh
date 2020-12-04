#!/bin/sh

numb='1515'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.1,2.4,0.4,0.6,0.8,2,1,10,10,210,0,21,0,3,2,66,18,1,2000,-1:-1,dia,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"