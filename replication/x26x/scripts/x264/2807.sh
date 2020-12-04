#!/bin/sh

numb='2808'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 30 --keyint 200 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.0,1.4,3.8,0.3,0.6,0.6,3,1,4,30,200,1,30,50,3,0,67,38,5,2000,-1:-1,dia,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"