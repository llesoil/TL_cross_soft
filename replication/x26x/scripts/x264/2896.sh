#!/bin/sh

numb='2897'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.1,1.4,3.4,0.6,0.9,0.6,1,0,12,30,290,2,21,0,3,1,67,18,1,2000,1:1,hex,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"