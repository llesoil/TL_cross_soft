#!/bin/sh

numb='432'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 45 --keyint 200 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.6,1.1,3.8,0.6,0.8,0.7,0,1,12,45,200,4,30,0,4,3,61,18,6,2000,1:1,hex,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"