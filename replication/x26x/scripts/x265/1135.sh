#!/bin/sh

numb='1136'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 35 --keyint 230 --lookahead-threads 1 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.6,1.3,3.8,0.3,0.7,0.9,1,0,10,35,230,1,22,20,3,0,67,18,5,1000,-2:-2,dia,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"