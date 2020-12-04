#!/bin/sh

numb='1570'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 30 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.4,0.2,0.2,0.9,0.3,1,1,12,30,300,2,24,50,5,0,64,38,4,2000,1:1,dia,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"