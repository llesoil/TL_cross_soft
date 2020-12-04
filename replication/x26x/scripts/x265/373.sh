#!/bin/sh

numb='374'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 5 --keyint 260 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.2,1.2,2.0,0.6,0.9,0.8,1,1,6,5,260,1,23,0,4,0,66,38,5,1000,-1:-1,dia,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"