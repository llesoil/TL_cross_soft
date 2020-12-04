#!/bin/sh

numb='1538'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.3,4.0,0.5,0.9,0.3,1,1,8,10,270,3,23,10,5,1,67,48,6,2000,-1:-1,dia,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"