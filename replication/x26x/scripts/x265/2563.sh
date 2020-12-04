#!/bin/sh

numb='2564'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 10 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.3,1.4,0.5,0.7,0.6,1,2,4,10,240,3,30,40,3,2,60,38,3,1000,-2:-2,hex,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"