#!/bin/sh

numb='2391'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 0 --keyint 250 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.0,1.0,5.0,0.3,0.6,0.1,3,1,10,0,250,1,21,30,4,1,67,18,2,1000,1:1,umh,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"