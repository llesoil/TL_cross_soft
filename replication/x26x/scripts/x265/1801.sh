#!/bin/sh

numb='1802'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 5 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.2,1.0,2.4,0.5,0.7,0.1,1,1,4,5,300,2,24,10,3,3,62,28,5,1000,1:1,hex,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"