#!/bin/sh

numb='1632'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 10 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.1,1.1,3.4,0.3,0.7,0.0,0,1,8,10,270,2,28,0,4,3,65,28,2,1000,-1:-1,umh,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"