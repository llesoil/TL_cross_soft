#!/bin/sh

numb='2996'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 15 --keyint 290 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.1,0.8,0.3,0.6,0.0,0,1,14,15,290,2,29,40,4,3,61,18,4,2000,1:1,dia,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"