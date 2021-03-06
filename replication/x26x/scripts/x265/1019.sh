#!/bin/sh

numb='1020'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.3,3.2,0.4,0.7,0.7,3,1,10,35,280,0,26,20,4,4,62,18,5,2000,1:1,hex,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"