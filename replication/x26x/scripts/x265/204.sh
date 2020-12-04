#!/bin/sh

numb='205'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 0 --keyint 280 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.2,1.4,0.8,0.3,0.7,0.1,2,1,8,0,280,2,28,50,4,4,66,18,3,1000,-1:-1,umh,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"