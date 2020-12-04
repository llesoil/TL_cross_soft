#!/bin/sh

numb='553'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 35 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.5,1.2,5.0,0.5,0.8,0.7,2,0,14,35,240,4,24,50,4,3,62,28,3,2000,1:1,umh,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"