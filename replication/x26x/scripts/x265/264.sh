#!/bin/sh

numb='265'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.6,1.3,4.6,0.5,0.9,0.0,1,0,6,20,240,2,28,40,4,3,61,28,6,1000,-2:-2,hex,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"