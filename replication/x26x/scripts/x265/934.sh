#!/bin/sh

numb='935'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.6,1.2,0.4,0.3,0.7,0.9,1,1,14,50,260,0,24,10,4,3,66,28,2,1000,-1:-1,hex,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"