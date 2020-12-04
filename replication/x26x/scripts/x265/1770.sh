#!/bin/sh

numb='1771'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 50 --keyint 200 --lookahead-threads 3 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.3,1.4,1.8,0.4,0.6,0.8,1,0,0,50,200,3,22,10,5,0,61,38,3,1000,1:1,dia,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"