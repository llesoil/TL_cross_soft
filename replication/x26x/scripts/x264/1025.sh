#!/bin/sh

numb='1026'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 50 --keyint 280 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.2,1.1,1.6,0.4,0.9,0.6,0,0,10,50,280,3,22,40,4,2,64,38,4,2000,-2:-2,dia,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"