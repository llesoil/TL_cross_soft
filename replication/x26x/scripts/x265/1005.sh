#!/bin/sh

numb='1006'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.3,1.3,0.8,0.3,0.7,0.0,3,1,8,0,220,3,23,40,5,0,62,38,1,2000,-1:-1,hex,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"