#!/bin/sh

numb='1052'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 210 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.6,1.2,0.4,0.2,0.7,0.4,1,0,12,5,210,4,28,30,5,2,69,18,3,2000,1:1,dia,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"