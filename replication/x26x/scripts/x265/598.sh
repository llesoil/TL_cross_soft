#!/bin/sh

numb='599'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.6,1.0,2.8,0.3,0.8,0.9,1,2,16,50,300,1,30,30,4,3,63,48,3,2000,-2:-2,dia,crop,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"