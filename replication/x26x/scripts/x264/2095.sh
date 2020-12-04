#!/bin/sh

numb='2096'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.1,4.6,0.6,0.7,0.6,1,2,6,0,260,2,23,10,3,2,67,18,2,2000,1:1,hex,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"