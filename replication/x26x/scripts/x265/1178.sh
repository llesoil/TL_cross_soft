#!/bin/sh

numb='1179'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 40 --keyint 270 --lookahead-threads 3 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.0,1.0,2.2,0.5,0.6,0.1,3,2,6,40,270,3,27,10,4,3,61,18,3,1000,-1:-1,umh,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"