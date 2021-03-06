#!/bin/sh

numb='1009'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.3,1.2,2.0,0.6,0.9,0.3,0,1,2,20,280,0,23,50,5,3,67,38,4,2000,1:1,dia,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"