#!/bin/sh

numb='2453'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 20 --keyint 220 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,None,--slow-firstpass,--no-weightb,1.0,1.0,1.3,2.0,0.2,0.9,0.5,3,1,8,20,220,4,23,20,5,4,66,28,1,1000,1:1,umh,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"