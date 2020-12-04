#!/bin/sh

numb='1418'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.3,4.4,0.6,0.8,0.9,2,0,2,35,220,4,22,50,3,2,67,48,1,1000,1:1,hex,show,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"