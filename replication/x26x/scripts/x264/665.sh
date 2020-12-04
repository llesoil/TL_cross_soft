#!/bin/sh

numb='666'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.2,1.3,0.2,0.3,0.9,0.2,1,0,14,45,280,0,22,30,5,2,65,48,1,1000,-1:-1,umh,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"