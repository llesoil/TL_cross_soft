#!/bin/sh

numb='791'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 20 --keyint 230 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.2,3.4,0.5,0.6,0.5,1,2,10,20,230,4,29,30,4,3,67,18,6,2000,-1:-1,dia,crop,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"