#!/bin/sh

numb='2075'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 30 --keyint 250 --lookahead-threads 3 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.6,1.1,1.8,0.2,0.8,0.4,1,1,14,30,250,3,23,10,4,0,67,38,6,1000,-2:-2,hex,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"