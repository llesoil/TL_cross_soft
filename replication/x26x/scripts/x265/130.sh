#!/bin/sh

numb='131'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 30 --keyint 240 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.2,1.1,3.2,0.4,0.9,0.7,3,1,8,30,240,1,29,10,3,1,69,28,2,2000,1:1,dia,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"