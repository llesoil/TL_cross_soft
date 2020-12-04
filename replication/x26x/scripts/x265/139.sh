#!/bin/sh

numb='140'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.4,1.2,4.2,0.5,0.7,0.2,3,1,2,20,280,3,26,10,4,0,60,18,2,2000,-2:-2,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"