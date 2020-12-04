#!/bin/sh

numb='1474'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 20 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.3,1.0,0.4,0.5,0.7,0.0,2,2,2,20,200,0,30,20,5,4,67,28,4,1000,1:1,dia,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"