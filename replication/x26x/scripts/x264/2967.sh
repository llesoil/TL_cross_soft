#!/bin/sh

numb='2968'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 10 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.4,1.1,3.8,0.6,0.7,0.1,0,1,6,10,290,1,23,10,4,3,63,48,4,2000,-2:-2,hex,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"