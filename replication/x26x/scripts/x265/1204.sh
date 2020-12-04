#!/bin/sh

numb='1205'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.1,3.6,0.4,0.8,0.1,1,0,6,40,220,1,29,30,4,2,67,28,4,2000,-2:-2,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"