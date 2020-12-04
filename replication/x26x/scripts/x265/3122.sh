#!/bin/sh

numb='3123'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.2,1.1,3.6,0.2,0.8,0.5,2,2,10,45,240,1,24,10,3,4,69,18,1,1000,1:1,hex,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"