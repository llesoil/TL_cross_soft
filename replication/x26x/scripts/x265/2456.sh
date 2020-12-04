#!/bin/sh

numb='2457'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 40 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.3,2.2,0.2,0.6,0.1,0,1,16,40,210,3,24,50,4,0,63,48,3,2000,1:1,hex,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"