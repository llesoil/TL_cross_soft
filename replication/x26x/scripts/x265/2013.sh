#!/bin/sh

numb='2014'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 10 --keyint 210 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.1,0.8,0.6,0.9,0.2,0,1,4,10,210,3,26,10,3,1,63,38,2,2000,-1:-1,umh,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"