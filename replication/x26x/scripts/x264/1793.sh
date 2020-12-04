#!/bin/sh

numb='1794'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 15 --keyint 220 --lookahead-threads 3 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.3,1.4,1.8,0.2,0.8,0.7,3,1,14,15,220,3,25,30,5,4,68,28,3,1000,-1:-1,dia,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"