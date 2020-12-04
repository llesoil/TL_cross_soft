#!/bin/sh

numb='45'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.4,1.1,4.6,0.5,0.9,0.0,3,0,14,0,220,3,20,20,5,4,63,38,6,1000,-1:-1,umh,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"