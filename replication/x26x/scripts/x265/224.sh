#!/bin/sh

numb='225'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.2,1.4,0.8,0.3,0.8,0.5,0,1,8,40,270,0,25,20,5,1,63,18,3,1000,1:1,dia,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"