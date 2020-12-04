#!/bin/sh

numb='2975'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 1.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.4,1.4,1.2,0.2,0.6,0.5,0,0,4,40,220,1,27,50,3,1,66,38,6,1000,-2:-2,umh,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"