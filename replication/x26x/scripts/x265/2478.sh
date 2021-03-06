#!/bin/sh

numb='2479'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.4,1.1,2.6,0.5,0.6,0.5,3,2,12,35,250,3,22,50,4,2,66,28,5,1000,-2:-2,umh,crop,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"