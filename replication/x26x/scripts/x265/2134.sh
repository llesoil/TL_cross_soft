#!/bin/sh

numb='2135'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.1,1.1,2.2,0.5,0.6,0.2,3,2,2,5,220,2,26,0,3,1,67,48,2,1000,1:1,dia,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"