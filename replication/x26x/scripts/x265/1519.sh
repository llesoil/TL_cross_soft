#!/bin/sh

numb='1520'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 40 --keyint 220 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.0,2.0,0.6,0.6,0.8,2,0,14,40,220,4,25,30,5,1,61,28,6,2000,-1:-1,dia,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"