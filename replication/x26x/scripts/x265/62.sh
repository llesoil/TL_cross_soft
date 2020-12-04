#!/bin/sh

numb='63'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 15 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.1,3.6,0.2,0.7,0.7,0,0,8,15,260,1,30,30,5,3,63,48,2,1000,-2:-2,dia,show,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"