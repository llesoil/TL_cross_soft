#!/bin/sh

numb='285'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 40 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.2,1.1,0.4,0.5,0.6,0.2,2,1,14,40,280,1,23,10,5,0,67,48,5,2000,-2:-2,dia,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"