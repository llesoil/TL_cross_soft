#!/bin/sh

numb='558'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.5,1.2,0.2,0.5,0.9,0.4,3,0,10,40,240,2,20,40,5,0,60,38,1,1000,-1:-1,umh,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"