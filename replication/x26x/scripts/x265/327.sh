#!/bin/sh

numb='328'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 50 --keyint 200 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.0,1.0,3.2,0.5,0.7,0.4,0,0,4,50,200,0,24,0,3,0,69,28,6,2000,1:1,umh,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"