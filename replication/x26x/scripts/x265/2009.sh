#!/bin/sh

numb='2010'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.0,1.2,4.8,0.2,0.9,0.7,0,2,0,35,220,4,24,50,3,2,69,18,1,1000,1:1,umh,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"