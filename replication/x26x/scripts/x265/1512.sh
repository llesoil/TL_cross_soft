#!/bin/sh

numb='1513'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 30 --keyint 220 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.0,4.8,0.4,0.6,0.1,0,1,10,30,220,3,21,20,5,2,68,28,1,2000,1:1,dia,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"