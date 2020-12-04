#!/bin/sh

numb='2831'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 0 --keyint 260 --lookahead-threads 3 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.6,1.1,4.6,0.5,0.9,0.8,3,1,14,0,260,3,21,10,3,1,67,38,2,2000,-2:-2,dia,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"