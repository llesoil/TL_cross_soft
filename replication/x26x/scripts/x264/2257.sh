#!/bin/sh

numb='2258'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.4,1.0,1.4,0.6,0.6,0.2,0,1,6,35,230,2,24,30,4,0,68,48,4,1000,1:1,umh,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"