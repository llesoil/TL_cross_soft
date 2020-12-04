#!/bin/sh

numb='2597'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 35 --keyint 280 --lookahead-threads 4 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.3,1.0,3.4,0.3,0.9,0.3,1,2,4,35,280,4,28,50,3,2,60,28,3,2000,-2:-2,dia,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"