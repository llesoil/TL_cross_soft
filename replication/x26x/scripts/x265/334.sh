#!/bin/sh

numb='335'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 35 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.3,1.0,1.2,0.4,0.9,0.2,2,0,2,35,200,2,29,0,3,3,65,28,4,1000,1:1,hex,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"