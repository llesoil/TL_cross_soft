#!/bin/sh

numb='2232'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 10 --keyint 300 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.2,1.1,0.4,0.6,0.7,0.1,0,0,6,10,300,3,28,0,3,3,66,18,2,1000,-1:-1,hex,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"