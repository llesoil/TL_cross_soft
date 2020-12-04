#!/bin/sh

numb='2832'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 25 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.1,2.0,0.6,0.9,0.2,3,0,6,25,240,0,24,20,5,4,67,28,2,2000,-2:-2,dia,crop,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"