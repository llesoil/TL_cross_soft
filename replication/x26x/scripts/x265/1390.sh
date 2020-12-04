#!/bin/sh

numb='1391'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.6,1.3,2.4,0.2,0.6,0.0,2,1,16,5,220,1,27,10,3,1,65,18,2,1000,-1:-1,dia,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"