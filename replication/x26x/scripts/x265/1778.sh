#!/bin/sh

numb='1779'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.2,1.3,0.4,0.3,0.6,0.3,2,2,6,50,240,4,25,20,4,3,63,18,6,2000,1:1,dia,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"