#!/bin/sh

numb='783'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 30 --keyint 250 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.3,2.8,0.3,0.6,0.5,3,0,12,30,250,0,25,0,3,2,60,28,5,1000,-2:-2,hex,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"