#!/bin/sh

numb='2696'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 35 --keyint 260 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.1,1.3,2.4,0.4,0.6,0.8,1,0,8,35,260,4,28,0,3,3,66,38,4,2000,-1:-1,hex,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"