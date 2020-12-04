#!/bin/sh

numb='766'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 50 --keyint 200 --lookahead-threads 3 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.3,1.0,3.0,0.4,0.7,0.6,3,1,2,50,200,3,23,0,5,1,63,28,5,2000,-1:-1,dia,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"