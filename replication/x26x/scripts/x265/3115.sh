#!/bin/sh

numb='3116'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 45 --keyint 270 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.1,1.0,1.4,0.4,0.8,0.6,3,0,10,45,270,3,24,0,3,1,67,28,5,1000,-2:-2,hex,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"