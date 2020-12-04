#!/bin/sh

numb='963'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 45 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.2,1.2,3.8,0.6,0.7,0.4,0,0,6,45,260,0,25,0,3,2,66,38,2,2000,1:1,dia,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"