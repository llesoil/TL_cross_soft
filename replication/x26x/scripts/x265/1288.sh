#!/bin/sh

numb='1289'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.4,1.3,2.2,0.5,0.8,0.5,1,0,2,15,250,0,22,0,5,0,69,18,3,1000,1:1,umh,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"