#!/bin/sh

numb='1951'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 50 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.5,1.3,3.8,0.3,0.7,0.0,2,0,4,50,220,1,21,30,4,1,68,48,6,1000,-2:-2,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"