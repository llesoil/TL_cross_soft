#!/bin/sh

numb='601'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.3,1.0,0.2,0.8,0.6,3,0,10,45,210,2,24,30,3,0,64,48,2,2000,-2:-2,hex,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"