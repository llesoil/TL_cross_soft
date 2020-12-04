#!/bin/sh

numb='2259'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 5.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.3,1.1,5.0,0.5,0.8,0.5,2,1,14,45,280,1,30,40,3,2,61,18,4,2000,1:1,dia,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"