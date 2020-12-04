#!/bin/sh

numb='2665'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 5 --keyint 240 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.1,1.3,2.8,0.3,0.8,0.2,0,0,10,5,240,1,27,30,5,2,68,48,2,2000,1:1,dia,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"