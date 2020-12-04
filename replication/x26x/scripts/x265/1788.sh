#!/bin/sh

numb='1789'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.0,1.4,0.8,0.6,0.6,0.4,0,1,12,0,210,3,20,40,4,2,61,18,1,2000,-1:-1,umh,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"