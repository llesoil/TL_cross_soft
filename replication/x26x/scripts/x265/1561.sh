#!/bin/sh

numb='1562'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 40 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.0,4.2,0.4,0.7,0.4,3,2,10,40,250,2,21,0,5,2,61,18,1,2000,1:1,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"