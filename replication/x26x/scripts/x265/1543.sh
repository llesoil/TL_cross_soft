#!/bin/sh

numb='1544'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 270 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.4,1.3,4.0,0.4,0.8,0.1,1,2,10,30,270,4,25,10,5,4,68,28,1,1000,-1:-1,umh,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"