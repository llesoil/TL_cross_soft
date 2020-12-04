#!/bin/sh

numb='1572'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 20 --keyint 250 --lookahead-threads 0 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.0,2.8,0.4,0.8,0.4,3,0,4,20,250,0,29,0,5,1,65,38,1,1000,-2:-2,umh,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"