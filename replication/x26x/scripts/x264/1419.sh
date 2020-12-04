#!/bin/sh

numb='1420'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.3,0.2,0.2,0.6,0.8,1,2,2,45,290,1,26,40,5,0,64,18,4,1000,1:1,umh,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"