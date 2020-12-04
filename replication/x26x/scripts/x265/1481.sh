#!/bin/sh

numb='1482'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.2,1.3,3.8,0.4,0.9,0.3,3,2,10,30,300,3,26,10,4,0,63,48,2,2000,1:1,hex,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"