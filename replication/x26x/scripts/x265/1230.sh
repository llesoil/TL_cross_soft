#!/bin/sh

numb='1231'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 40 --keyint 260 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.0,0.8,0.2,0.9,0.9,3,0,16,40,260,3,23,30,5,3,69,18,6,1000,1:1,dia,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"