#!/bin/sh

numb='2026'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.2,0.2,0.5,0.8,0.6,3,0,14,35,260,1,28,30,4,0,65,38,5,1000,-2:-2,dia,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"