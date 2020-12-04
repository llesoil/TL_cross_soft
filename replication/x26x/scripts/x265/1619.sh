#!/bin/sh

numb='1620'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 15 --keyint 200 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.3,1.1,3.4,0.3,0.7,0.3,0,2,16,15,200,1,24,50,5,0,67,48,6,2000,-2:-2,umh,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"