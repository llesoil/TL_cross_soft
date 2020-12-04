#!/bin/sh

numb='1065'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 260 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.1,0.8,0.4,0.7,0.0,3,2,6,15,260,0,21,30,3,0,66,28,1,2000,-2:-2,umh,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"