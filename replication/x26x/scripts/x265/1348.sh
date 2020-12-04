#!/bin/sh

numb='1349'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 10 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.5,1.4,2.4,0.6,0.9,0.8,3,0,10,10,240,3,30,40,3,4,64,28,1,1000,1:1,umh,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"