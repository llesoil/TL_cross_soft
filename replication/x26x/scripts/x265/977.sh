#!/bin/sh

numb='978'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.6,1.2,3.0,0.3,0.6,0.2,1,1,0,30,240,4,24,50,5,4,61,48,2,1000,1:1,hex,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"