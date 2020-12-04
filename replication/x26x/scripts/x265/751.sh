#!/bin/sh

numb='752'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.2,4.8,0.2,0.8,0.9,1,1,0,35,230,3,25,30,3,2,67,48,6,2000,1:1,hex,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"