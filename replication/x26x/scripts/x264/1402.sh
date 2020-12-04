#!/bin/sh

numb='1403'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 50 --keyint 220 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.1,2.2,0.2,0.6,0.0,2,0,14,50,220,3,22,40,4,4,64,28,2,1000,1:1,umh,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"