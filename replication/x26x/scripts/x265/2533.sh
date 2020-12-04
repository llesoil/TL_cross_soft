#!/bin/sh

numb='2534'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.0,0.4,0.6,0.9,0.3,3,2,0,5,270,4,29,40,3,3,66,18,5,2000,1:1,umh,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"