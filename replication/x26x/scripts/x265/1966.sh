#!/bin/sh

numb='1967'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.6,1.1,4.0,0.5,0.7,0.1,1,0,12,5,210,1,29,10,3,4,62,48,2,1000,1:1,hex,crop,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"