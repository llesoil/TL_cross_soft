#!/bin/sh

numb='1609'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.5,1.2,1.8,0.5,0.7,0.7,2,1,4,50,220,0,21,40,3,1,61,38,1,1000,-1:-1,hex,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"