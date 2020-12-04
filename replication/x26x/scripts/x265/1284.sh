#!/bin/sh

numb='1285'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 35 --keyint 260 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.3,2.6,0.6,0.6,0.5,3,2,6,35,260,0,21,0,3,1,60,18,6,1000,-1:-1,hex,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"