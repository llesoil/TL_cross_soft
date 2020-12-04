#!/bin/sh

numb='961'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 35 --keyint 260 --lookahead-threads 4 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.3,1.4,4.4,0.4,0.9,0.2,1,2,0,35,260,4,27,50,5,1,67,48,3,2000,-1:-1,hex,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"