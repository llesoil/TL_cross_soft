#!/bin/sh

numb='294'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.4,1.2,4.6,0.3,0.6,0.8,1,0,4,45,210,3,30,20,5,0,67,48,4,1000,-2:-2,dia,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"