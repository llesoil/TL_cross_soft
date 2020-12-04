#!/bin/sh

numb='756'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.5,1.0,0.4,0.6,0.9,0.8,0,2,8,40,240,2,26,10,4,1,63,28,3,1000,-1:-1,hex,crop,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"