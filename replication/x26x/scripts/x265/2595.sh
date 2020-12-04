#!/bin/sh

numb='2596'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.1,1.4,1.4,0.6,0.8,0.5,2,0,10,30,300,2,21,0,3,1,69,48,6,2000,1:1,dia,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"