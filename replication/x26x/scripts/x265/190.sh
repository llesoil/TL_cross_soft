#!/bin/sh

numb='191'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.2,1.4,4.2,0.5,0.8,0.1,2,0,0,5,270,0,22,20,3,0,64,28,3,1000,1:1,dia,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"