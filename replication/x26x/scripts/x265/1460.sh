#!/bin/sh

numb='1461'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.3,1.6,0.5,0.9,0.6,2,0,0,25,260,1,24,50,5,1,64,48,5,1000,-1:-1,hex,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"