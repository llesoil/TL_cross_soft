#!/bin/sh

numb='668'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.0,0.2,0.6,0.9,0.3,3,2,0,10,210,0,24,20,4,0,60,48,3,2000,-1:-1,hex,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"