#!/bin/sh

numb='209'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.1,1.1,0.8,0.5,0.7,0.6,3,1,14,45,230,0,30,50,3,1,63,48,1,1000,-2:-2,dia,crop,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"