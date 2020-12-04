#!/bin/sh

numb='924'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.1,1.4,3.8,0.3,0.9,0.1,3,1,10,30,280,0,23,10,4,4,65,28,6,2000,1:1,dia,crop,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"