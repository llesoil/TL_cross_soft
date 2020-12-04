#!/bin/sh

numb='1093'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 40 --keyint 280 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.1,1.1,2.8,0.3,0.7,0.2,1,1,12,40,280,2,28,0,5,3,60,28,5,1000,-1:-1,hex,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"