#!/bin/sh

numb='2218'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.4,4.0,0.3,0.8,0.6,3,1,6,25,300,1,27,20,3,4,69,48,1,2000,-2:-2,dia,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"