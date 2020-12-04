#!/bin/sh

numb='1141'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 20 --keyint 210 --lookahead-threads 4 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.2,1.4,0.6,0.2,0.8,0.1,0,1,14,20,210,4,23,30,3,4,63,48,6,2000,1:1,dia,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"