#!/bin/sh

numb='1458'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 35 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.6,1.2,1.6,0.5,0.9,0.6,0,1,0,35,300,1,30,20,3,1,64,48,1,2000,-2:-2,dia,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"