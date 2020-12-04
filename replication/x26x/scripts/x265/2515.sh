#!/bin/sh

numb='2516'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.2,1.3,1.4,0.5,0.6,0.0,2,2,8,40,220,2,23,40,3,1,60,28,5,1000,-1:-1,umh,crop,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"