#!/bin/sh

numb='2872'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 20 --keyint 270 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.6,1.4,5.0,0.5,0.6,0.2,2,0,8,20,270,2,27,30,4,3,68,38,5,2000,1:1,umh,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"