#!/bin/sh

numb='2554'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 5 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.5,1.2,3.0,0.3,0.7,0.3,1,2,0,5,210,2,24,40,5,4,60,38,4,2000,1:1,hex,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"