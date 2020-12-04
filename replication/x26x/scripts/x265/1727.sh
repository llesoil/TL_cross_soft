#!/bin/sh

numb='1728'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 50 --keyint 220 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.2,1.1,1.0,0.5,0.8,0.8,2,0,16,50,220,1,23,50,5,2,67,48,4,2000,-1:-1,umh,crop,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"