#!/bin/sh

numb='2875'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 30 --keyint 210 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.1,1.2,1.2,0.3,0.6,0.6,2,1,8,30,210,0,22,30,5,3,66,28,2,1000,-1:-1,dia,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"