#!/bin/sh

numb='124'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 10 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.2,3.0,0.5,0.9,0.0,3,1,6,10,300,3,24,0,3,3,66,18,6,1000,-2:-2,umh,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"