#!/bin/sh

numb='1647'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.5,1.0,0.4,0.3,0.9,0.6,2,2,16,0,270,4,21,40,4,1,66,28,5,1000,1:1,dia,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"