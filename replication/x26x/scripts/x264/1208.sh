#!/bin/sh

numb='1209'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 30 --keyint 290 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.1,2.8,0.2,0.8,0.5,2,0,14,30,290,3,22,30,4,4,68,28,1,1000,-1:-1,dia,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"