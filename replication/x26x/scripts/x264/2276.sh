#!/bin/sh

numb='2277'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.6,1.0,1.8,0.2,0.6,0.2,0,1,0,35,270,1,20,10,5,3,62,48,3,2000,1:1,hex,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"