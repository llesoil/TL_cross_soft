#!/bin/sh

numb='2782'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.1,0.8,0.3,0.6,0.8,3,1,6,30,250,4,26,40,4,0,63,48,2,1000,-1:-1,hex,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"