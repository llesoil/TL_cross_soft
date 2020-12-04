#!/bin/sh

numb='2978'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 25 --keyint 250 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.4,1.4,2.8,0.6,0.7,0.7,3,2,12,25,250,1,25,50,3,0,62,48,5,1000,1:1,hex,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"