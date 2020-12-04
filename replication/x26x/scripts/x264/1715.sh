#!/bin/sh

numb='1716'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 5 --keyint 230 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.1,1.4,2.6,0.3,0.9,0.5,1,1,8,5,230,3,21,20,3,4,60,48,4,2000,1:1,dia,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"