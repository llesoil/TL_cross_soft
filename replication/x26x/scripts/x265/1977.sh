#!/bin/sh

numb='1978'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.2,3.0,0.2,0.6,0.0,0,1,8,35,300,2,24,10,4,0,67,38,4,1000,-2:-2,hex,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"