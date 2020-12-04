#!/bin/sh

numb='187'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.0,1.1,0.6,0.4,0.7,0.0,0,0,4,50,210,2,21,0,4,1,63,28,1,1000,-2:-2,hex,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"