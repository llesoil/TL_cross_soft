#!/bin/sh

numb='101'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.4,1.2,3.8,0.4,0.8,0.4,3,2,0,15,300,4,22,40,3,4,61,48,5,1000,1:1,umh,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"