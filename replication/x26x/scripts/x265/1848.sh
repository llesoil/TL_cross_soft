#!/bin/sh

numb='1849'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 30 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.5,1.1,1.8,0.6,0.8,0.9,1,1,14,30,290,1,23,20,3,1,60,48,1,2000,-2:-2,hex,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"