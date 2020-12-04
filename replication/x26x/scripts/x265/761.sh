#!/bin/sh

numb='762'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 20 --keyint 200 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.5,1.0,1.8,0.6,0.8,0.9,0,1,10,20,200,3,20,10,4,3,62,18,3,1000,1:1,umh,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"