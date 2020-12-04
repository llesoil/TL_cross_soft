#!/bin/sh

numb='665'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.4,1.2,1.4,0.4,0.7,0.8,2,0,0,30,280,0,26,50,3,4,60,38,6,2000,-1:-1,dia,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"