#!/bin/sh

numb='1345'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.4,0.2,0.4,0.7,0.3,2,2,0,0,230,4,28,30,4,2,63,28,3,1000,-1:-1,hex,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"