#!/bin/sh

numb='3023'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 10 --keyint 300 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.4,1.0,4.4,0.2,0.6,0.1,1,0,2,10,300,2,22,10,5,4,67,18,3,2000,-1:-1,hex,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"