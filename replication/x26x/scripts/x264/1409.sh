#!/bin/sh

numb='1410'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 5 --keyint 220 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.0,1.0,1.4,3.2,0.4,0.7,0.9,0,1,14,5,220,3,21,20,3,3,63,48,1,2000,-2:-2,dia,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"