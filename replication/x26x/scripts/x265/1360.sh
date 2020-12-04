#!/bin/sh

numb='1361'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 15 --keyint 200 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.4,4.2,0.6,0.7,0.0,1,0,4,15,200,3,24,10,4,2,67,48,1,1000,1:1,hex,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"