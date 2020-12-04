#!/bin/sh

numb='2272'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 25 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.4,3.2,0.6,0.9,0.2,2,1,2,25,210,2,23,20,3,4,61,28,3,2000,1:1,umh,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"