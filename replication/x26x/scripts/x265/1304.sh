#!/bin/sh

numb='1305'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 35 --keyint 200 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.0,1.0,3.0,0.2,0.9,0.3,3,1,14,35,200,1,22,50,4,0,62,18,4,1000,-1:-1,umh,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"