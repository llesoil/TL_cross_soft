#!/bin/sh

numb='1382'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 4 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.1,1.2,1.6,0.5,0.7,0.5,0,2,2,20,240,4,22,40,5,0,65,38,1,1000,1:1,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"