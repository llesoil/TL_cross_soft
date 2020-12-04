#!/bin/sh

numb='246'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 25 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--weightb,3.0,1.0,1.4,1.6,0.5,0.6,0.1,0,0,16,25,230,2,30,10,3,1,67,28,1,2000,-2:-2,hex,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"