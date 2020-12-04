#!/bin/sh

numb='3081'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 15 --keyint 200 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.4,1.6,0.3,0.7,0.2,3,0,8,15,200,1,22,50,4,0,66,48,6,1000,1:1,dia,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"