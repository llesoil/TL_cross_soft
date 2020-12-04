#!/bin/sh

numb='1325'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 45 --keyint 270 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.3,1.3,1.8,0.5,0.8,0.9,3,0,16,45,270,0,30,30,3,0,64,28,6,2000,-1:-1,dia,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"