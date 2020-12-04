#!/bin/sh

numb='645'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 30 --keyint 200 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.6,1.2,3.4,0.4,0.6,0.3,0,2,4,30,200,4,29,20,4,2,67,48,4,2000,-1:-1,hex,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"