#!/bin/sh

numb='2574'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.5,1.3,1.4,0.2,0.7,0.0,0,2,0,5,220,1,24,40,5,1,62,48,5,1000,1:1,dia,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"