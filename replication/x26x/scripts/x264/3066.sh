#!/bin/sh

numb='3067'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 0 --keyint 250 --lookahead-threads 2 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.2,3.0,0.3,0.9,0.7,2,2,0,0,250,2,30,0,4,3,67,28,1,2000,-2:-2,dia,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"