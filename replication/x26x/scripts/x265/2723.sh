#!/bin/sh

numb='2724'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 10 --keyint 240 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.3,1.4,1.2,0.5,0.8,0.3,2,2,14,10,240,1,25,40,5,0,64,38,3,2000,-1:-1,umh,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"