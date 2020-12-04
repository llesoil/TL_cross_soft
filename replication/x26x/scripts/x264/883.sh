#!/bin/sh

numb='884'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 220 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.1,2.6,0.4,0.7,0.3,0,0,8,35,220,1,24,10,5,2,66,48,6,1000,-2:-2,hex,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"