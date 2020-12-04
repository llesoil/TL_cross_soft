#!/bin/sh

numb='2621'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 0 --keyint 260 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.0,3.0,0.5,0.8,0.8,0,0,0,0,260,3,23,30,5,0,67,38,5,1000,-1:-1,dia,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"