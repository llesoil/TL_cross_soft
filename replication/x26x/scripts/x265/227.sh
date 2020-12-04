#!/bin/sh

numb='228'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 40 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.4,1.6,0.5,0.6,0.9,2,2,2,40,220,0,26,0,5,2,66,48,2,2000,1:1,dia,crop,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"