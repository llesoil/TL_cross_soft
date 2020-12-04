#!/bin/sh

numb='660'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 30 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.2,1.4,0.2,0.2,0.7,0.8,0,2,4,30,210,2,22,0,4,2,62,38,1,2000,-1:-1,umh,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"