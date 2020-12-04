#!/bin/sh

numb='2136'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.4,1.2,5.0,0.4,0.8,0.3,0,0,14,15,210,4,27,30,3,4,62,18,4,2000,-1:-1,umh,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"