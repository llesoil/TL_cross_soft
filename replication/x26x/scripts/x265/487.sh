#!/bin/sh

numb='488'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 30 --keyint 270 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.2,1.4,4.8,0.3,0.9,0.0,2,0,4,30,270,0,24,20,5,0,68,38,3,1000,-2:-2,hex,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"