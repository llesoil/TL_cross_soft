#!/bin/sh

numb='2809'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 25 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.0,1.4,4.4,0.4,0.9,0.2,0,0,12,25,210,2,24,40,3,4,60,48,6,1000,-1:-1,umh,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"