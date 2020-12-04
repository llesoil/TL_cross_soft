#!/bin/sh

numb='2795'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.0,1.0,3.6,0.2,0.8,0.8,2,0,8,30,230,1,24,20,5,2,64,28,4,2000,1:1,dia,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"