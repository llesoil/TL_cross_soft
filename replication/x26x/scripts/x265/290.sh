#!/bin/sh

numb='291'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.3,1.4,0.2,0.4,0.6,0.8,3,0,2,45,220,2,24,40,5,3,64,38,1,1000,-2:-2,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"