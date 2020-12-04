#!/bin/sh

numb='908'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.4,1.1,2.2,0.5,0.9,0.2,3,2,0,25,210,0,23,40,4,0,65,38,1,1000,-1:-1,umh,crop,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"