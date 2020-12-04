#!/bin/sh

numb='2852'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.2,0.4,0.3,0.6,0.0,2,0,8,50,240,4,28,0,4,2,67,48,6,2000,1:1,umh,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"