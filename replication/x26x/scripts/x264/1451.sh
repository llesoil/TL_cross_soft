#!/bin/sh

numb='1452'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.0,1.0,4.4,0.4,0.9,0.1,1,2,12,20,290,1,28,40,4,2,68,28,4,2000,1:1,dia,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"