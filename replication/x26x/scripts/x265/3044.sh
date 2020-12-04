#!/bin/sh

numb='3045'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 30 --keyint 290 --lookahead-threads 1 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.4,1.3,3.6,0.3,0.7,0.1,1,2,12,30,290,1,29,40,4,2,64,28,6,1000,-1:-1,umh,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"