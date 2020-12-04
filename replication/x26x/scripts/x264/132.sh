#!/bin/sh

numb='133'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.3,1.0,0.5,0.6,0.7,3,2,16,0,300,1,22,50,4,1,66,48,6,2000,1:1,dia,crop,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"