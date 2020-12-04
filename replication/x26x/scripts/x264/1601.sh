#!/bin/sh

numb='1602'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 50 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.3,1.6,0.3,0.7,0.8,3,0,6,50,210,0,23,40,5,4,64,48,3,1000,1:1,umh,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"