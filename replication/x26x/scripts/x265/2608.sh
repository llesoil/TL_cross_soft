#!/bin/sh

numb='2609'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 10 --keyint 220 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--weightb,0.0,1.4,1.1,2.2,0.3,0.9,0.4,1,1,2,10,220,2,22,20,4,1,63,48,1,1000,1:1,umh,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"