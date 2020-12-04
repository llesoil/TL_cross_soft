#!/bin/sh

numb='2583'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 5 --keyint 260 --lookahead-threads 4 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.4,1.0,4.2,0.4,0.7,0.4,0,2,16,5,260,4,23,40,5,3,64,48,2,1000,-2:-2,umh,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"