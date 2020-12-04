#!/bin/sh

numb='199'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.4,2.0,0.6,0.9,0.2,3,2,6,0,230,4,25,50,5,0,68,28,5,2000,1:1,dia,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"