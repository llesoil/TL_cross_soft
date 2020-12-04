#!/bin/sh

numb='3054'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 25 --keyint 240 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.2,1.4,3.8,0.3,0.9,0.3,3,1,14,25,240,0,30,0,4,3,69,38,1,1000,-2:-2,umh,crop,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"