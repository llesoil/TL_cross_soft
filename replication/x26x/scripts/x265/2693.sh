#!/bin/sh

numb='2694'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.6,1.2,0.6,0.5,0.6,0.2,2,2,2,45,240,0,23,20,4,0,61,38,1,2000,-1:-1,dia,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"