#!/bin/sh

numb='3033'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.1,1.1,0.8,0.3,0.8,0.3,3,2,0,0,260,0,22,10,4,0,68,28,2,1000,-2:-2,dia,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"