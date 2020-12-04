#!/bin/sh

numb='1424'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 35 --keyint 280 --lookahead-threads 3 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.5,1.4,2.2,0.3,0.6,0.9,1,2,0,35,280,3,25,30,5,1,62,48,6,2000,-1:-1,dia,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"