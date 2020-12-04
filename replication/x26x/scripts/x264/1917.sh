#!/bin/sh

numb='1918'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.5,1.4,0.6,0.4,0.8,0.2,2,1,12,20,210,1,25,20,4,0,66,28,4,2000,1:1,umh,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"