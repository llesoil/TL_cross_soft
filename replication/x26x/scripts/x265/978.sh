#!/bin/sh

numb='979'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 50 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.1,1.1,2.0,0.5,0.6,0.9,2,1,6,50,250,2,21,50,3,2,62,38,2,2000,-1:-1,umh,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"