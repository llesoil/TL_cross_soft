#!/bin/sh

numb='1741'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 40 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.1,3.8,0.5,0.9,0.5,0,1,2,40,280,0,28,20,5,1,60,38,5,1000,-2:-2,umh,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"