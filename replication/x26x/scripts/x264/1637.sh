#!/bin/sh

numb='1638'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 25 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.4,0.8,0.3,0.6,0.3,3,2,0,25,260,0,30,0,5,4,60,48,2,2000,1:1,dia,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"