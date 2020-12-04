#!/bin/sh

numb='1203'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 10 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.1,5.0,0.4,0.8,0.6,3,2,2,10,220,2,20,20,5,1,63,38,6,2000,1:1,umh,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"