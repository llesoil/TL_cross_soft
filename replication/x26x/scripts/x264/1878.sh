#!/bin/sh

numb='1879'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 45 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.3,3.4,0.2,0.6,0.9,1,0,8,45,280,2,21,40,4,2,61,28,3,2000,-2:-2,hex,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"