#!/bin/sh

numb='90'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.1,1.1,2.6,0.6,0.9,0.1,3,0,12,50,290,1,26,20,4,0,60,48,2,1000,-2:-2,hex,crop,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"