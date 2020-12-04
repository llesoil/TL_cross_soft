#!/bin/sh

numb='1586'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.2,5.0,0.5,0.7,0.2,3,0,14,50,290,1,23,30,3,1,65,48,4,2000,1:1,dia,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"