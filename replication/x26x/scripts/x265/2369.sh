#!/bin/sh

numb='2370'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.0,1.3,3.8,0.6,0.9,0.5,2,0,0,0,210,2,23,0,3,2,64,28,1,1000,-2:-2,dia,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"