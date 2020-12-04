#!/bin/sh

numb='975'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.4,0.6,0.5,0.9,0.1,3,0,10,20,270,0,22,40,4,4,61,28,6,2000,-2:-2,dia,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"