#!/bin/sh

numb='2669'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 50 --keyint 240 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.6,1.2,4.6,0.3,0.8,0.8,1,0,0,50,240,1,20,0,4,0,66,38,6,1000,-2:-2,hex,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"