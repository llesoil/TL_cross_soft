#!/bin/sh

numb='58'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 0 --keyint 200 --lookahead-threads 4 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.2,1.1,4.6,0.6,0.7,0.0,3,2,6,0,200,4,21,0,4,3,68,38,1,1000,1:1,hex,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"