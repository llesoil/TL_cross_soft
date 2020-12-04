#!/bin/sh

numb='1142'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 3 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.6,1.4,1.0,0.5,0.7,0.3,0,1,14,0,290,3,22,0,3,4,67,18,6,1000,-2:-2,hex,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"