#!/bin/sh

numb='2327'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 25 --keyint 270 --lookahead-threads 4 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.2,2.0,0.3,0.9,0.0,3,2,14,25,270,4,28,10,5,1,64,38,1,1000,1:1,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"