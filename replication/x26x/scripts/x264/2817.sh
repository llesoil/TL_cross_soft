#!/bin/sh

numb='2818'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 45 --keyint 230 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.0,2.0,0.5,0.6,0.2,0,0,12,45,230,1,24,30,5,4,66,38,6,1000,1:1,hex,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"