#!/bin/sh

numb='582'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 0 --keyint 220 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.4,1.0,4.0,0.4,0.8,0.1,1,1,16,0,220,0,24,0,5,0,63,48,2,2000,1:1,dia,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"