#!/bin/sh

numb='207'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.4,2.2,0.2,0.9,0.7,2,1,10,10,200,1,27,40,3,1,65,48,5,1000,1:1,umh,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"