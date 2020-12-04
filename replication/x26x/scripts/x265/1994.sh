#!/bin/sh

numb='1995'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 5.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 280 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.3,5.0,0.4,0.9,0.4,1,1,4,40,280,1,29,50,3,2,68,28,5,2000,-1:-1,umh,crop,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"