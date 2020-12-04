#!/bin/sh

numb='1122'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,1.0,0.6,0.8,0.2,3,2,14,0,290,1,29,20,3,4,60,38,6,1000,-1:-1,umh,crop,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"