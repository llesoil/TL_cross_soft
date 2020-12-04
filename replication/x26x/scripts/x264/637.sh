#!/bin/sh

numb='638'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.1,1.1,1.4,0.3,0.7,0.2,1,0,6,20,210,2,27,0,5,1,65,28,2,1000,-1:-1,hex,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"