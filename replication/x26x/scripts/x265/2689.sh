#!/bin/sh

numb='2690'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.2,1.1,0.4,0.4,0.9,0.8,1,1,6,0,220,3,23,40,4,3,68,18,4,1000,-1:-1,hex,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"