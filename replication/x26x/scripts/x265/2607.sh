#!/bin/sh

numb='2608'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 20 --keyint 200 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.4,1.4,2.0,0.5,0.9,0.3,3,1,6,20,200,3,24,0,4,1,63,48,6,1000,-2:-2,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"