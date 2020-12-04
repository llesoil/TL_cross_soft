#!/bin/sh

numb='1291'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 5 --keyint 200 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.1,0.2,0.3,0.7,0.9,0,2,14,5,200,3,22,50,3,4,65,48,3,1000,-1:-1,umh,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"