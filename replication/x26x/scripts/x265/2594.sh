#!/bin/sh

numb='2595'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.4,2.6,0.5,0.8,0.3,3,0,8,20,270,0,22,50,5,0,66,48,4,1000,1:1,dia,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"