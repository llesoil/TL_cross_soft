#!/bin/sh

numb='555'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 35 --keyint 270 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.1,1.3,4.4,0.2,0.7,0.1,2,0,14,35,270,2,27,40,3,2,66,38,6,1000,1:1,dia,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"