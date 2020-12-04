#!/bin/sh

numb='2317'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.1,4.6,0.4,0.7,0.4,1,1,2,20,240,0,30,30,3,0,63,28,5,1000,-2:-2,dia,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"