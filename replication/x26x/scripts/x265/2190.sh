#!/bin/sh

numb='2191'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 20 --keyint 270 --lookahead-threads 4 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.4,0.6,0.3,0.7,0.9,0,2,10,20,270,4,21,20,4,2,61,48,3,1000,1:1,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"