#!/bin/sh

numb='2298'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 5 --keyint 240 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.1,2.0,0.4,0.9,0.5,3,2,6,5,240,1,29,10,5,3,62,18,2,1000,-1:-1,dia,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"