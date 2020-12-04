#!/bin/sh

numb='102'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.6,1.2,4.0,0.6,0.8,0.3,0,1,10,20,290,3,28,30,4,2,62,28,5,2000,-1:-1,hex,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"