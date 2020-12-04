#!/bin/sh

numb='912'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 5 --keyint 240 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.4,1.3,2.0,0.4,0.9,0.5,2,2,6,5,240,1,20,30,4,0,65,28,6,1000,1:1,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"