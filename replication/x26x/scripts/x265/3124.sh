#!/bin/sh

numb='3125'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 5 --keyint 240 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--no-weightb,3.0,1.2,1.0,0.8,0.4,0.9,0.4,2,2,0,5,240,2,23,0,3,3,67,48,1,2000,1:1,umh,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"