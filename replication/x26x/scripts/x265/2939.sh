#!/bin/sh

numb='2940'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 0 --keyint 200 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.0,1.2,2.4,0.6,0.9,0.6,2,1,0,0,200,2,28,20,4,0,60,38,1,1000,1:1,hex,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"