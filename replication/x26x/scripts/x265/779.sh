#!/bin/sh

numb='780'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.0,1.2,2.2,0.2,0.9,0.8,1,1,16,20,270,0,25,0,4,4,61,48,1,1000,-1:-1,hex,crop,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"