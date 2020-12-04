#!/bin/sh

numb='2695'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 30 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.4,1.1,4.2,0.3,0.7,0.9,2,1,14,30,270,3,28,30,4,2,62,18,1,2000,-1:-1,umh,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"