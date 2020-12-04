#!/bin/sh

numb='1745'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 10 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.4,1.4,4.0,0.6,0.6,0.4,1,1,4,10,300,3,24,10,4,1,63,38,2,2000,1:1,hex,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"