#!/bin/sh

numb='493'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.4,3.8,0.4,0.6,0.7,1,0,6,35,280,0,22,50,5,1,64,48,6,2000,-2:-2,dia,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"