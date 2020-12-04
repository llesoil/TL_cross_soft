#!/bin/sh

numb='1107'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 10 --keyint 290 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.5,1.2,4.8,0.2,0.6,0.3,0,0,10,10,290,0,23,50,3,2,62,38,4,1000,-1:-1,dia,crop,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"