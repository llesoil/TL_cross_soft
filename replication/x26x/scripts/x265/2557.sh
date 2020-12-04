#!/bin/sh

numb='2558'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.0,4.8,0.3,0.7,0.0,3,0,4,0,260,0,30,10,3,1,65,18,6,1000,-1:-1,umh,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"