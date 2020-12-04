#!/bin/sh

numb='616'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 45 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.0,1.0,1.0,0.2,0.7,0.0,2,1,4,45,280,3,23,30,5,3,66,38,2,2000,-2:-2,dia,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"