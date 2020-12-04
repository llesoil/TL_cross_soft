#!/bin/sh

numb='1661'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.4,2.2,0.4,0.9,0.2,1,2,2,10,240,4,26,0,4,2,68,28,1,2000,-2:-2,dia,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"