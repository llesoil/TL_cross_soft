#!/bin/sh

numb='138'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 20 --keyint 220 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.2,5.0,0.6,0.8,0.3,1,1,8,20,220,3,28,20,5,4,60,48,1,1000,1:1,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"