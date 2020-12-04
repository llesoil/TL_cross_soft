#!/bin/sh

numb='2640'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.0,1.0,2.4,0.6,0.8,0.9,0,1,4,10,220,0,30,40,4,3,69,18,3,1000,-1:-1,umh,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"