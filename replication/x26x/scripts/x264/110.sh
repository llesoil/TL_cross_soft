#!/bin/sh

numb='111'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 5 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.6,1.2,2.4,0.5,0.9,0.7,2,0,12,5,280,1,23,30,3,2,63,48,3,1000,1:1,umh,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"