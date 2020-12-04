#!/bin/sh

numb='2949'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 25 --keyint 220 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.3,0.8,0.2,0.7,0.6,3,2,10,25,220,4,25,10,3,4,63,28,5,2000,1:1,dia,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"