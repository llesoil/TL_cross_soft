#!/bin/sh

numb='1795'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 30 --keyint 220 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.4,1.3,4.2,0.6,0.7,0.5,0,1,4,30,220,2,21,0,4,4,62,28,2,2000,-2:-2,umh,crop,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"