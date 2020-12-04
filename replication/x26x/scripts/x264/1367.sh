#!/bin/sh

numb='1368'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.6,1.2,2.0,0.4,0.7,0.0,2,2,14,45,240,1,28,30,3,3,68,38,6,2000,-1:-1,hex,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"