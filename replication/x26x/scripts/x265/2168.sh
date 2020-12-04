#!/bin/sh

numb='2169'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 290 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.6,1.0,0.2,0.4,0.6,0.7,2,0,8,15,290,4,29,0,3,0,60,18,5,1000,1:1,umh,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"