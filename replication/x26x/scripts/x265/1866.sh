#!/bin/sh

numb='1867'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.4,1.2,0.6,0.2,0.9,0.0,0,1,8,40,240,4,24,50,3,1,63,38,1,1000,-1:-1,hex,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"