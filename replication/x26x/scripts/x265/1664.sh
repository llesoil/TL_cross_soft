#!/bin/sh

numb='1665'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 30 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.3,1.3,4.0,0.3,0.8,0.0,0,0,12,30,270,3,28,30,5,0,64,28,2,1000,-1:-1,dia,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"