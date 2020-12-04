#!/bin/sh

numb='919'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 0 --keyint 270 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.3,1.0,1.0,0.3,0.8,0.1,2,2,2,0,270,3,24,30,4,4,62,48,2,1000,1:1,dia,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"