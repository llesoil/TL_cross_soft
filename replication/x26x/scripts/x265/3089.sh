#!/bin/sh

numb='3090'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.5,1.0,5.0,0.4,0.9,0.2,1,2,12,40,230,4,27,0,5,2,66,48,3,2000,1:1,dia,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"