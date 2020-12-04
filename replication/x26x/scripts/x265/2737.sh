#!/bin/sh

numb='2738'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 40 --keyint 280 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.2,1.0,0.6,0.2,0.7,0.3,0,0,8,40,280,2,30,10,5,2,67,38,4,2000,-1:-1,hex,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"