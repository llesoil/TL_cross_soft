#!/bin/sh

numb='785'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 30 --keyint 270 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.4,1.2,0.2,0.3,0.8,0.5,2,2,4,30,270,2,22,10,5,2,68,18,6,2000,-2:-2,umh,crop,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"