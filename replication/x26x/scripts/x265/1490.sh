#!/bin/sh

numb='1491'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 40 --keyint 250 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.2,1.4,0.6,0.5,0.6,0.0,0,1,12,40,250,2,20,10,3,0,68,38,6,1000,-1:-1,dia,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"