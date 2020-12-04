#!/bin/sh

numb='310'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.0,1.3,1.6,0.6,0.6,0.6,2,1,16,20,250,3,27,40,5,0,67,18,2,1000,1:1,dia,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"