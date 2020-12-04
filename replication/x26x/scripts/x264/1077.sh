#!/bin/sh

numb='1078'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.3,1.3,3.4,0.2,0.7,0.2,3,2,0,20,220,3,29,20,4,1,62,28,3,2000,-2:-2,hex,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"