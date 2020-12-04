#!/bin/sh

numb='1553'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 5.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 0 --keyint 280 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.2,1.4,5.0,0.6,0.6,0.2,2,2,14,0,280,2,25,40,3,1,61,38,3,2000,-1:-1,hex,crop,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"