#!/bin/sh

numb='2231'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 10 --keyint 240 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.6,1.3,1.6,0.2,0.8,0.5,1,0,14,10,240,1,30,30,5,3,65,18,5,1000,1:1,dia,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"