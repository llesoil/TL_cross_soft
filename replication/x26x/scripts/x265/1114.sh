#!/bin/sh

numb='1115'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 10 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.5,1.2,2.6,0.3,0.9,0.1,0,0,16,10,240,3,30,10,3,3,60,18,1,1000,-1:-1,umh,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"