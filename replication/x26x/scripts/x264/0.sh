#!/bin/bash

numb='1'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 35 --keyint 210 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/real//; s/,/./' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps// ; s/frames// ; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.1,1.0,1.6,0.3,0.8,0.0,2,2,12,35,210,4,27,20,5,1,63,48,2,2000,-1:-1,umh,crop,superfast,10,animation,"
csvLine+="$size,$time,$persec"
echo "$csvLine"