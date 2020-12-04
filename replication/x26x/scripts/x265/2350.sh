#!/bin/sh

numb='2351'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.0,1.2,2.0,0.4,0.9,0.4,0,2,8,10,270,3,30,10,5,1,63,38,3,1000,-2:-2,umh,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"