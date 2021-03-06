#!/bin/sh

numb='2950'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 5 --keyint 240 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.1,4.2,0.3,0.9,0.3,0,1,2,5,240,0,23,40,5,4,67,38,3,2000,1:1,hex,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"