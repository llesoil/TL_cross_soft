#!/bin/sh

numb='234'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 25 --keyint 240 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.1,0.4,0.3,0.9,0.1,1,2,12,25,240,1,30,30,3,2,67,48,3,2000,-1:-1,umh,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"