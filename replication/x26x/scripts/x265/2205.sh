#!/bin/sh

numb='2206'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 15 --keyint 290 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.4,1.4,1.6,0.5,0.8,0.9,2,1,0,15,290,3,28,20,3,4,61,38,1,2000,-1:-1,dia,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"