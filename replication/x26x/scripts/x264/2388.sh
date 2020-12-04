#!/bin/sh

numb='2389'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.0,1.3,3.2,0.5,0.8,0.3,3,0,0,25,300,3,29,40,3,0,61,18,1,1000,-1:-1,hex,crop,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"