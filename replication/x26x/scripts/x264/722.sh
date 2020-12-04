#!/bin/sh

numb='723'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.1,0.6,0.5,0.7,0.0,0,0,14,30,240,4,30,30,4,3,69,18,5,2000,1:1,dia,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"