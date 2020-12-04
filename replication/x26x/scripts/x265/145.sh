#!/bin/sh

numb='146'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.3,4.4,0.2,0.7,0.4,1,0,2,20,240,0,24,10,3,0,60,48,5,2000,-2:-2,hex,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"