#!/bin/sh

numb='2567'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 35 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.4,1.2,0.4,0.4,0.7,0.4,2,0,14,35,240,1,21,0,3,3,60,28,2,2000,-1:-1,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"