#!/bin/sh

numb='2229'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.5,1.4,1.0,0.5,0.6,0.1,0,2,14,25,200,1,29,10,3,0,66,28,4,1000,1:1,hex,crop,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"