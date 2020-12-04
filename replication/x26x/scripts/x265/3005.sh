#!/bin/sh

numb='3006'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.3,1.0,4.6,0.5,0.9,0.6,1,0,10,40,270,0,20,40,5,4,65,48,2,2000,1:1,hex,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"