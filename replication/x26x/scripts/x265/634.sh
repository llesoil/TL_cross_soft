#!/bin/sh

numb='635'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 5 --keyint 280 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.5,1.1,2.6,0.3,0.7,0.2,0,1,8,5,280,2,23,0,5,3,61,38,6,1000,-1:-1,dia,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"