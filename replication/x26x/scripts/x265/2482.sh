#!/bin/sh

numb='2483'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 260 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.3,2.8,0.6,0.6,0.5,3,2,0,20,260,0,28,20,5,1,67,38,4,2000,-1:-1,hex,crop,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"