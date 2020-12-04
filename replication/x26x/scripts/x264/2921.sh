#!/bin/sh

numb='2922'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 15 --keyint 290 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.6,1.1,0.2,0.4,0.6,0.7,0,2,14,15,290,0,23,30,5,4,64,48,1,1000,1:1,dia,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"