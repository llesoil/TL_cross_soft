#!/bin/sh

numb='1900'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 5.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 25 --keyint 290 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.1,1.3,5.0,0.2,0.9,0.1,3,0,2,25,290,4,26,40,3,1,67,18,6,2000,1:1,hex,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"