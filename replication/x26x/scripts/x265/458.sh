#!/bin/sh

numb='459'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.6,1.2,4.2,0.4,0.7,0.3,3,0,2,5,270,0,22,10,5,1,62,38,6,1000,1:1,hex,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"