#!/bin/sh

numb='965'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 0 --keyint 200 --lookahead-threads 0 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.2,1.1,2.4,0.3,0.8,0.1,3,0,12,0,200,0,28,0,4,2,62,48,6,1000,-1:-1,dia,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"