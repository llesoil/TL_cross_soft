#!/bin/sh

numb='103'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.0,1.0,3.0,0.5,0.9,0.5,0,1,10,5,270,2,29,10,3,1,60,18,1,1000,-2:-2,umh,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"