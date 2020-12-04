#!/bin/sh

numb='2282'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 25 --keyint 290 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--no-weightb,1.0,1.4,1.0,4.4,0.4,0.8,0.6,3,1,16,25,290,3,26,20,3,1,60,28,1,2000,1:1,umh,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"