#!/bin/sh

numb='891'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 5 --keyint 220 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.0,4.2,0.4,0.7,0.9,2,1,6,5,220,0,22,30,3,2,61,48,4,2000,1:1,umh,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"