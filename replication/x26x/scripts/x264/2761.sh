#!/bin/sh

numb='2762'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 25 --keyint 240 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.2,1.4,3.6,0.5,0.8,0.0,3,1,4,25,240,4,27,0,5,2,66,28,4,2000,-2:-2,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"