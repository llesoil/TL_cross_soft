#!/bin/sh

numb='895'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 15 --keyint 230 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.5,1.0,2.6,0.3,0.6,0.6,2,2,12,15,230,1,22,40,4,2,66,18,1,1000,-1:-1,dia,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"