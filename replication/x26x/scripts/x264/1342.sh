#!/bin/sh

numb='1343'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 35 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.4,1.3,1.8,0.5,0.7,0.5,0,1,12,35,260,2,28,10,3,0,61,48,6,2000,-1:-1,hex,crop,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"