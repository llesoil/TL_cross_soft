#!/bin/sh

numb='1955'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.4,1.2,3.8,0.5,0.9,0.5,1,2,0,5,270,2,22,10,3,3,60,38,3,1000,-1:-1,umh,show,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"