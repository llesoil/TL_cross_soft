#!/bin/sh

numb='1756'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.3,2.4,0.2,0.8,0.8,3,0,4,0,270,4,24,50,3,4,62,18,4,1000,1:1,dia,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"