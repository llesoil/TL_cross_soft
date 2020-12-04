#!/bin/sh

numb='797'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.1,1.1,3.2,0.3,0.7,0.5,3,1,10,15,250,0,26,30,3,3,62,28,2,1000,-1:-1,umh,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"