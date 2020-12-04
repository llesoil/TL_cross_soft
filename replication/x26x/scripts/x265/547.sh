#!/bin/sh

numb='548'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.3,1.1,1.8,0.4,0.7,0.8,1,0,10,40,240,4,20,50,3,4,67,48,1,1000,-2:-2,umh,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"