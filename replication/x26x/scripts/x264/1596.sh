#!/bin/sh

numb='1597'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 10 --keyint 250 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.2,1.0,1.2,0.6,0.6,0.1,3,1,10,10,250,1,29,50,3,3,60,48,5,1000,1:1,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"