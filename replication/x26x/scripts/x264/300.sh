#!/bin/sh

numb='301'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.3,2.8,0.5,0.8,0.8,1,2,8,20,220,2,22,30,5,3,63,38,2,1000,-1:-1,dia,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"