#!/bin/sh

numb='2833'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.4,4.2,0.2,0.8,0.7,0,1,12,0,280,0,28,50,3,3,60,48,2,2000,-2:-2,umh,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"