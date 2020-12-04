#!/bin/sh

numb='1700'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.2,1.4,2.6,0.3,0.8,0.3,1,2,14,35,220,4,22,10,3,3,62,28,2,2000,1:1,dia,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"