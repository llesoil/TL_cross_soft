#!/bin/sh

numb='417'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 25 --keyint 220 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.1,1.1,2.0,0.2,0.8,0.8,3,0,6,25,220,2,23,10,4,3,67,48,2,1000,-2:-2,umh,crop,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"