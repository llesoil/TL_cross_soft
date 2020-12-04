#!/bin/sh

numb='223'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 5 --keyint 240 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.2,4.8,0.2,0.6,0.1,3,2,4,5,240,0,30,10,4,4,67,18,4,2000,1:1,hex,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"