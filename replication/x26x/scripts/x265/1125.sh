#!/bin/sh

numb='1126'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.6,1.0,1.0,0.4,0.9,0.2,0,0,14,50,280,4,20,20,5,2,66,48,1,2000,-1:-1,hex,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"