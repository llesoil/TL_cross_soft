#!/bin/sh

numb='947'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 30 --keyint 270 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.4,1.0,4.4,0.2,0.7,0.7,3,2,14,30,270,4,22,50,5,1,60,28,2,1000,-2:-2,umh,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"