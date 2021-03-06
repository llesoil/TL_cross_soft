#!/bin/sh

numb='499'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 280 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.4,1.2,2.8,0.3,0.8,0.0,1,0,12,5,280,4,29,0,5,0,60,48,6,2000,-1:-1,dia,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"