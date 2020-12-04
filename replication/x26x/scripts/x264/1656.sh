#!/bin/sh

numb='1657'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 30 --keyint 200 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.2,4.6,0.6,0.6,0.1,3,1,2,30,200,0,21,30,4,3,63,48,2,1000,-2:-2,dia,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"