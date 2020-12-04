#!/bin/sh

numb='798'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 25 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.5,1.2,3.4,0.2,0.8,0.1,0,2,10,25,200,2,24,40,4,4,61,48,5,2000,1:1,umh,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"