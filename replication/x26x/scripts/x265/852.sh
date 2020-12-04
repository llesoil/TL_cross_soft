#!/bin/sh

numb='853'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 30 --keyint 290 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.1,4.0,0.4,0.9,0.3,3,1,12,30,290,4,30,20,4,3,62,48,5,2000,-1:-1,umh,crop,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"