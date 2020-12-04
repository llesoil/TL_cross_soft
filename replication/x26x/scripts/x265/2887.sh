#!/bin/sh

numb='2888'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.4,3.4,0.4,0.6,0.1,2,0,14,45,260,3,30,40,5,2,68,48,4,1000,-2:-2,umh,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"