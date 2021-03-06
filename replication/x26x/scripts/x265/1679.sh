#!/bin/sh

numb='1680'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 25 --keyint 280 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.3,1.3,3.0,0.2,0.9,0.4,0,0,16,25,280,2,23,0,3,2,67,48,3,2000,-1:-1,umh,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"