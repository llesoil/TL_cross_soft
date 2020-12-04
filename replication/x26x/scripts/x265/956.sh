#!/bin/sh

numb='957'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.1,1.2,3.4,0.6,0.6,0.5,1,0,12,45,250,2,26,30,4,3,63,18,3,1000,1:1,umh,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"