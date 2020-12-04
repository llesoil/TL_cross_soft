#!/bin/sh

numb='688'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 300 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.1,1.4,3.8,0.3,0.9,0.4,3,2,0,20,300,2,28,20,5,1,66,38,2,1000,1:1,umh,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"