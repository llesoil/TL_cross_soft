#!/bin/sh

numb='2444'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.2,1.3,0.4,0.2,0.9,0.3,1,2,6,50,240,3,30,10,4,0,65,28,3,2000,-1:-1,umh,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"