#!/bin/sh

numb='1807'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.4,1.2,1.2,0.4,0.9,0.8,2,1,0,50,240,0,24,10,5,2,69,38,2,2000,-1:-1,dia,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"