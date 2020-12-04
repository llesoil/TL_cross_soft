#!/bin/sh

numb='1533'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 40 --keyint 250 --lookahead-threads 0 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,None,--weightb,2.0,1.6,1.1,4.8,0.4,0.7,0.7,0,1,10,40,250,0,28,0,3,3,67,38,1,2000,-1:-1,umh,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"