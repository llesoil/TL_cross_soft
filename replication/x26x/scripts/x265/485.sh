#!/bin/sh

numb='486'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 10 --keyint 300 --lookahead-threads 4 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.4,1.0,0.4,0.3,0.8,0.5,0,1,14,10,300,4,21,10,3,0,61,48,6,2000,1:1,dia,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"