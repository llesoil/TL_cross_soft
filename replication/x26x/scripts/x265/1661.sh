#!/bin/sh

numb='1662'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.3,1.2,4.0,0.2,0.6,0.5,1,2,2,15,280,0,24,0,3,3,65,18,1,1000,1:1,dia,crop,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"