#!/bin/sh

numb='198'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.5,1.4,1.8,0.5,0.8,0.0,2,1,10,40,220,2,30,30,4,3,62,38,5,1000,1:1,hex,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"