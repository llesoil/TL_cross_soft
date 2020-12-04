#!/bin/sh

numb='2102'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 35 --keyint 260 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.6,1.0,0.8,0.4,0.7,0.1,0,1,4,35,260,0,26,30,4,2,60,28,4,1000,1:1,dia,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"