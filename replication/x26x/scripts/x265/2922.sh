#!/bin/sh

numb='2923'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 15 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.0,4.6,0.2,0.9,0.8,3,1,4,15,280,0,24,30,5,4,66,18,1,1000,-1:-1,hex,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"