#!/bin/sh

numb='370'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 0 --keyint 240 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.3,1.0,4.8,0.3,0.9,0.3,0,0,2,0,240,4,27,40,3,2,63,28,4,1000,-1:-1,dia,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"