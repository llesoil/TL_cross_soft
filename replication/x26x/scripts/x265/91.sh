#!/bin/sh

numb='92'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 20 --qp 20 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.3,0.2,0.5,0.7,0.5,0,0,8,20,280,0,20,20,4,2,69,28,6,2000,1:1,dia,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"