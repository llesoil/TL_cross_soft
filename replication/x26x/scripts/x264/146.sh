#!/bin/sh

numb='147'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 40 --keyint 200 --lookahead-threads 1 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.2,0.2,0.3,0.8,0.8,0,1,6,40,200,1,28,20,5,1,67,48,5,1000,-1:-1,hex,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"