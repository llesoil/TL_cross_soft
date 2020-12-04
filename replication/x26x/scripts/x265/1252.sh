#!/bin/sh

numb='1253'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 10 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.1,1.4,4.8,0.2,0.6,0.2,1,0,10,10,260,2,29,0,3,1,63,18,2,1000,-2:-2,hex,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"