#!/bin/sh

numb='2056'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.1,1.4,0.3,0.6,0.4,3,0,12,15,240,4,20,0,5,2,63,48,4,1000,-1:-1,umh,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"