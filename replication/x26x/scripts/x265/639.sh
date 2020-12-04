#!/bin/sh

numb='640'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 10 --keyint 200 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.1,1.0,1.0,0.2,0.6,0.7,2,1,12,10,200,2,28,40,5,2,60,38,1,1000,1:1,dia,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"