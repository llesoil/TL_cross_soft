#!/bin/sh

numb='2242'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.5,1.0,1.2,0.3,0.7,0.6,2,2,0,35,230,3,30,10,5,3,63,38,4,1000,1:1,hex,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"