#!/bin/sh

numb='2098'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.1,1.3,2.6,0.5,0.9,0.6,1,0,6,45,210,3,23,40,3,3,67,28,3,2000,-2:-2,umh,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"