#!/bin/sh

numb='1056'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 10 --keyint 200 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.5,1.3,3.6,0.4,0.9,0.9,2,0,0,10,200,4,27,30,5,2,62,18,6,2000,-2:-2,hex,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"