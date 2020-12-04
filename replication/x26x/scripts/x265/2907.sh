#!/bin/sh

numb='2908'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 15 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.1,2.6,0.2,0.7,0.3,3,2,14,15,210,2,24,50,4,3,69,38,6,2000,1:1,hex,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"