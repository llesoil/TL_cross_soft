#!/bin/sh

numb='479'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 0 --keyint 220 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.3,1.2,4.0,0.4,0.6,0.6,1,2,16,0,220,1,24,30,3,0,60,48,6,1000,-2:-2,umh,crop,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"