#!/bin/sh

numb='1799'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 35 --keyint 280 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.4,0.8,0.2,0.9,0.4,0,1,8,35,280,2,23,10,5,3,65,18,4,1000,-2:-2,dia,show,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"