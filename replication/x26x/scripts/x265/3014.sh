#!/bin/sh

numb='3015'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.4,1.4,4.0,0.6,0.6,0.2,2,1,14,35,220,4,26,20,4,0,61,48,6,1000,-1:-1,hex,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"