#!/bin/sh

numb='838'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 0 --keyint 210 --lookahead-threads 4 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.5,1.1,1.2,0.6,0.9,0.1,1,2,8,0,210,4,20,50,5,1,67,48,4,2000,1:1,dia,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"