#!/bin/sh

numb='2887'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 35 --keyint 290 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.2,1.0,4.8,0.2,0.8,0.4,1,1,12,35,290,2,26,10,4,2,63,48,3,2000,1:1,hex,crop,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"