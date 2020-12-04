#!/bin/sh

numb='2177'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 40 --keyint 240 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.1,1.3,3.2,0.6,0.6,0.9,1,1,10,40,240,3,29,0,5,0,64,38,5,2000,-1:-1,hex,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"