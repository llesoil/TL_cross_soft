#!/bin/sh

numb='2161'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 10 --keyint 280 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.4,1.0,3.6,0.3,0.7,0.2,0,0,4,10,280,2,26,50,3,2,63,48,5,1000,1:1,dia,show,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"