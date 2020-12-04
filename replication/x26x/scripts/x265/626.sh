#!/bin/sh

numb='627'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 5 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.1,2.6,0.4,0.7,0.2,0,0,14,5,280,0,24,30,3,1,67,38,4,2000,-1:-1,hex,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"