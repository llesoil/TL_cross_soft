#!/bin/sh

numb='87'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.0,1.4,1.0,2.4,0.6,0.6,0.2,0,0,2,30,300,4,30,10,4,1,60,18,2,2000,-1:-1,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"