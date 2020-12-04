#!/bin/sh

numb='724'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.0,0.8,0.2,0.7,0.8,1,0,16,0,250,4,26,30,5,3,68,28,5,2000,1:1,hex,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"