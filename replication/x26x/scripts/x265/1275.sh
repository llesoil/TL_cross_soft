#!/bin/sh

numb='1276'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.1,1.2,0.4,0.6,0.8,0.4,1,1,4,5,270,2,23,20,3,1,62,18,5,1000,1:1,umh,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"