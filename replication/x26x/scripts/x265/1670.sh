#!/bin/sh

numb='1671'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 30 --keyint 240 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.6,1.4,3.8,0.4,0.6,0.1,1,2,16,30,240,0,30,40,3,0,64,48,4,1000,-1:-1,dia,show,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"