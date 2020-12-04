#!/bin/sh

numb='2527'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 20 --keyint 240 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.4,1.1,2.6,0.2,0.6,0.6,2,2,12,20,240,3,24,0,4,3,66,48,1,2000,-1:-1,dia,crop,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"