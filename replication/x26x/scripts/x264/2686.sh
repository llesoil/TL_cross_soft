#!/bin/sh

numb='2687'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 20 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.3,1.2,1.4,0.2,0.6,0.3,0,1,6,20,220,0,20,30,4,4,62,18,3,1000,1:1,dia,crop,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"