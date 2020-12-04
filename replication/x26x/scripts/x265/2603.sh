#!/bin/sh

numb='2604'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.6,1.4,0.6,0.3,0.7,0.9,1,1,0,45,200,2,24,40,3,0,65,38,2,2000,-1:-1,dia,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"