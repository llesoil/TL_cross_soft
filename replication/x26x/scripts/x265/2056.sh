#!/bin/sh

numb='2057'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 25 --keyint 240 --lookahead-threads 3 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.5,1.0,2.0,0.6,0.6,0.4,2,2,10,25,240,3,20,0,5,0,62,38,2,1000,-1:-1,dia,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"