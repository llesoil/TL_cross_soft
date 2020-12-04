#!/bin/sh

numb='188'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.2,1.0,1.0,0.3,0.6,0.3,1,2,2,15,220,0,30,30,5,3,64,48,6,1000,1:1,dia,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"