#!/bin/sh

numb='1682'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.2,2.0,0.4,0.9,0.2,3,0,2,0,250,4,23,0,4,3,65,28,2,2000,-1:-1,hex,crop,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"