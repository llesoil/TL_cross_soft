#!/bin/sh

numb='288'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 30 --keyint 290 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.2,1.0,3.4,0.4,0.7,0.8,2,2,2,30,290,3,22,50,3,0,65,28,6,2000,-2:-2,umh,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"