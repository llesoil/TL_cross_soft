#!/bin/sh

numb='1111'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.0,1.6,0.2,0.7,0.8,2,1,8,40,240,1,27,30,3,2,65,48,2,2000,-1:-1,dia,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"