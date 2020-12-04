#!/bin/sh

numb='1270'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 30 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.4,0.6,0.6,0.6,0.0,3,2,0,30,230,4,30,30,5,3,64,38,5,1000,-1:-1,dia,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"