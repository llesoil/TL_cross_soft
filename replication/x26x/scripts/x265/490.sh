#!/bin/sh

numb='491'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.3,1.4,1.4,0.2,0.6,0.4,2,0,2,45,290,4,24,0,4,2,64,38,2,1000,-2:-2,umh,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"