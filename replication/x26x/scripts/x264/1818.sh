#!/bin/sh

numb='1819'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 0 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.0,3.4,0.3,0.8,0.2,3,2,12,0,200,0,30,30,3,3,68,18,1,2000,-1:-1,dia,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"