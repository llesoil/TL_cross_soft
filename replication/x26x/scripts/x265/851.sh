#!/bin/sh

numb='852'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 5 --keyint 280 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.4,1.2,2.2,0.3,0.8,0.6,2,2,16,5,280,4,27,0,4,2,69,28,1,1000,-1:-1,dia,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"