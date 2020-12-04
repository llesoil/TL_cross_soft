#!/bin/sh

numb='3039'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.2,3.6,0.6,0.9,0.4,0,2,6,50,240,1,27,50,5,3,60,18,3,1000,-1:-1,dia,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"