#!/bin/sh

numb='1407'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 5 --keyint 260 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.2,1.0,0.6,0.6,0.5,2,2,8,5,260,3,20,10,5,4,63,38,2,1000,1:1,dia,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"