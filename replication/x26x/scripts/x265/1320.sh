#!/bin/sh

numb='1321'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 45 --keyint 220 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.0,1.8,0.6,0.6,0.7,3,1,0,45,220,4,27,20,3,0,61,18,6,1000,-1:-1,umh,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"