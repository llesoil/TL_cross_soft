#!/bin/sh

numb='320'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 5 --keyint 280 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.2,0.4,0.4,0.8,0.9,2,2,14,5,280,1,24,40,4,4,65,28,6,1000,-1:-1,dia,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"