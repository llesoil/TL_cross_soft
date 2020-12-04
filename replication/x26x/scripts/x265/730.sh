#!/bin/sh

numb='731'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 20 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.6,1.2,4.8,0.5,0.7,0.5,2,2,8,20,290,0,24,0,3,2,63,28,2,1000,-2:-2,dia,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"