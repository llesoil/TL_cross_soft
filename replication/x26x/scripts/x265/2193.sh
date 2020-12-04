#!/bin/sh

numb='2194'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 45 --keyint 220 --lookahead-threads 3 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.0,1.3,4.8,0.5,0.9,0.7,1,2,12,45,220,3,21,50,5,4,62,18,3,1000,-1:-1,hex,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"