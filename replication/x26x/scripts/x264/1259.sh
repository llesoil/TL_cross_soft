#!/bin/sh

numb='1260'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 30 --keyint 220 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.0,1.0,1.4,0.2,0.7,0.0,0,2,14,30,220,0,24,0,4,1,61,38,5,1000,1:1,dia,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"