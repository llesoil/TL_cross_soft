#!/bin/sh

numb='415'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.6,1.1,1.4,0.6,0.6,0.1,0,1,16,25,260,2,26,50,4,1,60,38,6,1000,-1:-1,umh,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"