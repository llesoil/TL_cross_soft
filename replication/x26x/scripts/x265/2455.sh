#!/bin/sh

numb='2456'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 0 --keyint 250 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.4,4.0,0.3,0.9,0.8,1,1,6,0,250,3,23,20,3,1,60,28,6,1000,-2:-2,hex,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"