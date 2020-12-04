#!/bin/sh

numb='1715'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.0,1.1,0.4,0.5,0.9,0.6,0,1,10,30,240,4,24,50,3,0,61,18,6,1000,-1:-1,umh,crop,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"