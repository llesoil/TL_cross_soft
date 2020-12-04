#!/bin/sh

numb='683'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 20 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.2,1.0,2.2,0.6,0.6,0.2,1,0,6,20,260,0,30,0,3,3,64,38,1,1000,-1:-1,hex,show,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"