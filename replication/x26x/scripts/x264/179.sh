#!/bin/sh

numb='180'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.4,1.4,0.8,0.3,0.9,0.4,2,0,16,40,260,0,23,30,3,0,60,28,6,2000,-1:-1,hex,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"