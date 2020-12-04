#!/bin/sh

numb='2051'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 50 --keyint 240 --lookahead-threads 3 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.3,3.8,0.5,0.6,0.3,0,1,14,50,240,3,21,0,4,4,68,28,1,1000,-2:-2,umh,crop,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"