#!/bin/sh

numb='264'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.4,5.0,0.4,0.8,0.8,2,1,14,5,270,2,30,40,4,0,64,38,6,2000,-1:-1,umh,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"