#!/bin/sh

numb='2481'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 0 --keyint 200 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.5,1.0,4.2,0.2,0.8,0.4,1,0,2,0,200,4,20,20,3,1,63,18,5,2000,1:1,dia,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"