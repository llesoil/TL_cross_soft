#!/bin/sh

numb='1061'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 0 --keyint 280 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.3,1.4,2.8,0.4,0.9,0.0,3,0,12,0,280,2,28,50,5,2,61,28,5,2000,-2:-2,dia,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"