#!/bin/sh

numb='1446'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 15 --keyint 270 --lookahead-threads 4 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.5,1.0,3.0,0.3,0.6,0.2,0,0,4,15,270,4,25,40,5,4,61,48,1,2000,1:1,umh,show,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"