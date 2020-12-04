#!/bin/sh

numb='336'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.0,1.3,0.4,0.3,0.7,0.8,1,2,14,35,270,1,30,40,3,0,61,28,2,2000,-2:-2,hex,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"