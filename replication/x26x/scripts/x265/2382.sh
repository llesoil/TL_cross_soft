#!/bin/sh

numb='2383'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 15 --keyint 280 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.6,1.1,4.4,0.6,0.9,0.9,0,0,14,15,280,2,22,0,5,3,66,38,1,1000,-1:-1,umh,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"