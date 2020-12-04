#!/bin/sh

numb='973'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.2,1.3,2.8,0.5,0.9,0.7,2,0,10,10,240,4,22,0,5,0,69,28,6,2000,-1:-1,dia,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"