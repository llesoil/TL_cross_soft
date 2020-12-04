#!/bin/sh

numb='1449'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.3,1.2,4.2,0.6,0.6,0.0,0,0,12,0,260,0,28,30,3,2,62,48,1,2000,-1:-1,umh,crop,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"