#!/bin/sh

numb='367'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 35 --keyint 210 --lookahead-threads 0 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.4,1.1,1.6,0.3,0.8,0.7,3,1,12,35,210,0,29,0,5,4,61,38,2,1000,-1:-1,dia,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"