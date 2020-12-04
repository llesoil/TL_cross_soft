#!/bin/sh

numb='372'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 35 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.6,1.3,1.8,0.2,0.7,0.2,0,0,2,35,210,0,21,10,3,2,63,28,2,1000,-1:-1,umh,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"