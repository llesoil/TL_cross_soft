#!/bin/sh

numb='2883'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 10 --keyint 250 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.6,1.1,3.0,0.2,0.9,0.7,0,1,14,10,250,1,23,20,5,2,66,28,2,1000,-1:-1,hex,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"