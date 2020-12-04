#!/bin/sh

numb='195'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 5 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.6,1.2,4.8,0.5,0.6,0.1,2,1,4,5,220,4,22,30,5,0,69,38,1,2000,-1:-1,umh,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"