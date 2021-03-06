#!/bin/sh

numb='2692'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 5 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,0.0,1.3,1.2,3.8,0.2,0.6,0.5,0,1,4,5,280,1,23,40,4,2,69,18,1,1000,-2:-2,hex,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"