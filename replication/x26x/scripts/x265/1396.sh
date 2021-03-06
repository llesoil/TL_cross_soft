#!/bin/sh

numb='1397'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.3,1.0,1.8,0.3,0.6,0.8,1,0,0,50,240,2,30,0,3,4,60,38,6,2000,1:1,hex,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"